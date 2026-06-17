import "package:esim_open_source/domain/data/response/auth/otp_response_model.dart";
import "package:esim_open_source/domain/data/response/auth/resend_otp_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/auth/resend_otp_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_data_factory.dart";
import "../../../helpers/test_environment_setup.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for ResendOtpUseCase
/// Tests the resend OTP functionality with email and phone number
Future<void> main() async {
  await TestEnvironmentSetup.initializeTestEnvironment();

  late ResendOtpUseCase useCase;
  late MockApiAuthRepository mockRepository;

  setUp(() async {
    await setupTestLocator();
    mockRepository = locator<ApiAuthRepository>() as MockApiAuthRepository;
    useCase = ResendOtpUseCase(mockRepository);
  });

  tearDown(() async {
    await locator.reset();
  });

  group("ResendOtpUseCase Tests", () {
    test("execute returns success resource when repository succeeds with email", () async {
      // Arrange
      final ResendOtpParams params = ResendOtpParams(
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
      final ResendOtpParams params = ResendOtpParams(
        email: null,
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
      expect(result.data, isNotNull);

      verify(mockRepository.login(
        email: null,
        phoneNumber: "+1234567890",
      ),).called(1);
    });

    test("execute returns error resource when repository fails", () async {
      // Arrange
      final ResendOtpParams params = ResendOtpParams(
        email: "test@example.com",
        phoneNumber: null,
      );

      final Resource<OtpResponseModel?> expectedResponse =
          TestDataFactory.createErrorResource<OtpResponseModel?>(
        message: "Failed to resend OTP",
      );

      when(mockRepository.login(
        email: anyNamed("email"),
        phoneNumber: anyNamed("phoneNumber"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<OtpResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to resend OTP"));

      verify(mockRepository.login(
        email: "test@example.com",
        phoneNumber: null,
      ),).called(1);
    });

    test("execute returns error resource for rate limit exceeded", () async {
      // Arrange
      final ResendOtpParams params = ResendOtpParams(
        email: "test@example.com",
        phoneNumber: null,
      );

      final Resource<OtpResponseModel?> expectedResponse =
          TestDataFactory.createErrorResource<OtpResponseModel?>(
        message: "Too many requests. Please try again later",
        code: 429,
      );

      when(mockRepository.login(
        email: anyNamed("email"),
        phoneNumber: anyNamed("phoneNumber"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<OtpResponseModel?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Too many requests. Please try again later"));
      expect(result.error?.errorCode, equals(429));
    });

    test("execute returns error resource for network error", () async {
      // Arrange
      final ResendOtpParams params = ResendOtpParams(
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
      final ResendOtpParams params = ResendOtpParams(
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
  });

  group("ResendOtpNewChannelUseCase Tests", () {
    late ResendOtpNewChannelUseCase newChannelUseCase;

    setUp(() {
      newChannelUseCase = ResendOtpNewChannelUseCase(mockRepository);
    });

    test("execute returns success resource when repository succeeds", () async {
      // Arrange
      final ResendOtpNewChannelParams params = ResendOtpNewChannelParams(
        email: "test@example.com",
        phoneNumber: null,
        otpChannel: "SMS",
      );

      final ResendOtpResponseModel response = ResendOtpResponseModel(
        status: "success",
        message: "OTP sent via SMS",
      );

      final Resource<ResendOtpResponseModel?> expectedResponse =
          TestDataFactory.createSuccessResource<ResendOtpResponseModel?>(
        data: response,
        message: "OTP sent via SMS",
      );

      when(mockRepository.resendOtpNewChannel(
        email: anyNamed("email"),
        phone: anyNamed("phone"),
        otpChannel: anyNamed("otpChannel"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<ResendOtpResponseModel?> result =
          await newChannelUseCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data?.status, equals("success"));
      expect(result.data?.message, equals("OTP sent via SMS"));

      // execute maps params.phoneNumber -> phone
      verify(mockRepository.resendOtpNewChannel(
        email: "test@example.com",
        phone: null,
        otpChannel: "SMS",
      ),).called(1);
    });

    test(
        "execute returns success resource with null data when repository returns null data",
        () async {
      // Arrange
      final ResendOtpNewChannelParams params = ResendOtpNewChannelParams(
        email: "test@example.com",
        phoneNumber: null,
        otpChannel: "EMAIL",
      );

      final Resource<ResendOtpResponseModel?> expectedResponse =
          TestDataFactory.createSuccessResource<ResendOtpResponseModel?>(
        data: null,
        message: "OTP sent",
      );

      when(mockRepository.resendOtpNewChannel(
        email: anyNamed("email"),
        phone: anyNamed("phone"),
        otpChannel: anyNamed("otpChannel"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<ResendOtpResponseModel?> result =
          await newChannelUseCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNull);
    });

    test("execute returns error resource when repository fails", () async {
      // Arrange
      final ResendOtpNewChannelParams params = ResendOtpNewChannelParams(
        email: "test@example.com",
        phoneNumber: null,
        otpChannel: "SMS",
      );

      final Resource<ResendOtpResponseModel?> expectedResponse =
          TestDataFactory.createErrorResource<ResendOtpResponseModel?>(
        message: "Too many requests. Please try again later",
        code: 429,
      );

      when(mockRepository.resendOtpNewChannel(
        email: anyNamed("email"),
        phone: anyNamed("phone"),
        otpChannel: anyNamed("otpChannel"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<ResendOtpResponseModel?> result =
          await newChannelUseCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(
        result.message,
        equals("Too many requests. Please try again later"),
      );
      expect(result.error?.errorCode, equals(429));
    });
  });
}
