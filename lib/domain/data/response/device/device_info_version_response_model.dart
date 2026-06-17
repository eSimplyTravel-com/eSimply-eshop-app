import "package:esim_open_source/domain/data/response/device/device_info_action_data_response_model.dart";

class DeviceInfoVersionResponseModel {
  DeviceInfoVersionResponseModel({
    this.action,
    this.version,
    this.recordGuid,
    this.name,
    this.description,
    this.buttonAccept,
    this.buttonDenied,
    this.createdDate,
  });

  DeviceInfoActionDataResponseModel? action;
  String? version;
  String? recordGuid;
  String? name;
  String? description;
  String? buttonAccept;
  String? buttonDenied;
  String? createdDate;
}
