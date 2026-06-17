import "package:esim_open_source/domain/data/params/add_device_params.dart";
import "package:esim_open_source/domain/data/response/device/device_info_response_model.dart";
import "package:esim_open_source/domain/repository/api_device_repository.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/domain/repository/services/secure_storage_service.dart";
import "package:esim_open_source/domain/use_case/device/register_device_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/test_environment_setup.dart";
import "../../../helpers/view_helper.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// Unit tests for RegisterDeviceUseCase
/// Tests device registration with FCM token
Future<void> main() async {
  await prepareTest();

  late RegisterDeviceUseCase useCase;
  late MockApiDeviceRepository mockRepository;
  late MockDeviceInfoService mockDeviceInfoService;
  late MockSecureStorageService mockSecureStorageService;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    mockRepository = locator<ApiDeviceRepository>() as MockApiDeviceRepository;
    mockDeviceInfoService = locator<DeviceInfoService>() as MockDeviceInfoService;
    mockSecureStorageService = locator<SecureStorageService>() as MockSecureStorageService;

    // Setup default mocks for device info
    when(mockDeviceInfoService.addDeviceParams).thenAnswer((_) async => AddDeviceParams(
      fcmToken: "test_fcm_token",
      manufacturer: "Test Manufacturer",
      deviceModel: "Test Model",
      deviceOs: "iOS",
      deviceOsVersion: "17.0",
      appVersion: "1.0.0",
      ramSize: "4GB",
      screenResolution: "1920x1080",
      isRooted: false,
    ),);

    when(mockSecureStorageService.getString(SecureStorageKeys.deviceID))
        .thenAnswer((_) async => "test_device_id_123");

    when(mockDeviceInfoService.deviceID).thenAnswer((_) async => "test_device_id_123");

    useCase = RegisterDeviceUseCase(mockRepository);
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("RegisterDeviceUseCase Tests", () {
    test("execute returns success when device registered", () async {
      // Arrange
      final RegisterDeviceUseCaseParams params = RegisterDeviceUseCaseParams(
        fcmToken: "test_fcm_token",
        userGuid: "user_guid_123",
      );

      final DeviceInfoResponseModel mockResponse = DeviceInfoResponseModel();

      final Resource<DeviceInfoResponseModel?> expectedResponse =
      Resource<DeviceInfoResponseModel?>.success(mockResponse, message: "Success");

      when(mockRepository.registerDevice(
        params: anyNamed("params"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<DeviceInfoResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.success));
      expect(result.data, isNotNull);

      verify(mockRepository.registerDevice(
        params: anyNamed("params"),
      ),).called(1);
    });

    test("execute returns error when registration fails", () async {
      // Arrange
      final RegisterDeviceUseCaseParams params = RegisterDeviceUseCaseParams(
        fcmToken: "test_fcm_token",
        userGuid: "user_guid_123",
      );

      final Resource<DeviceInfoResponseModel?> expectedResponse =
      Resource<DeviceInfoResponseModel?>.error("Registration failed");

      when(mockRepository.registerDevice(
        params: anyNamed("params"),
      ),).thenAnswer((_) async => expectedResponse);

      // Act
      final Resource<DeviceInfoResponseModel?> result =
          await useCase.execute(params);

      // Assert
      expect(result.resourceType, equals(ResourceType.error));
      expect(result.message, equals("Registration failed"));
    });

    test("execute handles different FCM tokens", () async {
      // Arrange
      final List<String> fcmTokens = <String>[
        "token_1",
        "token_2",
        "token_3",
      ];

      for (final String token in fcmTokens) {
        final RegisterDeviceUseCaseParams params = RegisterDeviceUseCaseParams(
          fcmToken: token,
          userGuid: "user_guid",
        );

        final DeviceInfoResponseModel mockResponse = DeviceInfoResponseModel();

        final Resource<DeviceInfoResponseModel?> expectedResponse =
        Resource<DeviceInfoResponseModel?>.success(mockResponse, message: null);

        when(mockRepository.registerDevice(
          params: anyNamed("params"),
        ),).thenAnswer((_) async => expectedResponse);

        // Act
        final Resource<DeviceInfoResponseModel?> result =
            await useCase.execute(params);

        // Assert
        expect(result.resourceType, equals(ResourceType.success));
      }
    });

    test("execute handles repository exception", () async {
      // Arrange
      final RegisterDeviceUseCaseParams params = RegisterDeviceUseCaseParams(
        fcmToken: "test_token",
        userGuid: "user_guid",
      );

      when(mockRepository.registerDevice(
        params: anyNamed("params"),
      ),).thenThrow(Exception("Network error"));

      // Act & Assert
      expect(
        () async => await useCase.execute(params),
        throwsException,
      );
    });
  });
}
