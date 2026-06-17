import "package:esim_open_source/domain/data/response/app/banner_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/user/user_notification_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/api_bundles_repository.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/repository/services/connectivity_service.dart";
import "package:esim_open_source/domain/repository/services/environment_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/referral_info_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/extensions/stacked_services/custom_route_observer.dart";
import "package:esim_open_source/presentation/reactive_service/bundles_data_service.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/order_receipt_bottom_sheet_view/order_receipt_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager.dart";
import "package:esim_open_source/utils/value_stream.dart";
import "package:flutter/material.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../locator_test.dart";
import "../locator_test.mocks.dart";

// ignore_for_file: type=lint
void onViewModelReadyMock({
  String viewName = "",
  bool isConnected = true,
  bool clearTillFirstAndShow = true,
}) {
  MockEnvironmentService environmentService =
      locator<EnvironmentService>() as MockEnvironmentService;
  when(environmentService.isAndroid).thenReturn(true);

  MockApiUserRepository mockApiUserRepository =
      locator<ApiUserRepository>() as MockApiUserRepository;
  when(locator<NavigationRouter>().isPageVisible(viewName)).thenReturn(true);
  when(locator<NavigationRouter>().isPageVisible("")).thenReturn(true);
  when(locator<ConnectivityService>().isConnected())
      .thenAnswer((_) async => isConnected);
  when(locator<NavigationService>().clearTillFirstAndShow(HomePager.routeName))
      .thenAnswer((_) async => clearTillFirstAndShow);
  when(locator<NavigationService>().back()).thenReturn(true);
  when(locator<NavigationService>()
          .pushNamedAndRemoveUntil(HomePager.routeName))
      .thenAnswer((_) async => clearTillFirstAndShow);
  when(locator<LocalStorageService>().languageCode).thenReturn("en");
  when(locator<DialogService>().showDialog(
    title: anyNamed("title"),
    description: anyNamed("description"),
  )).thenAnswer((_) async => null);
  when(locator<UserAuthenticationService>().userEmailAddress).thenReturn("");
  when(locator<BundlesDataService>().isBundleServicesLoading).thenReturn(true);
  when(locator<BundlesDataService>().hasError).thenReturn(false);
  when(locator<BundlesDataService>().errorMessage).thenReturn(null);
  when(locator<AppConfigurationService>().getCashbackDiscount)
      .thenReturn("10%");
  when(locator<ReferralInfoService>().getReferralAmount).thenReturn("5");
  when(locator<ReferralInfoService>().getReferralAmountAndCurrency)
      .thenReturn("5 \$");
  when(locator<ReferralInfoService>().getReferralMessage)
      .thenReturn("Get \$5 when you join!");
  when(locator<UserAuthenticationService>().userFirstName).thenReturn("");
  when(locator<UserAuthenticationService>().userLastName).thenReturn("");
  when(locator<UserAuthenticationService>().isUserLoggedIn).thenReturn(true);
  when(locator<UserAuthenticationService>().userPhoneNumber)
      .thenReturn("expected");
  when(locator<UserAuthenticationService>().referralCode)
      .thenReturn("TEST123");

  // BottomSheetService mocks
  when(locator<BottomSheetService>().showCustomSheet(
    data: anyNamed("data"),
    enableDrag: false,
    isScrollControlled: true,
    variant: anyNamed("variant"),
  )).thenAnswer((_) async => null);

  // Navigation Service mocks
  MockNavigationService mockNavigationService =
      locator<NavigationService>() as MockNavigationService;
  when(mockNavigationService.navigateTo(
    any,
    arguments: anyNamed("arguments"),
    id: anyNamed("id"),
    preventDuplicates: anyNamed("preventDuplicates"),
    parameters: anyNamed("parameters"),
    transition: anyNamed("transition"),
  )).thenAnswer((_) async => null);

  // API mocks
  when(mockApiUserRepository.getUserNotifications(
    pageIndex: anyNamed("pageIndex"),
    pageSize: anyNamed("pageSize"),
  )).thenAnswer(
    (_) async => Resource<List<UserNotificationModel>>.success(
      <UserNotificationModel>[],
      message: "Success",
    ),
  );

  when(mockApiUserRepository.getMyEsims()).thenAnswer(
    (_) async => Resource<List<PurchaseEsimBundleResponseModel>?>.success(
      <PurchaseEsimBundleResponseModel>[],
      message: "Success",
    ),
  );

  // ApiBundles repository mocks
  MockApiBundlesRepository mockApiBundlesRepository =
      locator<ApiBundlesRepository>() as MockApiBundlesRepository;
  when(mockApiBundlesRepository.getBundlesByCountries(
    countryCodes: anyNamed("countryCodes"),
  )).thenAnswer((_) async => Resource<List<BundleResponseModel>>.success(
    <BundleResponseModel>[],
    message: "Success",
  ));

  when(mockApiBundlesRepository.getBundlesByRegion(
    regionCode: anyNamed("regionCode"),
  )).thenAnswer((_) async => Resource<List<BundleResponseModel>>.success(
    <BundleResponseModel>[],
    message: "Success",
  ));

  // ApiApp repository mocks
  MockApiAppRepository mockApiAppRepository =
      locator<ApiAppRepository>() as MockApiAppRepository;
  ValueStream<Resource<List<BannerResponseModel>?>> bannerStream =
      ValueStream<Resource<List<BannerResponseModel>?>>();
  bannerStream.add(Resource<List<BannerResponseModel>?>.success(
    <BannerResponseModel>[],
    message: "Success",
  ));
  when(mockApiAppRepository.getBannerStream()).thenReturn(bannerStream);
  when(mockApiAppRepository.resetBannerStream()).thenAnswer((_) async {});

  // OrderReceiptBottomSheetViewModel specific mocks
  if (viewName == "OrderReceiptBottomSheetView") {
    MockOrderReceiptBottomSheetViewModel mockOrderReceiptViewModel =
        locator<OrderReceiptBottomSheetViewModel>()
            as MockOrderReceiptBottomSheetViewModel;
    when(mockOrderReceiptViewModel.globalKey).thenReturn(GlobalKey());
    when(mockOrderReceiptViewModel.bundleOrderModel).thenReturn(null);
    when(mockOrderReceiptViewModel.viewState).thenReturn(ViewState.idle);
    when(mockOrderReceiptViewModel.isBusy).thenReturn(false);
  }
}

// Empty main function to prevent Flutter test runner from treating this as a test file
void main() {}
