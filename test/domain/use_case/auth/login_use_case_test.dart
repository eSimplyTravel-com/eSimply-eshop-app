import "package:esim_open_source/domain/data/response/auth/otp_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/auth/login_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_data_factory.dart";
import "../../../helpers/test_environment_setup.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for LoginUseCase
/// Tests the login functionality with email and phone number
Future<void> main() async {
  await TestEnvironmentSetup.initializeTestEnvironment();

  late LoginUseCase useCase;
  late MockApiAuthRepository mockRepository;

  setUp(() async {
    await setupTestLocator();
    mockRepository = locator<ApiAuthRepository>() as MockApiAuthRepository;
    useCase = LoginUseCase(mockRepository);
  });

  tearDown(() async {
    await locator.reset();
  });

  group("LoginUseCase Tests", () {
    test("execute returns success resource when repository succeeds with email", () async {
      // Arrange
      final LoginParams params = LoginParams(
        email: "test@example.com",
        phoneNumber: null,
      );

      final OtpResponseModel otpResponse = OtpResponseModel(
        otpExpiration: 300,
      );

      final Resource<OtpResponseModel?> expectedResponse =
          TestDataFactory.createSuccessResource<OtpResponseModel?>(
        data: otpResponse,
        message: "Success",
      );

      when(mockRepository.login(
        email: anyNamed("email"),
        phoneNumber: anyNamed("phoneNumber"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<OtpResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.otpExpiration, equals(300));

      verify(mockRepository.login(
        email: "test@example.com",
        phoneNumber: null,
      ),).called(1);
    });

    test("execute returns success resource when repository succeeds with phone number", () async {
      // Arrange
      final LoginParams params = LoginParams(
        email: null,
        phoneNumber: "+1234567890",
      );

      final OtpResponseModel otpResponse = OtpResponseModel(
        otpExpiration: 300,
      );

      final Resource<OtpResponseModel?> expectedResponse =
          TestDataFactory.createSuccessResource<OtpResponseModel?>(
        data: otpResponse,
        message: "Success",
      );

      when(mockRepository.login(
        email: anyNamed("email"),
        phoneNumber: anyNamed("phoneNumber"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<OtpResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.otpExpiration, equals(300));

      verify(mockRepository.login(
        email: null,
        phoneNumber: "+1234567890",
      ),).called(1);
    });

    test("execute returns error resource when repository fails", () async {
      // Arrange
      final LoginParams params = LoginParams(
        email: "test@example.com",
        phoneNumber: null,
      );

      final Resource<OtpResponseModel?> expectedResponse =
          TestDataFactory.createErrorResource<OtpResponseModel?>(
        message: "Failed to send OTP",
      );

      when(mockRepository.login(
        email: anyNamed("email"),
        phoneNumber: anyNamed("phoneNumber"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<OtpResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to send OTP"));

      verify(mockRepository.login(
        email: "test@example.com",
        phoneNumber: null,
      ),).called(1);
    });

    test("execute returns error resource when email is invalid", () async {
      // Arrange
      final LoginParams params = LoginParams(
        email: "invalid-email",
        phoneNumber: null,
      );

      final Resource<OtpResponseModel?> expectedResponse =
          TestDataFactory.createErrorResource<OtpResponseModel?>(
        message: "Invalid email format",
        code: 400,
      );

      when(mockRepository.login(
        email: anyNamed("email"),
        phoneNumber: anyNamed("phoneNumber"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<OtpResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Invalid email format"));
      expect(result.error?.errorCode, equals(400));
    });

    test("execute returns error resource for network error", () async {
      // Arrange
      final LoginParams params = LoginParams(
        email: "test@example.com",
        phoneNumber: null,
      );

      final Resource<OtpResponseModel?> expectedResponse =
          TestDataFactory.createErrorResource<OtpResponseModel?>(
        message: "Network error",
        code: 500,
      );

      when(mockRepository.login(
        email: anyNamed("email"),
        phoneNumber: anyNamed("phoneNumber"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<OtpResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Network error"));
      expect(result.error?.errorCode, equals(500));
    });

    test("execute handles both email and phone number provided", () async {
      // Arrange
      final LoginParams params = LoginParams(
        email: "test@example.com",
        phoneNumber: "+1234567890",
      );

      final OtpResponseModel otpResponse = OtpResponseModel(
        otpExpiration: 300,
      );

      final Resource<OtpResponseModel?> expectedResponse =
          TestDataFactory.createSuccessResource<OtpResponseModel?>(
        data: otpResponse,
      );

      when(mockRepository.login(
        email: anyNamed("email"),
        phoneNumber: anyNamed("phoneNumber"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<OtpResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));

      verify(mockRepository.login(
        email: "test@example.com",
        phoneNumber: "+1234567890",
      ),).called(1);
    });

    test("execute returns error for 401 unauthorized", () async {
      // Arrange
      final LoginParams params = LoginParams(
        email: "test@example.com",
        phoneNumber: null,
      );

      final Resource<OtpResponseModel?> expectedResponse =
          TestDataFactory.createErrorResource<OtpResponseModel?>(
        message: "Unauthorized",
        code: 401,
      );

      when(mockRepository.login(
        email: anyNamed("email"),
        phoneNumber: anyNamed("phoneNumber"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<OtpResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.error?.errorCode, equals(401));
    });

    test("execute returns error for 404 not found", () async {
      // Arrange
      final LoginParams params = LoginParams(
        email: "nonexistent@example.com",
        phoneNumber: null,
      );

      final Resource<OtpResponseModel?> expectedResponse =
          TestDataFactory.createErrorResource<OtpResponseModel?>(
        message: "User not found",
        code: 404,
      );

      when(mockRepository.login(
        email: anyNamed("email"),
        phoneNumber: anyNamed("phoneNumber"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<OtpResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("User not found"));
      expect(result.error?.errorCode, equals(404));
    });
  });
}
