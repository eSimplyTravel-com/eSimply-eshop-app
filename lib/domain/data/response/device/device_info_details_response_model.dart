import "package:esim_open_source/domain/data/response/device/device_info_version_response_model.dart";

class DeviceInfoDetailsResponseModel {
  DeviceInfoDetailsResponseModel({
    this.recordGuid,
    this.deviceId,
    this.token,
    this.platformTag,
    this.osTag,
    this.appGuid,
    this.appSettings,
    this.version,
  });

  String? recordGuid;
  String? deviceId;
  String? token;
  String? platformTag;
  String? osTag;
  String? appGuid;
  dynamic appSettings;
  DeviceInfoVersionResponseModel? version;
}
