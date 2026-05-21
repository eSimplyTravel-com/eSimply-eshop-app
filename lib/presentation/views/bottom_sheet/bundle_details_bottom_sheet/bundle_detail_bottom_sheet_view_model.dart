import "dart:async";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/request/related_search.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_assign_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/payment_service.dart";
import "package:esim_open_source/domain/use_case/auth/tmp_login_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/promotion/validate_promo_code_use_case.dart";
import "package:esim_open_source/domain/use_case/user/assign_user_bundle_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_bundle_exists_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_user_info_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/models/payment_request_params.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/action_helpers.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/purchase_loading_view/purchase_loading_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/purchase_loading_view/purchase_loading_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/verify_purchase_view/verify_purchase_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager_view_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:esim_open_source/utils/order_status_enum.dart";
import "package:esim_open_source/utils/payment_helper.dart";
import "package:flutter/material.dart";
import "package:phone_input/phone_input_package.dart";
import "package:stacked_services/stacked_services.dart";

class BundleDetailBottomSheetViewModel extends BaseModel {
  //#region UseCases
  final TmpLoginUseCase tmpLoginUseCase = TmpLoginUseCase(locator());
  final GetBundleExistsUseCase getBundleExistsUseCase =
      GetBundleExistsUseCase(locator());
  final ValidatePromoCodeUseCase validatePromoCodeUseCase =
      ValidatePromoCodeUseCase(locator());

  //#endregion

  //#region Variables
  late RegionRequestModel? region;
  late BundleResponseModel? bundle;
  late BundleResponseModel? tempBundle;
  late List<CountriesRequestModel>? countriesList;

  PhoneController phoneController =
      PhoneController(const PhoneNumber(isoCode: IsoCode.LB, nsn: ""));

  bool _isTermsChecked = false;
  bool _isLoginEnabled = false;
  bool _isValidPhoneNumber = false;

  final TextEditingController _emailController = TextEditingController();

  String? _promoCode;
  String? _emailErrorMessage;

  String get emailErrorMessage => _emailErrorMessage ?? "";

  bool get isTermsChecked => _isTermsChecked;

  bool get isLoginEnabled => _isLoginEnabled;

  TextEditingController get emailController => _emailController;

  bool get isPromoCodeEnabled =>
      AppEnvironment.appEnvironmentHelper.enablePromoCode;

  bool get isPurchaseButtonEnabled {
    if (isUserLoggedIn) {
      return true;
    }
    return _isLoginEnabled;
  }

  //Promo code sub view
  bool isPromoCodeExpanded = false;

  String get _referralCode =>
      localStorageService.getString(LocalStorageKeys.referralCode) ?? "";
  final TextEditingController _promoCodeController = TextEditingController();

  TextEditingController get promoCodeController => _promoCodeController;

  String promoCodeMessage = "";
  bool promoCodeFieldEnabled = true;
  Color? promoCodeFieldColor;

  IconData get promoCodeFieldIcon {
    if (promoCodeFieldEnabled) {
      return Icons.error_outline;
    }
    return Icons.check_circle_outline;
  }

  String get promoCodeButtonText {
    if (promoCodeFieldEnabled) {
      return LocaleKeys.promoCodeView_buttonText.tr();
    }
    return LocaleKeys.promoCodeView_cancelButtonText.tr();
  }

  bool get showPhoneInput {
    switch (AppEnvironment.appEnvironmentHelper.loginType) {
      case LoginType.email:
      case LoginType.emailAndPhoneAndEmailVerification:
        return false;
      case LoginType.phoneNumber:
      case LoginType.emailAndPhone:
      case LoginType.emailAndPhoneAndBothVerification:
        return true;
    }
  }

  //#endregion

  //#region Functions
  @override
  void onViewModelReady() {
    super.onViewModelReady();
    _emailController.addListener(_validateForm);
    _promoCodeController.addListener(_onPromoCodeTextChanged);

    if (_referralCode.isNotEmpty) {
      unawaited(validatePromoCode(_referralCode, isReferral: true));
    }
  }

  void validateNumber({
    required String code,
    required String number,
    required bool isValid,
  }) {
    _isValidPhoneNumber = isValid;
    _validateForm();
  }

  void updateTermsSelections() {
    _isTermsChecked = !_isTermsChecked;
    notifyListeners();
    _validateForm();
  }

  void expandedCallBack() {
    isPromoCodeExpanded = !isPromoCodeExpanded;
    notifyListeners();
  }

  void updatePromoCodeView({
    required bool isEnabled,
    Color? fieldColor,
    String message = "",
  }) {
    if (_promoCodeController.text.isNotEmpty) {
      promoCodeMessage = message;
      promoCodeFieldColor = fieldColor;
      promoCodeFieldEnabled = isEnabled;
      notifyListeners();
    }
  }

  void _validateForm() {
    switch (AppEnvironment.appEnvironmentHelper.loginType) {
      case LoginType.email:
      case LoginType.emailAndPhoneAndEmailVerification:
        final String emailAddress = _emailController.text.trim();
        _emailErrorMessage = _validateEmailAddress(emailAddress);
        _isLoginEnabled = _emailErrorMessage == "" && isTermsChecked;
      case LoginType.phoneNumber:
      case LoginType.emailAndPhone:
      case LoginType.emailAndPhoneAndBothVerification:
        _isLoginEnabled = _isValidPhoneNumber && isTermsChecked;
    }

    notifyListeners();
  }

  void _onPromoCodeTextChanged() {
    if (_promoCodeController.text.isEmpty && promoCodeMessage.isNotEmpty) {
      promoCodeMessage = "";
      promoCodeFieldColor = null;
    }
    notifyListeners();
  }

  String _validateEmailAddress(String text) {
    if (text.trim().isEmpty) {
      return LocaleKeys.is_required_field.tr();
    }

    if (text.trim().isValidEmail()) {
      return "";
    }

    return LocaleKeys.enter_a_valid_email_address.tr();
  }

  Future<void> buyNowPressed(BuildContext context) async {
    analyticsService.logEvent(
      event: AnalyticEvent.bundleDetail(
        bundleCode: bundle?.bundleCode ?? "",
        bundleName: bundle?.bundleName ?? "",
        user: userEmailAddress,
      ),
    );
    // Show compatible sheet
    SheetResponse<EmptyBottomSheetResponse>? response =
        await bottomSheetService.showCustomSheet(
      enableDrag: false,
      isScrollControlled: true,
      variant: BottomSheetType.compatibleSheetView,
    );
    if (response?.confirmed ?? false) {
      // let payment sheet handle everything

      if (isUserLoggedIn) {
        //check if exists
        bool bundleExists = await _checkIfBundleExists();
        if (bundleExists && context.mounted) {
          BundleExistsAction bundleExistsAction = await showNativeDialog(
                params: NativeDialogParams(
                  context: context,
                  barrierDismissible: true,
                  titleText: LocaleKeys.bundleExistsView_titleText.tr(),
                  contentText: LocaleKeys.bundleExistsView_contentText.tr(),
                  buttons: <NativeButtonParams>[
                    NativeButtonParams(
                      buttonTitle:
                          LocaleKeys.bundleExistsView_buttonOneText.tr(),
                      buttonAction: () => navigationService.back(
                        result: BundleExistsAction.buyNewEsim,
                      ),
                    ),
                    NativeButtonParams(
                      buttonTitle:
                          LocaleKeys.bundleExistsView_buttonTwoText.tr(),
                      buttonAction: () => navigationService.back(
                        result: BundleExistsAction.goToEsim,
                      ),
                    ),
                  ],
                ),
              ) ??
              BundleExistsAction.close;
          if (bundleExistsAction == BundleExistsAction.buyNewEsim) {
            await _continueToPurchase();
          } else if (bundleExistsAction == BundleExistsAction.goToEsim) {
            locator<HomePagerViewModel>().changeSelectedTabIndex(index: 1);
            navigationService.clearTillFirstAndShow(HomePager.routeName);
          }
        } else {
          await _continueToPurchase();
        }
      } else {
        await _continueToPurchase();
      }
    }
  }

  Future<List<PaymentType>> _refreshWalletAndValidatePaymentTypes(
    List<PaymentType> paymentTypeList,
  ) async {
    if (!paymentTypeList.contains(PaymentType.wallet)) {
      return paymentTypeList;
    }

    List<PaymentType> updatedList = paymentTypeList;

    try {
      Resource<AuthResponseModel?> response =
          await GetUserInfoUseCase(locator<ApiAuthRepository>())
              .execute(NoParams());

      await handleResponse(
        response,
        onSuccess: (Resource<AuthResponseModel?> result) async {},
        onFailure: (Resource<AuthResponseModel?> result) async {
          updatedList = updatedList
              .where((PaymentType element) => element != PaymentType.wallet)
              .toList();
        },
      );
    } on Object catch (_) {
      updatedList = updatedList
          .where((PaymentType element) => element != PaymentType.wallet)
          .toList();
    }

    return updatedList;
  }

  List<PaymentType> _removeWalletIfInsufficientBalance(
    List<PaymentType> paymentTypeList,
    double price,
  ) {
    if (paymentTypeList.contains(PaymentType.wallet) &&
        price > userAuthenticationService.walletAvailableBalance) {
      return paymentTypeList
          .where((PaymentType element) => element != PaymentType.wallet)
          .toList();
    }
    return paymentTypeList;
  }

  Future<PaymentType?> _selectPaymentType(
    List<PaymentType> paymentTypeList,
    double price,
  ) async {
    if (paymentTypeList.length == 1) {
      return _handleSinglePaymentType(paymentTypeList.first, price);
    }

    return PaymentHelper.choosePaymentMethod(paymentTypeList);
  }

  PaymentType? _handleSinglePaymentType(PaymentType paymentType, double price) {
    if (paymentType == PaymentType.wallet) {
      if (!isUserLoggedIn) {
        return null;
      }

      final bool hasSufficientBalance =
          userAuthenticationService.walletAvailableBalance >= price;

      if (!hasSufficientBalance) {
        unawaited(showToast(LocaleKeys.no_sufficient_balance_in_wallet.tr()));
        return null;
      }
    }

    return paymentType;
  }

  Future<void> _continueToPurchase() async {
    List<PaymentType> paymentTypeList = AppEnvironment.appEnvironmentHelper
        .paymentTypeList(isUserLoggedIn: isUserLoggedIn);
    final double price = bundle?.price ?? 0;

    if (price == 0) {
      _triggerAssignFlow(paymentType: PaymentType.card);
      return;
    }

    paymentTypeList =
        await _refreshWalletAndValidatePaymentTypes(paymentTypeList);
    paymentTypeList =
        _removeWalletIfInsufficientBalance(paymentTypeList, price);

    if (paymentTypeList.isEmpty) {
      showToast(LocaleKeys.no_payment_method_available.tr());
      return;
    }

    final PaymentType? paymentType =
        await _selectPaymentType(paymentTypeList, price);
    if (paymentType != null) {
      _triggerAssignFlow(paymentType: paymentType);
    }
  }

  Future<void> _triggerAssignFlow({
    required PaymentType paymentType,
  }) async {
    String? bearerToken;
    if (!isUserLoggedIn) {
      bearerToken = await _getTemporaryToken();
      if (bearerToken == null) {
        return;
      }
    }

    setViewState(ViewState.busy);
    Resource<BundleAssignResponseModel?> response =
        await AssignUserBundleUseCase(locator()).execute(
      AssignUserBundleParam(
        bundleCode: bundle?.bundleCode ?? "",
        promoCode: _promoCode ?? "",
        referralCode: "",
        affiliateCode: "",
        paymentType: paymentType.type,
        bearerToken: bearerToken,
        relatedSearch: (bundle?.isCruise ?? false)
            ? RelatedSearchRequestModel(
                countries: <CountriesRequestModel>[],
              )
            : RelatedSearchRequestModel(
                region: region,
                countries: countriesList,
              ),
      ),
    );
    setViewState(ViewState.idle);

    handleResponse(
      response,
      onSuccess: (Resource<BundleAssignResponseModel?> result) async {
        analyticsService.logEvent(
          event: AnalyticEvent.createOrder(
            bundleCode: bundle?.bundleCode ?? "",
            bundleName: bundle?.bundleName ?? "",
            user: userEmailAddress,
            orderId: result.data?.orderId ?? "",
            method: paymentType.type,
          ),
        );
        PaymentStatus paymentStatus =
            PaymentStatus.fromString(result.data?.paymentStatus);
        if (paymentStatus == PaymentStatus.completed) {
          _navigateToLoading(
            result.data?.orderId ?? "",
            bearerToken,
          );
          return;
        }
        await PaymentHelper.checkTaxAmount(
          result: result,
          onError: () async {
            handleError(result);
            cancelOrder(orderID: result.data?.orderId ?? "");
          },
          onSuccess: () => _initiatePaymentRequest(
            params: PaymentRequestParams(
              secretParams: PaymentRequestSecretParams(
                paymentType: paymentType,
                publishableKey: result.data?.publishableKey ?? "",
                merchantIdentifier: result.data?.merchantIdentifier ?? "",
                paymentIntentClientSecret:
                    result.data?.paymentIntentClientSecret ?? "",
                customerEphemeralKeySecret:
                    result.data?.customerEphemeralKeySecret ?? "",
                bearerToken: bearerToken,
                test: result.data?.testEnv ?? false,
              ),
              idParams: PaymentRequestIDParams(
                orderID: result.data?.orderId ?? "",
                customerId: result.data?.customerId ?? "",
                billingCountryCode: result.data?.billingCountryCode ?? "",
                bundleCode: bundle?.bundleCode ?? "",
                bundleName: bundle?.bundleName ?? "",
              ),
            ),
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
          return;
        }
        handleError(response);
      },
    );
  }

  Future<void> _initiatePaymentRequest({
    required PaymentRequestParams params,
  }) async {
    try {
      setViewState(ViewState.busy);

      await paymentService.prepareCheckout(
        paymentType: params.secretParams.paymentType,
        publishableKey: params.secretParams.publishableKey,
        merchantIdentifier: params.secretParams.merchantIdentifier,
      );

      analyticsService.logEvent(
        event: AnalyticEvent.stripePay(
          bundleCode: bundle?.bundleCode ?? "",
          bundleName: bundle?.bundleName ?? "",
          user: userEmailAddress,
          orderId: params.idParams.orderID,
        ),
      );
      PaymentResult paymentResult = await paymentService.processOrderPayment(
        paymentType: params.secretParams.paymentType,
        params: ProcessOrderPaymentParams(
          orderID: params.idParams.orderID,
          billingCountryCode: params.idParams.billingCountryCode,
          paymentIntentClientSecret:
              params.secretParams.paymentIntentClientSecret,
          customerId: params.idParams.customerId,
          customerEphemeralKeySecret:
              params.secretParams.customerEphemeralKeySecret,
          testEnv: params.secretParams.test,
        ),
      );

      setViewState(ViewState.idle);

      switch (paymentResult) {
        case PaymentResult.completed:
          analyticsService.logEvent(
            event: AnalyticEvent.stripePaymentSuccessful(
              bundleCode: bundle?.bundleCode ?? "",
              bundleName: bundle?.bundleName ?? "",
              user: userEmailAddress,
              orderId: params.idParams.orderID,
            ),
          );
          _navigateToLoading(
            params.idParams.orderID,
            params.secretParams.bearerToken,
          );

        case PaymentResult.canceled:
          cancelOrder(orderID: params.idParams.orderID);

        case PaymentResult.otpRequested:
          //must send api for request otp , not implemented from backend
          bool result = await locator<NavigationService>().navigateTo(
            VerifyPurchaseView.routeName,
            arguments: VerifyPurchaseViewArgs(
              iccid: "",
              orderID: params.idParams.orderID,
            ),
            preventDuplicates: false,
          );
          debugPrint("result: $result");
          if (result) {
            _navigateToLoading(
              params.idParams.orderID,
              params.secretParams.bearerToken,
            );
          } else {
            cancelOrder(orderID: params.idParams.orderID);
          }
      }
    } on Exception catch (e) {
      showToast(
        e.toString().replaceAll("Exception:", ""),
      );
      setViewState(ViewState.idle);
      unawaited(cancelOrder(orderID: params.idParams.orderID));
      return;
    }
  }

  Future<void> showTermsSheet() async {
    SheetResponse<EmptyBottomSheetResponse>? response =
        await bottomSheetService.showCustomSheet(
      variant: BottomSheetType.termsCondition,
      isScrollControlled: true,
      enableDrag: false,
    );
    if (response?.confirmed ?? false) {
      _isTermsChecked = true;
      _validateForm();
    }
  }

  Future<void> _navigateToLoading(String orderID, String? bearerToken) async {
    // remove the promo code after payment successfully completed
    _removePromoCodeFromLocalStorage();

    String utm = localStorageService.getString(LocalStorageKeys.utm) ?? "";
    analyticsService.logEvent(
      event: AnalyticEvent.buySuccess(
        utm: utm,
        platform: Platform.isAndroid ? "Android" : "iOS",
        amount: bundle?.priceDisplay ?? "",
        currency: bundle?.currencyCode ?? "",
      ),
    );

    locator.resetLazySingleton(instance: locator<PurchaseLoadingViewModel>());
    navigationService.navigateTo(
      preventDuplicates: false,
      PurchaseLoadingView.routeName,
      arguments: PurchaseLoadingViewData(
        orderID: orderID,
        bearerToken: bearerToken,
      ),
    );
  }

  //#endregion

  //#region Apis
  Future<String?> _getTemporaryToken() async {
    setViewState(ViewState.busy);
    Resource<AuthResponseModel?> response = await tmpLoginUseCase.execute(
      TmpLoginParams(
        email:
            (emailErrorMessage == "" && _emailController.text.trim().isNotEmpty)
                ? _emailController.text.trim()
                : null,
        phone: _isValidPhoneNumber
            ? "+${phoneController.value?.countryCode}${phoneController.value?.nsn}"
            : null,
      ),
    );
    setViewState(ViewState.idle);
    String? token;

    switch (response.resourceType) {
      case ResourceType.success:
        if (response.data == null) {
          handleError(response);
        } else {
          token = response.data?.accessToken;
        }
      case ResourceType.error:
        handleError(response);
      case ResourceType.loading:
    }

    return token;
  }

  Future<bool> _checkIfBundleExists() async {
    setViewState(ViewState.busy);
    bool bundleExists = false;
    Resource<bool?> response = await getBundleExistsUseCase
        .execute(BundleExistsParams(code: bundle?.bundleCode ?? ""));

    handleResponse(
      response,
      onSuccess: (Resource<bool?> result) async {
        if (result.data == null) {
          handleError(response);
          return;
        }
        bundleExists = result.data ?? false;
      },
      onFailure: (Resource<bool?> result) async {},
    );
    setViewState(ViewState.idle);
    return bundleExists;
  }

  Future<void> validatePromoCode(
    String promoCode, {
    bool isReferral = false,
  }) async {
    if (!promoCodeFieldEnabled) {
      _promoCode = null;
      bundle = tempBundle;
      _promoCodeController.clear();
      updatePromoCodeView(isEnabled: true);
      notifyListeners();
      return;
    }

    setViewState(ViewState.busy);

    Resource<BundleResponseModel?> response =
        await validatePromoCodeUseCase.execute(
      ValidatePromoCodeUseCaseParams(
        promoCode: promoCode.trim(),
        bundleCode: bundle?.bundleCode ?? "",
      ),
    );

    handleResponse(
      response,
      onSuccess: (Resource<BundleResponseModel?> result) async {
        bundle = result.data;
        _promoCode = promoCode;
        if (isReferral) {
          _promoCodeController.text = _referralCode;
          isPromoCodeExpanded = true;
        }
        updatePromoCodeView(
          message: result.message ?? "",
          isEnabled: false,
          fieldColor: Colors.green,
        );
      },
      onFailure: (Resource<BundleResponseModel?> result) async {
        bundle = tempBundle;
        _promoCode = null;

        if (isReferral) {
          isPromoCodeExpanded = false;
          _removePromoCodeFromLocalStorage();
          updatePromoCodeView(isEnabled: true);
        } else {
          updatePromoCodeView(
            message: result.message ?? "",
            isEnabled: true,
            fieldColor: Colors.red,
          );
        }
      },
    );

    setViewState(ViewState.idle);
  }

  void _removePromoCodeFromLocalStorage() {
    unawaited(
      locator<LocalStorageService>().remove(LocalStorageKeys.referralCode),
    );
  }

//#endregion
}
