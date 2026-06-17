class DeviceInfoActionDataResponseModel {
  DeviceInfoActionDataResponseModel({
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

  String? name;
  int? id;
  String? tag;
  String? description;
  bool? isActive;
  bool? isEditable;
  dynamic category;
  List<dynamic>? details;
  String? recordGuid;
}
