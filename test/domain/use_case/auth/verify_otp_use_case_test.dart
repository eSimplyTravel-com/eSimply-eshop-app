import "package:esim_open_source/domain/data/params/add_device_params.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/secure_storage_service.dart";
import "package:esim_open_source/domain/use_case/auth/verify_otp_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_data_factory.dart";
import "../../../helpers/test_environment_setup.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for VerifyOtpUseCase
/// Tests the OTP verification functionality
/// Note: This use case has side effects (saves user response, syncs language/currency, applies referral, adds device)
/// These are tested by verifying the repository method calls
Future<void> main() async {
  await TestEnvironmentSetup.initializeTestEnvironment();

  late VerifyOtpUseCase useCase;
  late MockApiAuthRepository mockRepository;
  late MockLocalStorageService mockLocalStorageService;
  late MockDeviceInfoService mockDeviceInfoService;
  late MockSecureStorageService mockSecureStorageService;
  late MockApiAppRepository mockAppRepository;

  setUp(() async {
    await setupTestLocator();
    mockRepository = locator<ApiAuthRepository>() as MockApiAuthRepository;
    mockLocalStorageService = locator<LocalStorageService>() as MockLocalStorageService;
    mockDeviceInfoService = locator<DeviceInfoService>() as MockDeviceInfoService;
    mockSecureStorageService = locator<SecureStorageService>() as MockSecureStorageService;
    mockAppRepository = locator<ApiAppRepository>() as MockApiAppRepository;
    useCase = VerifyOtpUseCase(mockRepository);

    // Mock LocalStorageService getString to return empty string by default
    when(mockLocalStorageService.getString(any)).thenReturn("");

    // Mock SecureStorageService getString to return empty string by default
    when(mockSecureStorageService.getString(any)).thenAnswer((_) async => "");

    // Mock DeviceInfoService addDeviceParams
    final AddDeviceParams mockDeviceParams = AddDeviceParams(
      fcmToken: "mock_fcm_token",
      manufacturer: "mock_manufacturer",
      deviceModel: "mock_device_model",
      deviceOs: "mock_os",
      deviceOsVersion: "mock_os_version",
      appVersion: "1.0.0",
      ramSize: "4GB",
      screenResolution: "1920x1080",
      isRooted: false,
    );
    when(mockDeviceInfoService.addDeviceParams).thenAnswer((_) async => mockDeviceParams);
    when(mockDeviceInfoService.deviceID).thenAnswer((_) async => "mock_device_id");

    // Mock ApiAppRepository addDevice to return success
    when(mockAppRepository.addDevice(any)).thenAnswer((_) async => TestDataFactory.createSuccessResource<EmptyResponse?>(data: EmptyResponse()));
  });

  tearDown(() async {
    await locator.reset();
  });

  group("VerifyOtpUseCase Tests", () {
    test("execute returns success resource when repository succeeds with email", () async {
      // Arrange
      final VerifyOtpParams params = VerifyOtpParams(
        email: "test@example.com",
        pinCode: "123456",
      );

      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "access_token",
        refreshToken: "refresh_token",
      );

      final Resource<AuthResponseModel> expectedResponse =
          TestDataFactory.createSuccessResource<AuthResponseModel>(
        data: authResponse,
        message: "OTP verified successfully",
      );

      when(mockRepository.verifyOtp(
        email: anyNamed("email"),
        phoneNumber: anyNamed("phoneNumber"),
        pinCode: anyNamed("pinCode"),
        providerType: anyNamed("providerType"),
        providerToken: anyNamed("providerToken"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);
      expect(result.data?.accessToken, equals("access_token"));

      verify(mockRepository.verifyOtp(
        email: "test@example.com",
        pinCode: "123456",
      ),).called(1);
    });

    test("execute returns success resource when repository succeeds with phone", () async {
      // Arrange
      final VerifyOtpParams params = VerifyOtpParams(
        phoneNumber: "+1234567890",
        pinCode: "654321",
      );

      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "access_token",
        refreshToken: "refresh_token",
      );

      final Resource<AuthResponseModel> expectedResponse =
          TestDataFactory.createSuccessResource<AuthResponseModel>(
        data: authResponse,
      );

      when(mockRepository.verifyOtp(
        email: anyNamed("email"),
        phoneNumber: anyNamed("phoneNumber"),
        pinCode: anyNamed("pinCode"),
        providerType: anyNamed("providerType"),
        providerToken: anyNamed("providerToken"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));

      verify(mockRepository.verifyOtp(
        phoneNumber: "+1234567890",
        pinCode: "654321",
      ),).called(1);
    });

    test("execute returns error resource when OTP is invalid", () async {
      // Arrange
      final VerifyOtpParams params = VerifyOtpParams(
        email: "test@example.com",
        pinCode: "000000",
      );

      final Resource<AuthResponseModel> expectedResponse =
          TestDataFactory.createErrorResource<AuthResponseModel>(
        message: "Invalid OTP",
        code: 400,
      );

      when(mockRepository.verifyOtp(
        email: anyNamed("email"),
        phoneNumber: anyNamed("phoneNumber"),
        pinCode: anyNamed("pinCode"),
        providerType: anyNamed("providerType"),
        providerToken: anyNamed("providerToken"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Invalid OTP"));
      expect(result.error?.errorCode, equals(400));
    });

    test("execute returns error resource when OTP is expired", () async {
      // Arrange
      final VerifyOtpParams params = VerifyOtpParams(
        email: "test@example.com",
        pinCode: "123456",
      );

      final Resource<AuthResponseModel> expectedResponse =
          TestDataFactory.createErrorResource<AuthResponseModel>(
        message: "OTP expired",
        code: 401,
      );

      when(mockRepository.verifyOtp(
        email: anyNamed("email"),
        phoneNumber: anyNamed("phoneNumber"),
        pinCode: anyNamed("pinCode"),
        providerType: anyNamed("providerType"),
        providerToken: anyNamed("providerToken"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("OTP expired"));
      expect(result.error?.errorCode, equals(401));
    });

    test("execute handles social media provider verification", () async {
      // Arrange
      final VerifyOtpParams params = VerifyOtpParams(
        email: "test@example.com",
        providerToken: "social_token_123",
        providerType: "google",
      );

      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "access_token",
        refreshToken: "refresh_token",
      );

      final Resource<AuthResponseModel> expectedResponse =
          TestDataFactory.createSuccessResource<AuthResponseModel>(
        data: authResponse,
      );

      when(mockRepository.verifyOtp(
        email: anyNamed("email"),
        phoneNumber: anyNamed("phoneNumber"),
        pinCode: anyNamed("pinCode"),
        providerType: anyNamed("providerType"),
        providerToken: anyNamed("providerToken"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));

      verify(mockRepository.verifyOtp(
        email: "test@example.com",
        providerType: "google",
        providerToken: "social_token_123",
      ),).called(1);
    });

    test("execute returns error for network error", () async {
      // Arrange
      final VerifyOtpParams params = VerifyOtpParams(
        email: "test@example.com",
        pinCode: "123456",
      );

      final Resource<AuthResponseModel> expectedResponse =
          TestDataFactory.createErrorResource<AuthResponseModel>(
        message: "Network error",
        code: 500,
      );

      when(mockRepository.verifyOtp(
        email: anyNamed("email"),
        phoneNumber: anyNamed("phoneNumber"),
        pinCode: anyNamed("pinCode"),
        providerType: anyNamed("providerType"),
        providerToken: anyNamed("providerToken"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.error?.errorCode, equals(500));
    });

    test("execute returns error for too many attempts", () async {
      // Arrange
      final VerifyOtpParams params = VerifyOtpParams(
        email: "test@example.com",
        pinCode: "123456",
      );

      final Resource<AuthResponseModel> expectedResponse =
          TestDataFactory.createErrorResource<AuthResponseModel>(
        message: "Too many verification attempts",
        code: 429,
      );

      when(mockRepository.verifyOtp(
        email: anyNamed("email"),
        phoneNumber: anyNamed("phoneNumber"),
        pinCode: anyNamed("pinCode"),
        providerType: anyNamed("providerType"),
        providerToken: anyNamed("providerToken"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.error?.errorCode, equals(429));
    });
  });
}
