import "dart:io";

import "package:esim_open_source/domain/data/request/device_info_request_model.dart";

class DeviceInfoRequestModelDto {
  DeviceInfoRequestModelDto({
    required this.deviceName,
    this.latitude = 0,
    this.longitude = 0,
    this.mcc = "0",
    this.mnc = "0",
  });

  factory DeviceInfoRequestModelDto.fromDomain(DeviceInfoRequestModel model) {
    return DeviceInfoRequestModelDto(
      deviceName: model.deviceName,
      latitude: model.latitude,
      longitude: model.longitude,
      mcc: model.mcc,
      mnc: model.mnc,
    );
  }

  String deviceName;
  double latitude;
  double longitude;
  String mcc;
  String mnc;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "deviceName": deviceName,
      "latitude": latitude,
      "longitude": longitude,
      "mcc": mcc,
      "mnc": mnc,
    };
  }

  static String get osTag {
    if (Platform.isIOS) {
      return "IOS";
    }
    return "ANDROID";
  }

  static String get platformTag {
    if (Platform.isIOS) {
      return "MOBILE_IOS";
    }
    return "MOBILE_ANDROID";
  }
}
