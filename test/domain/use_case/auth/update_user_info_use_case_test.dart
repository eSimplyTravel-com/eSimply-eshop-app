import "package:esim_open_source/domain/data/params/update_user_info_params.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/use_case/auth/update_user_info_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_data_factory.dart";
import "../../../helpers/test_environment_setup.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for UpdateUserInfoUseCase
/// Tests the user information update functionality
/// Note: This use case updates user authentication service after successful update
Future<void> main() async {
  await TestEnvironmentSetup.initializeTestEnvironment();

  late UpdateUserInfoUseCase useCase;
  late MockApiAuthRepository mockRepository;
  late MockAppConfigurationService mockAppConfigurationService;

  setUp(() async {
    await setupTestLocator();
    mockRepository = locator<ApiAuthRepository>() as MockApiAuthRepository;
    mockAppConfigurationService = locator<AppConfigurationService>() as MockAppConfigurationService;
    useCase = UpdateUserInfoUseCase(mockRepository);

    // Mock getLoginType to return a default login type
    when(mockAppConfigurationService.getLoginType).thenReturn(null);
  });

  tearDown(() async {
    await locator.reset();
  });

  group("UpdateUserInfoUseCase Tests", () {
    test("execute returns success resource when updating all fields", () async {
      // Arrange
      final UpdateUserInfoParams params = UpdateUserInfoParams(
        email: "updated@example.com",
        msisdn: "+9876543210",
        firstName: "John",
        lastName: "Doe",
        currencyCode: "USD",
        languageCode: "en",
      );

      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "access_token",
        refreshToken: "refresh_token",
      );

      final Resource<AuthResponseModel> expectedResponse =
          TestDataFactory.createSuccessResource<AuthResponseModel>(
        data: authResponse,
        message: "User info updated successfully",
      );

      when(mockRepository.updateUserInfo(
        request: argThat(isA<UpdateUserInfoRequest>(), named: "request"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);

      verify(mockRepository.updateUserInfo(
        request: argThat(isA<UpdateUserInfoRequest>(), named: "request"),
      ),).called(1);
    });

    test("execute returns success resource when updating partial fields", () async {
      // Arrange
      final UpdateUserInfoParams params = UpdateUserInfoParams(
        firstName: "Jane",
        lastName: "Smith",
      );

      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "access_token",
        refreshToken: "refresh_token",
      );

      final Resource<AuthResponseModel> expectedResponse =
          TestDataFactory.createSuccessResource<AuthResponseModel>(
        data: authResponse,
      );

      when(mockRepository.updateUserInfo(
        request: argThat(isA<UpdateUserInfoRequest>(), named: "request"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));

      verify(mockRepository.updateUserInfo(
        request: argThat(isA<UpdateUserInfoRequest>(), named: "request"),
      ),).called(1);
    });

    test("execute returns error resource when repository fails", () async {
      // Arrange
      final UpdateUserInfoParams params = UpdateUserInfoParams(
        firstName: "John",
        lastName: "Doe",
      );

      final Resource<AuthResponseModel> expectedResponse =
          TestDataFactory.createErrorResource<AuthResponseModel>(
        message: "Failed to update user info",
      );

      when(mockRepository.updateUserInfo(
        request: argThat(isA<UpdateUserInfoRequest>(), named: "request"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to update user info"));
    });

    test("execute returns error for invalid email format", () async {
      // Arrange
      final UpdateUserInfoParams params = UpdateUserInfoParams(
        email: "invalid-email",
      );

      final Resource<AuthResponseModel> expectedResponse =
          TestDataFactory.createErrorResource<AuthResponseModel>(
        message: "Invalid email format",
        code: 400,
      );

      when(mockRepository.updateUserInfo(
        request: argThat(isA<UpdateUserInfoRequest>(), named: "request"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.error?.errorCode, equals(400));
    });

    test("execute handles newsletter subscription toggle", () async {
      // Arrange
      final UpdateUserInfoParams params = UpdateUserInfoParams(
      );

      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "access_token",
        refreshToken: "refresh_token",
      );

      final Resource<AuthResponseModel> expectedResponse =
          TestDataFactory.createSuccessResource<AuthResponseModel>(
        data: authResponse,
      );

      when(mockRepository.updateUserInfo(
        request: argThat(isA<UpdateUserInfoRequest>(), named: "request"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));

      verify(mockRepository.updateUserInfo(
        request: argThat(isA<UpdateUserInfoRequest>(), named: "request"),
      ),).called(1);
    });

    test("execute handles language and currency update", () async {
      // Arrange
      final UpdateUserInfoParams params = UpdateUserInfoParams(
        languageCode: "es",
        currencyCode: "EUR",
      );

      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "access_token",
        refreshToken: "refresh_token",
      );

      final Resource<AuthResponseModel> expectedResponse =
          TestDataFactory.createSuccessResource<AuthResponseModel>(
        data: authResponse,
      );

      when(mockRepository.updateUserInfo(
        request: argThat(isA<UpdateUserInfoRequest>(), named: "request"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));

      verify(mockRepository.updateUserInfo(
        request: argThat(isA<UpdateUserInfoRequest>(), named: "request"),
      ),).called(1);
    });

    test("execute returns error for unauthorized access", () async {
      // Arrange
      final UpdateUserInfoParams params = UpdateUserInfoParams(
        firstName: "John",
      );

      final Resource<AuthResponseModel> expectedResponse =
          TestDataFactory.createErrorResource<AuthResponseModel>(
        message: "Unauthorized",
        code: 401,
      );

      when(mockRepository.updateUserInfo(
        request: argThat(isA<UpdateUserInfoRequest>(), named: "request"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.error?.errorCode, equals(401));
    });

    test("execute returns error for network error", () async {
      // Arrange
      final UpdateUserInfoParams params = UpdateUserInfoParams(
        firstName: "John",
      );

      final Resource<AuthResponseModel> expectedResponse =
          TestDataFactory.createErrorResource<AuthResponseModel>(
        message: "Network error",
        code: 500,
      );

      when(mockRepository.updateUserInfo(
        request: argThat(isA<UpdateUserInfoRequest>(), named: "request"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.error?.errorCode, equals(500));
    });
  });
}
