import "package:esim_open_source/data/remote/request/device/device_info_request_model_dto.dart";
import "package:esim_open_source/domain/data/params/register_device_params.dart";

class RegisterDeviceParamsDto {
  RegisterDeviceParamsDto({
    required this.fcmToken,
    required this.deviceId,
    required this.appGuid,
    required this.version,
    required this.userGuid,
    required this.deviceInfo,
  });

  factory RegisterDeviceParamsDto.fromDomain(RegisterDeviceParams params) {
    return RegisterDeviceParamsDto(
      fcmToken: params.fcmToken,
      deviceId: params.deviceId,
      appGuid: params.appGuid,
      version: params.version,
      userGuid: params.userGuid,
      deviceInfo: DeviceInfoRequestModelDto.fromDomain(params.deviceInfo),
    );
  }

  final String fcmToken;
  final String deviceId;
  final String appGuid;
  final String version;
  final String userGuid;
  final DeviceInfoRequestModelDto deviceInfo;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "deviceId": deviceId,
        "fcmToken": fcmToken,
        "platformTag": DeviceInfoRequestModelDto.platformTag,
        "osTag": DeviceInfoRequestModelDto.osTag,
        "appGuid": appGuid,
        "Version": version,
        "deviceInfo": deviceInfo.toJson(),
        if (userGuid.isNotEmpty) "userGuid": userGuid,
      };
}
