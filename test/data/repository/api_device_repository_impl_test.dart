// api_device_repository_impl_test.dart

import "dart:async";

import "package:esim_open_source/data/remote/responses/base_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/device/device_info_response_model_dto.dart";
import "package:esim_open_source/data/repository/api_device_repository_impl.dart";
import "package:esim_open_source/domain/data/params/register_device_params.dart";
import "package:esim_open_source/domain/data/request/device_info_request_model.dart";
import "package:esim_open_source/domain/data/response/device/device_info_response_model.dart";
import "package:esim_open_source/domain/repository/api_device_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../locator_test.mocks.dart";

void main() {
  late ApiDeviceRepository repository;
  late MockAPIDevice mockApiDevice;

  setUp(() {
    mockApiDevice = MockAPIDevice();
    repository = ApiDeviceRepositoryImpl(mockApiDevice);
  });

  group("ApiDeviceRepositoryImpl", () {
    const String testFcmToken = "test-fcm-token-123";
    const String testDeviceId = "test-device-id-456";
    const String testAppGuid = "test-app-guid-789";
    const String testVersion = "1.0.0";
    const String testUserGuid = "test-user-guid-101";

    late DeviceInfoRequestModel testDeviceInfo;
    late RegisterDeviceParams testParams;

    setUp(() {
      testDeviceInfo = DeviceInfoRequestModel(
        deviceName: "Test Device",
        latitude: 12.34,
        longitude: 56.78,
        mcc: "404",
        mnc: "10",
      );

      testParams = RegisterDeviceParams(
        fcmToken: testFcmToken,
        deviceId: testDeviceId,
        appGuid: testAppGuid,
        version: testVersion,
        userGuid: testUserGuid,
        deviceInfo: testDeviceInfo,
      );
    });

    group("registerDevice", () {
      test("should return success resource when API call succeeds", () async {
        // Arrange
        final DeviceInfoResponseModelDto expectedResponse =
            DeviceInfoResponseModelDto();
        final ResponseMainDto<DeviceInfoResponseModelDto?> responseMain =
            ResponseMainDto<DeviceInfoResponseModelDto?>.createErrorWithData(
          data: expectedResponse,
          message: "Device registered successfully",
          statusCode: 200,
        );

        when(
          mockApiDevice.registerDevice(
            params: anyNamed("params"),
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<DeviceInfoResponseModel?> result =
            await repository.registerDevice(
          params: testParams,
        ) as Resource<DeviceInfoResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isNotNull);
        expect(result.message, "Device registered successfully");
        expect(result.error, isNull);

        verify(
          mockApiDevice.registerDevice(
            params: anyNamed("params"),
          ),
        ).called(1);
      });

      test("should return error resource when API call returns non-200 status",
          () async {
        // Arrange
        final ResponseMainDto<DeviceInfoResponseModelDto?> responseMain =
            ResponseMainDto<DeviceInfoResponseModelDto?>.createErrorWithData(
          statusCode: 400,
          developerMessage: "Invalid device information provided",
          title: "Invalid device information provided",
        );

        when(
          mockApiDevice.registerDevice(
            params: anyNamed("params"),
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<DeviceInfoResponseModel?> result =
            await repository.registerDevice(
          params: testParams,
        ) as Resource<DeviceInfoResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Invalid device information provided");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(
          mockApiDevice.registerDevice(
            params: anyNamed("params"),
          ),
        ).called(1);
      });

      test("should return error resource when API returns 500 status",
          () async {
        // Arrange
        final ResponseMainDto<DeviceInfoResponseModelDto?> responseMain =
            ResponseMainDto<DeviceInfoResponseModelDto?>.createErrorWithData(
          statusCode: 500,
          developerMessage: "Internal server error",
          title: "Internal server error",
        );

        when(
          mockApiDevice.registerDevice(
            params: anyNamed("params"),
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<DeviceInfoResponseModel?> result =
            await repository.registerDevice(
          params: testParams,
        ) as Resource<DeviceInfoResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Internal server error");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(
          mockApiDevice.registerDevice(
            params: anyNamed("params"),
          ),
        ).called(1);
      });

      test("should return error resource when API returns 401 status",
          () async {
        // Arrange
        final ResponseMainDto<DeviceInfoResponseModelDto?> responseMain =
            ResponseMainDto<DeviceInfoResponseModelDto?>.createErrorWithData(
          statusCode: 401,
          developerMessage: "Unauthorized access",
          title: "Unauthorized access",
        );

        when(
          mockApiDevice.registerDevice(
            params: anyNamed("params"),
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<DeviceInfoResponseModel?> result =
            await repository.registerDevice(
          params: testParams,
        ) as Resource<DeviceInfoResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Unauthorized access");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(
          mockApiDevice.registerDevice(
            params: anyNamed("params"),
          ),
        ).called(1);
      });

      test("should pass all parameters correctly to API device", () async {
        // Arrange
        const String customFcmToken = "custom-token";
        const String customDeviceId = "custom-device-id";
        const String customAppGuid = "custom-app-guid";
        const String customVersion = "2.1.0";
        const String customUserGuid = "custom-user-guid";

        final DeviceInfoRequestModel customDeviceInfo = DeviceInfoRequestModel(
          deviceName: "iPhone 15",
          latitude: 25.20,
          longitude: 55.27,
          mcc: "424",
          mnc: "02",
        );

        final RegisterDeviceParams customParams = RegisterDeviceParams(
          fcmToken: customFcmToken,
          deviceId: customDeviceId,
          appGuid: customAppGuid,
          version: customVersion,
          userGuid: customUserGuid,
          deviceInfo: customDeviceInfo,
        );

        final DeviceInfoResponseModelDto expectedResponse =
            DeviceInfoResponseModelDto();
        final ResponseMainDto<DeviceInfoResponseModelDto?> responseMain =
            ResponseMainDto<DeviceInfoResponseModelDto?>.createErrorWithData(
          data: expectedResponse,
          message: "Success",
          statusCode: 200,
        );

        when(
          mockApiDevice.registerDevice(
            params: customParams,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        await repository.registerDevice(
          params: customParams,
        );

        // Assert
        verify(
          mockApiDevice.registerDevice(
            params: customParams,
          ),
        ).called(1);
      });
    });

    group("Edge cases and boundary conditions", () {
      test("should handle null response data gracefully", () async {
        // Arrange
        final ResponseMainDto<DeviceInfoResponseModelDto?> responseMain =
            ResponseMainDto<DeviceInfoResponseModelDto?>.createErrorWithData(
          message: "Success but no data",
          statusCode: 200,
        );

        when(
          mockApiDevice.registerDevice(
            params: anyNamed("params"),
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<DeviceInfoResponseModel?> result =
            await repository.registerDevice(
          params: testParams,
        ) as Resource<DeviceInfoResponseModel?>;

        // Assert - a 200 with null data is a valid success(null), not an error:
        // the mapper is skipped and the nullable domain type carries the null.
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isNull);
      });

      test("should handle empty string parameters", () async {
        // Arrange
        const String emptyString = "";
        final DeviceInfoRequestModel emptyDeviceInfo = DeviceInfoRequestModel(
          deviceName: emptyString,
          mcc: emptyString,
          mnc: emptyString,
        );

        final RegisterDeviceParams emptyParams = RegisterDeviceParams(
          fcmToken: emptyString,
          deviceId: emptyString,
          appGuid: emptyString,
          version: emptyString,
          userGuid: emptyString,
          deviceInfo: emptyDeviceInfo,
        );

        final DeviceInfoResponseModelDto expectedResponse =
            DeviceInfoResponseModelDto();
        final ResponseMainDto<DeviceInfoResponseModelDto?> responseMain =
            ResponseMainDto<DeviceInfoResponseModelDto?>.createErrorWithData(
          data: expectedResponse,
          message: "Success",
          statusCode: 200,
        );

        when(
          mockApiDevice.registerDevice(
            params: emptyParams,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<DeviceInfoResponseModel?> result =
            await repository.registerDevice(
          params: emptyParams,
        ) as Resource<DeviceInfoResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isNotNull);

        verify(
          mockApiDevice.registerDevice(
            params: emptyParams,
          ),
        ).called(1);
      });
    });

    group("Repository contract compliance", () {
      test("should implement ApiDeviceRepository interface", () {
        expect(repository, isA<ApiDeviceRepository>());
      });

      test("should return FutureOr<dynamic> as specified in interface", () {
        // Arrange
        final ResponseMainDto<DeviceInfoResponseModelDto?> responseMain =
            ResponseMainDto<DeviceInfoResponseModelDto?>.createErrorWithData(
          data: DeviceInfoResponseModelDto(),
          message: "Success",
          statusCode: 200,
        );

        when(
          mockApiDevice.registerDevice(
            params: anyNamed("params"),
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final FutureOr<dynamic> result = repository.registerDevice(
          params: testParams,
        );

        // Assert
        expect(result, isA<FutureOr<dynamic>>());
        expect(result, isA<Future<Resource<DeviceInfoResponseModel?>>>());
      });
    });
  });
}
