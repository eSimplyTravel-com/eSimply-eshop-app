import "dart:async";
import "dart:io";
import "dart:math";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_assign_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/payment_service.dart";
import "package:esim_open_source/domain/use_case/user/get_related_topup_use_case.dart";
import "package:esim_open_source/domain/use_case/user/top_up_user_bundle_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/models/payment_request_params.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/action_helpers.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/esim_base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/verify_purchase_view/verify_purchase_view.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:esim_open_source/utils/payment_helper.dart";
import "package:stacked_services/stacked_services.dart";

class TopUpBottomSheetViewModel extends EsimBaseModel {
  TopUpBottomSheetViewModel({required this.request, required this.completer});

  //#region UseCases
  final TopUpUserBundleUseCase topUpUserBundleUseCase =
      TopUpUserBundleUseCase(locator());

  //#endregion

  //#region Variables
  final SheetRequest<BundleTopUpBottomRequest> request;
  final Function(SheetResponse<MainBottomSheetResponse>) completer;
  List<BundleResponseModel> bundleItems = <BundleResponseModel>[];

  //#endregion

  //#region Functions
  @override
  void onViewModelReady() {
    unawaited(fetchTopUpRelated());
  }

  Future<void> onBuyClick({required int index}) async {
    BundleResponseModel item = bundleItems[index];

    List<PaymentType> paymentTypeList = AppEnvironment.appEnvironmentHelper
        .paymentTypeList(isUserLoggedIn: isUserLoggedIn);

    final double price = item.price ?? 0;

    // check if amount in wallet covers the bundle price
    if (paymentTypeList.contains(PaymentType.wallet) &&
        price > userAuthenticationService.walletAvailableBalance) {
      paymentTypeList = paymentTypeList
          .where((PaymentType element) => element != PaymentType.wallet)
          .toList();
    }

    if (paymentTypeList.isEmpty) {
      //no payment type available
      showToast(LocaleKeys.no_payment_method_available.tr());
      return;
    }

    String iccId = request.data?.iccID ?? "";

    if (paymentTypeList.length == 1) {
      //check if it's wallet, then check if wallet available
      PaymentType paymentType = paymentTypeList.first;

      switch (paymentType) {
        case PaymentType.wallet:
          final bool hasSufficientBalance =
              userAuthenticationService.walletAvailableBalance >=
                  (item.price ?? 0.0);
          if (!hasSufficientBalance) {
            showToast(LocaleKeys.no_sufficient_balance_in_wallet.tr());
            return;
          }
          _topUpBundle(
            paymentType: paymentType,
            iccId: iccId,
            item: item,
          );

        case PaymentType.dcb:
        case PaymentType.card:
          _topUpBundle(
            paymentType: paymentType,
            iccId: iccId,
            item: item,
          );
      }
    } else {
      PaymentType? paymentType =
          await PaymentHelper.choosePaymentMethod(paymentTypeList);
      if (paymentType != null) {
        _topUpBundle(
          paymentType: paymentType,
          iccId: iccId,
          item: item,
        );
      }
    }
  }

  void closeBottomSheet() {
    completer(SheetResponse<MainBottomSheetResponse>());
  }

  double calculateHeight(double screenHeight) {
    if (bundleItems.isEmpty) {
      return 300;
    }

    double cellHeight = 200;
    double cellsHeight = 120 + (bundleItems.length * cellHeight);

    return min(cellsHeight, screenHeight);
  }

  //#endregion

  //#region Apis
  Future<void> fetchTopUpRelated() async {
    bundleItems
      ..clear()
      ..add(BundleResponseModel())
      ..add(BundleResponseModel());

    applyShimmer = true;
    // await Future<void>.delayed(Duration(seconds: 2));
    //
    // bundleItems
    //   ..clear()
    //   ..add(
    //     BundleResponseModel(
    //       priceDisplay: LocaleKeys.bundleInfo_priceText
    //           .tr(namedArgs: {"price": "\$ 20.00"}),
    //       planType: "5 GB",
    //       bundleCode: "456456",
    //       validityDisplay: "10 days",
    //       bundleName: "Europe",
    //       activityPolicy: "policy",
    //     ),
    //   );

    Resource<List<BundleResponseModel>?> response =
        await GetRelatedTopupUseCase(locator()).execute(
      GetRelatedTopupParam(
        iccID: request.data?.iccID ?? "",
        bundleCode: request.data?.bundleCode ?? "",
      ),
    );
    handleResponse(
      response,
      onSuccess: (Resource<List<BundleResponseModel>?> result) async {
        if (result.data == null) {
          handleError(response);
          return;
        }
        bundleItems
          ..clear()
          ..addAll(result.data ?? <BundleResponseModel>[]);
        applyShimmer = false;
      },
      onFailure: (Resource<List<BundleResponseModel>?> result) async {
        await handleError(response);
        closeBottomSheet();
      },
    );
  }

  Future<void> _topUpBundle({
    required PaymentType paymentType,
    required String iccId,
    required BundleResponseModel item,
  }) async {
    String bundleCode = item.bundleCode ?? "";
    // double bundlePrice = item.price ?? 0.0;
    String bundlePriceDisplay = item.priceDisplay ?? "";
    String bundleCurrency = item.currencyCode ?? "";

    setViewState(ViewState.busy);
    Resource<BundleAssignResponseModel?> response = await topUpUserBundleUseCase
        .execute(TopUpUserBundleParam(iccID: iccId, bundleCode: bundleCode, paymentType: paymentType.type));
    handleResponse(
      response,
      onSuccess: (Resource<BundleAssignResponseModel?> result) async {
        setViewState(ViewState.idle);
        PaymentHelper.checkTaxAmount(
          result: result,
          onError: () async {
            handleError(result);
            cancelOrder(orderID: result.data?.orderId ?? "");
          },
          onSuccess: () => initiatePaymentRequest(
            params: PaymentRequestParams(
              secretParams: PaymentRequestSecretParams(
                  paymentType: paymentType,
                  publishableKey: result.data?.publishableKey ?? "",
                  merchantIdentifier:result.data?.merchantIdentifier ?? "",
                  paymentIntentClientSecret: result.data?.paymentIntentClientSecret ?? "",
                  customerEphemeralKeySecret: result.data?.customerEphemeralKeySecret ?? "",
                  test: result.data?.testEnv ?? false,),
              idParams: PaymentRequestIDParams(
                  orderID: result.data?.orderId ?? "",
                  customerId: result.data?.customerId ?? "",
                  billingCountryCode: result.data?.billingCountryCode ?? "",
                  bundleCode: item.bundleCode ?? "",
                  bundleName: item.bundleName ?? "",),
            ),
            bundlePrice: bundlePriceDisplay,
            bundleCurrency: bundleCurrency,
          ),
        );
      },
      onFailure: (Resource<BundleAssignResponseModel?> result) async {
        if (response.error?.errorCode ==
            MainTimeoutException.timeoutErrorCode) {
          await showNativeErrorMessage(
            response.error?.message,
            LocaleKeys.processing.tr(),
          );
          closeBottomSheet();
          return;
        }
        handleError(response);
      },
    );
  }

  Future<void> initiatePaymentRequest({
    required PaymentRequestParams params,
    required String bundlePrice,
    required String bundleCurrency,
  }) async {
    try {
      setViewState(ViewState.busy);
      await paymentService.prepareCheckout(
        paymentType: params.secretParams.paymentType,
        publishableKey: params.secretParams.publishableKey,
        merchantIdentifier: params.secretParams.merchantIdentifier,
      );

      PaymentResult paymentResult = await paymentService.processOrderPayment(
        paymentType: params.secretParams.paymentType,
        params: ProcessOrderPaymentParams(
          iccID: request.data?.iccID ?? "",
          orderID: params.idParams.orderID,
          billingCountryCode: params.idParams.billingCountryCode,
          paymentIntentClientSecret: params.secretParams.paymentIntentClientSecret,
          customerId: params.idParams.customerId,
          customerEphemeralKeySecret: params.secretParams.customerEphemeralKeySecret,
          testEnv: params.secretParams.test,
        ),
      );

      setViewState(ViewState.idle);

      switch (paymentResult) {
        case PaymentResult.completed:
          hideKeyboard();
          String utm = localStorageService.getString(LocalStorageKeys.utm) ?? "";
          analyticsService.logEvent(
            event: AnalyticEvent.buyTopUpSuccess(
              utm: utm,
              platform: Platform.isAndroid ? "Android" : "iOS",
              amount: bundlePrice,
              currency: bundleCurrency,
            ),
          );
          completer(
            SheetResponse<MainBottomSheetResponse>(
              data: MainBottomSheetResponse(
                canceled: false,
                tag: params.idParams.orderID,
              ),
            ),
          );

        case PaymentResult.canceled:
          hideKeyboard();
          unawaited(cancelOrder(orderID: params.idParams.orderID));
          closeBottomSheet();

        case PaymentResult.otpRequested:
          setViewState(ViewState.idle);
          bool result = await navigationService.navigateTo(
            VerifyPurchaseView.routeName,
            arguments: VerifyPurchaseViewArgs(
              iccid: request.data?.iccID ?? "",
              orderID: params.idParams.orderID,
            ),
            preventDuplicates: false,
          );
          if (result) {
            hideKeyboard();
            String utm = localStorageService.getString(LocalStorageKeys.utm) ?? "";
            analyticsService.logEvent(
              event: AnalyticEvent.buyTopUpSuccess(
                utm: utm,
                platform: Platform.isAndroid ? "Android" : "iOS",
                amount: bundlePrice,
                currency: bundleCurrency,
              ),
            );
            completer(
              SheetResponse<MainBottomSheetResponse>(
                data: MainBottomSheetResponse(
                  canceled: false,
                  tag: params.idParams.orderID,
                ),
              ),
            );
          } else {
            hideKeyboard();
            unawaited(cancelOrder(orderID: params.idParams.orderID));
            closeBottomSheet();
          }
      }
    } on Exception catch (e) {
      unawaited(cancelOrder(orderID: params.idParams.orderID));
      closeBottomSheet();
      showToast(
        e.toString().replaceAll("Exception:", ""),
      );
      hideKeyboard();
      return;
    }
  }
//#endregion
}
