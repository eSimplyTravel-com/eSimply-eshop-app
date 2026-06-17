import "package:esim_open_source/data/remote/responses/device/device_info_details_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/device/device_info_response_model.dart";

class DeviceInfoResponseModelDto {
  DeviceInfoResponseModelDto({this.device});

  factory DeviceInfoResponseModelDto.fromJson({dynamic json}) {
    return DeviceInfoResponseModelDto(
      device: json["device"] != null
          ? DeviceInfoDetailsResponseModelDto.fromJson(json["device"])
          : null,
    );
  }

  DeviceInfoDetailsResponseModelDto? device;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "device": device?.toJson(),
    };
  }

  DeviceInfoResponseModel toDomain() {
    DeviceInfoResponseModel response = DeviceInfoResponseModel(
      device: device?.toDomain(),
    );
    return response;
  }
}
