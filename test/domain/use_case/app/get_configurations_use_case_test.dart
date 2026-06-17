import "package:esim_open_source/domain/data/response/app/configuration_response_model.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/use_case/app/get_configurations_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_data_factory.dart";
import "../../../helpers/test_environment_setup.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for GetConfigurationsUseCase
/// Tests the get configurations use case with caching functionality
Future<void> main() async {
  await TestEnvironmentSetup.initializeTestEnvironment();

  late GetConfigurationsUseCase useCase;
  late MockApiAppRepository mockRepository;

  setUp(() async {
    await setupTestLocator();
    mockRepository = locator<ApiAppRepository>() as MockApiAppRepository;
    useCase = GetConfigurationsUseCase(mockRepository);
    // Clear previous response cache between tests
    GetConfigurationsUseCase.previousResponse = null;
  });

  tearDown(() async {
    // Clean up static cache
    GetConfigurationsUseCase.previousResponse = null;
    await locator.reset();
  });

  group("GetConfigurationsUseCase Tests", () {
    test("execute returns success resource when repository succeeds", () async {
      // Arrange
      final List<ConfigurationResponseModel> configurations =
          TestDataFactory.createConfigurationResponseList(count: 3);

      final Resource<List<ConfigurationResponseModel>?> expectedResponse =
          TestDataFactory.createSuccessResource<List<ConfigurationResponseModel>?>(
        data: configurations,
        message: "Success",
      );

      when(mockRepository.getConfigurations()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<ConfigurationResponseModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.length, equals(3));

      verify(mockRepository.getConfigurations()).called(1);
    });

    test("execute returns error resource when repository fails", () async {
      // Arrange
      final Resource<List<ConfigurationResponseModel>?> expectedResponse =
          TestDataFactory.createErrorResource<List<ConfigurationResponseModel>?>(
        message: "Failed to fetch configurations",
      );

      when(mockRepository.getConfigurations()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<ConfigurationResponseModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to fetch configurations"));

      verify(mockRepository.getConfigurations()).called(1);
    });

    test("execute caches successful response for subsequent calls", () async {
      // Arrange
      final List<ConfigurationResponseModel> configurations =
          TestDataFactory.createConfigurationResponseList();

      final Resource<List<ConfigurationResponseModel>?> expectedResponse =
          TestDataFactory.createSuccessResource<List<ConfigurationResponseModel>?>(
        data: configurations,
      );

      when(mockRepository.getConfigurations()).thenAnswer((_) async => expectedResponse);

      // Act - First call
      final Resource<List<ConfigurationResponseModel>?> result1 =
          await useCase.execute(NoParams());

      // Act - Second call
      final Resource<List<ConfigurationResponseModel>?> result2 =
          await useCase.execute(NoParams());

      // Assert
      expect(result1.resourceType, equals(ResourceType.success));
      expect(result2.resourceType, equals(ResourceType.success));
      expect(result1.data, equals(result2.data));

      // Repository should only be called once due to caching
      verify(mockRepository.getConfigurations()).called(1);
    });

    test("execute does not cache error response", () async {
      // Arrange
      final Resource<List<ConfigurationResponseModel>?> errorResponse =
          TestDataFactory.createErrorResource<List<ConfigurationResponseModel>?>(
        message: "Network error",
      );

      when(mockRepository.getConfigurations()).thenAnswer((_) async => errorResponse);

      // Act - First call
      final Resource<List<ConfigurationResponseModel>?> result1 =
          await useCase.execute(NoParams());

      // Act - Second call
      final Resource<List<ConfigurationResponseModel>?> result2 =
          await useCase.execute(NoParams());

      // Assert
      expect(result1.resourceType, equals(ResourceType.error));
      expect(result2.resourceType, equals(ResourceType.error));

      // Repository should be called twice since error is not cached
      verify(mockRepository.getConfigurations()).called(2);
    });

    test("execute does not cache loading response", () async {
      // Arrange
      final Resource<List<ConfigurationResponseModel>?> loadingResponse =
          TestDataFactory.createLoadingResource<List<ConfigurationResponseModel>?>();

      when(mockRepository.getConfigurations()).thenAnswer((_) async => loadingResponse);

      // Act - First call
      final Resource<List<ConfigurationResponseModel>?> result1 =
          await useCase.execute(NoParams());

      // Act - Second call
      final Resource<List<ConfigurationResponseModel>?> result2 =
          await useCase.execute(NoParams());

      // Assert
      expect(result1.resourceType, equals(ResourceType.loading));
      expect(result2.resourceType, equals(ResourceType.loading));

      // Repository should be called twice since loading is not cached
      verify(mockRepository.getConfigurations()).called(2);
    });

    test("execute works with null params", () async {
      // Arrange
      final Resource<List<ConfigurationResponseModel>?> expectedResponse =
          TestDataFactory.createSuccessResource<List<ConfigurationResponseModel>?>(
        data: TestDataFactory.createConfigurationResponseList(),
      );

      when(mockRepository.getConfigurations()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<ConfigurationResponseModel>?> result = await useCase.execute(null);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));

      verify(mockRepository.getConfigurations()).called(1);
    });

    test("execute handles empty configuration list", () async {
      // Arrange
      final Resource<List<ConfigurationResponseModel>?> expectedResponse =
          TestDataFactory.createSuccessResource<List<ConfigurationResponseModel>?>(
        data: <ConfigurationResponseModel>[],
      );

      when(mockRepository.getConfigurations()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<ConfigurationResponseModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.isEmpty, isTrue);

      verify(mockRepository.getConfigurations()).called(1);
    });

    test("execute verifies configuration data structure", () async {
      // Arrange
      final List<ConfigurationResponseModel> configurations = <ConfigurationResponseModel>[
        TestDataFactory.createConfigurationResponse(
          key: "feature_flag",
          value: "true",
        ),
        TestDataFactory.createConfigurationResponse(
          key: "api_version",
          value: "v2",
        ),
      ];

      final Resource<List<ConfigurationResponseModel>?> expectedResponse =
          TestDataFactory.createSuccessResource<List<ConfigurationResponseModel>?>(
        data: configurations,
      );

      when(mockRepository.getConfigurations()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<List<ConfigurationResponseModel>?> result =
          await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data?.length, equals(2));
      expect(result.data?[0].key, equals("feature_flag"));
      expect(result.data?[0].value, equals("true"));
      expect(result.data?[1].key, equals("api_version"));
      expect(result.data?[1].value, equals("v2"));

      verify(mockRepository.getConfigurations()).called(1);
    });
  });
}
