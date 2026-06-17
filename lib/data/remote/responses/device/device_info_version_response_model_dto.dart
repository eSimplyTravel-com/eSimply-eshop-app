import "package:esim_open_source/data/remote/responses/device/device_info_action_data_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/device/device_info_version_response_model.dart";

class DeviceInfoVersionResponseModelDto {
  DeviceInfoVersionResponseModelDto({
    this.action,
    this.version,
    this.recordGuid,
    this.name,
    this.description,
    this.buttonAccept,
    this.buttonDenied,
    this.createdDate,
  });

  factory DeviceInfoVersionResponseModelDto.fromJson(Map<String, dynamic> json) {
    return DeviceInfoVersionResponseModelDto(
      action: json["action"] != null
          ? DeviceInfoActionDataResponseModelDto.fromJson(json["action"])
          : null,
      version: json["version"],
      recordGuid: json["recordGuid"],
      name: json["name"],
      description: json["description"],
      buttonAccept: json["buttonAccept"],
      buttonDenied: json["buttonDenied"],
      createdDate: json["createdDate"],
    );
  }
  DeviceInfoActionDataResponseModelDto? action;
  String? version;
  String? recordGuid;
  String? name;
  String? description;
  String? buttonAccept;
  String? buttonDenied;
  String? createdDate;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "action": action?.toJson(),
      "version": version,
      "recordGuid": recordGuid,
      "name": name,
      "description": description,
      "buttonAccept": buttonAccept,
      "buttonDenied": buttonDenied,
      "createdDate": createdDate,
    };
  }

  DeviceInfoVersionResponseModel toDomain() {
    DeviceInfoVersionResponseModel response = DeviceInfoVersionResponseModel(
      action: action?.toDomain(),
      version: version,
      recordGuid: recordGuid,
      name: name,
      description: description,
      buttonAccept: buttonAccept,
      buttonDenied: buttonDenied,
      createdDate: createdDate,
    );

    return response;
  }
}
