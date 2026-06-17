import "package:esim_open_source/domain/data/params/add_device_params.dart";
import "package:esim_open_source/domain/data/params/update_user_info_params.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/secure_storage_service.dart";
import "package:esim_open_source/domain/use_case/auth/social_media_verify_login_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_data_factory.dart";
import "../../../helpers/test_environment_setup.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for SocialMediaVerifyLoginUseCase
/// Tests the social media login verification functionality
/// Note: This use case has side effects (saves user response, syncs language/currency, applies referral, adds device)
Future<void> main() async {
  await TestEnvironmentSetup.initializeTestEnvironment();

  late SocialMediaVerifyLoginUseCase useCase;
  late MockApiAuthRepository mockRepository;
  late MockLocalStorageService mockLocalStorageService;
  late MockDeviceInfoService mockDeviceInfoService;
  late MockSecureStorageService mockSecureStorageService;
  late MockApiAppRepository mockAppRepository;

  setUp(() async {
    await setupTestLocator();
    mockRepository = locator<ApiAuthRepository>() as MockApiAuthRepository;
    mockLocalStorageService =
    locator<LocalStorageService>() as MockLocalStorageService;
    mockDeviceInfoService =
    locator<DeviceInfoService>() as MockDeviceInfoService;
    mockSecureStorageService =
    locator<SecureStorageService>() as MockSecureStorageService;
    mockAppRepository = locator<ApiAppRepository>() as MockApiAppRepository;
    useCase = SocialMediaVerifyLoginUseCase(mockRepository);

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
    when(mockDeviceInfoService.addDeviceParams).thenAnswer((
        _,) async => mockDeviceParams,);
    when(mockDeviceInfoService.deviceID).thenAnswer((
        _,) async => "mock_device_id",);

    // Mock ApiAppRepository addDevice to return success
    when(mockAppRepository.addDevice(any)).thenAnswer((_) async =>
        TestDataFactory.createSuccessResource<EmptyResponse?>(
            data: EmptyResponse(),),);
  });

  tearDown(() async {
    await locator.reset();
  });

  group("SocialMediaVerifyLoginUseCase Tests", () {
    test("execute returns success resource when repository succeeds", () async {
      // Arrange
      final SocialMediaVerifyLoginParams params = SocialMediaVerifyLoginParams(
        accessToken: "social_access_token",
        refreshToken: "social_refresh_token",
      );

      final AuthResponseModel authResponse = AuthResponseModel(
        accessToken: "social_access_token",
        refreshToken: "social_refresh_token",
      );

      final Resource<AuthResponseModel> expectedResponse =
      TestDataFactory.createSuccessResource<AuthResponseModel>(
        data: authResponse,
        message: "Social login verified successfully",
      );

      when(mockRepository.updateUserInfo(
        request: argThat(isA<UpdateUserInfoRequest>(), named: "request"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);

      verify(mockRepository.updateUserInfo(request: argThat(isA<UpdateUserInfoRequest>(), named: "request")))
          .called(1);
    });

    test("execute returns error resource when repository fails", () async {
      // Arrange
      final SocialMediaVerifyLoginParams params = SocialMediaVerifyLoginParams(
        accessToken: "invalid_token",
        refreshToken: "invalid_refresh_token",
      );

      final Resource<AuthResponseModel> expectedResponse =
      TestDataFactory.createErrorResource<AuthResponseModel>(
        message: "Failed to verify social login",
      );

      when(mockRepository.updateUserInfo(
        request: argThat(isA<UpdateUserInfoRequest>(), named: "request"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Failed to verify social login"));

      verify(mockRepository.updateUserInfo(request: argThat(isA<UpdateUserInfoRequest>(), named: "request")))
          .called(1);
    });

    test("execute returns error for invalid social token", () async {
      // Arrange
      final SocialMediaVerifyLoginParams params = SocialMediaVerifyLoginParams(
        accessToken: "invalid_token",
        refreshToken: "refresh_token",
      );

      final Resource<AuthResponseModel> expectedResponse =
      TestDataFactory.createErrorResource<AuthResponseModel>(
        message: "Invalid social media token",
        code: 401,
      );

      when(mockRepository.updateUserInfo(
        request: argThat(isA<UpdateUserInfoRequest>(), named: "request"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Invalid social media token"));
      expect(result.error?.errorCode, equals(401));
    });

    test("execute returns error for expired social token", () async {
      // Arrange
      final SocialMediaVerifyLoginParams params = SocialMediaVerifyLoginParams(
        accessToken: "expired_token",
        refreshToken: "refresh_token",
      );

      final Resource<AuthResponseModel> expectedResponse =
      TestDataFactory.createErrorResource<AuthResponseModel>(
        message: "Social media token expired",
        code: 403,
      );

      when(mockRepository.updateUserInfo(
        request: argThat(isA<UpdateUserInfoRequest>(), named: "request"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<AuthResponseModel> result = await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.error?.errorCode, equals(403));
    });

    test("execute handles network error", () async {
      // Arrange
      final SocialMediaVerifyLoginParams params = SocialMediaVerifyLoginParams(
        accessToken: "access_token",
        refreshToken: "refresh_token",
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
      expect(result.message, equals("Network error"));
      expect(result.error?.errorCode, equals(500));
    });

    test("execute handles empty tokens", () async {
      // Arrange
      final SocialMediaVerifyLoginParams params = SocialMediaVerifyLoginParams(
        accessToken: "",
        refreshToken: "",
      );

      final Resource<AuthResponseModel> expectedResponse =
      TestDataFactory.createErrorResource<AuthResponseModel>(
        message: "Empty access token",
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
  });
}
