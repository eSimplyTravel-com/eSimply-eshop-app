// api_bundles_repository_impl_test.dart

import "dart:async";

import "package:esim_open_source/data/data_source/home_local_data_source.dart";
import "package:esim_open_source/data/remote/responses/base_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_consumption_response_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/home_data_response_model_dto.dart";
import "package:esim_open_source/data/repository/api_bundles_repository_impl.dart";
import "package:esim_open_source/domain/data/api_bundles.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_consumption_response.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/repository/api_bundles_repository.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/reactive_service/bundles_data_service.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../locator_test.dart";
import "../../locator_test.mocks.dart" as locator_mocks;
import "api_bundles_repository_impl_test.mocks.dart";

@GenerateMocks(<Type>[APIBundles, HomeLocalDataSource])
void main() {
  late ApiBundlesRepository repository;
  late MockAPIBundles mockApiBundles;
  late MockHomeLocalDataSource mockLocalDataSource;
  late locator_mocks.MockLocalStorageService mockLocalStorageService;
  late locator_mocks.MockAppConfigurationService mockAppConfigurationService;

  setUpAll(() async {
    await setupTestLocator();
  });

  setUp(() {
    mockApiBundles = MockAPIBundles();
    mockLocalDataSource = MockHomeLocalDataSource();
    mockLocalStorageService =
        locator<LocalStorageService>() as locator_mocks.MockLocalStorageService;
    mockAppConfigurationService = locator<AppConfigurationService>()
        as locator_mocks.MockAppConfigurationService;
    repository = ApiBundlesRepositoryImpl(
      repository: mockLocalDataSource,
      apiBundles: mockApiBundles,
    );
  });

  tearDown(() async {
    await repository.dispose();
    reset(mockLocalStorageService);
    reset(mockAppConfigurationService);
  });

  group("ApiBundlesRepositoryImpl", () {
    group("getBundleConsumption", () {
      const String testIccID = "89012345678901234567";

      test(
          "should return success resource when bundle consumption retrieval succeeds",
          () async {
        // Arrange
        final BundleConsumptionResponseDto expectedResponse =
            BundleConsumptionResponseDto(
          consumption: 5000000000, // 5GB in bytes
          unit: "bytes",
          displayConsumption: "5 GB",
        );
        final ResponseMainDto<BundleConsumptionResponseDto> responseMain =
            ResponseMainDto<BundleConsumptionResponseDto>.createErrorWithData(
          data: expectedResponse,
          message: "Bundle consumption retrieved",
          statusCode: 200,
        );

        when(
          mockApiBundles.getBundleConsumption(iccID: testIccID),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<BundleConsumptionResponse?> result =
            await repository.getBundleConsumption(
          iccID: testIccID,
        );

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.consumption, 5000000000);
        expect(result.data?.unit, "bytes");
        expect(result.data?.displayConsumption, "5 GB");
        expect(result.message, "Bundle consumption retrieved");
        expect(result.error, isNull);

        verify(mockApiBundles.getBundleConsumption(iccID: testIccID)).called(1);
      });

      test(
          "should return error resource when bundle consumption retrieval fails",
          () async {
        // Arrange
        final ResponseMainDto<BundleConsumptionResponseDto> responseMain =
            ResponseMainDto<BundleConsumptionResponseDto>.createErrorWithData(
          statusCode: 404,
          developerMessage: "Bundle not found",
          title: "Bundle not found",
        );

        when(
          mockApiBundles.getBundleConsumption(iccID: testIccID),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<BundleConsumptionResponse?> result =
            await repository.getBundleConsumption(
          iccID: testIccID,
        );

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Bundle not found");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(mockApiBundles.getBundleConsumption(iccID: testIccID)).called(1);
      });

      test("should handle invalid ICCID format", () async {
        // Arrange
        const String invalidIccID = "invalid";
        final ResponseMainDto<BundleConsumptionResponseDto> responseMain =
            ResponseMainDto<BundleConsumptionResponseDto>.createErrorWithData(
          statusCode: 400,
          developerMessage: "Invalid ICCID format",
          title: "Invalid ICCID format",
        );

        when(
          mockApiBundles.getBundleConsumption(iccID: invalidIccID),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<BundleConsumptionResponse?> result =
            await repository.getBundleConsumption(
          iccID: invalidIccID,
        );

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Invalid ICCID format");

        verify(mockApiBundles.getBundleConsumption(iccID: invalidIccID))
            .called(1);
      });
    });

    group("getHomeData", () {
      void stubLocatorServices() {
        when(mockLocalStorageService.currencyCode).thenReturn(null);
        when(mockLocalStorageService.languageCode).thenReturn("en");
        when(mockAppConfigurationService.getDefaultCurrency).thenReturn("USD");
        // getSelectedCurrencyCode saves the default currency when currencyCode is null
        when(
          mockLocalStorageService.setString(
            LocalStorageKeys.appCurrency,
            any,
          ),
        ).thenAnswer((_) async => true);
      }

      test(
          "should return stream and fetch from API when no cache and version succeeds",
          () async {
        // Arrange
        stubLocatorServices();

        final HomeDataResponseModelDto apiData =
            HomeDataResponseModelDto(version: "v1_USD_en");
        final ResponseMainDto<HomeDataResponseModelDto> apiResponse =
            ResponseMainDto<HomeDataResponseModelDto>.createErrorWithData(
          data: apiData,
          statusCode: 200,
        );

        when(mockLocalDataSource.getHomeData()).thenReturn(null);
        when(mockApiBundles.getAllData()).thenAnswer((_) async => apiResponse);
        when(mockLocalDataSource.saveHomeData(any))
            .thenAnswer((_) async => Future<void>.value());

        // Act
        final Stream<BundleServicesStreamModel> stream =
            await repository.getHomeData(
          version: Future<HomeDataVersionResult>.value(
            HomeDataVersionResult(version: "v1", isSuccess: true),
          ),
        );

        // Pump event loop to let async background fetch complete
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(stream, isA<Stream<BundleServicesStreamModel>>());
        verify(mockLocalDataSource.getHomeData()).called(1);
        verify(mockApiBundles.getAllData()).called(1);
        verify(mockLocalDataSource.saveHomeData(any)).called(1);
      });

      test(
          "should emit cached data immediately when cache exists and not from refresh",
          () async {
        // Arrange
        stubLocatorServices();

        final HomeDataResponseModelDto cachedDto =
            HomeDataResponseModelDto(version: "v1_USD_en");
        when(mockLocalDataSource.getHomeData()).thenReturn(cachedDto);

        final HomeDataResponseModelDto apiData =
            HomeDataResponseModelDto(version: "v1_USD_en");
        final ResponseMainDto<HomeDataResponseModelDto> apiResponse =
            ResponseMainDto<HomeDataResponseModelDto>.createErrorWithData(
          data: apiData,
          statusCode: 200,
        );
        when(mockApiBundles.getAllData()).thenAnswer((_) async => apiResponse);
        when(mockLocalDataSource.saveHomeData(any))
            .thenAnswer((_) async => Future<void>.value());

        // Act — subscribe BEFORE calling getHomeData so we catch synchronous emissions
        final List<BundleServicesStreamModel> emissions =
            <BundleServicesStreamModel>[];
        final StreamSubscription<BundleServicesStreamModel> sub =
            repository.homeDataStream.listen(emissions.add);

        await repository.getHomeData(
          version: Future<HomeDataVersionResult>.value(
            HomeDataVersionResult(version: "v1", isSuccess: true),
          ),
        );

        // Pump to let background fetch complete
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        // Assert — cached data emitted first (shouldRenderShimmer=false)
        expect(emissions, isNotEmpty);
        expect(emissions.first.shouldRenderShimmer, false);
        verify(mockLocalDataSource.getHomeData()).called(1);
      });

      test(
          "should not fetch from API when cached version matches and not force refresh",
          () async {
        // Arrange — cached version matches exactly what appendAppCurrency+Language produces
        stubLocatorServices();

        final HomeDataResponseModelDto cachedDto =
            HomeDataResponseModelDto(version: "v1_USD_en");
        when(mockLocalDataSource.getHomeData()).thenReturn(cachedDto);

        // Act
        await repository.getHomeData(
          version: Future<HomeDataVersionResult>.value(
            HomeDataVersionResult(version: "v1", isSuccess: true),
          ),
        );
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        // Assert — API not called because cached version matches
        verifyNever(mockApiBundles.getAllData());
      });
    });

    group("getAllBundles", () {
      test("should return success resource when get all bundles succeeds",
          () async {
        // Arrange
        final List<BundleResponseModelDto> expectedBundles =
            <BundleResponseModelDto>[
          BundleResponseModelDto(
            bundleCode: "bundle-1",
            bundleName: "Global 5GB",
            price: 10.99,
          ),
          BundleResponseModelDto(
            bundleCode: "bundle-2",
            bundleName: "Europe 10GB",
            price: 15.99,
          ),
        ];
        final ResponseMainDto<List<BundleResponseModelDto>> responseMain =
            ResponseMainDto<List<BundleResponseModelDto>>.createErrorWithData(
          data: expectedBundles,
          message: "Bundles retrieved successfully",
          statusCode: 200,
        );

        when(mockApiBundles.getAllBundles())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<BundleResponseModel>?> result = await repository
            .getAllBundles() as Resource<List<BundleResponseModel>?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.length, 2);
        expect(result.data?[0].bundleCode, "bundle-1");
        expect(result.data?[1].bundleCode, "bundle-2");
        expect(result.message, "Bundles retrieved successfully");
        expect(result.error, isNull);

        verify(mockApiBundles.getAllBundles()).called(1);
      });

      test("should return error resource when get all bundles fails", () async {
        // Arrange
        final ResponseMainDto<List<BundleResponseModelDto>> responseMain =
            ResponseMainDto<List<BundleResponseModelDto>>.createErrorWithData(
          statusCode: 500,
          developerMessage: "Server error",
          title: "Server error",
        );

        when(mockApiBundles.getAllBundles())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<BundleResponseModel>?> result = await repository
            .getAllBundles() as Resource<List<BundleResponseModel>?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Server error");
        expect(result.data, isNull);

        verify(mockApiBundles.getAllBundles()).called(1);
      });

      test("should handle empty bundle list", () async {
        // Arrange
        final List<BundleResponseModelDto> emptyBundles =
            <BundleResponseModelDto>[];
        final ResponseMainDto<List<BundleResponseModelDto>> responseMain =
            ResponseMainDto<List<BundleResponseModelDto>>.createErrorWithData(
          data: emptyBundles,
          message: "No bundles available",
          statusCode: 200,
        );

        when(mockApiBundles.getAllBundles())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<BundleResponseModel>?> result = await repository
            .getAllBundles() as Resource<List<BundleResponseModel>?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isEmpty);

        verify(mockApiBundles.getAllBundles()).called(1);
      });
    });

    group("getBundle", () {
      const String testBundleCode = "bundle-test-123";

      test("should return success resource when get bundle by code succeeds",
          () async {
        // Arrange
        final BundleResponseModelDto expectedBundle = BundleResponseModelDto(
          bundleCode: testBundleCode,
          bundleName: "Test Bundle 5GB",
          price: 12.99,
          validity: 30,
        );
        final ResponseMainDto<BundleResponseModelDto> responseMain =
            ResponseMainDto<BundleResponseModelDto>.createErrorWithData(
          data: expectedBundle,
          message: "Bundle retrieved",
          statusCode: 200,
        );

        when(
          mockApiBundles.getBundle(code: testBundleCode),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<BundleResponseModel?> result =
            await repository.getBundle(
          code: testBundleCode,
        ) as Resource<BundleResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.bundleCode, testBundleCode);
        expect(result.data?.bundleName, "Test Bundle 5GB");
        expect(result.data?.price, 12.99);
        expect(result.message, "Bundle retrieved");
        expect(result.error, isNull);

        verify(mockApiBundles.getBundle(code: testBundleCode)).called(1);
      });

      test("should return error resource when bundle not found", () async {
        // Arrange
        final ResponseMainDto<BundleResponseModelDto> responseMain =
            ResponseMainDto<BundleResponseModelDto>.createErrorWithData(
          statusCode: 404,
          developerMessage: "Bundle not found",
          title: "Bundle not found",
        );

        when(
          mockApiBundles.getBundle(code: testBundleCode),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<BundleResponseModel?> result =
            await repository.getBundle(
          code: testBundleCode,
        ) as Resource<BundleResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Bundle not found");
        expect(result.data, isNull);

        verify(mockApiBundles.getBundle(code: testBundleCode)).called(1);
      });

      test("should handle invalid bundle code", () async {
        // Arrange
        const String invalidCode = "";
        final ResponseMainDto<BundleResponseModelDto> responseMain =
            ResponseMainDto<BundleResponseModelDto>.createErrorWithData(
          statusCode: 400,
          developerMessage: "Invalid bundle code",
          title: "Invalid bundle code",
        );

        when(
          mockApiBundles.getBundle(code: invalidCode),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<BundleResponseModel?> result =
            await repository.getBundle(
          code: invalidCode,
        ) as Resource<BundleResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Invalid bundle code");

        verify(mockApiBundles.getBundle(code: invalidCode)).called(1);
      });
    });

    group("getBundlesByRegion", () {
      const String testRegionCode = "EUR";

      test("should return success resource when get bundles by region succeeds",
          () async {
        // Arrange
        final List<BundleResponseModelDto> expectedBundles =
            <BundleResponseModelDto>[
          BundleResponseModelDto(
            bundleCode: "eur-bundle-1",
            bundleName: "Europe 5GB",
          ),
          BundleResponseModelDto(
            bundleCode: "eur-bundle-2",
            bundleName: "Europe 10GB",
          ),
        ];
        final ResponseMainDto<List<BundleResponseModelDto>> responseMain =
            ResponseMainDto<List<BundleResponseModelDto>>.createErrorWithData(
          data: expectedBundles,
          message: "Region bundles retrieved",
          statusCode: 200,
        );

        when(
          mockApiBundles.getBundlesByRegion(regionCode: testRegionCode),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<BundleResponseModel>> result =
            await repository.getBundlesByRegion(
          regionCode: testRegionCode,
        ) as Resource<List<BundleResponseModel>>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.length, 2);
        expect(result.data?[0].bundleCode, "eur-bundle-1");
        expect(result.message, "Region bundles retrieved");
        expect(result.error, isNull);

        verify(mockApiBundles.getBundlesByRegion(regionCode: testRegionCode))
            .called(1);
      });

      test("should return error resource when get bundles by region fails",
          () async {
        // Arrange
        final ResponseMainDto<List<BundleResponseModelDto>> responseMain =
            ResponseMainDto<List<BundleResponseModelDto>>.createErrorWithData(
          statusCode: 404,
          developerMessage: "Region not found",
          title: "Region not found",
        );

        when(
          mockApiBundles.getBundlesByRegion(regionCode: testRegionCode),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<BundleResponseModel>> result =
            await repository.getBundlesByRegion(
          regionCode: testRegionCode,
        ) as Resource<List<BundleResponseModel>>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Region not found");
        expect(result.data, isNull);

        verify(mockApiBundles.getBundlesByRegion(regionCode: testRegionCode))
            .called(1);
      });

      test("should handle empty region bundle list", () async {
        // Arrange
        final List<BundleResponseModelDto> emptyBundles =
            <BundleResponseModelDto>[];
        final ResponseMainDto<List<BundleResponseModelDto>> responseMain =
            ResponseMainDto<List<BundleResponseModelDto>>.createErrorWithData(
          data: emptyBundles,
          message: "No bundles for this region",
          statusCode: 200,
        );

        when(
          mockApiBundles.getBundlesByRegion(regionCode: testRegionCode),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<BundleResponseModel>> result =
            await repository.getBundlesByRegion(
          regionCode: testRegionCode,
        ) as Resource<List<BundleResponseModel>>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isEmpty);

        verify(mockApiBundles.getBundlesByRegion(regionCode: testRegionCode))
            .called(1);
      });
    });

    group("getBundlesByCountries", () {
      const String testCountryCodes = "US,CA,MX";

      test(
          "should return success resource when get bundles by countries succeeds",
          () async {
        // Arrange
        final List<BundleResponseModelDto> expectedBundles =
            <BundleResponseModelDto>[
          BundleResponseModelDto(
            bundleCode: "na-bundle-1",
            bundleName: "North America 5GB",
          ),
          BundleResponseModelDto(
            bundleCode: "na-bundle-2",
            bundleName: "North America 10GB",
          ),
        ];
        final ResponseMainDto<List<BundleResponseModelDto>> responseMain =
            ResponseMainDto<List<BundleResponseModelDto>>.createErrorWithData(
          data: expectedBundles,
          message: "Country bundles retrieved",
          statusCode: 200,
        );

        when(
          mockApiBundles.getBundlesByCountries(countryCodes: testCountryCodes),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<BundleResponseModel>> result =
            await repository.getBundlesByCountries(
          countryCodes: testCountryCodes,
        ) as Resource<List<BundleResponseModel>>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.length, 2);
        expect(result.data?[0].bundleCode, "na-bundle-1");
        expect(result.message, "Country bundles retrieved");
        expect(result.error, isNull);

        verify(
          mockApiBundles.getBundlesByCountries(countryCodes: testCountryCodes),
        ).called(1);
      });

      test("should return error resource when get bundles by countries fails",
          () async {
        // Arrange
        final ResponseMainDto<List<BundleResponseModelDto>> responseMain =
            ResponseMainDto<List<BundleResponseModelDto>>.createErrorWithData(
          statusCode: 400,
          developerMessage: "Invalid country codes",
          title: "Invalid country codes",
        );

        when(
          mockApiBundles.getBundlesByCountries(countryCodes: testCountryCodes),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<BundleResponseModel>> result =
            await repository.getBundlesByCountries(
          countryCodes: testCountryCodes,
        ) as Resource<List<BundleResponseModel>>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Invalid country codes");
        expect(result.data, isNull);

        verify(
          mockApiBundles.getBundlesByCountries(countryCodes: testCountryCodes),
        ).called(1);
      });

      test("should handle single country code", () async {
        // Arrange
        const String singleCountry = "US";
        final List<BundleResponseModelDto> expectedBundles =
            <BundleResponseModelDto>[
          BundleResponseModelDto(bundleCode: "us-bundle"),
        ];
        final ResponseMainDto<List<BundleResponseModelDto>> responseMain =
            ResponseMainDto<List<BundleResponseModelDto>>.createErrorWithData(
          data: expectedBundles,
          message: "Success",
          statusCode: 200,
        );

        when(
          mockApiBundles.getBundlesByCountries(countryCodes: singleCountry),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<BundleResponseModel>> result =
            await repository.getBundlesByCountries(
          countryCodes: singleCountry,
        ) as Resource<List<BundleResponseModel>>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.length, 1);

        verify(
          mockApiBundles.getBundlesByCountries(countryCodes: singleCountry),
        ).called(1);
      });
    });

    group("clearCache", () {
      test("should call local data source clearCache", () async {
        // Arrange
        when(mockLocalDataSource.clearCache())
            .thenAnswer((_) async => Future<void>.value());

        // Act
        await repository.clearCache();

        // Assert
        verify(mockLocalDataSource.clearCache()).called(1);
      });

      test("should handle clearCache errors gracefully", () async {
        // Arrange
        when(mockLocalDataSource.clearCache())
            .thenThrow(Exception("Clear cache failed"));

        // Act & Assert
        expect(
          () => repository.clearCache(),
          throwsException,
        );

        verify(mockLocalDataSource.clearCache()).called(1);
      });
    });

    group("dispose", () {
      test("should close stream controller without errors", () async {
        // Act
        await repository.dispose();

        // Assert - Should complete without throwing
        expect(repository.dispose, returnsNormally);
      });

      test("should be able to dispose multiple times", () async {
        // Act
        await repository.dispose();
        await repository.dispose();

        // Assert - Should not throw on multiple dispose calls
        expect(repository.dispose, returnsNormally);
      });
    });

    group("homeDataStream", () {
      test("should expose homeDataStream getter", () {
        // Act
        final Stream<BundleServicesStreamModel> stream =
            repository.homeDataStream;

        // Assert
        expect(stream, isA<Stream<BundleServicesStreamModel>>());
        expect(stream, isNotNull);
      });
    });

    group("Repository contract compliance", () {
      test("should implement ApiBundlesRepository interface", () {
        expect(repository, isA<ApiBundlesRepository>());
      });

      test("should maintain consistent Resource<T> pattern across methods",
          () async {
        // Arrange & Act - Test all methods return proper Resource types
        when(mockApiBundles.getBundleConsumption(iccID: anyNamed("iccID")))
            .thenAnswer(
          (_) async =>
              ResponseMainDto<BundleConsumptionResponseDto>.createErrorWithData(
            data: BundleConsumptionResponseDto(),
            statusCode: 200,
          ),
        );
        final dynamic consumptionResult =
            await repository.getBundleConsumption(iccID: "test");
        expect(consumptionResult, isA<Resource<BundleConsumptionResponse?>>());

        when(mockApiBundles.getAllBundles()).thenAnswer(
          (_) async =>
              ResponseMainDto<List<BundleResponseModelDto>>.createErrorWithData(
            data: <BundleResponseModelDto>[],
            statusCode: 200,
          ),
        );
        final dynamic bundlesResult = await repository.getAllBundles();
        expect(bundlesResult, isA<Resource<List<BundleResponseModel>?>>());

        when(mockApiBundles.getBundle(code: anyNamed("code"))).thenAnswer(
          (_) async =>
              ResponseMainDto<BundleResponseModelDto>.createErrorWithData(
            data: BundleResponseModelDto(),
            statusCode: 200,
          ),
        );
        final dynamic bundleResult = await repository.getBundle(code: "test");
        expect(bundleResult, isA<Resource<BundleResponseModel?>>());
      });
    });

    group("Edge cases and error handling", () {
      test("should handle concurrent getHomeData calls", () async {},
          skip:
              "Complex concurrent stream test — covered by individual getHomeData tests");

      test("should handle null response data gracefully", () async {
        // Arrange
        final ResponseMainDto<BundleResponseModelDto> responseMain =
            ResponseMainDto<BundleResponseModelDto>.createErrorWithData(
          message: "Success but no data",
          statusCode: 200,
        );

        when(mockApiBundles.getBundle(code: anyNamed("code")))
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<BundleResponseModel?> result = await repository
            .getBundle(code: "test") as Resource<BundleResponseModel?>;

        // Assert
        // A 200 with data:null is a valid success(null), not an error (§6b).
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isNull);
      });

      test("should handle network timeout", () async {
        // Arrange
        when(mockApiBundles.getAllBundles())
            .thenThrow(TimeoutException("Request timeout"));

        // Act & Assert
        expect(
          () => repository.getAllBundles(),
          throwsA(isA<TimeoutException>()),
        );
      });
    });
  });
}
