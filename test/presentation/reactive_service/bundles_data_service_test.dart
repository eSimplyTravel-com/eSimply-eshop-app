import "dart:async";

import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/home_data_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/regions_response_model.dart";
import "package:esim_open_source/domain/repository/api_bundles_repository.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/reactive_service/bundles_data_service.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../helpers/test_environment_setup.dart";
import "../../helpers/view_helper.dart";
import "../../locator_test.dart";
import "../../locator_test.mocks.dart";

/// Unit tests for BundlesDataService - a reactive service that manages bundle data state
///
/// Tests cover:
/// - Service initialization and async data loading
/// - Stream-based data updates from repository
/// - Home data getters (bundles, countries, regions)
/// - Loading and error states
/// - Data refresh logic with version checking
/// - Convenience methods for filtering bundles
/// - Cache clearing
Future<void> main() async {
  await prepareTest();

  late BundlesDataService bundlesService;
  late MockApiBundlesRepository mockBundlesRepository;
  late MockAppConfigurationService mockAppConfigService;
  late StreamController<BundleServicesStreamModel> streamController;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();

    mockBundlesRepository =
        locator<ApiBundlesRepository>() as MockApiBundlesRepository;
    mockAppConfigService =
        locator<AppConfigurationService>() as MockAppConfigurationService;

    // Mock LocalStorageService properties for string extensions
    final MockLocalStorageService mockLocalStorageService =
        locator<LocalStorageService>() as MockLocalStorageService;
    when(mockLocalStorageService.currencyCode).thenReturn("USD");
    when(mockLocalStorageService.languageCode).thenReturn("en");

    // Setup stream controller for mocking repository stream
    streamController = StreamController<BundleServicesStreamModel>.broadcast();

    when(mockBundlesRepository.homeDataStream)
        .thenAnswer((_) => streamController.stream);

    when(mockAppConfigService.getCatalogVersion)
        .thenAnswer((_) async => "v1.0.0");

    when(mockAppConfigService.getAppConfigurations())
        .thenAnswer((_) async => Future<void>.value());

    when(mockBundlesRepository.getHomeData(
      version: anyNamed("version"),
      isFromRefresh: anyNamed("isFromRefresh"),
    ),).thenAnswer((_) => streamController.stream);

    when(mockBundlesRepository.clearCache())
        .thenAnswer((_) async => Future<void>.value());
  });

  tearDown(() async {
    await streamController.close();
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("BundlesDataService Initialization Tests", () {
    test("initializes with null data and loading state", () async {
      // Act
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Assert
      expect(bundlesService.homeData, isNull);
      expect(bundlesService.globalBundles, isNull);
      expect(bundlesService.cruiseBundles, isNull);
      expect(bundlesService.countries, isNull);
      expect(bundlesService.regions, isNull);
    });

    test("fetches catalog version during initialization", () async {
      // Act
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Assert
      verify(mockAppConfigService.getCatalogVersion).called(1);
    });

    test("calls getHomeData during initialization", () async {
      // Act
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Assert
      verify(mockBundlesRepository.getHomeData(
        version: anyNamed("version"),
        isFromRefresh: anyNamed("isFromRefresh"),
      ),).called(1);
    });

    test("sets loading state to true during initialization", () async {
      // Act
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Assert
      expect(bundlesService.isBundleServicesLoading, isTrue);
      expect(bundlesService.hasError, isFalse);
    });
  });

  group("BundlesDataService Stream Updates Tests", () {
    test("updates data when stream emits success resource", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final HomeDataResponseModel homeData = HomeDataResponseModel(
        version: "v1.0.0",
        globalBundles: <BundleResponseModel>[
          BundleResponseModel(
            bundleCode: "bundle1",
            displayTitle: "Test Bundle",
          ),
        ],
        countries: <CountryResponseModel>[
          CountryResponseModel(
            iso3Code: "USA",
            country: "United States",
          ),
        ],
        regions: <RegionsResponseModel>[
          RegionsResponseModel(
            regionCode: "NA",
            regionName: "North America",
          ),
        ],
        cruiseBundles: <BundleResponseModel>[],
      );

      // Act
      streamController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.success(homeData, message: null),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Assert
      expect(bundlesService.homeData, isNotNull);
      expect(bundlesService.globalBundles?.length, equals(1));
      expect(bundlesService.globalBundles?[0].bundleCode, equals("bundle1"));
      expect(bundlesService.countries?.length, equals(1));
      expect(bundlesService.regions?.length, equals(1));
      expect(bundlesService.isBundleServicesLoading, isFalse);
      expect(bundlesService.hasError, isFalse);
    });

    test("sets error state when stream emits error resource", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Act
      streamController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.error("Network error occurred"),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(bundlesService.hasError, isTrue);
      expect(bundlesService.errorMessage, equals("Network error occurred"));
      expect(bundlesService.isBundleServicesLoading, isFalse);
    });

    test("sets loading when stream emits shimmer state", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Act
      streamController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: true,
          homeData: Resource<HomeDataResponseModel>.loading(),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(bundlesService.isBundleServicesLoading, isTrue);
    });

    test("notifies listeners when data is updated", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      int listenerCallCount = 0;
      bundlesService.addListener(() {
        listenerCallCount++;
      });

      final HomeDataResponseModel homeData = HomeDataResponseModel(
        globalBundles: <BundleResponseModel>[],
      );

      // Act
      streamController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.success(homeData, message: null),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Assert
      expect(listenerCallCount, greaterThan(0));
    });
  });

  group("BundlesDataService Getters Tests", () {
    test("returns correct home data", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final HomeDataResponseModel homeData = HomeDataResponseModel(
        version: "v2.0.0",
        globalBundles: <BundleResponseModel>[],
      );

      streamController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.success(homeData, message: null),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Assert
      expect(bundlesService.homeData, isNotNull);
      expect(bundlesService.homeData?.version, equals("v2.0.0"));
    });

    test("returns correct global bundles list", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final List<BundleResponseModel> bundles = <BundleResponseModel>[
        BundleResponseModel(bundleCode: "b1"),
        BundleResponseModel(bundleCode: "b2"),
      ];

      streamController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.success(
            HomeDataResponseModel(globalBundles: bundles),
            message: null,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Assert
      expect(bundlesService.globalBundles?.length, equals(2));
      expect(bundlesService.globalBundles?[0].bundleCode, equals("b1"));
      expect(bundlesService.globalBundles?[1].bundleCode, equals("b2"));
    });

    test("returns correct cruise bundles list", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final List<BundleResponseModel> cruiseBundles = <BundleResponseModel>[
        BundleResponseModel(bundleCode: "cruise1"),
      ];

      streamController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.success(
            HomeDataResponseModel(cruiseBundles: cruiseBundles),
            message: null,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Assert
      expect(bundlesService.cruiseBundles?.length, equals(1));
      expect(bundlesService.cruiseBundles?[0].bundleCode, equals("cruise1"));
    });

    test("returns correct countries list", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(iso3Code: "USA", country: "United States"),
        CountryResponseModel(iso3Code: "CAN", country: "Canada"),
      ];

      streamController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.success(
            HomeDataResponseModel(countries: countries),
            message: null,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Assert
      expect(bundlesService.countries?.length, equals(2));
      expect(bundlesService.countries?[0].iso3Code, equals("USA"));
      expect(bundlesService.countries?[1].iso3Code, equals("CAN"));
    });

    test("returns correct regions list", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final List<RegionsResponseModel> regions = <RegionsResponseModel>[
        RegionsResponseModel(regionCode: "EU", regionName: "Europe"),
        RegionsResponseModel(regionCode: "AS", regionName: "Asia"),
      ];

      streamController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.success(
            HomeDataResponseModel(regions: regions),
            message: null,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Assert
      expect(bundlesService.regions?.length, equals(2));
      expect(bundlesService.regions?[0].regionCode, equals("EU"));
      expect(bundlesService.regions?[1].regionCode, equals("AS"));
    });
  });

  group("BundlesDataService Convenience Methods Tests", () {
    test("getBundlesByCountry filters bundles correctly", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final List<BundleResponseModel> bundles = <BundleResponseModel>[
        BundleResponseModel(
          bundleCode: "b1",
          countries: <CountryResponseModel>[
            CountryResponseModel(iso3Code: "USA"),
          ],
        ),
        BundleResponseModel(
          bundleCode: "b2",
          countries: <CountryResponseModel>[
            CountryResponseModel(iso3Code: "CAN"),
          ],
        ),
        BundleResponseModel(
          bundleCode: "b3",
          countries: <CountryResponseModel>[
            CountryResponseModel(iso3Code: "USA"),
            CountryResponseModel(iso3Code: "MEX"),
          ],
        ),
      ];

      streamController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.success(
            HomeDataResponseModel(globalBundles: bundles),
            message: null,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Act
      final List<BundleResponseModel>? usaBundles =
          bundlesService.getBundlesByCountry("USA");

      // Assert
      expect(usaBundles?.length, equals(2));
      expect(usaBundles?[0].bundleCode, equals("b1"));
      expect(usaBundles?[1].bundleCode, equals("b3"));
    });

    test("getBundlesByRegion filters bundles correctly", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final List<BundleResponseModel> bundles = <BundleResponseModel>[
        BundleResponseModel(
          bundleCode: "b1",
          countries: <CountryResponseModel>[
            CountryResponseModel(zoneName: "Europe"),
          ],
        ),
        BundleResponseModel(
          bundleCode: "b2",
          countries: <CountryResponseModel>[
            CountryResponseModel(zoneName: "Asia"),
          ],
        ),
        BundleResponseModel(
          bundleCode: "b3",
          countries: <CountryResponseModel>[
            CountryResponseModel(zoneName: "Europe"),
          ],
        ),
      ];

      streamController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.success(
            HomeDataResponseModel(globalBundles: bundles),
            message: null,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Act
      final List<BundleResponseModel>? europeBundles =
          bundlesService.getBundlesByRegion("Europe");

      // Assert
      expect(europeBundles?.length, equals(2));
      expect(europeBundles?[0].bundleCode, equals("b1"));
      expect(europeBundles?[1].bundleCode, equals("b3"));
    });

    test("getCountryByCode returns correct country", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(iso3Code: "USA", country: "United States"),
        CountryResponseModel(iso3Code: "CAN", country: "Canada"),
      ];

      streamController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.success(
            HomeDataResponseModel(countries: countries),
            message: null,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Act
      final CountryResponseModel? country =
          bundlesService.getCountryByCode("CAN");

      // Assert
      expect(country, isNotNull);
      expect(country?.iso3Code, equals("CAN"));
      expect(country?.country, equals("Canada"));
    });

    test("getRegionByCode returns correct region", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final List<RegionsResponseModel> regions = <RegionsResponseModel>[
        RegionsResponseModel(regionCode: "EU", regionName: "Europe"),
        RegionsResponseModel(regionCode: "AS", regionName: "Asia"),
      ];

      streamController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.success(
            HomeDataResponseModel(regions: regions),
            message: null,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Act
      final RegionsResponseModel? region =
          bundlesService.getRegionByCode("AS");

      // Assert
      expect(region, isNotNull);
      expect(region?.regionCode, equals("AS"));
      expect(region?.regionName, equals("Asia"));
    });

    test("getBundlesByCountry returns empty list when no matches", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final List<BundleResponseModel> bundles = <BundleResponseModel>[
        BundleResponseModel(
          bundleCode: "b1",
          countries: <CountryResponseModel>[
            CountryResponseModel(iso3Code: "USA"),
          ],
        ),
      ];

      streamController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.success(
            HomeDataResponseModel(globalBundles: bundles),
            message: null,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Act
      final List<BundleResponseModel>? results =
          bundlesService.getBundlesByCountry("XYZ");

      // Assert
      expect(results, isEmpty);
    });
  });

  group("BundlesDataService Refresh Data Tests", () {
    test("refreshData skips when already loading", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Service is loading during initialization
      expect(bundlesService.isBundleServicesLoading, isTrue);

      // Act
      await bundlesService.refreshData();

      // Assert - should not call getAppConfigurations during loading
      verifyNever(mockAppConfigService.getAppConfigurations());
    });

    test("refreshData calls getAppConfigurations when not loading", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Emit success to stop loading
      streamController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.success(
            HomeDataResponseModel(version: "v1.0.0"),
            message: null,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Act
      await bundlesService.refreshData();

      // Assert
      verify(mockAppConfigService.getAppConfigurations()).called(1);
    });

    test("refreshData skips when version matches cached version", () async {
      // Arrange
      when(mockAppConfigService.getCatalogVersion)
          .thenAnswer((_) async => "v1.0.0");

      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      streamController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.success(
            HomeDataResponseModel(version: "v1.0.0"),
            message: null,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 600));

      final int initialCallCount = verify(
        mockBundlesRepository.getHomeData(
          version: anyNamed("version"),
          isFromRefresh: anyNamed("isFromRefresh"),
        ),
      ).callCount;

      // Act
      await bundlesService.refreshData();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Assert - should not call getHomeData again
      expect(
        verify(
          mockBundlesRepository.getHomeData(
            version: anyNamed("version"),
            isFromRefresh: anyNamed("isFromRefresh"),
          ),
        ).callCount,
        equals(initialCallCount),
      );
    });
  });

  group("BundlesDataService Clear Data Tests", () {
    test("clearData resets all data to null", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      streamController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.success(
            HomeDataResponseModel(
              globalBundles: <BundleResponseModel>[
                BundleResponseModel(bundleCode: "b1"),
              ],
              countries: <CountryResponseModel>[
                CountryResponseModel(iso3Code: "USA"),
              ],
            ),
            message: null,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 600));

      expect(bundlesService.globalBundles, isNotNull);

      // Act
      await bundlesService.clearData();

      // Assert
      expect(bundlesService.homeData, isNull);
      expect(bundlesService.globalBundles, isNull);
      expect(bundlesService.cruiseBundles, isNull);
      expect(bundlesService.countries, isNull);
      expect(bundlesService.regions, isNull);
      expect(bundlesService.hasError, isFalse);
      expect(bundlesService.errorMessage, isNull);
    });

    test("clearData calls repository clearCache", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Act
      await bundlesService.clearData();

      // Assert
      verify(mockBundlesRepository.clearCache()).called(1);
    });

    test("clearData notifies listeners", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      int listenerCallCount = 0;
      bundlesService.addListener(() {
        listenerCallCount++;
      });

      // Act
      await bundlesService.clearData();

      // Assert
      expect(listenerCallCount, greaterThan(0));
    });
  });

  group("BundlesDataService Edge Cases Tests", () {
    test("handles stream errors gracefully", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Act
      streamController.addError("Stream error");
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(bundlesService.hasError, isTrue);
      expect(bundlesService.isBundleServicesLoading, isFalse);
    });

    test("handles null home data in success response", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Act
      streamController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.success(
            HomeDataResponseModel(),
            message: null,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Assert
      expect(bundlesService.isBundleServicesLoading, isFalse);
    });

    test("handles empty catalog version", () async {
      // Arrange
      when(mockAppConfigService.getCatalogVersion).thenAnswer((_) async => "");

      // Act
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Assert - should still initialize
      expect(bundlesService, isNotNull);
    });

    test("handles bundles with null countries list", () async {
      // Arrange
      bundlesService = BundlesDataService();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final List<BundleResponseModel> bundles = <BundleResponseModel>[
        BundleResponseModel(bundleCode: "b1"),
      ];

      streamController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.success(
            HomeDataResponseModel(globalBundles: bundles),
            message: null,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 600));

      // Act
      final List<BundleResponseModel>? result =
          bundlesService.getBundlesByCountry("USA");

      // Assert
      expect(result, isEmpty);
    });
  });
}
