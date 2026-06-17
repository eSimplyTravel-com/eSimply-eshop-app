import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/auth/tmp_login_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_data_factory.dart";
import "../../../helpers/test_environment_setup.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for TmpLoginUseCase
/// Tests the temporary login functionality
Future<void> main() async {
  await TestEnvironmentSetup.initializeTestEnvironment();

  late TmpLoginUseCase useCase;
  late MockApiAuthRepository mockRepository;

  setUp(() async {
    await setupTestLocator();
    mockRepository = locator<ApiAuthRepository>() as MockApiAuthRepository;
    useCase = TmpLoginUseCase(mockRepository);
  });

  tearDown(() async {
    await locator.reset();
  });

  group("TmpLoginUseCase Tests", () {
    test("execute returns success resource when repository succeeds with email", () async {
      // Arrange
      final TmpLoginParams params = TmpLoginParams(
        email: "test@example.com",
        phone: null,
      );

      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "temp_access_token",
        refreshToken: "temp_refresh_token",
      );

      final Resource<AuthResponseModel?> expectedResponse =
          TestDataFactory.createSuccessResource<AuthResponseModel?>(
        data: authResponse,
        message: "Temporary login successful",
      );

      when(mockRepository.tmpLogin(
        email: anyNamed("email"),
        phone: anyNamed("phone"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.accessToken, equals("temp_access_token"));

      verify(mockRepository.tmpLogin(
        email: "test@example.com",
        phone: null,
      ),).called(1);
    });

    test("execute returns success resource when repository succeeds with phone", () async {
      // Arrange
      final TmpLoginParams params = TmpLoginParams(
        email: null,
        phone: "+1234567890",
      );

      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "temp_access_token",
        refreshToken: "temp_refresh_token",
      );

      final Resource<AuthResponseModel?> expectedResponse =
          TestDataFactory.createSuccessResource<AuthResponseModel?>(
        data: authResponse,
      );

      when(mockRepository.tmpLogin(
        email: anyNamed("email"),
        phone: anyNamed("phone"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);

      verify(mockRepository.tmpLogin(
        email: null,
        phone: "+1234567890",
      ),).called(1);
    });

    test("execute returns error resource when repository fails", () async {
      // Arrange
      final TmpLoginParams params = TmpLoginParams(
        email: "test@example.com",
        phone: null,
      );

      final Resource<AuthResponseModel?> expectedResponse =
          TestDataFactory.createErrorResource<AuthResponseModel?>(
        message: "Temporary login failed",
      );

      when(mockRepository.tmpLogin(
        email: anyNamed("email"),
        phone: anyNamed("phone"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Temporary login failed"));
    });

    test("execute returns error for unauthorized access", () async {
      // Arrange
      final TmpLoginParams params = TmpLoginParams(
        email: "test@example.com",
        phone: null,
      );

      final Resource<AuthResponseModel?> expectedResponse =
          TestDataFactory.createErrorResource<AuthResponseModel?>(
        message: "Unauthorized",
        code: 401,
      );

      when(mockRepository.tmpLogin(
        email: anyNamed("email"),
        phone: anyNamed("phone"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.error?.errorCode, equals(401));
    });

    test("execute handles both email and phone provided", () async {
      // Arrange
      final TmpLoginParams params = TmpLoginParams(
        email: "test@example.com",
        phone: "+1234567890",
      );

      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "temp_access_token",
        refreshToken: "temp_refresh_token",
      );

      final Resource<AuthResponseModel?> expectedResponse =
          TestDataFactory.createSuccessResource<AuthResponseModel?>(
        data: authResponse,
      );

      when(mockRepository.tmpLogin(
        email: anyNamed("email"),
        phone: anyNamed("phone"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));

      verify(mockRepository.tmpLogin(
        email: "test@example.com",
        phone: "+1234567890",
      ),).called(1);
    });

    test("execute returns error for network error", () async {
      // Arrange
      final TmpLoginParams params = TmpLoginParams(
        email: "test@example.com",
        phone: null,
      );

      final Resource<AuthResponseModel?> expectedResponse =
          TestDataFactory.createErrorResource<AuthResponseModel?>(
        message: "Network error",
        code: 500,
      );

      when(mockRepository.tmpLogin(
        email: anyNamed("email"),
        phone: anyNamed("phone"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.error?.errorCode, equals(500));
    });
  });
}
