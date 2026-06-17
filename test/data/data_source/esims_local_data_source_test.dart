// esims_local_data_source_test.dart

import "package:esim_open_source/data/data_source/esims_local_data_source.dart";
import "package:esim_open_source/data/data_source/my_esim_entities/esim_bundle_category_entity.dart";
import "package:esim_open_source/data/data_source/my_esim_entities/esim_country_entity.dart";
import "package:esim_open_source/data/data_source/my_esim_entities/esim_entity.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_category_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/purchase_esim_bundle_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/transaction_history_response_model_dto.dart";
import "package:esim_open_source/objectbox.g.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "esims_local_data_source_test.mocks.dart";

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
  MockSpec<Box<EsimEntity>>(as: #MockEsimBox),
  MockSpec<Box<EsimCountryEntity>>(as: #MockEsimCountryBox),
  MockSpec<Box<EsimBundleCategoryEntity>>(as: #MockEsimBundleCategoryBox),
  MockSpec<Query<EsimEntity>>(as: #MockEsimQuery),
  MockSpec<Query<EsimCountryEntity>>(as: #MockEsimCountryQuery),
  MockSpec<QueryBuilder<EsimEntity>>(
    as: #MockEsimQueryBuilder,
    unsupportedMembers: <Symbol>{#link, #backlink, #linkMany, #backlinkMany},
  ),
  MockSpec<QueryBuilder<EsimCountryEntity>>(
    as: #MockEsimCountryQueryBuilder,
    unsupportedMembers: <Symbol>{#link, #backlink, #linkMany, #backlinkMany},
  ),
])
EsimEntity createTestEsimEntity({
  String? orderNumber,
  String? orderStatus,
  String? displayTitle,
  String? bundleCode,
  String? iccid,
}) {
  return EsimEntity(
    isTopupAllowed: false,
    planStarted: false,
    bundleExpired: false,
    labelName: null,
    orderNumber: orderNumber,
    orderStatus: orderStatus,
    qrCodeValue: null,
    activationCode: null,
    smdpAddress: null,
    validityDate: null,
    iccid: iccid,
    paymentDate: null,
    sharedWith: null,
    displayTitle: displayTitle,
    displaySubtitle: null,
    bundleCode: bundleCode,
    bundleMarketingName: null,
    bundleName: null,
    countCountries: null,
    currencyCode: null,
    gprsLimitDisplay: null,
    price: null,
    priceDisplay: null,
    unlimited: null,
    validity: null,
    validityLabel: null,
    planType: null,
    activityPolicy: null,
    icon: null,
    bundleMessage: null,
    searchedCountries: null,
  );
}

void main() {
  late FakeStore fakeStore;
  late MockEsimBox mockEsimBox;
  late MockEsimCountryBox mockCountryBox;
  late MockEsimBundleCategoryBox mockBundleCategoryBox;
  late EsimsLocalDataSource dataSource;

  setUp(() {
    fakeStore = FakeStore();
    mockEsimBox = MockEsimBox();
    mockCountryBox = MockEsimCountryBox();
    mockBundleCategoryBox = MockEsimBundleCategoryBox();

    // Register boxes with the fake store
    fakeStore
      ..registerBox<EsimEntity>(mockEsimBox)
      ..registerBox<EsimCountryEntity>(mockCountryBox)
      ..registerBox<EsimBundleCategoryEntity>(mockBundleCategoryBox);

    dataSource = EsimsLocalDataSource(fakeStore);
  });

  group("EsimsLocalDataSource", () {
    group("replacePurchasedEsims", () {
      test("should handle null data list gracefully", () async {
        // Act
        await dataSource.replacePurchasedEsims(null);

        // Assert - no exception should be thrown
        // When null is passed, no boxes should be modified
        verifyNever(mockEsimBox.put(any));
      });

      test("should clear cache before saving new data", () async {
        // Arrange
        final List<PurchaseEsimBundleResponseModelDto> dataList =
            <PurchaseEsimBundleResponseModelDto>[
          PurchaseEsimBundleResponseModelDto(
            orderNumber: "test-order-1",
            orderStatus: "active",
            displayTitle: "Test Bundle",
          ),
        ];

        // Mock box behaviors
        when(mockEsimBox.removeAll()).thenReturn(0);
        when(mockCountryBox.removeAll()).thenReturn(0);
        when(mockBundleCategoryBox.removeAll()).thenReturn(0);
        when(mockEsimBox.put(any)).thenReturn(1);

        // Act
        await dataSource.replacePurchasedEsims(dataList);

        // Assert
        verify(mockEsimBox.removeAll()).called(1);
        verify(mockCountryBox.removeAll()).called(1);
        verify(mockBundleCategoryBox.removeAll()).called(1);
      });

      test("should save esim data without related entities", () async {
        // Arrange
        final List<PurchaseEsimBundleResponseModelDto> dataList =
            <PurchaseEsimBundleResponseModelDto>[
          PurchaseEsimBundleResponseModelDto(
            orderNumber: "test-order-1",
            orderStatus: "active",
            displayTitle: "Test Bundle",
            bundleCode: "BUNDLE-123",
            iccid: "8901234567890123456",
          ),
        ];

        when(mockEsimBox.removeAll()).thenReturn(0);
        when(mockCountryBox.removeAll()).thenReturn(0);
        when(mockBundleCategoryBox.removeAll()).thenReturn(0);
        when(mockEsimBox.put(any)).thenReturn(1);

        // Act
        await dataSource.replacePurchasedEsims(dataList);

        // Assert
        verify(mockEsimBox.put(any)).called(1);
      });

      test("should save esim data with bundle category", () async {
        // Arrange
        final BundleCategoryResponseModelDto category =
            BundleCategoryResponseModelDto(
          title: "Global",
        );

        final List<PurchaseEsimBundleResponseModelDto> dataList =
            <PurchaseEsimBundleResponseModelDto>[
          PurchaseEsimBundleResponseModelDto(
            orderNumber: "test-order-1",
            orderStatus: "active",
            displayTitle: "Test Bundle",
            bundleCategory: category,
          ),
        ];

        when(mockEsimBox.removeAll()).thenReturn(0);
        when(mockCountryBox.removeAll()).thenReturn(0);
        when(mockBundleCategoryBox.removeAll()).thenReturn(0);
        when(mockEsimBox.put(any)).thenReturn(1);

        // Act
        await dataSource.replacePurchasedEsims(dataList);

        // Assert
        verify(mockEsimBox.put(any)).called(1);
      });

      test("should save esim data with countries", () async {
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

        final List<PurchaseEsimBundleResponseModelDto> dataList =
            <PurchaseEsimBundleResponseModelDto>[
          PurchaseEsimBundleResponseModelDto(
            orderNumber: "test-order-1",
            orderStatus: "active",
            displayTitle: "Test Bundle",
            countries: countries,
          ),
        ];

        when(mockEsimBox.removeAll()).thenReturn(0);
        when(mockCountryBox.removeAll()).thenReturn(0);
        when(mockBundleCategoryBox.removeAll()).thenReturn(0);
        when(mockEsimBox.put(any)).thenReturn(1);

        // Act
        await dataSource.replacePurchasedEsims(dataList);

        // Assert
        verify(mockEsimBox.put(any)).called(1);
      });

      test("should save esim data with transaction history", () async {
        // Arrange
        final List<TransactionHistoryResponseModelDto> transactions =
            <TransactionHistoryResponseModelDto>[
          TransactionHistoryResponseModelDto(
            userOrderId: "order-1",
          ),
        ];

        final List<PurchaseEsimBundleResponseModelDto> dataList =
            <PurchaseEsimBundleResponseModelDto>[
          PurchaseEsimBundleResponseModelDto(
            orderNumber: "test-order-1",
            orderStatus: "active",
            displayTitle: "Test Bundle",
            transactionHistory: transactions,
          ),
        ];

        when(mockEsimBox.removeAll()).thenReturn(0);
        when(mockCountryBox.removeAll()).thenReturn(0);
        when(mockBundleCategoryBox.removeAll()).thenReturn(0);
        when(mockEsimBox.put(any)).thenReturn(1);

        // Act
        await dataSource.replacePurchasedEsims(dataList);

        // Assert
        verify(mockEsimBox.put(any)).called(1);
      });

      test("should save transaction history with bundle and bundle category",
          () async {
        // Arrange
        final BundleCategoryResponseModelDto bundleCategory =
            BundleCategoryResponseModelDto(
          title: "Premium",
        );

        final BundleResponseModelDto bundle = BundleResponseModelDto(
          bundleCode: "PREMIUM-123",
          bundleName: "Premium Bundle",
          bundleCategory: bundleCategory,
        );

        final List<TransactionHistoryResponseModelDto> transactions =
            <TransactionHistoryResponseModelDto>[
          TransactionHistoryResponseModelDto(
            userOrderId: "order-1",
            bundle: bundle,
          ),
        ];

        final List<PurchaseEsimBundleResponseModelDto> dataList =
            <PurchaseEsimBundleResponseModelDto>[
          PurchaseEsimBundleResponseModelDto(
            orderNumber: "test-order-1",
            orderStatus: "active",
            displayTitle: "Test Bundle",
            transactionHistory: transactions,
          ),
        ];

        final MockEsimCountryQueryBuilder mockQueryBuilder =
            MockEsimCountryQueryBuilder();
        final MockEsimCountryQuery mockQuery = MockEsimCountryQuery();

        when(mockCountryBox.query(any)).thenReturn(mockQueryBuilder);
        when(mockQueryBuilder.build()).thenReturn(mockQuery);
        when(mockQuery.findFirst()).thenReturn(null);

        when(mockEsimBox.removeAll()).thenReturn(0);
        when(mockCountryBox.removeAll()).thenReturn(0);
        when(mockBundleCategoryBox.removeAll()).thenReturn(0);
        when(mockEsimBox.put(any)).thenReturn(1);
        when(mockBundleCategoryBox.put(any)).thenReturn(1);
        when(mockCountryBox.put(any)).thenReturn(1);

        // Act
        await dataSource.replacePurchasedEsims(dataList);

        // Assert
        verify(mockEsimBox.put(any)).called(1);
        verify(mockBundleCategoryBox.put(any)).called(1);
      });

      test("should handle multiple esim bundles", () async {
        // Arrange
        final List<PurchaseEsimBundleResponseModelDto> dataList =
            <PurchaseEsimBundleResponseModelDto>[
          PurchaseEsimBundleResponseModelDto(
            orderNumber: "test-order-1",
            orderStatus: "active",
            displayTitle: "Test Bundle 1",
          ),
          PurchaseEsimBundleResponseModelDto(
            orderNumber: "test-order-2",
            orderStatus: "expired",
            displayTitle: "Test Bundle 2",
          ),
          PurchaseEsimBundleResponseModelDto(
            orderNumber: "test-order-3",
            orderStatus: "active",
            displayTitle: "Test Bundle 3",
          ),
        ];

        when(mockEsimBox.removeAll()).thenReturn(0);
        when(mockCountryBox.removeAll()).thenReturn(0);
        when(mockBundleCategoryBox.removeAll()).thenReturn(0);
        when(mockEsimBox.put(any)).thenReturn(1);

        // Act
        await dataSource.replacePurchasedEsims(dataList);

        // Assert
        verify(mockEsimBox.put(any)).called(3);
      });

      test("should reuse existing country when iso3Code matches", () async {
        // Arrange
        final List<CountryResponseModelDto> countries = <CountryResponseModelDto>[
          CountryResponseModelDto(
            iso3Code: "USA",
            country: "United States",
          ),
        ];

        final BundleResponseModelDto bundle = BundleResponseModelDto(
          bundleCode: "BUNDLE-123",
          bundleName: "Test Bundle",
          countries: countries,
        );

        final List<TransactionHistoryResponseModelDto> transactions =
            <TransactionHistoryResponseModelDto>[
          TransactionHistoryResponseModelDto(
            userOrderId: "order-1",
            bundle: bundle,
          ),
        ];

        final List<PurchaseEsimBundleResponseModelDto> dataList =
            <PurchaseEsimBundleResponseModelDto>[
          PurchaseEsimBundleResponseModelDto(
            orderNumber: "test-order-1",
            orderStatus: "active",
            displayTitle: "Test Bundle",
            transactionHistory: transactions,
          ),
        ];

        final MockEsimCountryQueryBuilder mockQueryBuilder =
            MockEsimCountryQueryBuilder();
        final MockEsimCountryQuery mockQuery = MockEsimCountryQuery();
        final EsimCountryEntity existingCountry = EsimCountryEntity(
          countryID: "1",
          iso3Code: "USA",
          country: "United States",
          zoneName: null,
          countryCode: null,
          alternativeCountry: null,
          icon: null,
          operatorList: null,
        );

        when(mockCountryBox.query(any)).thenReturn(mockQueryBuilder);
        when(mockQueryBuilder.build()).thenReturn(mockQuery);
        when(mockQuery.findFirst()).thenReturn(existingCountry);

        when(mockEsimBox.removeAll()).thenReturn(0);
        when(mockCountryBox.removeAll()).thenReturn(0);
        when(mockBundleCategoryBox.removeAll()).thenReturn(0);
        when(mockEsimBox.put(any)).thenReturn(1);

        // Act
        await dataSource.replacePurchasedEsims(dataList);

        // Assert
        verify(mockEsimBox.put(any)).called(1);
        verifyNever(mockCountryBox.put(any));
      });

      test("should create new country when iso3Code does not match", () async {
        // Arrange
        final List<CountryResponseModelDto> countries = <CountryResponseModelDto>[
          CountryResponseModelDto(
            iso3Code: "USA",
            country: "United States",
          ),
        ];

        final BundleResponseModelDto bundle = BundleResponseModelDto(
          bundleCode: "BUNDLE-123",
          bundleName: "Test Bundle",
          countries: countries,
        );

        final List<TransactionHistoryResponseModelDto> transactions =
            <TransactionHistoryResponseModelDto>[
          TransactionHistoryResponseModelDto(
            userOrderId: "order-1",
            bundle: bundle,
          ),
        ];

        final List<PurchaseEsimBundleResponseModelDto> dataList =
            <PurchaseEsimBundleResponseModelDto>[
          PurchaseEsimBundleResponseModelDto(
            orderNumber: "test-order-1",
            orderStatus: "active",
            displayTitle: "Test Bundle",
            transactionHistory: transactions,
          ),
        ];

        final MockEsimCountryQueryBuilder mockQueryBuilder =
            MockEsimCountryQueryBuilder();
        final MockEsimCountryQuery mockQuery = MockEsimCountryQuery();

        when(mockCountryBox.query(any)).thenReturn(mockQueryBuilder);
        when(mockQueryBuilder.build()).thenReturn(mockQuery);
        when(mockQuery.findFirst()).thenReturn(null);

        when(mockEsimBox.removeAll()).thenReturn(0);
        when(mockCountryBox.removeAll()).thenReturn(0);
        when(mockBundleCategoryBox.removeAll()).thenReturn(0);
        when(mockEsimBox.put(any)).thenReturn(1);
        when(mockCountryBox.put(any)).thenReturn(1);

        // Act
        await dataSource.replacePurchasedEsims(dataList);

        // Assert
        verify(mockEsimBox.put(any)).called(1);
        verify(mockCountryBox.put(any)).called(1);
      });
    });

    group("getPurchasedEsims", () {
      test("should return empty list when no esims in database", () {
        // Arrange
        final MockEsimQueryBuilder mockQueryBuilder = MockEsimQueryBuilder();
        final MockEsimQuery mockQuery = MockEsimQuery();

        when(mockEsimBox.query()).thenReturn(mockQueryBuilder);
        when(mockQueryBuilder.build()).thenReturn(mockQuery);
        when(mockQuery.find()).thenReturn(<EsimEntity>[]);

        // Act
        final List<PurchaseEsimBundleResponseModelDto>? result =
            dataSource.getPurchasedEsims();

        // Assert
        expect(result, isNotNull);
        expect(result, isEmpty);
      });

      test("should return list of esims from database", () {
        // Arrange
        final List<EsimEntity> esimEntities = <EsimEntity>[
          createTestEsimEntity(
            orderNumber: "order-1",
            orderStatus: "active",
            displayTitle: "Bundle 1",
          ),
          createTestEsimEntity(
            orderNumber: "order-2",
            orderStatus: "expired",
            displayTitle: "Bundle 2",
          ),
        ];

        final MockEsimQueryBuilder mockQueryBuilder = MockEsimQueryBuilder();
        final MockEsimQuery mockQuery = MockEsimQuery();

        when(mockEsimBox.query()).thenReturn(mockQueryBuilder);
        when(mockQueryBuilder.build()).thenReturn(mockQuery);
        when(mockQuery.find()).thenReturn(esimEntities);

        // Act
        final List<PurchaseEsimBundleResponseModelDto>? result =
            dataSource.getPurchasedEsims();

        // Assert
        expect(result, isNotNull);
        expect(result!.length, 2);
        expect(result[0].orderNumber, "order-1");
        expect(result[1].orderNumber, "order-2");
      });

      test("should convert esim entities to response models", () {
        // Arrange
        final List<EsimEntity> esimEntities = <EsimEntity>[
          createTestEsimEntity(
            orderNumber: "order-123",
            orderStatus: "active",
            displayTitle: "Test Bundle",
            bundleCode: "BUNDLE-123",
            iccid: "8901234567890123456",
          ),
        ];

        final MockEsimQueryBuilder mockQueryBuilder = MockEsimQueryBuilder();
        final MockEsimQuery mockQuery = MockEsimQuery();

        when(mockEsimBox.query()).thenReturn(mockQueryBuilder);
        when(mockQueryBuilder.build()).thenReturn(mockQuery);
        when(mockQuery.find()).thenReturn(esimEntities);

        // Act
        final List<PurchaseEsimBundleResponseModelDto>? result =
            dataSource.getPurchasedEsims();

        // Assert
        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].orderNumber, "order-123");
        expect(result[0].orderStatus, "active");
        expect(result[0].displayTitle, "Test Bundle");
        expect(result[0].bundleCode, "BUNDLE-123");
        expect(result[0].iccid, "8901234567890123456");
      });
    });

    group("clearCache", () {
      test("should remove all data from all boxes", () async {
        // Arrange
        when(mockEsimBox.removeAll()).thenReturn(5);
        when(mockCountryBox.removeAll()).thenReturn(10);
        when(mockBundleCategoryBox.removeAll()).thenReturn(3);

        // Act
        await dataSource.clearCache();

        // Assert
        verify(mockEsimBox.removeAll()).called(1);
        verify(mockCountryBox.removeAll()).called(1);
        verify(mockBundleCategoryBox.removeAll()).called(1);
      });

      test("should handle empty database gracefully", () async {
        // Arrange
        when(mockEsimBox.removeAll()).thenReturn(0);
        when(mockCountryBox.removeAll()).thenReturn(0);
        when(mockBundleCategoryBox.removeAll()).thenReturn(0);

        // Act
        await dataSource.clearCache();

        // Assert
        verify(mockEsimBox.removeAll()).called(1);
        verify(mockCountryBox.removeAll()).called(1);
        verify(mockBundleCategoryBox.removeAll()).called(1);
      });
    });
  });
}
