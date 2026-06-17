import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/user/verify_order_otp_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_environment_setup.dart";
import "../../../helpers/view_helper.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for VerifyOrderOtpUseCase
/// Tests OTP verification for order confirmation
Future<void> main() async {
  await prepareTest();

  late VerifyOrderOtpUseCase useCase;
  late MockApiUserRepository mockRepository;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    mockRepository = locator<ApiUserRepository>() as MockApiUserRepository;
    useCase = VerifyOrderOtpUseCase(mockRepository);
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("VerifyOrderOtpUseCase Tests", () {
    test("execute returns success when OTP is valid", () async {
      // Arrange
      const String testOtp = "123456";
      const String testIccid = "89012345678901234567";
      const String testOrderID = "ORDER123";

      final VerifyOrderOtpParam params = VerifyOrderOtpParam(
        otp: testOtp,
        iccid: testIccid,
        orderID: testOrderID,
      );

      final EmptyResponse mockResponse = EmptyResponse();
      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.success(mockResponse, message: "OTP verified successfully");

      when(mockRepository.verifyOrderOtp(
        otp: testOtp,
        iccid: testIccid,
        orderID: testOrderID,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.message, equals("OTP verified successfully"));

      verify(mockRepository.verifyOrderOtp(
        otp: testOtp,
        iccid: testIccid,
        orderID: testOrderID,
      ),).called(1);
    });

    test("execute returns error when OTP is invalid", () async {
      // Arrange
      const String invalidOtp = "000000";
      const String testIccid = "89012345678901234567";
      const String testOrderID = "ORDER123";

      final VerifyOrderOtpParam params = VerifyOrderOtpParam(
        otp: invalidOtp,
        iccid: testIccid,
        orderID: testOrderID,
      );

      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.error("Invalid OTP");

      when(mockRepository.verifyOrderOtp(
        otp: invalidOtp,
        iccid: testIccid,
        orderID: testOrderID,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Invalid OTP"));
      expect(result.data, isNull);

      verify(mockRepository.verifyOrderOtp(
        otp: invalidOtp,
        iccid: testIccid,
        orderID: testOrderID,
      ),).called(1);
    });

    test("execute handles OTP expired error", () async {
      // Arrange
      const String testOtp = "123456";
      const String testIccid = "89012345678901234567";
      const String testOrderID = "ORDER123";

      final VerifyOrderOtpParam params = VerifyOrderOtpParam(
        otp: testOtp,
        iccid: testIccid,
        orderID: testOrderID,
      );

      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.error("OTP has expired");

      when(mockRepository.verifyOrderOtp(
        otp: testOtp,
        iccid: testIccid,
        orderID: testOrderID,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("OTP has expired"));
    });

    test("execute handles different OTP formats", () async {
      // Arrange
      final List<String> otpCodes = <String>["123456", "000000", "999999"];
      const String testIccid = "89012345678901234567";
      const String testOrderID = "ORDER123";

      for (final String otp in otpCodes) {
        final VerifyOrderOtpParam params = VerifyOrderOtpParam(
          otp: otp,
          iccid: testIccid,
          orderID: testOrderID,
        );

        final EmptyResponse mockResponse = EmptyResponse();
        final Resource<EmptyResponse?> expectedResponse =
        Resource<EmptyResponse?>.success(mockResponse, message: null);

        when(mockRepository.verifyOrderOtp(
          otp: otp,
          iccid: testIccid,
          orderID: testOrderID,
        ),).thenAnswer((_) async => expectedResponse);

        // Act
        final Resource<EmptyResponse?> result = await useCase.execute(params);

        // Assert
        expect(result.resourceType, equals(ResourceType.success));
        verify(mockRepository.verifyOrderOtp(
          otp: otp,
          iccid: testIccid,
          orderID: testOrderID,
        ),).called(1);
      }
    });

    test("execute handles repository exception", () async {
      // Arrange
      const String testOtp = "123456";
      const String testIccid = "89012345678901234567";
      const String testOrderID = "ORDER123";

      final VerifyOrderOtpParam params = VerifyOrderOtpParam(
        otp: testOtp,
        iccid: testIccid,
        orderID: testOrderID,
      );

      when(mockRepository.verifyOrderOtp(
        otp: testOtp,
        iccid: testIccid,
        orderID: testOrderID,
      ),).thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(params),
        throwsException,
      );

      verify(mockRepository.verifyOrderOtp(
        otp: testOtp,
        iccid: testIccid,
        orderID: testOrderID,
      ),).called(1);
    });

    test("execute handles empty OTP", () async {
      // Arrange
      const String emptyOtp = "";
      const String testIccid = "89012345678901234567";
      const String testOrderID = "ORDER123";

      final VerifyOrderOtpParam params = VerifyOrderOtpParam(
        otp: emptyOtp,
        iccid: testIccid,
        orderID: testOrderID,
      );

      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.error("OTP cannot be empty");

      when(mockRepository.verifyOrderOtp(
        otp: emptyOtp,
        iccid: testIccid,
        orderID: testOrderID,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("OTP cannot be empty"));
    });

    test("execute handles too many attempts error", () async {
      // Arrange
      const String testOtp = "123456";
      const String testIccid = "89012345678901234567";
      const String testOrderID = "ORDER123";

      final VerifyOrderOtpParam params = VerifyOrderOtpParam(
        otp: testOtp,
        iccid: testIccid,
        orderID: testOrderID,
      );

      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.error("Too many failed attempts. Please request a new OTP");

      when(mockRepository.verifyOrderOtp(
        otp: testOtp,
        iccid: testIccid,
        orderID: testOrderID,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(
        result.message,
        equals("Too many failed attempts. Please request a new OTP"),
      );
    });

    test("execute returns null data on successful verification", () async {
      // Arrange
      const String testOtp = "123456";
      const String testIccid = "89012345678901234567";
      const String testOrderID = "ORDER123";

      final VerifyOrderOtpParam params = VerifyOrderOtpParam(
        otp: testOtp,
        iccid: testIccid,
        orderID: testOrderID,
      );

      final Resource<EmptyResponse?> expectedResponse =
      Resource<EmptyResponse?>.success(null, message: "Verified");

      when(mockRepository.verifyOrderOtp(
        otp: testOtp,
        iccid: testIccid,
        orderID: testOrderID,
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<EmptyResponse?> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNull);
    });
  });
}
