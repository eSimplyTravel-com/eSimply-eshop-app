import "package:esim_open_source/domain/data/response/device/device_info_action_data_response_model.dart";

class DeviceInfoActionDataResponseModelDto {
  DeviceInfoActionDataResponseModelDto({
    this.name,
    this.id,
    this.tag,
    this.description,
    this.isActive,
    this.isEditable,
    this.category,
    this.details,
    this.recordGuid,
  });
  factory DeviceInfoActionDataResponseModelDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return DeviceInfoActionDataResponseModelDto(
      name: json["name"],
      id: json["id"],
      tag: json["tag"],
      description: json["description"],
      isActive: json["isActive"],
      isEditable: json["isEditable"],
      category: json["category"],
      details: json["details"] != null
          ? List<dynamic>.from(json["details"])
          : <dynamic>[],
      recordGuid: json["recordGuid"],
    );
  }
  String? name;
  int? id;
  String? tag;
  String? description;
  bool? isActive;
  bool? isEditable;
  dynamic category;
  List<dynamic>? details;
  String? recordGuid;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "name": name,
      "id": id,
      "tag": tag,
      "description": description,
      "isActive": isActive,
      "isEditable": isEditable,
      "category": category,
      "details": details,
      "recordGuid": recordGuid,
    };
  }

  DeviceInfoActionDataResponseModel toDomain() {
    DeviceInfoActionDataResponseModel response = DeviceInfoActionDataResponseModel(
      name: name,
      id: id,
      tag: tag,
      description: description,
      isActive: isActive,
      isEditable: isEditable,
      category: category,
      details: details,
      recordGuid: recordGuid,
    );

    return response;
  }
}
