import "package:esim_open_source/domain/data/response/app/currencies_response_model.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/use_case/app/get_currencies_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_data_factory.dart";
import "../../../helpers/test_environment_setup.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for GetCurrenciesUseCase
/// Tests the get currencies use case with caching functionality
Future<void> main() async {
  await TestEnvironmentSetup.initializeTestEnvironment();

  late GetCurrenciesUseCase useCase;
  late MockApiAppRepository mockRepository;

  setUp(() async {
    await setupTestLocator();
    mockRepository = locator<ApiAppRepository>() as MockApiAppRepository;
    useCase = GetCurrenciesUseCase(mockRepository);
    // Clear previous response cache between tests
    GetCurrenciesUseCase.previousResponse = null;
  });

  tearDown(() async {
    // Clean up static cache
    GetCurrenciesUseCase.previousResponse = null;
    await locator.reset();
  });

  group("GetCurrenciesUseCase Tests", () {
    test("execute returns success resource when repository succeeds", () async {
      // Arrange
      final List<CurrenciesResponseModel> currencies =
          TestDataFactory.createCurrencyResponseList();

      final Resource<List<CurrenciesResponseModel>?> expectedResponse =
          TestDataFactory.createSuccessResource<List<CurrenciesResponseModel>?>(
        data: currencies,
        message: "Success",
      );

      when(mockRepository.getCurrencies())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<CurrenciesResponseModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.length, equals(3));

      verify(mockRepository.getCurrencies()).called(1);
    });

    test("execute returns error resource when repository fails", () async {
      // Arrange
      final Resource<List<CurrenciesResponseModel>?> expectedResponse =
          TestDataFactory.createErrorResource<List<CurrenciesResponseModel>?>(
        message: "Failed to fetch currencies",
      );

      when(mockRepository.getCurrencies())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<CurrenciesResponseModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to fetch currencies"));

      verify(mockRepository.getCurrencies()).called(1);
    });

    test("execute caches successful response for subsequent calls", () async {
      // Arrange
      final List<CurrenciesResponseModel> currencies =
          TestDataFactory.createCurrencyResponseList(count: 2);

      final Resource<List<CurrenciesResponseModel>?> expectedResponse =
          TestDataFactory.createSuccessResource<List<CurrenciesResponseModel>?>(
        data: currencies,
      );

      when(mockRepository.getCurrencies())
          .thenAnswer((_) async => expectedResponse);

      // Act - First call
      final Resource<List<CurrenciesResponseModel>?> result1 =
          await useCase.execute(NoParams());

      // Act - Second call
      final Resource<List<CurrenciesResponseModel>?> result2 =
          await useCase.execute(NoParams());

      // Assert
      expect(result1.resourceType, equals(ResourceType.success));
      expect(result2.resourceType, equals(ResourceType.success));
      expect(result1.data, equals(result2.data));

      // Repository should only be called once due to caching
      verify(mockRepository.getCurrencies()).called(1);
    });

    test("execute does not cache error response", () async {
      // Arrange
      final Resource<List<CurrenciesResponseModel>?> errorResponse =
          TestDataFactory.createErrorResource<List<CurrenciesResponseModel>?>(
        message: "Network error",
      );

      when(mockRepository.getCurrencies())
          .thenAnswer((_) async => errorResponse);

      // Act - First call
      final Resource<List<CurrenciesResponseModel>?> result1 =
          await useCase.execute(NoParams());

      // Act - Second call
      final Resource<List<CurrenciesResponseModel>?> result2 =
          await useCase.execute(NoParams());

      // Assert
      expect(result1.resourceType, equals(ResourceType.error));
      expect(result2.resourceType, equals(ResourceType.error));

      // Repository should be called twice since error is not cached
      verify(mockRepository.getCurrencies()).called(2);
    });

    test("execute does not cache loading response", () async {
      // Arrange
      final Resource<List<CurrenciesResponseModel>?> loadingResponse =
          TestDataFactory.createLoadingResource<
              List<CurrenciesResponseModel>?>();

      when(mockRepository.getCurrencies())
          .thenAnswer((_) async => loadingResponse);

      // Act - First call
      final Resource<List<CurrenciesResponseModel>?> result1 =
          await useCase.execute(NoParams());

      // Act - Second call
      final Resource<List<CurrenciesResponseModel>?> result2 =
          await useCase.execute(NoParams());

      // Assert
      expect(result1.resourceType, equals(ResourceType.loading));
      expect(result2.resourceType, equals(ResourceType.loading));

      // Repository should be called twice since loading is not cached
      verify(mockRepository.getCurrencies()).called(2);
    });

    test("execute works with null params", () async {
      // Arrange
      final Resource<List<CurrenciesResponseModel>?> expectedResponse =
          TestDataFactory.createSuccessResource<List<CurrenciesResponseModel>?>(
        data: TestDataFactory.createCurrencyResponseList(),
      );

      when(mockRepository.getCurrencies())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<CurrenciesResponseModel>?> result =
          await useCase.execute(null);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));

      verify(mockRepository.getCurrencies()).called(1);
    });

    test("execute handles empty currency list", () async {
      // Arrange
      final Resource<List<CurrenciesResponseModel>?> expectedResponse =
          TestDataFactory.createSuccessResource<List<CurrenciesResponseModel>?>(
        data: <CurrenciesResponseModel>[],
      );

      when(mockRepository.getCurrencies())
          .thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<CurrenciesResponseModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.isEmpty, isTrue);

      verify(mockRepository.getCurrencies()).called(1);
    });
  });
}
