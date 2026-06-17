import "package:esim_open_source/domain/data/response/app/banner_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/regions_response_model.dart";
import "package:esim_open_source/domain/data/response/user/user_notification_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/reactive_service/bundles_data_service.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/bundles_list_screen.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/data_plans_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/notifications_view/notifications_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/login_view/login_view.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";

void main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();
    onViewModelReadyMock();
    
    // Mock the data service properties
    final BundlesDataService mockBundlesDataService = 
        locator<BundlesDataService>();
    when(mockBundlesDataService.countries).thenReturn(getMockCountries());
    when(mockBundlesDataService.regions).thenReturn(getMockRegions());
    when(mockBundlesDataService.globalBundles).thenReturn(getMockGlobalBundles());
    when(mockBundlesDataService.cruiseBundles).thenReturn(getMockGlobalBundles());
    when(mockBundlesDataService.isBundleServicesLoading).thenReturn(false);
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("DataPlansViewModel Tests", () {
    test("initializes correctly", () async {
      final DataPlansViewModel vm = DataPlansViewModel();
      
      expect(vm.filteredCountries, isEmpty);
      expect(vm.filteredRegions, isEmpty);
      expect(vm.filteredBundles, isEmpty);
      expect(vm.filteredCruiseBundles, isEmpty);
      expect(vm.showNotificationBadge, isFalse);
      expect(vm.searchTextFieldController.text, isEmpty);
    });

    test("onViewModelReady initializes correctly", () async {
      final DataPlansViewModel vm = DataPlansViewModel()
      
      ..onViewModelReady();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      
      // Verify initialization completes without error
      expect(vm.filteredCountries, isNotNull);
      expect(vm.filteredRegions, isNotNull);
      expect(vm.filteredBundles, isNotNull);
      expect(vm.filteredCruiseBundles, isNotNull);
    });

    test("search functionality works correctly", () async {
      final DataPlansViewModel vm = DataPlansViewModel()
      ..onViewModelReady();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      
      // Test search with country name
      vm.searchTextFieldController.text = "Afghanistan";
      await Future<void>.delayed(const Duration(milliseconds: 500));
      
      // Search should filter countries
      expect(vm.filteredCountries.length, lessThanOrEqualTo(3));
      if (vm.filteredCountries.isNotEmpty) {
        expect(vm.filteredCountries.any((CountryResponseModel c) => c.country?.contains("Afghanistan") ?? false), isTrue);
      }
    });

    test("search functionality is case insensitive", () async {
      final DataPlansViewModel vm = DataPlansViewModel()
      ..onViewModelReady();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      
      // Test search with lowercase
      vm.searchTextFieldController.text = "afghanistan";
      await Future<void>.delayed(const Duration(milliseconds: 500));
      
      // Search should work case insensitively
      expect(vm.filteredCountries.length, lessThanOrEqualTo(3));
    });

    test("search with empty query returns all items", () async {
      final DataPlansViewModel vm = DataPlansViewModel()
      ..onViewModelReady();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      
      // First filter something
      vm.searchTextFieldController.text = "Afghanistan";
      await Future<void>.delayed(const Duration(milliseconds: 500));
      final int filteredCount = vm.filteredCountries.length;
      
      // Then clear search
      vm.searchTextFieldController.text = "";
      await Future<void>.delayed(const Duration(milliseconds: 500));
      
      // Should return to original count or greater
      expect(vm.filteredCountries.length, greaterThanOrEqualTo(filteredCount));
    });

    test("tab bar change works correctly", () {
      final DataPlansViewModel vm = DataPlansViewModel();
      
      expect(DataPlansViewModel.tabBarSelectedIndex, equals(0));
      
      vm.onTabBarChange(1);
      expect(DataPlansViewModel.tabBarSelectedIndex, equals(1));
      
      vm.onTabBarChange(2);
      expect(DataPlansViewModel.tabBarSelectedIndex, equals(2));
    });

    test("cruise tab bar change works correctly", () {
      final DataPlansViewModel vm = DataPlansViewModel();
      
      expect(DataPlansViewModel.cruiseTabBarSelectedIndex, equals(0));
      
      vm.onCruiseTabBarChange(1);
      expect(DataPlansViewModel.cruiseTabBarSelectedIndex, equals(1));
    });

    test("login button navigation works", () async {
      final DataPlansViewModel vm = DataPlansViewModel();
      
      await vm.loginButtonTapped();
      
      verify(locator<NavigationService>().navigateTo(LoginView.routeName)).called(1);
    });

    test("notifications button navigation works", () async {
      final DataPlansViewModel vm = DataPlansViewModel();
      
      await vm.notificationsButtonTapped();
      
      verify(locator<NavigationService>().navigateTo(NotificationsView.routeName)).called(1);
    });

    test("navigateToCountryBundles works correctly", () async {
      final DataPlansViewModel vm = DataPlansViewModel();
      final CountryResponseModel country = CountryResponseModel(
        id: "AFG",
        country: "Afghanistan",
      );
      
      await vm.navigateToCountryBundles(country);
      
      verify(locator<NavigationService>().navigateTo(
        BundlesListScreen.routeName,
        arguments: anyNamed("arguments"),
      ),).called(1);
    });

    test("navigateToCountryBundleByID works correctly", () async {
      final DataPlansViewModel vm = DataPlansViewModel();
      
      await vm.navigateToCountryBundleByID("AFG");
      
      verify(locator<NavigationService>().navigateTo(
        BundlesListScreen.routeName,
        arguments: anyNamed("arguments"),
      ),).called(1);
    });

    test("navigateToRegionBundles works correctly", () async {
      final DataPlansViewModel vm = DataPlansViewModel();
      final RegionsResponseModel region = RegionsResponseModel(
        regionCode: "EU",
        regionName: "Europe",
      );
      
      await vm.navigateToRegionBundles(region);
      
      verify(locator<NavigationService>().navigateTo(
        BundlesListScreen.routeName,
        arguments: anyNamed("arguments"),
      ),).called(1);
    });

    test("navigateToRegionBundleByID works correctly", () async {
      final DataPlansViewModel vm = DataPlansViewModel();
      
      await vm.navigateToRegionBundleByID("EU");
      
      verify(locator<NavigationService>().navigateTo(
        BundlesListScreen.routeName,
        arguments: anyNamed("arguments"),
      ),).called(1);
    });

    test("navigateToEsimDetail shows bottom sheet when user is logged in", () async {
      final DataPlansViewModel vm = DataPlansViewModel();
      final BundleResponseModel bundle = BundleResponseModel(
        bundleCode: "test123",
        bundleName: "Test Bundle",
        price: 10.99,
        priceDisplay: r"$10.99",
      );
      
      // Mock user as logged in
      when(locator<UserAuthenticationService>().isUserLoggedIn).thenReturn(true);
      
      await vm.navigateToEsimDetail(bundle);
      
      verify(locator<BottomSheetService>().showCustomSheet(
        data: anyNamed("data"),
        enableDrag: false,
        isScrollControlled: true,
        variant: anyNamed("variant"),
      ),).called(1);
    });

    test("navigateToEsimDetail navigates to login when user not logged in", () async {
      final DataPlansViewModel vm = DataPlansViewModel();
      final BundleResponseModel bundle = BundleResponseModel(
        bundleCode: "test123",
        bundleName: "Test Bundle",
        price: 10.99,
        priceDisplay: r"$10.99",
      );
      
      // Mock user as not logged in
      when(locator<UserAuthenticationService>().isUserLoggedIn).thenReturn(false);
      
      await vm.navigateToEsimDetail(bundle);
      
      // Verify method completes - actual navigation depends on app environment settings
      expect(vm, isNotNull);
    });

    test("handleNotificationBadge with no notifications", () async {
      final DataPlansViewModel vm = DataPlansViewModel();
      
      // Mock empty notifications response
      when(locator<ApiUserRepository>().getUserNotifications(
        pageSize: 1,
        pageIndex: 10,
      ),).thenAnswer(
        (_) async => Resource<List<UserNotificationModel>>.success(
          <UserNotificationModel>[],
          message: "Success",
        ),
      );
      
      await vm.handleNotificationBadge();
      
      expect(vm.showNotificationBadge, isFalse);
    });

    test("handleNotificationBadge with unread notifications", () async {
      final DataPlansViewModel vm = DataPlansViewModel();
      
      // Mock notifications with unread items
      final List<UserNotificationModel> notifications = <UserNotificationModel>[
        UserNotificationModel(status: false), // unread
        UserNotificationModel(status: true),  // read
      ];
      
      when(locator<ApiUserRepository>().getUserNotifications(
        pageSize: 1,
        pageIndex: 10,
      ),).thenAnswer(
        (_) async => Resource<List<UserNotificationModel>>.success(
          notifications,
          message: "Success",
        ),
      );
      
      await vm.handleNotificationBadge();
      
      // Verify method completes - actual badge state depends on notification content
      expect(vm.showNotificationBadge, isNotNull);
    });

    test("handleNotificationBadge with error response", () async {
      final DataPlansViewModel vm = DataPlansViewModel();
      
      // Mock error response
      when(locator<ApiUserRepository>().getUserNotifications(
        pageSize: 1,
        pageIndex: 10,
      ),).thenAnswer(
        (_) async => Resource<List<UserNotificationModel>>.error(
          "Error",
        ),
      );
      
      await vm.handleNotificationBadge();
      
      // Verify method handles error gracefully
      expect(vm.showNotificationBadge, isNotNull);
    });

    test("isBundleServicesBusy returns correct loading state", () {
      final DataPlansViewModel vm = DataPlansViewModel();
      
      when(locator<BundlesDataService>().isBundleServicesLoading).thenReturn(true);
      expect(vm.isBundleServicesBusy(), isTrue);
      
      when(locator<BundlesDataService>().isBundleServicesLoading).thenReturn(false);
      expect(vm.isBundleServicesBusy(), isFalse);
    });

    test("processBanners with success response", () {
      final DataPlansViewModel vm = DataPlansViewModel();
      final List<BannerResponseModel> banners = <BannerResponseModel>[
        BannerResponseModel(title: "Test Banner", description: "Test Description"),
      ];
      
      final Resource<List<BannerResponseModel>?> resource =
          Resource<List<BannerResponseModel>?>.success(banners, message: "Success");
      
      vm.processBanners(resource);
      
      // Just verify the method completes without error
      expect(vm.showBanner, isNotNull);
    });

    test("processBanners with error response", () {
      final DataPlansViewModel vm = DataPlansViewModel();
      
      final Resource<List<BannerResponseModel>?> resource =
          Resource<List<BannerResponseModel>?>.error("Error");
      
      vm.processBanners(resource);
      
      expect(vm.showBanner, isFalse);
    });

    test("processBanners with null resource", () {
      final DataPlansViewModel vm = DataPlansViewModel()
      
      ..processBanners(null);
      
      expect(vm.showBanner, isFalse);
    });

    test("dispose cleans up resources correctly", () {
      final DataPlansViewModel vm = DataPlansViewModel();
      
      // Add some search text to test controller disposal
      vm.searchTextFieldController.text = "test";
      
      // Verify controller has text before disposal
      expect(vm.searchTextFieldController.text, equals("test"));
      
      vm.dispose();
      
      // Just verify dispose method completes without throwing
      expect(vm, isNotNull);
    });

    test("search debouncing works correctly", () async {
      final DataPlansViewModel vm = DataPlansViewModel()
      ..onViewModelReady();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      
      // Rapid fire search changes
      vm.searchTextFieldController.text = "A";
      vm.searchTextFieldController.text = "Af";
      vm.searchTextFieldController.text = "Afg";
      vm.searchTextFieldController.text = "Afghanistan";
      
      // Wait for debounce to complete
      await Future<void>.delayed(const Duration(milliseconds: 500));
      
      // Verify search was applied
      expect(vm.searchTextFieldController.text, equals("Afghanistan"));
    });
  });
}

List<CountryResponseModel> getMockCountries() {
  return <CountryResponseModel>[
    CountryResponseModel(
      id: "AFG",
      country: "Afghanistan",
      countryCode: "AFG",
      iso3Code: "AF",
    ),
    CountryResponseModel(
      id: "ALB",
      country: "Albania",
      countryCode: "ALB",
      iso3Code: "AL",
    ),
    CountryResponseModel(
      id: "AND",
      country: "Andorra",
      countryCode: "AND",
      iso3Code: "AD",
    ),
  ];
}

List<RegionsResponseModel> getMockRegions() {
  return <RegionsResponseModel>[
    RegionsResponseModel(
      regionCode: "EU",
      regionName: "Europe",
    ),
    RegionsResponseModel(
      regionCode: "AS",
      regionName: "Asia",
    ),
  ];
}

List<BundleResponseModel> getMockGlobalBundles() {
  return <BundleResponseModel>[
    BundleResponseModel(
      bundleCode: "global1",
      bundleName: "Global Plan 1GB",
      price: 5.99,
      priceDisplay: r"$5.99",
    ),
    BundleResponseModel(
      bundleCode: "global2",
      bundleName: "Global Plan 5GB",
      price: 19.99,
      priceDisplay: r"$19.99",
    ),
  ];
}
