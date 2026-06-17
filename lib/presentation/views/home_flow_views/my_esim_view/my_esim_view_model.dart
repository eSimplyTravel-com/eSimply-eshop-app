import "dart:async";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/data/response/user/user_notification_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/repository/services/flutter_channel_handler_service.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_bundle_label_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_user_notifications_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_user_purchased_esims_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/validation_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/purchase_loading_view/purchase_loading_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/purchase_loading_view/purchase_loading_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/notifications_view/notifications_view.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:stacked_services/stacked_services.dart";

class MyESimViewModel extends BaseModel {
  //#region UseCases
  final GetUserNotificationsUseCase getUserNotificationsUseCase =
      GetUserNotificationsUseCase(locator<ApiUserRepository>());

  final GetBundleLabelUseCase getBundleLabelUseCase =
      GetBundleLabelUseCase(locator());

  //#endregion

  //#region Variables
  final ESimState _state = ESimState();

  ESimState get state => _state;

  bool isInstallationFailed = false;
  //#endregion

  //#region Functions
  @override
  void onViewModelReady() {
    unawaited(refreshScreen(isSilent: false));
  }

  set setTabIndex(int index) {
    _state.selectedTabIndex = index;
    // unawaited(refreshData());
    // notifyListeners();
  }

  void openDataPlans() {
    locator<HomePagerViewModel>().changeSelectedTabIndex(index: 0);
  }

  void notificationsButtonTapped() {
    unawaited(navigationService.navigateTo(NotificationsView.routeName));
  }

  PurchaseEsimBundleResponseModel? _getEsimBundleByICCID(String iccid) {
    PurchaseEsimBundleResponseModel? selectedItem;
    selectedItem = _state.currentESimList
        .where((PurchaseEsimBundleResponseModel item) => item.iccid == iccid)
        .firstOrNull;
    selectedItem ??= _state.expiredESimList
        .where((PurchaseEsimBundleResponseModel item) => item.iccid == iccid)
        .firstOrNull;
    return selectedItem;
  }

  Future<void> onTopUpClick({required String iccid}) async {
    PurchaseEsimBundleResponseModel? item = _getEsimBundleByICCID(iccid);

    if (item == null) {
      return;
    }

    SheetResponse<MainBottomSheetResponse>? sheetResponse =
        await bottomSheetService.showCustomSheet(
      isScrollControlled: true,
      variant: BottomSheetType.topUpBundle,
      data: BundleTopUpBottomRequest(
        iccID: item.iccid ?? "",
        bundleCode: item.bundleCode ?? "",
      ),
    );

    if (!(sheetResponse?.data?.canceled ?? true)) {
      bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.successBottomSheet,
        data: SuccessBottomRequest(
          title: LocaleKeys.hurray.tr(),
          description: LocaleKeys.top_up_success_message.tr(),
          imagePath: EnvironmentImages.compatibleIcon.fullImagePath,
        ),
      );

      refreshCurrentPlans();
    }
  }

  Future<void> onConsumptionClick({required String iccid}) async {
    PurchaseEsimBundleResponseModel? item = _getEsimBundleByICCID(iccid);

    if (item == null) {
      return;
    }

    SheetResponse<MainBottomSheetResponse>? sheetResponse =
        await bottomSheetService.showCustomSheet(
      isScrollControlled: true,
      variant: BottomSheetType.bundleConsumption,
      data: BundleConsumptionBottomRequest(
        iccID: item.iccid ?? "",
        showTopUp: item.isTopupAllowed ?? true,
        isUnlimitedData: item.unlimited ?? false,
      ),
    );

    if (!(sheetResponse?.data?.canceled ?? true) &&
        sheetResponse?.data?.tag == "top-up") {
      onTopUpClick(iccid: iccid);
    }
  }

  Future<void> onQrCodeClick({required String iccid}) async {
    PurchaseEsimBundleResponseModel? item = _getEsimBundleByICCID(iccid);

    if (item == null) {
      return;
    }

    await bottomSheetService.showCustomSheet(
      isScrollControlled: true,
      variant: BottomSheetType.bundleQrCode,
      data: BundleQrBottomRequest(
        iccID: item.iccid ?? "",
        activationCode: item.activationCode ?? "",
        smDpAddress: item.smdpAddress ?? "",
      ),
    );
  }

  Future<void> onInstallClick({required String iccid}) async {
    try {
      PurchaseEsimBundleResponseModel? item = _getEsimBundleByICCID(iccid);

      if (item == null) {
        return;
      }

      if (Platform.isAndroid) {
        // unawaited(
        await locator<FlutterChannelHandlerService>().openEsimSetupForAndroid(
          smdpAddress: item.smdpAddress ?? "",
          activationCode: item.activationCode ?? "",
          //),
        );
      } else {
        // unawaited(
        await locator<FlutterChannelHandlerService>().openEsimSetupForIOS(
          smdpAddress: item.smdpAddress ?? "",
          activationCode: item.activationCode ?? "",
          //  ),
        );
      }
    } on Object catch (ex) {
      _state.showInstallButton = false;
      notifyListeners();
      isInstallationFailed = true;
      showNativeErrorMessage("", ex.toString().replaceAll("Exception:", ""));
    }
  }

  Future<void> onEditNameClick({required String iccid}) async {
    PurchaseEsimBundleResponseModel? item = _getEsimBundleByICCID(iccid);

    if (item == null) {
      return;
    }

    SheetResponse<MainBottomSheetResponse>? sheetResponse =
        await bottomSheetService.showCustomSheet(
      isScrollControlled: true,
      variant: BottomSheetType.bundleEditName,
      data: BundleEditNameRequest(
        name: item.displayTitle ?? "",
      ),
    );
    if (sheetResponse?.data?.canceled == false &&
        (sheetResponse?.data?.tag ?? "").isNotEmpty) {
      _changeBundleName(
        iccid: item.iccid ?? "",
        label: sheetResponse?.data?.tag ?? "",
      );
    }
  }

  Future<void> navigateToLoading(String orderID) async {
    locator.resetLazySingleton(instance: locator<PurchaseLoadingViewModel>());
    navigationService.navigateTo(
      PurchaseLoadingView.routeName,
      arguments: PurchaseLoadingViewData(orderID: orderID),
    );
  }

  Future<void> onCurrentBundleClick({required String iccid}) async {
    if (isBusy) {
      return;
    }
    PurchaseEsimBundleResponseModel? item = _getEsimBundleByICCID(iccid);

    if (item == null) {
      return;
    }

    SheetResponse<MainBottomSheetResponse>? sheetResponse =
        await bottomSheetService.showCustomSheet(
      isScrollControlled: true,
      ignoreSafeArea: false,
      // enableDrag: false,
      variant: BottomSheetType.myESimBundle,
      data: MyESimBundleRequest(eSimBundleResponseModel: item),
    );
    if (!(sheetResponse?.data?.canceled ?? false)) {
      String tag = sheetResponse?.data?.tag ?? "";
      if (tag == "top_up") {
        onTopUpClick(iccid: iccid);
      }
    }
  }

  Future<void> onExpiredBundleClick({required String iccid}) async {
    if (isBusy) {
      return;
    }
    PurchaseEsimBundleResponseModel? item = _getEsimBundleByICCID(iccid);

    if (item == null) {
      return;
    }

    SheetResponse<MainBottomSheetResponse>? sheetResponse =
        await bottomSheetService.showCustomSheet(
      isScrollControlled: true,
      ignoreSafeArea: false,
      // enableDrag: false,
      variant: BottomSheetType.myESimBundle,
      data: MyESimBundleRequest(eSimBundleResponseModel: item),
    );
    if (!(sheetResponse?.data?.canceled ?? false)) {
      String tag = sheetResponse?.data?.tag ?? "";
      if (tag == "top_up") {
        onTopUpClick(iccid: iccid);
      }
    }
  }

  Future<void> refreshCurrentPlans() async {
    refreshScreen(isSilent: false);
  }

//#endregion

  //#region Apis

  Future<void> handleNotificationBadge() async {
    Resource<List<UserNotificationModel>?> response =
        await getUserNotificationsUseCase.execute(NoParams());
    handleResponse(
      response,
      onSuccess: (Resource<List<UserNotificationModel>?> result) async {
        if (result.data == null || (result.data?.isEmpty ?? true)) {
          _state.showNotificationBadge = false;
        } else {
          UserNotificationModel? foundNotRead;
          try {
            foundNotRead = result.data!.firstWhere(
              (UserNotificationModel notification) =>
                  !(notification.status ?? false),
            );
          } on Exception catch (_) {
            foundNotRead = null;
          }

          _state.showNotificationBadge = (foundNotRead != null);
          notifyListeners();
        }
      },
      onFailure: (Resource<List<UserNotificationModel>?> result) async {
        _state.showNotificationBadge = false;
        notifyListeners();
      },
    );
  }

  Future<void> refreshScreen({
    bool isSilent = true,
  }) async {
    if (isUserLoggedIn) {
      handleNotificationBadge();
      fetchESimData(isSilent: isSilent);
    }
  }

  Future<void> fetchESimData({
    bool isSilent = true,
  }) async {
    if (_state.currentESimList.isEmpty) {
      _state.currentESimList.clear();
      _state.currentESimList
          .addAll(PurchaseEsimBundleResponseModel.mockItems());
    }

    if (_state.expiredESimList.isEmpty) {
      _state.expiredESimList.clear();
      _state.expiredESimList
          .addAll(PurchaseEsimBundleResponseModel.mockItems());
    }

    setViewState(ViewState.busy);
    // await Future<void>.delayed(const Duration(seconds: 1));
    // setViewState(ViewState.idle);
    // return;
    Resource<List<PurchaseEsimBundleResponseModel>?> response =
        await GetUserPurchasedEsimsUseCase(locator()).execute(
      NoParams(),
    );
    handleResponse(
      response,
      onSuccess:
          (Resource<List<PurchaseEsimBundleResponseModel>?> result) async {
        _state.currentESimList.clear();
        _state.expiredESimList.clear();
        if (result.data == null) {
          handleError(response);
          return;
        }
        result.data?.forEach((PurchaseEsimBundleResponseModel item) {
          if (item.bundleExpired ?? false) {
            _state.expiredESimList.add(item);
          } else {
            _state.currentESimList.add(item);
          }
        });
        if (isInstallationFailed) {
          _state.showInstallButton = false;
        } else {
          _state.showInstallButton = await isInstallButtonEnabled();
        }
        setViewState(ViewState.idle);
      },
      onFailure:
          (Resource<List<PurchaseEsimBundleResponseModel>?> result) async {
        _state.currentESimList.clear();
        _state.expiredESimList.clear();
        if (!isSilent) {
          handleError(response);
        }
      },
    );
  }

  Future<void> _changeBundleName({
    required String iccid,
    required String label,
  }) async {
    setViewState(ViewState.busy);
    Resource<EmptyResponse?> response = await getBundleLabelUseCase.execute(
      BundleLabelParams(
        iccid: iccid,
        label: label,
      ),
    );
    handleResponse(
      response,
      onSuccess: (Resource<EmptyResponse?> result) async {
        refreshCurrentPlans();
      },
    );
  }

//#endregion
}

class ESimState {
  final List<PurchaseEsimBundleResponseModel> currentESimList =
      <PurchaseEsimBundleResponseModel>[];
  final List<PurchaseEsimBundleResponseModel> expiredESimList =
      <PurchaseEsimBundleResponseModel>[];
  bool showNotificationBadge = false;
  int selectedTabIndex = 0;
  bool showInstallButton = false;
}
