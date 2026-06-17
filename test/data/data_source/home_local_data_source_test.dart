// home_local_data_source_test.dart

import "package:esim_open_source/data/data_source/home_data_entities/bundle_category_entity.dart";
import "package:esim_open_source/data/data_source/home_data_entities/country_entity.dart";
import "package:esim_open_source/data/data_source/home_data_entities/home_data_entity.dart";
import "package:esim_open_source/data/data_source/home_local_data_source.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_category_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/home_data_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/regions_response_model_dto.dart";
import "package:esim_open_source/objectbox.g.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "home_local_data_source_test.mocks.dart";

// Fake Store implementation for testing
class FakeStore extends Fake implements Store {
  final Map<Type, Box<dynamic>> _boxes = <Type, Box<dynamic>>{};

  void registerBox<T>(Box<T> box) {
    _boxes[T] = box;
  }

  @override
  Box<T> box<T>() {
    if (!_boxes.containsKey(T)) {
      throw StateError("No box registered for type $T");
    }
    return _boxes[T]! as Box<T>;
  }

  @override
  R runInTransaction<R>(TxMode mode, R Function() fn) {
    return fn();
  }
}

@GenerateMocks(<Type>[Store])
@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<Box<HomeDataEntity>>(as: #MockHomeDataBox),
  MockSpec<Box<CountryEntity>>(as: #MockCountryBox),
  MockSpec<Box<BundleCategoryEntity>>(as: #MockBundleCategoryBox),
  MockSpec<Query<HomeDataEntity>>(as: #MockHomeDataQuery),
  MockSpec<Query<CountryEntity>>(as: #MockCountryQuery),
  MockSpec<QueryBuilder<HomeDataEntity>>(
    as: #MockHomeDataQueryBuilder,
    unsupportedMembers: <Symbol>{#link, #backlink, #linkMany, #backlinkMany},
  ),
  MockSpec<QueryBuilder<CountryEntity>>(
    as: #MockCountryQueryBuilder,
    unsupportedMembers: <Symbol>{#link, #backlink, #linkMany, #backlinkMany},
  ),
])
void main() {
  late FakeStore fakeStore;
  late MockHomeDataBox mockHomeDataBox;
  late MockCountryBox mockCountryBox;
  late MockBundleCategoryBox mockBundleCategoryBox;
  late HomeLocalDataSource dataSource;

  setUp(() {
    fakeStore = FakeStore();
    mockHomeDataBox = MockHomeDataBox();
    mockCountryBox = MockCountryBox();
    mockBundleCategoryBox = MockBundleCategoryBox();

    // Register boxes with the fake store
    fakeStore
      ..registerBox<HomeDataEntity>(mockHomeDataBox)
      ..registerBox<CountryEntity>(mockCountryBox)
      ..registerBox<BundleCategoryEntity>(mockBundleCategoryBox);

    dataSource = HomeLocalDataSource(fakeStore);
  });

  group("HomeLocalDataSource", () {
    group("saveHomeData", () {
      test("should save home data with version", () async {
        // Arrange
        final HomeDataResponseModelDto homeData = HomeDataResponseModelDto(
          version: "1.0.0",
        );

        when(mockHomeDataBox.put(any)).thenReturn(1);

        // Act
        await dataSource.saveHomeData(homeData);

        // Assert
        verify(mockHomeDataBox.put(any)).called(1);
      });

      test("should save home data with regions", () async {
        // Arrange
        final List<RegionsResponseModelDto> regions = <RegionsResponseModelDto>[
          RegionsResponseModelDto(
            regionName: "North America",
            regionCode: "NA",
          ),
          RegionsResponseModelDto(
            regionName: "Europe",
            regionCode: "EU",
          ),
        ];

        final HomeDataResponseModelDto homeData = HomeDataResponseModelDto(
          version: "1.0.0",
          regions: regions,
        );

        when(mockHomeDataBox.put(any)).thenReturn(1);

        // Act
        await dataSource.saveHomeData(homeData);

        // Assert
        verify(mockHomeDataBox.put(any)).called(1);
      });

      test("should save home data with countries", () async {
        // Arrange
        final List<CountryResponseModelDto> countries = <CountryResponseModelDto>[
          CountryResponseModelDto(
            iso3Code: "USA",
            country: "United States",
          ),
          CountryResponseModelDto(
            iso3Code: "CAN",
            country: "Canada",
          ),
        ];

        final HomeDataResponseModelDto homeData = HomeDataResponseModelDto(
          version: "1.0.0",
          countries: countries,
        );

        when(mockHomeDataBox.put(any)).thenReturn(1);

        // Act
        await dataSource.saveHomeData(homeData);

        // Assert
        verify(mockHomeDataBox.put(any)).called(1);
      });

      test("should save home data with global bundles", () async {
        // Arrange
        final List<BundleResponseModelDto> globalBundles = <BundleResponseModelDto>[
          BundleResponseModelDto(
            bundleCode: "GLOBAL-1",
            bundleName: "Global Bundle 1",
          ),
        ];

        final HomeDataResponseModelDto homeData = HomeDataResponseModelDto(
          version: "1.0.0",
          globalBundles: globalBundles,
        );

        final MockCountryQueryBuilder mockQueryBuilder =
            MockCountryQueryBuilder();
        final MockCountryQuery mockQuery = MockCountryQuery();

        when(mockCountryBox.query(any)).thenReturn(mockQueryBuilder);
        when(mockQueryBuilder.build()).thenReturn(mockQuery);
        when(mockQuery.findFirst()).thenReturn(null);

        when(mockHomeDataBox.put(any)).thenReturn(1);
        when(mockCountryBox.put(any)).thenReturn(1);

        // Act
        await dataSource.saveHomeData(homeData);

        // Assert
        verify(mockHomeDataBox.put(any)).called(1);
      });

      test("should save global bundle with bundle category", () async {
        // Arrange
        final BundleCategoryResponseModelDto category =
            BundleCategoryResponseModelDto(
          title: "Premium",
        );

        final List<BundleResponseModelDto> globalBundles = <BundleResponseModelDto>[
          BundleResponseModelDto(
            bundleCode: "GLOBAL-1",
            bundleName: "Global Bundle 1",
            bundleCategory: category,
          ),
        ];

        final HomeDataResponseModelDto homeData = HomeDataResponseModelDto(
          version: "1.0.0",
          globalBundles: globalBundles,
        );

        final MockCountryQueryBuilder mockQueryBuilder =
            MockCountryQueryBuilder();
        final MockCountryQuery mockQuery = MockCountryQuery();

        when(mockCountryBox.query(any)).thenReturn(mockQueryBuilder);
        when(mockQueryBuilder.build()).thenReturn(mockQuery);
        when(mockQuery.findFirst()).thenReturn(null);

        when(mockHomeDataBox.put(any)).thenReturn(1);
        when(mockBundleCategoryBox.put(any)).thenReturn(1);
        when(mockCountryBox.put(any)).thenReturn(1);

        // Act
        await dataSource.saveHomeData(homeData);

        // Assert
        verify(mockHomeDataBox.put(any)).called(1);
        verify(mockBundleCategoryBox.put(any)).called(1);
      });

      test("should save global bundle with countries", () async {
        // Arrange
        final List<CountryResponseModelDto> bundleCountries =
            <CountryResponseModelDto>[
          CountryResponseModelDto(
            iso3Code: "USA",
            country: "United States",
          ),
        ];

        final List<BundleResponseModelDto> globalBundles = <BundleResponseModelDto>[
          BundleResponseModelDto(
            bundleCode: "GLOBAL-1",
            bundleName: "Global Bundle 1",
            countries: bundleCountries,
          ),
        ];

        final HomeDataResponseModelDto homeData = HomeDataResponseModelDto(
          version: "1.0.0",
          globalBundles: globalBundles,
        );

        final MockCountryQueryBuilder mockQueryBuilder =
            MockCountryQueryBuilder();
        final MockCountryQuery mockQuery = MockCountryQuery();

        when(mockCountryBox.query(any)).thenReturn(mockQueryBuilder);
        when(mockQueryBuilder.build()).thenReturn(mockQuery);
        when(mockQuery.findFirst()).thenReturn(null);

        when(mockHomeDataBox.put(any)).thenReturn(1);
        when(mockCountryBox.put(any)).thenReturn(1);

        // Act
        await dataSource.saveHomeData(homeData);

        // Assert
        verify(mockHomeDataBox.put(any)).called(1);
        verify(mockCountryBox.put(any)).called(1);
      });

      test("should save home data with cruise bundles", () async {
        // Arrange
        final List<BundleResponseModelDto> cruiseBundles = <BundleResponseModelDto>[
          BundleResponseModelDto(
            bundleCode: "CRUISE-1",
            bundleName: "Cruise Bundle 1",
          ),
        ];

        final HomeDataResponseModelDto homeData = HomeDataResponseModelDto(
          version: "1.0.0",
          cruiseBundles: cruiseBundles,
        );

        final MockCountryQueryBuilder mockQueryBuilder =
            MockCountryQueryBuilder();
        final MockCountryQuery mockQuery = MockCountryQuery();

        when(mockCountryBox.query(any)).thenReturn(mockQueryBuilder);
        when(mockQueryBuilder.build()).thenReturn(mockQuery);
        when(mockQuery.findFirst()).thenReturn(null);

        when(mockHomeDataBox.put(any)).thenReturn(1);
        when(mockCountryBox.put(any)).thenReturn(1);

        // Act
        await dataSource.saveHomeData(homeData);

        // Assert
        verify(mockHomeDataBox.put(any)).called(1);
      });

      test("should save cruise bundle with bundle category", () async {
        // Arrange
        final BundleCategoryResponseModelDto category =
            BundleCategoryResponseModelDto(
          title: "Cruise",
        );

        final List<BundleResponseModelDto> cruiseBundles = <BundleResponseModelDto>[
          BundleResponseModelDto(
            bundleCode: "CRUISE-1",
            bundleName: "Cruise Bundle 1",
            bundleCategory: category,
          ),
        ];

        final HomeDataResponseModelDto homeData = HomeDataResponseModelDto(
          version: "1.0.0",
          cruiseBundles: cruiseBundles,
        );

        final MockCountryQueryBuilder mockQueryBuilder =
            MockCountryQueryBuilder();
        final MockCountryQuery mockQuery = MockCountryQuery();

        when(mockCountryBox.query(any)).thenReturn(mockQueryBuilder);
        when(mockQueryBuilder.build()).thenReturn(mockQuery);
        when(mockQuery.findFirst()).thenReturn(null);

        when(mockHomeDataBox.put(any)).thenReturn(1);
        when(mockBundleCategoryBox.put(any)).thenReturn(1);
        when(mockCountryBox.put(any)).thenReturn(1);

        // Act
        await dataSource.saveHomeData(homeData);

        // Assert
        verify(mockHomeDataBox.put(any)).called(1);
        verify(mockBundleCategoryBox.put(any)).called(1);
      });

      test("should save cruise bundle with countries", () async {
        // Arrange
        final List<CountryResponseModelDto> bundleCountries =
            <CountryResponseModelDto>[
          CountryResponseModelDto(
            iso3Code: "USA",
            country: "United States",
          ),
        ];

        final List<BundleResponseModelDto> cruiseBundles = <BundleResponseModelDto>[
          BundleResponseModelDto(
            bundleCode: "CRUISE-1",
            bundleName: "Cruise Bundle 1",
            countries: bundleCountries,
          ),
        ];

        final HomeDataResponseModelDto homeData = HomeDataResponseModelDto(
          version: "1.0.0",
          cruiseBundles: cruiseBundles,
        );

        final MockCountryQueryBuilder mockQueryBuilder =
            MockCountryQueryBuilder();
        final MockCountryQuery mockQuery = MockCountryQuery();

        when(mockCountryBox.query(any)).thenReturn(mockQueryBuilder);
        when(mockQueryBuilder.build()).thenReturn(mockQuery);
        when(mockQuery.findFirst()).thenReturn(null);

        when(mockHomeDataBox.put(any)).thenReturn(1);
        when(mockCountryBox.put(any)).thenReturn(1);

        // Act
        await dataSource.saveHomeData(homeData);

        // Assert
        verify(mockHomeDataBox.put(any)).called(1);
        verify(mockCountryBox.put(any)).called(1);
      });

      test("should reuse existing country when iso3Code matches", () async {
        // Arrange
        final CountryEntity existingCountry = CountryEntity(
          countryID: "1",
          iso3Code: "USA",
          country: "United States",
          zoneName: null,
          countryCode: null,
          alternativeCountry: null,
          icon: null,
          operatorList: null,
        );

        final List<CountryResponseModelDto> bundleCountries =
            <CountryResponseModelDto>[
          CountryResponseModelDto(
            iso3Code: "USA",
            country: "United States",
          ),
        ];

        final List<BundleResponseModelDto> globalBundles = <BundleResponseModelDto>[
          BundleResponseModelDto(
            bundleCode: "GLOBAL-1",
            bundleName: "Global Bundle 1",
            countries: bundleCountries,
          ),
        ];

        final HomeDataResponseModelDto homeData = HomeDataResponseModelDto(
          version: "1.0.0",
          globalBundles: globalBundles,
        );

        final MockCountryQueryBuilder mockQueryBuilder =
            MockCountryQueryBuilder();
        final MockCountryQuery mockQuery = MockCountryQuery();

        when(mockCountryBox.query(any)).thenReturn(mockQueryBuilder);
        when(mockQueryBuilder.build()).thenReturn(mockQuery);
        when(mockQuery.findFirst()).thenReturn(existingCountry);

        when(mockHomeDataBox.put(any)).thenReturn(1);

        // Act
        await dataSource.saveHomeData(homeData);

        // Assert
        verify(mockHomeDataBox.put(any)).called(1);
        verifyNever(mockCountryBox.put(any));
      });

      test("should create new country when iso3Code does not match", () async {
        // Arrange
        final List<CountryResponseModelDto> bundleCountries =
            <CountryResponseModelDto>[
          CountryResponseModelDto(
            iso3Code: "CAN",
            country: "Canada",
          ),
        ];

        final List<BundleResponseModelDto> globalBundles = <BundleResponseModelDto>[
          BundleResponseModelDto(
            bundleCode: "GLOBAL-1",
            bundleName: "Global Bundle 1",
            countries: bundleCountries,
          ),
        ];

        final HomeDataResponseModelDto homeData = HomeDataResponseModelDto(
          version: "1.0.0",
          globalBundles: globalBundles,
        );

        final MockCountryQueryBuilder mockQueryBuilder =
            MockCountryQueryBuilder();
        final MockCountryQuery mockQuery = MockCountryQuery();

        when(mockCountryBox.query(any)).thenReturn(mockQueryBuilder);
        when(mockQueryBuilder.build()).thenReturn(mockQuery);
        when(mockQuery.findFirst()).thenReturn(null);

        when(mockHomeDataBox.put(any)).thenReturn(1);
        when(mockCountryBox.put(any)).thenReturn(1);

        // Act
        await dataSource.saveHomeData(homeData);

        // Assert
        verify(mockHomeDataBox.put(any)).called(1);
        verify(mockCountryBox.put(any)).called(1);
      });

      test("should save complete home data with all entities", () async {
        // Arrange
        final List<RegionsResponseModelDto> regions = <RegionsResponseModelDto>[
          RegionsResponseModelDto(regionName: "Europe", regionCode: "EU"),
        ];

        final List<CountryResponseModelDto> countries = <CountryResponseModelDto>[
          CountryResponseModelDto(iso3Code: "USA", country: "United States"),
        ];

        final BundleCategoryResponseModelDto category =
            BundleCategoryResponseModelDto(
          title: "Premium",
        );

        final List<BundleResponseModelDto> globalBundles = <BundleResponseModelDto>[
          BundleResponseModelDto(
            bundleCode: "GLOBAL-1",
            bundleName: "Global Bundle",
            bundleCategory: category,
            countries: countries,
          ),
        ];

        final List<BundleResponseModelDto> cruiseBundles = <BundleResponseModelDto>[
          BundleResponseModelDto(
            bundleCode: "CRUISE-1",
            bundleName: "Cruise Bundle",
          ),
        ];

        final HomeDataResponseModelDto homeData = HomeDataResponseModelDto(
          version: "2.0.0",
          regions: regions,
          countries: countries,
          globalBundles: globalBundles,
          cruiseBundles: cruiseBundles,
        );

        final MockCountryQueryBuilder mockQueryBuilder =
            MockCountryQueryBuilder();
        final MockCountryQuery mockQuery = MockCountryQuery();

        when(mockCountryBox.query(any)).thenReturn(mockQueryBuilder);
        when(mockQueryBuilder.build()).thenReturn(mockQuery);
        when(mockQuery.findFirst()).thenReturn(null);

        when(mockHomeDataBox.put(any)).thenReturn(1);
        when(mockBundleCategoryBox.put(any)).thenReturn(1);
        when(mockCountryBox.put(any)).thenReturn(1);

        // Act
        await dataSource.saveHomeData(homeData);

        // Assert
        verify(mockHomeDataBox.put(any)).called(1);
      });
    });

    group("getHomeData", () {
      test("should return null when no home data in database", () {
        // Arrange
        final MockHomeDataQueryBuilder mockQueryBuilder =
            MockHomeDataQueryBuilder();
        final MockHomeDataQuery mockQuery = MockHomeDataQuery();

        when(mockHomeDataBox.query()).thenReturn(mockQueryBuilder);
        when(mockQueryBuilder.order(any, flags: anyNamed("flags")))
            .thenReturn(mockQueryBuilder);
        when(mockQueryBuilder.build()).thenReturn(mockQuery);
        when(mockQuery.findFirst()).thenReturn(null);

        // Act
        final HomeDataResponseModelDto? result = dataSource.getHomeData();

        // Assert
        expect(result, isNull);
      });

      test("should return most recent home data ordered by lastUpdated", () {
        // Arrange
        final HomeDataEntity homeDataEntity = HomeDataEntity(
          lastUpdated: DateTime.now(),
        )..version = "1.0.0";

        final MockHomeDataQueryBuilder mockQueryBuilder =
            MockHomeDataQueryBuilder();
        final MockHomeDataQuery mockQuery = MockHomeDataQuery();

        when(mockHomeDataBox.query()).thenReturn(mockQueryBuilder);
        when(mockQueryBuilder.order(any, flags: anyNamed("flags")))
            .thenReturn(mockQueryBuilder);
        when(mockQueryBuilder.build()).thenReturn(mockQuery);
        when(mockQuery.findFirst()).thenReturn(homeDataEntity);

        // Act
        final HomeDataResponseModelDto? result = dataSource.getHomeData();

        // Assert
        expect(result, isNotNull);
        expect(result!.version, "1.0.0");
        verify(
          mockQueryBuilder.order(
            HomeDataEntity_.lastUpdated,
            flags: Order.descending,
          ),
        ).called(1);
      });

      test("should convert home data entity to response model", () {
        // Arrange
        final HomeDataEntity homeDataEntity = HomeDataEntity(
          lastUpdated: DateTime.now(),
        )..version = "2.0.0";

        final MockHomeDataQueryBuilder mockQueryBuilder =
            MockHomeDataQueryBuilder();
        final MockHomeDataQuery mockQuery = MockHomeDataQuery();

        when(mockHomeDataBox.query()).thenReturn(mockQueryBuilder);
        when(mockQueryBuilder.order(any, flags: anyNamed("flags")))
            .thenReturn(mockQueryBuilder);
        when(mockQueryBuilder.build()).thenReturn(mockQuery);
        when(mockQuery.findFirst()).thenReturn(homeDataEntity);

        // Act
        final HomeDataResponseModelDto? result = dataSource.getHomeData();

        // Assert
        expect(result, isNotNull);
        expect(result!.version, "2.0.0");
      });
    });

    group("clearCache", () {
      test("should remove all data from all boxes", () async {
        // Arrange
        when(mockHomeDataBox.removeAll()).thenReturn(1);
        when(mockCountryBox.removeAll()).thenReturn(10);
        when(mockBundleCategoryBox.removeAll()).thenReturn(5);

        // Act
        await dataSource.clearCache();

        // Assert
        verify(mockHomeDataBox.removeAll()).called(1);
        verify(mockCountryBox.removeAll()).called(1);
        verify(mockBundleCategoryBox.removeAll()).called(1);
      });

      test("should handle empty database gracefully", () async {
        // Arrange
        when(mockHomeDataBox.removeAll()).thenReturn(0);
        when(mockCountryBox.removeAll()).thenReturn(0);
        when(mockBundleCategoryBox.removeAll()).thenReturn(0);

        // Act
        await dataSource.clearCache();

        // Assert
        verify(mockHomeDataBox.removeAll()).called(1);
        verify(mockCountryBox.removeAll()).called(1);
        verify(mockBundleCategoryBox.removeAll()).called(1);
      });
    });
  });
}
