import "dart:async";
import "dart:developer";

import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/regions_response_model.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/api_device_repository.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/domain/repository/services/flutter_channel_handler_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/payment_service.dart";
import "package:esim_open_source/domain/repository/services/redirections_handler_service.dart";
import "package:esim_open_source/domain/repository/services/social_login_service.dart";
import "package:esim_open_source/domain/use_case/app/add_device_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/presentation/reactive_service/bundles_data_service.dart";
import "package:esim_open_source/presentation/reactive_service/user_service.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart"
    as shared;
import "package:esim_open_source/presentation/views/base/mixins/connectivity_handler_mixin.dart";
import "package:esim_open_source/presentation/views/base/mixins/dialog_utilities_mixin.dart";
import "package:esim_open_source/presentation/views/base/mixins/navigation_helper_mixin.dart";
import "package:esim_open_source/presentation/views/base/mixins/response_handler_mixin.dart";
import "package:esim_open_source/presentation/views/base/mixins/view_state_manager_mixin.dart";
import "package:flutter/material.dart";
import "package:stacked/stacked.dart";
import "package:stacked_themes/stacked_themes.dart";

class BaseModel extends ReactiveViewModel
    with
        ViewStateManagerMixin,
        DialogUtilitiesMixin,
        NavigationHelperMixin,
        ResponseHandlerMixin,
        ConnectivityHandlerMixin {
  BaseModel() {
    log("init ${super.runtimeType}");
  }

  final LocalStorageService localStorageService =
      locator<LocalStorageService>();
  final AnalyticsService analyticsService = locator<AnalyticsService>();
  final ThemeService themeService = locator<ThemeService>();
  final UserService userService = locator<UserService>();
  final PaymentService paymentService = locator<PaymentService>();
  final RedirectionsHandlerService redirectionsHandlerService =
      locator<RedirectionsHandlerService>();

  final AddDeviceUseCase addDeviceUseCase = AddDeviceUseCase(
    locator<ApiAppRepository>(),
    locator<ApiDeviceRepository>(),
  );

  final FlutterChannelHandlerService flutterChannelHandlerService =
      locator<FlutterChannelHandlerService>();
  final BundlesDataService _bundlesService = locator<BundlesDataService>();

  List<BundleResponseModel>? get globalBundles => _bundlesService.globalBundles;

  List<CountryResponseModel>? get countries => _bundlesService.countries;

  List<RegionsResponseModel>? get regions => _bundlesService.regions;

  List<BundleResponseModel>? get cruiseBundles => _bundlesService.cruiseBundles;

  bool get isBundleServicesLoading => _bundlesService.isBundleServicesLoading;

  @override
  bool get hasError => _bundlesService.hasError;

  String? get errorMessage => _bundlesService.errorMessage;

  Future<void> refreshData() async {
    await _bundlesService.refreshData();
    notifyListeners();
  }

  List<BundleResponseModel>? getBundlesForCountry(String countryCode) {
    return _bundlesService.getBundlesByCountry(countryCode);
  }

  bool get showMainBanner => true;

  String get userFirstName => userAuthenticationService.userFirstName;

  String get userLastName => userAuthenticationService.userLastName;

  String get userEmailAddress => userAuthenticationService.userEmailAddress;

  String get userMsisdn => userAuthenticationService.userPhoneNumber;

  bool get isArabic {
    return false;
  }

  Color get themeColor => shared.themeColor;

  @override
  List<ListenableServiceMixin> get listenableServices =>
      <ListenableServiceMixin>[
        userService,
        userAuthenticationService,
        _bundlesService,
      ];

  Future<void> logoutUser() async {
    await userAuthenticationService.clearUserInfo();
    locator<SocialLoginService>().logOut();
    addDeviceUseCase.execute(NoParams());
    await analyticsService.setUserId(null);
  }

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
