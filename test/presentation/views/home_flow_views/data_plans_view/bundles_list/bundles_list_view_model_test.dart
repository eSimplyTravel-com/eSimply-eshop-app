import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/presentation/reactive_service/bundles_data_service.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/bundles_list_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/navigation/esim_arguments.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../../helpers/view_helper.dart";
import "../../../../../helpers/view_model_helper.dart";
import "../../../../../locator_test.dart";

Future<void> main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();
    onViewModelReadyMock();
    
    // Mock the countries property
    final BundlesDataService mockBundlesDataService = 
        locator<BundlesDataService>();
    when(mockBundlesDataService.countries).thenReturn(getMockCountries());
  });

  group("BundlesListViewModel Tests", () {
    test("initializes correctly with country arguments", () async {
      // Use an ID from getMockCountries()
      final EsimArguments args =
          const EsimArguments(id: "AFG", name: "Afghanistan", type: "Country");
      final BundlesListViewModel vm = BundlesListViewModel()
        ..esimArguments = args

      ..onViewModelReady();
      // Wait a bit for async operations to complete (onViewModelReady already calls getSelectedCountry)
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(vm.esimArguments, equals(args));
      // Check if countries are loaded correctly
      expect(vm.countries?.length, equals(3));
      // Since AFG is in getMockCountries(), it should find and add it
      expect(vm.selectedCountryChips.length, equals(1));
      expect(vm.selectedCountryChips.first.country, equals("Afghanistan"));
    });

    test("initializes correctly with region arguments", () async {
      final EsimArguments args =
          const EsimArguments(id: "EU", name: "Europe", type: "Region");
      final BundlesListViewModel vm = BundlesListViewModel()
        ..esimArguments = args

      ..onViewModelReady();
      // Wait a bit for async operations to complete (onViewModelReady already calls getSelectedCountry)
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(vm.esimArguments, equals(args));
      expect(vm.selectedCountryChips.length, equals(0));
    });

    test("filtered countries returns correct results when search is focused", () {
      final EsimArguments args =
          const EsimArguments(id: "1", name: "test", type: "Country");
      final BundlesListViewModel vm = BundlesListViewModel()
        ..esimArguments = args

      ..setSearchFocused(focused: true);
      
      // Test empty search returns all unselected countries
      List<CountryResponseModel> filtered = vm.filteredCountries;
      expect(filtered.length, equals(3));

      // Test search filtering
      vm.searchTextFieldController.text = "alb";
      filtered = vm.filteredCountries;
      expect(filtered.length, equals(1));
      expect(filtered.first.country, equals("Albania"));

      // Test ISO code filtering
      vm.searchTextFieldController.text = "AF";
      filtered = vm.filteredCountries;
      expect(filtered.length, equals(1));
      expect(filtered.first.country, equals("Afghanistan"));
    });

    test("filtered countries returns empty when search is not focused", () {
      final EsimArguments args =
          const EsimArguments(id: "1", name: "test", type: "Country");
      final BundlesListViewModel vm = BundlesListViewModel()
        ..esimArguments = args

      ..setSearchFocused(focused: false);
      
      List<CountryResponseModel> filtered = vm.filteredCountries;
      expect(filtered.length, equals(0));
    });

    test("adds country correctly", () async {
      final EsimArguments args =
          const EsimArguments(id: "1", name: "test", type: "Country");
      final BundlesListViewModel vm = BundlesListViewModel()
        ..esimArguments = args
      
      ..onViewModelReady();
      
      final CountryResponseModel country = 
          CountryResponseModel(id: "ALB", country: "Albania");
      
      await vm.addCountry(country);
      
      expect(vm.selectedCountryChips.contains(country), isTrue);
      expect(vm.countryCodes, contains("ALB"));
    });

    test("does not add duplicate country", () async {
      final EsimArguments args =
          const EsimArguments(id: "1", name: "test", type: "Country");
      final BundlesListViewModel vm = BundlesListViewModel()
        ..esimArguments = args
      
      ..onViewModelReady();
      
      final CountryResponseModel country = 
          CountryResponseModel(id: "ALB", country: "Albania");
      
      await vm.addCountry(country);
      await vm.addCountry(country); // Try to add the same country again
      
      expect(vm.selectedCountryChips.where((CountryResponseModel c) => c.id == "ALB").length, equals(1));
    });

    test("removes country correctly when multiple countries exist", () async {
      final EsimArguments args =
          const EsimArguments(id: "1", name: "test", type: "Country");
      final BundlesListViewModel vm = BundlesListViewModel()
        ..esimArguments = args
      
      ..onViewModelReady();
      
      final CountryResponseModel country1 = 
          CountryResponseModel(id: "ALB", country: "Albania");
      final CountryResponseModel country2 = 
          CountryResponseModel(id: "AND", country: "Andorra");
      
      await vm.addCountry(country1);
      await vm.addCountry(country2);
      
      expect(vm.selectedCountryChips.length, equals(2));
      
      await vm.removeCountry(country1);
      
      expect(vm.selectedCountryChips.length, equals(1));
      expect(vm.selectedCountryChips.contains(country1), isFalse);
      expect(vm.selectedCountryChips.contains(country2), isTrue);
    });

    test("navigates back when removing last country", () async {
      final EsimArguments args =
          const EsimArguments(id: "1", name: "test", type: "Country");
      final BundlesListViewModel vm = BundlesListViewModel()
        ..esimArguments = args
      
      ..onViewModelReady();
      
      final CountryResponseModel country = 
          CountryResponseModel(id: "ALB", country: "Albania");
      
      await vm.addCountry(country);
      expect(vm.selectedCountryChips.length, equals(1));
      
      await vm.removeCountry(country);
      
      // Should have navigated back (verified through mock in setup)
      verify(locator<NavigationService>().back()).called(1);
    });

    test("search focus management works correctly", () {
      final EsimArguments args =
          const EsimArguments(id: "1", name: "test", type: "Country");
      final BundlesListViewModel vm = BundlesListViewModel()
        ..esimArguments = args;

      expect(vm.isSearchFocused.value, isFalse);

      vm.setSearchFocused(focused: true);
      expect(vm.isSearchFocused.value, isTrue);

      vm.searchTextFieldController.text = "test search";
      vm.setSearchFocused(focused: false);
      expect(vm.isSearchFocused.value, isFalse);
      expect(vm.searchTextFieldController.text, isEmpty);
    });

    test("country codes returns correct format", () async {
      final EsimArguments args =
          const EsimArguments(id: "1", name: "test", type: "Country");
      final BundlesListViewModel vm = BundlesListViewModel()
        ..esimArguments = args

      ..onViewModelReady();

      expect(vm.countryCodes, isEmpty);

      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(id: "ALB", country: "Albania"),
        CountryResponseModel(id: "AND", country: "Andorra"),
      ];

      for (final CountryResponseModel country in countries) {
        await vm.addCountry(country);
      }

      expect(vm.countryCodes, equals("ALB,AND"));
    });

    test("navigation to esim detail with country arguments", () async {
      final EsimArguments args =
          const EsimArguments(id: "1", name: "test", type: "Country");
      final BundlesListViewModel vm = BundlesListViewModel()
        ..esimArguments = args

      ..onViewModelReady();

      final CountryResponseModel country = 
          CountryResponseModel(id: "ALB", country: "Albania", iso3Code: "AL");
      await vm.addCountry(country);

      final BundleResponseModel bundle = BundleResponseModel(
        bundleCode: "bundle1",
        price: 10.99,
        priceDisplay: r"$10.99",
        bundleName: "Test Bundle",
      );
      await vm.navigateToEsimDetail(bundle);

      // Verify navigation or bottom sheet was called
      verify(locator<BottomSheetService>().showCustomSheet(
        data: anyNamed("data"),
        enableDrag: false,
        isScrollControlled: true,
        variant: anyNamed("variant"),
      ),).called(1);
    });

    test("navigation to esim detail with region arguments", () async {
      final EsimArguments args =
          const EsimArguments(id: "EU", name: "Europe", type: "Region");
      final BundlesListViewModel vm = BundlesListViewModel()
        ..esimArguments = args

      ..onViewModelReady();

      final BundleResponseModel bundle = BundleResponseModel(
        bundleCode: "bundle1",
        price: 10.99,
        priceDisplay: r"$10.99",
        bundleName: "Test Bundle",
      );
      await vm.navigateToEsimDetail(bundle);

      // Verify navigation or bottom sheet was called
      verify(locator<BottomSheetService>().showCustomSheet(
        data: anyNamed("data"),
        enableDrag: false,
        isScrollControlled: true,
        variant: anyNamed("variant"),
      ),).called(1);
    });

    test("disposes correctly", () {
      final EsimArguments args =
          const EsimArguments(id: "1", name: "test", type: "Country");
      final BundlesListViewModel vm = BundlesListViewModel()
        ..esimArguments = args

      ..onViewModelReady()
      ..onDispose();

      // Controller should be disposed - attempting to use it should throw
      expect(() => vm.searchTextFieldController.text = "test", throwsFlutterError);
    });

    test("getMockCountries returns correct data", () {
      final List<CountryResponseModel> countries = getMockCountries();
      
      expect(countries.length, equals(3));
      expect(countries[0].country, equals("Afghanistan"));
      expect(countries[1].country, equals("Albania"));
      expect(countries[2].country, equals("Andorra"));
    });

    test("child view model is initialized correctly", () {
      final EsimArguments args =
          const EsimArguments(id: "1", name: "test", type: "Country");
      final BundlesListViewModel vm = BundlesListViewModel()
        ..esimArguments = args

      ..onViewModelReady();

      expect(vm.childViewModel, isNotNull);
    });
  });

  tearDown(() async {
    await tearDownTest();
  });
}
