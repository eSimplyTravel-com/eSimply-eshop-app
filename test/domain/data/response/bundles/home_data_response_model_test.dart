import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/home_data_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/regions_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for HomeDataResponseModel
void main() {
  group("HomeDataResponseModel Tests", () {
    test("constructor assigns values correctly", () {
      // Arrange
      final List<RegionsResponseModel> regions = <RegionsResponseModel>[
        RegionsResponseModel(regionCode: "EU"),
      ];
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(countryCode: "US"),
      ];
      final List<BundleResponseModel> globalBundles = <BundleResponseModel>[
        BundleResponseModel(bundleCode: "GLOBAL1"),
      ];
      final List<BundleResponseModel> cruiseBundles = <BundleResponseModel>[
        BundleResponseModel(bundleCode: "CRUISE1"),
      ];

      // Act
      final HomeDataResponseModel model = HomeDataResponseModel(
        regions: regions,
        countries: countries,
        globalBundles: globalBundles,
        cruiseBundles: cruiseBundles,
        version: "1.0.0",
      );

      // Assert
      expect(model.regions, regions);
      expect(model.countries, countries);
      expect(model.globalBundles, globalBundles);
      expect(model.cruiseBundles, cruiseBundles);
      expect(model.version, "1.0.0");
    });

    test("constructor with all null values", () {
      // Act
      final HomeDataResponseModel model = HomeDataResponseModel();

      // Assert
      expect(model.regions, isNull);
      expect(model.countries, isNull);
      expect(model.globalBundles, isNull);
      expect(model.cruiseBundles, isNull);
      expect(model.version, isNull);
    });

    test("constructor with empty lists", () {
      // Act
      final HomeDataResponseModel model = HomeDataResponseModel(
        regions: <RegionsResponseModel>[],
        countries: <CountryResponseModel>[],
        globalBundles: <BundleResponseModel>[],
        cruiseBundles: <BundleResponseModel>[],
      );

      // Assert
      expect(model.regions, isNotNull);
      expect(model.regions, isEmpty);
      expect(model.countries, isNotNull);
      expect(model.countries, isEmpty);
      expect(model.globalBundles, isNotNull);
      expect(model.globalBundles, isEmpty);
      expect(model.cruiseBundles, isNotNull);
      expect(model.cruiseBundles, isEmpty);
    });

    test("regions list with single item", () {
      // Arrange
      final List<RegionsResponseModel> regions = <RegionsResponseModel>[
        RegionsResponseModel(regionCode: "EU"),
      ];

      // Act
      final HomeDataResponseModel model = HomeDataResponseModel(
        regions: regions,
      );

      // Assert
      expect(model.regions?.length, 1);
      expect(model.regions?[0].regionCode, "EU");
    });

    test("regions list with multiple items", () {
      // Arrange
      final List<RegionsResponseModel> regions = <RegionsResponseModel>[
        RegionsResponseModel(regionCode: "EU"),
        RegionsResponseModel(regionCode: "ASIA"),
        RegionsResponseModel(regionCode: "AMERICAS"),
      ];

      // Act
      final HomeDataResponseModel model = HomeDataResponseModel(
        regions: regions,
      );

      // Assert
      expect(model.regions?.length, 3);
      expect(model.regions?[0].regionCode, "EU");
      expect(model.regions?[1].regionCode, "ASIA");
      expect(model.regions?[2].regionCode, "AMERICAS");
    });

    test("countries list with single item", () {
      // Arrange
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(countryCode: "US"),
      ];

      // Act
      final HomeDataResponseModel model = HomeDataResponseModel(
        countries: countries,
      );

      // Assert
      expect(model.countries?.length, 1);
      expect(model.countries?[0].countryCode, "US");
    });

    test("countries list with multiple items", () {
      // Arrange
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(countryCode: "US"),
        CountryResponseModel(countryCode: "DE"),
        CountryResponseModel(countryCode: "JP"),
      ];

      // Act
      final HomeDataResponseModel model = HomeDataResponseModel(
        countries: countries,
      );

      // Assert
      expect(model.countries?.length, 3);
      expect(model.countries?[0].countryCode, "US");
      expect(model.countries?[1].countryCode, "DE");
      expect(model.countries?[2].countryCode, "JP");
    });

    test("globalBundles list with single item", () {
      // Arrange
      final List<BundleResponseModel> globalBundles = <BundleResponseModel>[
        BundleResponseModel(bundleCode: "GLOBAL1", bundleName: "Global Bundle"),
      ];

      // Act
      final HomeDataResponseModel model = HomeDataResponseModel(
        globalBundles: globalBundles,
      );

      // Assert
      expect(model.globalBundles?.length, 1);
      expect(model.globalBundles?[0].bundleCode, "GLOBAL1");
    });

    test("globalBundles list with multiple items", () {
      // Arrange
      final List<BundleResponseModel> globalBundles = <BundleResponseModel>[
        BundleResponseModel(bundleCode: "GLOBAL1"),
        BundleResponseModel(bundleCode: "GLOBAL2"),
      ];

      // Act
      final HomeDataResponseModel model = HomeDataResponseModel(
        globalBundles: globalBundles,
      );

      // Assert
      expect(model.globalBundles?.length, 2);
      expect(model.globalBundles?[0].bundleCode, "GLOBAL1");
      expect(model.globalBundles?[1].bundleCode, "GLOBAL2");
    });

    test("cruiseBundles list with single item", () {
      // Arrange
      final List<BundleResponseModel> cruiseBundles = <BundleResponseModel>[
        BundleResponseModel(bundleCode: "CRUISE1", bundleName: "Cruise Bundle"),
      ];

      // Act
      final HomeDataResponseModel model = HomeDataResponseModel(
        cruiseBundles: cruiseBundles,
      );

      // Assert
      expect(model.cruiseBundles?.length, 1);
      expect(model.cruiseBundles?[0].bundleCode, "CRUISE1");
    });

    test("cruiseBundles list with multiple items", () {
      // Arrange
      final List<BundleResponseModel> cruiseBundles = <BundleResponseModel>[
        BundleResponseModel(bundleCode: "CRUISE1"),
        BundleResponseModel(bundleCode: "CRUISE2"),
        BundleResponseModel(bundleCode: "CRUISE3"),
      ];

      // Act
      final HomeDataResponseModel model = HomeDataResponseModel(
        cruiseBundles: cruiseBundles,
      );

      // Assert
      expect(model.cruiseBundles?.length, 3);
    });

    test("version formats", () {
      // Act
      final HomeDataResponseModel model1 = HomeDataResponseModel(version: "1.0.0");
      final HomeDataResponseModel model2 = HomeDataResponseModel(version: "2.1.5");
      final HomeDataResponseModel model3 = HomeDataResponseModel(version: "");

      // Assert
      expect(model1.version, "1.0.0");
      expect(model2.version, "2.1.5");
      expect(model3.version, "");
    });

    test("all lists null, version provided", () {
      // Act
      final HomeDataResponseModel model = HomeDataResponseModel(
        regions: null,
        countries: null,
        globalBundles: null,
        cruiseBundles: null,
        version: "1.0.0",
      );

      // Assert
      expect(model.regions, isNull);
      expect(model.countries, isNull);
      expect(model.globalBundles, isNull);
      expect(model.cruiseBundles, isNull);
      expect(model.version, "1.0.0");
    });

    test("partial null lists", () {
      // Arrange
      final List<RegionsResponseModel> regions = <RegionsResponseModel>[
        RegionsResponseModel(regionCode: "EU"),
      ];
      final List<BundleResponseModel> globalBundles = <BundleResponseModel>[
        BundleResponseModel(bundleCode: "GB1"),
      ];

      // Act
      final HomeDataResponseModel model = HomeDataResponseModel(
        regions: regions,
        countries: null,
        globalBundles: globalBundles,
        cruiseBundles: null,
      );

      // Assert
      expect(model.regions, isNotNull);
      expect(model.countries, isNull);
      expect(model.globalBundles, isNotNull);
      expect(model.cruiseBundles, isNull);
    });


    test("multiple instances are independent", () {
      // Arrange
      final List<BundleResponseModel> bundles1 = <BundleResponseModel>[
        BundleResponseModel(bundleCode: "B1"),
      ];
      final List<BundleResponseModel> bundles2 = <BundleResponseModel>[
        BundleResponseModel(bundleCode: "B2"),
      ];

      // Act
      final HomeDataResponseModel model1 = HomeDataResponseModel(
        globalBundles: bundles1,
        version: "1.0",
      );
      final HomeDataResponseModel model2 = HomeDataResponseModel(
        globalBundles: bundles2,
        version: "2.0",
      );

      // Assert
      expect(model1.globalBundles?[0].bundleCode, "B1");
      expect(model2.globalBundles?[0].bundleCode, "B2");
      expect(model1.version, "1.0");
      expect(model2.version, "2.0");
    });

    test("response type is correct", () {
      // Act
      final HomeDataResponseModel model = HomeDataResponseModel();

      // Assert
      expect(model, isA<HomeDataResponseModel>());
    });
  });
}
