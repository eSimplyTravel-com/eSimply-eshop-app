import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/auth/refresh_token_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_data_factory.dart";
import "../../../helpers/test_environment_setup.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for RefreshTokenUseCase
/// Tests the token refresh functionality
Future<void> main() async {
  await TestEnvironmentSetup.initializeTestEnvironment();

  late RefreshTokenUseCase useCase;
  late MockApiAuthRepository mockRepository;

  setUp(() async {
    await setupTestLocator();
    mockRepository = locator<ApiAuthRepository>() as MockApiAuthRepository;
    useCase = RefreshTokenUseCase(mockRepository);
  });

  tearDown(() async {
    await locator.reset();
  });

  group("RefreshTokenUseCase Tests", () {
    test("execute returns success resource when repository succeeds", () async {
      // Arrange
      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "new_access_token",
        refreshToken: "new_refresh_token",
      );

      final Resource<AuthResponseModel> expectedResponse =
          TestDataFactory.createSuccessResource<AuthResponseModel>(
        data: authResponse,
        message: "Token refreshed successfully",
      );

      when(mockRepository.refreshTokenAPITrigger()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.accessToken, equals("new_access_token"));
      expect(result.data?.refreshToken, equals("new_refresh_token"));

      verify(mockRepository.refreshTokenAPITrigger()).called(1);
    });

    test("execute returns error resource when repository fails", () async {
      // Arrange
      final Resource<AuthResponseModel> expectedResponse =
          TestDataFactory.createErrorResource<AuthResponseModel>(
        message: "Failed to refresh token",
      );

      when(mockRepository.refreshTokenAPITrigger()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to refresh token"));

      verify(mockRepository.refreshTokenAPITrigger()).called(1);
    });

    test("execute returns error for expired refresh token", () async {
      // Arrange
      final Resource<AuthResponseModel> expectedResponse =
          TestDataFactory.createErrorResource<AuthResponseModel>(
        message: "Refresh token expired",
        code: 401,
      );

      when(mockRepository.refreshTokenAPITrigger()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Refresh token expired"));
      expect(result.error?.errorCode, equals(401));
    });

    test("execute returns error for invalid refresh token", () async {
      // Arrange
      final Resource<AuthResponseModel> expectedResponse =
          TestDataFactory.createErrorResource<AuthResponseModel>(
        message: "Invalid refresh token",
        code: 403,
      );

      when(mockRepository.refreshTokenAPITrigger()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.error?.errorCode, equals(403));
    });

    test("execute returns error for network error", () async {
      // Arrange
      final Resource<AuthResponseModel> expectedResponse =
          TestDataFactory.createErrorResource<AuthResponseModel>(
        message: "Network error",
        code: 500,
      );

      when(mockRepository.refreshTokenAPITrigger()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Network error"));
      expect(result.error?.errorCode, equals(500));
    });

    test("execute works with null params", () async {
      // Arrange
      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "new_access_token",
        refreshToken: "new_refresh_token",
      );

      final Resource<AuthResponseModel> expectedResponse =
          TestDataFactory.createSuccessResource<AuthResponseModel>(
        data: authResponse,
      );

      when(mockRepository.refreshTokenAPITrigger()).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(NoParams());

      // Assert
      expect(result.resourceType, equals(ResourceType.success));

      verify(mockRepository.refreshTokenAPITrigger()).called(1);
    });
  });
}
