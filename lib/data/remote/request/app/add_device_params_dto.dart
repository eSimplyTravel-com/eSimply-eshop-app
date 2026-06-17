import "package:esim_open_source/domain/data/params/add_device_params.dart";

class AddDeviceParamsDto {
  AddDeviceParamsDto({
    required this.fcmToken,
    required this.manufacturer,
    required this.deviceModel,
    required this.deviceOs,
    required this.deviceOsVersion,
    required this.appVersion,
    required this.ramSize,
    required this.screenResolution,
    required this.isRooted,
  });

  factory AddDeviceParamsDto.fromDomain(AddDeviceParams params) {
    return AddDeviceParamsDto(
      fcmToken: params.fcmToken,
      manufacturer: params.manufacturer,
      deviceModel: params.deviceModel,
      deviceOs: params.deviceOs,
      deviceOsVersion: params.deviceOsVersion,
      appVersion: params.appVersion,
      ramSize: params.ramSize,
      screenResolution: params.screenResolution,
      isRooted: params.isRooted,
    );
  }

  final String fcmToken;
  final String manufacturer;
  final String deviceModel;
  final String deviceOs;
  final String deviceOsVersion;
  final String appVersion;
  final String ramSize;
  final String screenResolution;
  final bool isRooted;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "fcm_token": fcmToken,
        "manufacturer": manufacturer,
        "device_model": deviceModel,
        "os": deviceOs,
        "os_version": deviceOsVersion,
        "app_version": appVersion,
        "ram_size": ramSize,
        "screen_resolution": screenResolution,
        "is_rooted": isRooted,
      };
}
