import "package:esim_open_source/domain/data/request/device_info_request_model.dart";

class RegisterDeviceParams {
  RegisterDeviceParams({
    required this.fcmToken,
    required this.deviceId,
    required this.appGuid,
    required this.version,
    required this.userGuid,
    required this.deviceInfo,
  });

  String fcmToken;
  String deviceId;
  String appGuid;
  String version;
  String userGuid;
  DeviceInfoRequestModel deviceInfo;
}
