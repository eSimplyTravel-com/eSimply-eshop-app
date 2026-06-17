import "dart:async";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/data_source/esims_local_data_source.dart";
import "package:esim_open_source/data/data_source/home_local_data_source.dart";
import "package:esim_open_source/data/data_source/local_storage_service_impl.dart";
import "package:esim_open_source/data/data_source/secure_storage_service_impl.dart";
import "package:esim_open_source/data/remote/apis/app_apis/api_app_impl.dart";
import "package:esim_open_source/data/remote/apis/auth_apis/api_auth_impl.dart";
import "package:esim_open_source/data/remote/apis/bundles_apis/api_bundles_impl.dart";
import "package:esim_open_source/data/remote/apis/device_apis/api_device_impl.dart";
import "package:esim_open_source/data/remote/apis/promotion_apis/api_promotion_impl.dart";
import "package:esim_open_source/data/remote/apis/user_apis/apis_user_impl.dart";
import "package:esim_open_source/data/repository/api_app_repository_impl.dart";
import "package:esim_open_source/data/repository/api_auth_repository_impl.dart";
import "package:esim_open_source/data/repository/api_bundles_repository_impl.dart";
import "package:esim_open_source/data/repository/api_device_repository_impl.dart";
import "package:esim_open_source/data/repository/api_promotion_repository_impl.dart";
import "package:esim_open_source/data/repository/api_user_repository_impl.dart";
import "package:esim_open_source/data/services/analytics_service_impl.dart";
import "package:esim_open_source/data/services/app_configuration_service_impl.dart";
import "package:esim_open_source/data/services/connectivity_service_impl.dart";
import "package:esim_open_source/data/services/device_info_service_impl.dart";
import "package:esim_open_source/data/services/dynamic_linking_service_empty_impl.dart";
import "package:esim_open_source/data/services/dynamic_linking_service_impl.dart";
import "package:esim_open_source/data/services/environment_service_impl.dart";
import "package:esim_open_source/data/services/flutter_channel_handler_service_impl.dart";
import "package:esim_open_source/data/services/payment/payment_service_impl.dart";
import "package:esim_open_source/data/services/push_notification_service_impl.dart";
import "package:esim_open_source/data/services/redirections_handler_service_impl.dart";
import "package:esim_open_source/data/services/referral_info_service_impl.dart";
import "package:esim_open_source/data/services/remote_config_service_impl.dart";
import "package:esim_open_source/data/services/social_login_service_impl.dart";
import "package:esim_open_source/domain/data/api_bundles.dart";
import "package:esim_open_source/domain/data/api_promotion.dart";
import "package:esim_open_source/domain/data/api_user.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/api_bundles_repository.dart";
import "package:esim_open_source/domain/repository/api_device_repository.dart";
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
import "package:esim_open_source/domain/repository/services/remote_config_service.dart";
import "package:esim_open_source/domain/repository/services/secure_storage_service.dart";
import "package:esim_open_source/domain/repository/services/social_login_service.dart";
import "package:esim_open_source/objectbox.g.dart";
import "package:esim_open_source/presentation/extensions/stacked_services/custom_route_observer.dart";
import "package:esim_open_source/presentation/view_models/main_model.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/bundle_details_bottom_sheet/bundle_detail_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/cashback_reward_bottom_sheet/cashback_reward_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/delete_account_bottom_sheet/delete_account_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/e_sim_bundle/my_e_sim_bundle_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/e_sim_bundle_consumption/consumption_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/edit_name/edit_name_bottom_sheet_view_model.dart";
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
import "package:esim_open_source/presentation/views/start_up_view/startup_view_model.dart";
import "package:get_it/get_it.dart";
import "package:stacked_services/stacked_services.dart";
import "package:stacked_themes/stacked_themes.dart";

GetIt locator = GetIt.instance;

Future<void> setupBaseFlutterLocator() async {
  await setupLocator();

  locator
    ..registerLazySingleton(NavigationRouter.new)
    ..registerLazySingleton(CustomRouteObserver.new);

  await thirdPartyServicesModule();

  await appServicesModule();

  await appAPIServicesModule();

  await viewModelModules();

  await viewModelInjectionModules();
}

Future<void> appServicesModule() async {
  //push notifications
  locator
    ..registerLazySingleton(
      () => DeviceInfoServiceImpl.instance as DeviceInfoService,
    )
    ..registerLazySingleton(
      () =>
          PushNotificationServiceImpl.getInstance() as PushNotificationService,
    )
    ..registerLazySingleton(
      () => SocialLoginServiceImpl.instance as SocialLoginService,
      dispose: (SocialLoginService service) => service.onDispose(),
    )
    // ..registerLazySingleton(
    //   () => AppEnvironment.appEnvironmentHelper.paymentServiceType ==
    //           PaymentType.dcb
    //       ? DcbPaymentServiceImpl.instance as PaymentService
    //       : StripePaymentServiceImpl.instance as PaymentService,
    // )
    ..registerLazySingleton(
      () => PaymentServiceImpl.instance as PaymentService,
    )
    ..registerLazySingleton(
      () => SecureStorageServiceImpl.instance as SecureStorageService,
    )
    ..registerLazySingleton(
      () => RedirectionsHandlerServiceImpl.initializeWithNavigationService(
        navigationService: locator(),
        bottomSheetService: locator(),
      ) as RedirectionsHandlerService,
    )
    ..registerSingletonAsync(
      () async => await LocalStorageServiceImpl.instance as LocalStorageService,
    )
    ..registerLazySingleton(
      () => AppConfigurationServiceImpl.instance as AppConfigurationService,
    )
    ..registerLazySingleton(
      () => ReferralInfoServiceImpl.instance as ReferralInfoService,
    )
    ..registerLazySingleton(
      () => FlutterChannelHandlerServiceImpl.getInstance()
          as FlutterChannelHandlerService,
    )
    ..registerSingletonAsync<Store>(
      () async => openStore(),
    )
    ..registerLazySingleton(
      () => RemoteConfigServiceImpl.instance as RemoteConfigService,
    )
    ..registerLazySingleton(
      () => AnalyticsServiceImpl.instance as AnalyticsService,
    )
    ..registerLazySingleton(
      () => EnvironmentServiceImpl.instance as EnvironmentService,
    );
}

Future<void> appAPIServicesModule() async {
  locator
    ..registerLazySingleton(
      () => ConnectivityServiceImpl.instance as ConnectivityService,
    )
    ..registerLazySingleton(
      () => ApiAuthRepositoryImpl(APIAuthImpl.instance) as ApiAuthRepository,
    )
    // ..registerLazySingleton(
    //   () => EsimRepositoryImpl(EsimRemoteDataSource.instance) as EsimRepository,
    // )
    ..registerLazySingleton(
      () => ApiAppRepositoryImpl(APIAppImpl.instance) as ApiAppRepository,
    )
    ..registerLazySingleton(
      () => APIBundlesImpl.instance as APIBundles,
    )
    ..registerLazySingleton(
      () => APIUserImpl.instance as ApiUser,
    )
    ..registerLazySingleton(
      () => ApiBundlesRepositoryImpl(
        apiBundles: locator(),
        repository: HomeLocalDataSource(locator()),
      ) as ApiBundlesRepository,
      dispose: (ApiBundlesRepository repository) => repository.dispose(),
    )
    ..registerLazySingleton(
      () => ApiUserRepositoryImpl(
        apiUserBundles: locator(),
        repository: EsimsLocalDataSource(locator()),
      ) as ApiUserRepository,
    )
    ..registerLazySingleton(
      () => ApiDeviceRepositoryImpl(ApiDeviceImpl.instance)
          as ApiDeviceRepository,
    )
    ..registerLazySingleton(
      () => APIPromotionImpl.instance as APIPromotion,
    )
    ..registerLazySingleton(
      () => ApiPromotionRepositoryImpl(
        apiPromotion: locator(),
      ) as ApiPromotionRepository,
    )
    ..registerLazySingleton(
      () {
        if (AppEnvironment.appEnvironmentHelper.enableBranchIO) {
          return DynamicLinkingServiceImpl() as DynamicLinkingService;
        }
        return DynamicLinkingServiceEmptyImpl() as DynamicLinkingService;
      },
    );
    // ..registerLazySingleton(() => GetOrderHistoryPaginationUseCase(locator()));
  // ..registerLazySingleton(() => GetBundlesByRegionUseCase(locator()))
  // ..registerLazySingleton(() => GetBundlesByCountryUseCase(locator()))
  // ..registerLazySingleton(() => GetBundlesGlobalUseCase(locator()))
  // ..registerLazySingleton(() => GetCountriesUseCase(locator()))
  // ..registerLazySingleton(() => GetRegionsUseCase(locator()))
  // ..registerLazySingleton(() => GetAvailableNetworksUseCase(locator()));
}

Future<void> thirdPartyServicesModule() async {
  locator
    ..registerLazySingleton(NavigationService.new)
    ..registerLazySingleton(DialogService.new)
    ..registerLazySingleton(SnackbarService.new)
    ..registerLazySingleton(BottomSheetService.new)
    ..registerLazySingleton(ThemeService.getInstance);
}

Future<void> viewModelModules() async {
  locator
    ..registerLazySingleton(() => (MainViewModel()))
    ..registerLazySingleton(() => (MyESimViewModel()))
    ..registerLazySingleton(() => (ProfileViewModel()))
    ..registerLazySingleton(() => (DataPlansViewModel()))
    ..registerLazySingleton(() => (HomePagerViewModel()))
    ..registerLazySingleton(() => (PurchaseLoadingViewModel()));
}

Future<void> viewModelInjectionModules() async {
  locator
    ..registerFactory<ContinueWithEmailViewModel>(
      ContinueWithEmailViewModel.new,
    )
    ..registerFactory<StartUpViewModel>(
      StartUpViewModel.new,
    )
    ..registerFactory<DeviceCompabilityCheckViewModel>(
      DeviceCompabilityCheckViewModel.new,
    )
    ..registerFactory<VerifyLoginViewModel>(
      VerifyLoginViewModel.new,
    )
    ..registerFactory<UserGuideDetailedViewModel>(
      UserGuideDetailedViewModel.new,
    )
    ..registerFactory<OrderHistoryViewModel>(
      OrderHistoryViewModel.new,
    )
    ..registerFactory<RewardsHistoryViewModel>(
      RewardsHistoryViewModel.new,
    )
    ..registerFactory<FaqViewModel>(
      FaqViewModel.new,
    )
    ..registerFactory<DynamicSelectionViewModel>(
      DynamicSelectionViewModel.new,
    )
    ..registerFactory<LoginViewModel>(
      LoginViewModel.new,
    )
    ..registerFactory<DynamicDataViewModel>(
      DynamicDataViewModel.new,
    )
    ..registerFactory<ContactUsViewModel>(
      ContactUsViewModel.new,
    )
    ..registerFactory<AccountInformationViewModel>(
      AccountInformationViewModel.new,
    )
    ..registerFactory<NotificationsViewModel>(
      NotificationsViewModel.new,
    )
    ..registerFactory<VerifyPurchaseViewModel>(
      VerifyPurchaseViewModel.new,
    )
    ..registerFactory<PurchaseOrderSuccessViewModel>(
      PurchaseOrderSuccessViewModel.new,
    )
    ..registerFactory<BundlesListViewModel>(
      BundlesListViewModel.new,
    )
    ..registerFactory<BundleDetailBottomSheetViewModel>(
      BundleDetailBottomSheetViewModel.new,
    )
    ..registerFactory<OrderReceiptBottomSheetViewModel>(
      OrderReceiptBottomSheetViewModel.new,
    )
    ..registerFactory<EditNameBottomSheetViewModel>(
      EditNameBottomSheetViewModel.new,
    )
    ..registerFactory<DeleteAccountBottomSheetViewModel>(
      DeleteAccountBottomSheetViewModel.new,
    )
    ..registerFactory<MyESimBundleBottomSheetViewModel>(
      MyESimBundleBottomSheetViewModel.new,
    )
    ..registerFactory<CashbackRewardBottomSheetViewModel>(
      CashbackRewardBottomSheetViewModel.new,
    )
    ..registerFactory<AndroidUserGuideViewModel>(
      AndroidUserGuideViewModel.new,
    )
    ..registerFactory<ConsumptionBottomSheetViewModel>(
      ConsumptionBottomSheetViewModel.new,
    )
    ..registerFactory<OrderBottomSheetViewModel>(
      OrderBottomSheetViewModel.new,
    );
}

Future<void> resetLazySingleton<T extends Object>({
  T? instance,
  String? instanceName,
  FutureOr<void> Function(T)? disposingFunction,
}) async {
  await locator.resetLazySingleton<T>(
    instance: instance,
    instanceName: instanceName,
    disposingFunction: disposingFunction,
  );
}

// /// Clears the instance of a lazy singleton,
// /// being able to call the factory function on the next call
// /// of [get] on that type again.
// /// you select the lazy Singleton you want to reset by either providing
// /// an [instance], its registered type [T] or its registration name.
// /// if you need to dispose some resources before the reset, you can
// /// provide a [disposingFunction]. This function overrides the disposing
// /// you might have provided when registering.
// void resetLazySingleton<T>({Object instance,
// String instanceName,
// void Function(T) disposingFunction})
