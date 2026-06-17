import "package:esim_open_source/data/remote/responses/device/device_info_version_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/device/device_info_details_response_model.dart";

class DeviceInfoDetailsResponseModelDto {
  DeviceInfoDetailsResponseModelDto({
    this.recordGuid,
    this.deviceId,
    this.token,
    this.platformTag,
    this.osTag,
    this.appGuid,
    this.appSettings,
    this.version,
  });

  factory DeviceInfoDetailsResponseModelDto.fromJson(Map<String, dynamic> json) {
    return DeviceInfoDetailsResponseModelDto(
      recordGuid: json["recordGuid"],
      deviceId: json["deviceId"],
      token: json["token"],
      platformTag: json["platformTag"],
      osTag: json["osTag"],
      appGuid: json["appGuid"],
      appSettings: json["appSettings"],
      version: json["version"] != null
          ? DeviceInfoVersionResponseModelDto.fromJson(json["version"])
          : null,
    );
  }

  String? recordGuid;
  String? deviceId;
  String? token;
  String? platformTag;
  String? osTag;
  String? appGuid;
  dynamic appSettings;
  DeviceInfoVersionResponseModelDto? version;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "recordGuid": recordGuid,
      "deviceId": deviceId,
      "token": token,
      "platformTag": platformTag,
      "osTag": osTag,
      "appGuid": appGuid,
      "appSettings": appSettings,
      "version": version?.toJson(),
    };
  }

  DeviceInfoDetailsResponseModel toDomain() {
    DeviceInfoDetailsResponseModel response = DeviceInfoDetailsResponseModel(
      recordGuid: recordGuid,
      deviceId: deviceId,
      token: token,
      platformTag: platformTag,
      osTag: osTag,
      appGuid: appGuid,
      appSettings: appSettings,
      version: version?.toDomain(),
    );

    return response;
  }
}
