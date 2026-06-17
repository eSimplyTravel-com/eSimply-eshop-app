import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/auth/logout_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_data_factory.dart";
import "../../../helpers/test_environment_setup.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for LogoutUseCase
/// Tests the logout functionality
Future<void> main() async {
  await TestEnvironmentSetup.initializeTestEnvironment();

  late LogoutUseCase useCase;
  late MockApiAuthRepository mockRepository;

  setUp(() async {
    await setupTestLocator();
    mockRepository = locator<ApiAuthRepository>() as MockApiAuthRepository;
    useCase = LogoutUseCase(mockRepository);
  });

  tearDown(() async {
    await locator.reset();
  });

  group("LogoutUseCase Tests", () {
    test("execute returns success resource when repository succeeds", () async {
      // Arrange
      final EmptyResponse emptyResponse = EmptyResponse();

      final Resource<EmptyResponse> expectedResponse =
          TestDataFactory.createSuccessResource<EmptyResponse>(
        data: emptyResponse,
        message: "Logged out successfully",
      );

      when(mockRepository.logout()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.message, equals("Logged out successfully"));

      verify(mockRepository.logout()).called(1);
    });

    test("execute returns error resource when repository fails", () async {
      // Arrange
      final Resource<EmptyResponse> expectedResponse =
          TestDataFactory.createErrorResource<EmptyResponse>(
        message: "Failed to logout",
      );

      when(mockRepository.logout()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to logout"));

      verify(mockRepository.logout()).called(1);
    });

    test("execute returns error resource for network error", () async {
      // Arrange
      final Resource<EmptyResponse> expectedResponse =
          TestDataFactory.createErrorResource<EmptyResponse>(
        message: "Network error",
        code: 500,
      );

      when(mockRepository.logout()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Network error"));
      expect(result.error?.errorCode, equals(500));

      verify(mockRepository.logout()).called(1);
    });

    test("execute returns error for 401 unauthorized", () async {
      // Arrange
      final Resource<EmptyResponse> expectedResponse =
          TestDataFactory.createErrorResource<EmptyResponse>(
        message: "Unauthorized",
        code: 401,
      );

      when(mockRepository.logout()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.error?.errorCode, equals(401));

      verify(mockRepository.logout()).called(1);
    });

    test("execute works with null params", () async {
      // Arrange
      final EmptyResponse emptyResponse = EmptyResponse();

      final Resource<EmptyResponse> expectedResponse =
          TestDataFactory.createSuccessResource<EmptyResponse>(
        data: emptyResponse,
      );

      when(mockRepository.logout()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));

      verify(mockRepository.logout()).called(1);
    });

    test("execute handles timeout error", () async {
      // Arrange
      final Resource<EmptyResponse> expectedResponse =
          TestDataFactory.createErrorResource<EmptyResponse>(
        message: "Request timeout",
        code: 408,
      );

      when(mockRepository.logout()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Request timeout"));
      expect(result.error?.errorCode, equals(408));
    });
  });
}
