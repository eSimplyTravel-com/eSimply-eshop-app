import "package:esim_open_source/domain/data/api_app.dart";
import "package:esim_open_source/domain/data/api_bundles.dart";
import "package:esim_open_source/domain/data/api_device.dart";
import "package:esim_open_source/domain/data/api_notifications.dart";
import "package:esim_open_source/domain/data/api_promotion.dart";
import "package:esim_open_source/domain/data/api_user.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/api_bundles_repository.dart";
import "package:esim_open_source/domain/repository/api_device_repository.dart";
import "package:esim_open_source/domain/repository/api_notifications_repository.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/repository/services/connectivity_service.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/domain/repository/services/dynamic_linking_service.dart";
import "package:esim_open_source/domain/repository/services/environment_service.dart";
import "package:esim_open_source/domain/repository/services/flutter_channel_handler_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/payment_service.dart";
import "package:esim_open_source/domain/repository/services/push_notification_service.dart";
import "package:esim_open_source/domain/repository/services/redirections_handler_service.dart";
import "package:esim_open_source/domain/repository/services/referral_info_service.dart";
// import "package:esim_open_source/domain/repository/services/remote_config_service.dart";
import "package:esim_open_source/domain/repository/services/secure_storage_service.dart";
import "package:esim_open_source/domain/repository/services/social_login_service.dart";
import "package:esim_open_source/domain/use_case/app/get_about_us_use_case.dart";
import "package:esim_open_source/domain/use_case/app/get_banner_use_case.dart";
import "package:esim_open_source/domain/use_case/app/get_terms_and_condition_use_case.dart";
import "package:esim_open_source/presentation/extensions/stacked_services/custom_route_observer.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/cashback_reward_bottom_sheet/cashback_reward_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/delete_account_bottom_sheet/delete_account_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/e_sim_bundle/my_e_sim_bundle_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/e_sim_bundle_consumption/consumption_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/edit_name/edit_name_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/reactive_service/bundles_data_service.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/reactive_service/user_service.dart";
import "package:esim_open_source/presentation/view_models/main_model.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/bundle_details_bottom_sheet/bundle_detail_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/order_bottom_sheet_view/order_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/order_receipt_bottom_sheet_view/order_receipt_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/bundles_list_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/data_plans_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/purchase_loading_view/purchase_loading_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/purchase_order_success/purchase_order_success_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/verify_purchase_view/verify_purchase_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/my_esim_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/notifications_view/notifications_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/account_information_view/account_information_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/contact_us_view/contact_us_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_data_view/dynamic_data_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_selection_view/dynamic_selection_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/faq_view/faq_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/order_history_view/order_history_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/rewards_history_view/rewards_history_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/android_user_guide_view/android_user_guide_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_detailed_view/user_guide_detailed_view_model.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/continue_with_email_view/continue_with_email_view_model.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/device_compability_check_view/device_compability_check_view_model.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/login_view/login_view_model.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/verify_login_view/verify_login_view_model.dart";
// import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/verify_purchase_view/verify_purchase_view_model.dart";
import "package:esim_open_source/presentation/views/start_up_view/startup_view_model.dart";
import "package:flutter_esim/flutter_esim.dart";
import "package:get_it/get_it.dart";
import "package:http/http.dart" as http;
import "package:mockito/annotations.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:stacked/stacked_annotations.dart";
import "package:stacked_services/stacked_services.dart";
import "package:stacked_themes/stacked_themes.dart";

import "locator_test.mocks.dart";

// ignore_for_file: type=lint
@GenerateMocks(<Type>[
  NavigationRouter,
  CustomRouteObserver,
  DeviceInfoService,
  DynamicLinkingService,
  PushNotificationService,
  SocialLoginService,
  PaymentService,
  SecureStorageService,
  RedirectionsHandlerService,
  LocalStorageService,
  AppConfigurationService,
  ReferralInfoService,
  FlutterChannelHandlerService,
  AnalyticsService,
  BundleDetailBottomSheetViewModel,
  OrderBottomSheetViewModel,
  OrderReceiptBottomSheetViewModel,
  EditNameBottomSheetViewModel,
  CashbackRewardBottomSheetViewModel,
  DeleteAccountBottomSheetViewModel,
  MyESimBundleBottomSheetViewModel,
  ConsumptionBottomSheetViewModel,
  //RemoteConfigService,
  ConnectivityService,
  ApiAuthRepository,
  ApiAppRepository,
  APIBundles,
  ApiUser,
  ApiBundlesRepository,
  ApiUserRepository,
  ApiDeviceRepository,
  APIPromotion,
  ApiPromotionRepository,
  GetAboutUsUseCase,
  GetBannerUseCase,
  GetTermsAndConditionUseCase,
  NavigationService,
  DialogService,
  SnackbarService,
  BottomSheetService,
  ThemeService,
  //ViewModel
  AndroidUserGuideViewModel,
  MainViewModel,
  MyESimViewModel,
  ProfileViewModel,
  DataPlansViewModel,
  HomePagerViewModel,
  StartUpViewModel,
  ContinueWithEmailViewModel,
  PurchaseLoadingViewModel,
  DeviceCompabilityCheckViewModel,
  LoginViewModel,
  VerifyLoginViewModel,
  VerifyPurchaseViewModel,
  UserGuideDetailedViewModel,
  //Services
  UserService,
  UserAuthenticationService,
  BundlesDataService,
  EnvironmentService,
  SharedPreferences,
  FlutterEsim,
  APIDevice,
  APIApp,
  APINotifications,
  ApiNotificationsRepository,
  http.Client,
])
Future<void> main() async {}

final GetIt locator = GetIt.instance;

Future<void> setupTestLocator() async {
  StackedLocator.instance.registerEnvironment();

  locator
    ..registerLazySingleton<NavigationRouter>(MockNavigationRouter.new)
    ..registerLazySingleton<MockCustomRouteObserver>(
      MockCustomRouteObserver.new,
    )
    ..registerLazySingleton<UserService>(MockUserService.new)
    ..registerLazySingleton<UserAuthenticationService>(
      MockUserAuthenticationService.new,
    )
    ..registerLazySingleton<BundlesDataService>(MockBundlesDataService.new);

  await appServicesModule();
  await appAPIServicesModule();
  await thirdPartyServicesModule();
  await viewModelModules();
}

Future<void> appServicesModule() async {
  locator
    ..registerLazySingleton<DeviceInfoService>(MockDeviceInfoService.new)
    ..registerLazySingleton<DynamicLinkingService>(
        MockDynamicLinkingService.new)
    ..registerLazySingleton<PushNotificationService>(
      MockPushNotificationService.new,
    )
    ..registerLazySingleton<SocialLoginService>(MockSocialLoginService.new)
    ..registerLazySingleton<PaymentService>(MockPaymentService.new)
    ..registerLazySingleton<SecureStorageService>(MockSecureStorageService.new)
    ..registerLazySingleton<RedirectionsHandlerService>(
      MockRedirectionsHandlerService.new,
    )
    ..registerLazySingleton<LocalStorageService>(MockLocalStorageService.new)
    ..registerLazySingleton<AnalyticsService>(MockAnalyticsService.new)
    ..registerLazySingleton<ReferralInfoService>(
      MockReferralInfoService.new,
    )
    ..registerLazySingleton<AppConfigurationService>(
      MockAppConfigurationService.new,
    )
    ..registerLazySingleton<FlutterChannelHandlerService>(
      MockFlutterChannelHandlerService.new,
    )
    ..registerLazySingleton<EnvironmentService>(
      MockEnvironmentService.new,
    )
    //..registerLazySingleton<RemoteConfigService>(MockRemoteConfigService.new)
    ..registerLazySingleton<ConnectivityService>(MockConnectivityService.new)
    ..registerLazySingleton<SharedPreferences>(MockSharedPreferences.new);
  //   ..registerLazySingleton(
  //   () => RedirectionsHandlerServiceImpl.initializeWithNavigationService(
  //     navigationService: locator(),
  //     bottomSheetService: locator(),
  //   ) as RedirectionsHandlerService,
  // )
  // ..registerSingletonAsync<Store>(
  //   () async => openStore(),
  // )
}

Future<void> appAPIServicesModule() async {
  locator
    ..registerLazySingleton<ApiAuthRepository>(MockApiAuthRepository.new)
    ..registerLazySingleton<ApiAppRepository>(
      MockApiAppRepository.new,
    )
    ..registerLazySingleton<APIBundles>(MockAPIBundles.new)
    ..registerLazySingleton<ApiUser>(MockApiUser.new)
    ..registerLazySingleton<ApiBundlesRepository>(MockApiBundlesRepository.new)
    ..registerLazySingleton<ApiUserRepository>(
      MockApiUserRepository.new,
    )
    ..registerLazySingleton<GetAboutUsUseCase>(
      MockGetAboutUsUseCase.new,
    )
    ..registerLazySingleton<GetTermsAndConditionUseCase>(
      MockGetTermsAndConditionUseCase.new,
    )
    // ..registerLazySingleton<GetOrderHistoryPaginationUseCase>(
    //   MockGetOrderHistoryPaginationUseCase.new,
    // )
    ..registerLazySingleton<ApiDeviceRepository>(MockApiDeviceRepository.new)
    ..registerLazySingleton<APIPromotion>(MockAPIPromotion.new)
    ..registerLazySingleton<ApiPromotionRepository>(
      MockApiPromotionRepository.new,
    );
}

Future<void> thirdPartyServicesModule() async {
  locator
    ..registerLazySingleton<NavigationService>(MockNavigationService.new)
    ..registerLazySingleton<DialogService>(MockDialogService.new)
    ..registerLazySingleton<SnackbarService>(MockSnackbarService.new)
    ..registerLazySingleton<BottomSheetService>(MockBottomSheetService.new)
    ..registerLazySingleton<ThemeService>(MockThemeService.new);
}

Future<void> viewModelModules() async {
  locator
    ..registerLazySingleton<OrderBottomSheetViewModel>(
      MockOrderBottomSheetViewModel.new,
    )
    ..registerLazySingleton<OrderReceiptBottomSheetViewModel>(
      MockOrderReceiptBottomSheetViewModel.new,
    )
    ..registerFactory<EditNameBottomSheetViewModel>(
      MockEditNameBottomSheetViewModel.new,
    )
    ..registerFactory<CashbackRewardBottomSheetViewModel>(
      MockCashbackRewardBottomSheetViewModel.new,
    )
    ..registerFactory<MyESimBundleBottomSheetViewModel>(
      MockMyESimBundleBottomSheetViewModel.new,
    )
    ..registerFactory<ConsumptionBottomSheetViewModel>(
      ConsumptionBottomSheetViewModel.new,
    )
    ..registerLazySingleton<BundleDetailBottomSheetViewModel>(
      MockBundleDetailBottomSheetViewModel.new,
    )
    ..registerLazySingleton<AndroidUserGuideViewModel>(
      MockAndroidUserGuideViewModel.new,
    )
    ..registerLazySingleton<MainViewModel>(
      MockMainViewModel.new,
    )
    ..registerLazySingleton<MyESimViewModel>(
      MyESimViewModel.new,
    )
    ..registerLazySingleton<ProfileViewModel>(
      ProfileViewModel.new,
    )
    ..registerLazySingleton<DataPlansViewModel>(
      /*Mock*/ DataPlansViewModel.new,
    )
    ..registerLazySingleton<HomePagerViewModel>(
      /*Mock*/ HomePagerViewModel.new,
    )
    ..registerLazySingleton<PurchaseLoadingViewModel>(
      PurchaseLoadingViewModel.new,
    )
    ..registerLazySingleton<ContinueWithEmailViewModel>(
      MockContinueWithEmailViewModel.new,
    )
    ..registerLazySingleton<StartUpViewModel>(
      MockStartUpViewModel.new,
    )
    ..registerLazySingleton<DeviceCompabilityCheckViewModel>(
      MockDeviceCompabilityCheckViewModel.new,
    )
    ..registerLazySingleton<LoginViewModel>(
      MockLoginViewModel.new,
    )
    ..registerLazySingleton<VerifyLoginViewModel>(
      VerifyLoginViewModel.new,
    )
    ..registerLazySingleton<VerifyPurchaseViewModel>(
      VerifyPurchaseViewModel.new,
    )
    ..registerLazySingleton<UserGuideDetailedViewModel>(
      UserGuideDetailedViewModel.new,
    )
    ..registerLazySingleton<OrderHistoryViewModel>(
      OrderHistoryViewModel.new,
    )
    ..registerLazySingleton<RewardsHistoryViewModel>(
      RewardsHistoryViewModel.new,
    )
    ..registerLazySingleton<FaqViewModel>(
      FaqViewModel.new,
    )
    ..registerLazySingleton<DynamicSelectionViewModel>(
      DynamicSelectionViewModel.new,
    )
    ..registerLazySingleton<DynamicDataViewModel>(
      DynamicDataViewModel.new,
    )
    ..registerLazySingleton<ContactUsViewModel>(
      ContactUsViewModel.new,
    )
    ..registerLazySingleton<AccountInformationViewModel>(
      AccountInformationViewModel.new,
    )
    ..registerLazySingleton<NotificationsViewModel>(
      NotificationsViewModel.new,
    )
    ..registerLazySingleton<PurchaseOrderSuccessViewModel>(
      PurchaseOrderSuccessViewModel.new,
    )
    ..registerLazySingleton<BundlesListViewModel>(
      BundlesListViewModel.new,
    );
}
