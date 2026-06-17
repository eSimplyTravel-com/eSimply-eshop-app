import "dart:convert";

import "package:esim_open_source/domain/data/response/bundles/bundle_consumption_response.dart";

/// consumption : 0
/// unit : "string"
/// display_consumption : "string"

BundleConsumptionResponseDto bundleConsumptionResponseFromJson(String str) =>
    BundleConsumptionResponseDto.fromJson(json: json.decode(str));
String bundleConsumptionResponseToJson(BundleConsumptionResponseDto data) =>
    json.encode(data.toJson());

class BundleConsumptionResponseDto {
  BundleConsumptionResponseDto({
    num? consumption,
    String? unit,
    String? displayConsumption,
  }) {
    _consumption = consumption;
    _unit = unit;
    _displayConsumption = displayConsumption;
  }

  BundleConsumptionResponseDto.fromJson({dynamic json}) {
    _consumption = json["consumption"];
    _unit = json["unit"];
    _displayConsumption = json["display_consumption"];
  }
  num? _consumption;
  String? _unit;
  String? _displayConsumption;
  BundleConsumptionResponseDto copyWith({
    num? consumption,
    String? unit,
    String? displayConsumption,
  }) =>
      BundleConsumptionResponseDto(
        consumption: consumption ?? _consumption,
        unit: unit ?? _unit,
        displayConsumption: displayConsumption ?? _displayConsumption,
      );
  num? get consumption => _consumption;
  String? get unit => _unit;
  String? get displayConsumption => _displayConsumption;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["consumption"] = _consumption;
    map["unit"] = _unit;
    map["display_consumption"] = _displayConsumption;
    return map;
  }

  BundleConsumptionResponse toDomain() {
    BundleConsumptionResponse response = BundleConsumptionResponse(
      consumption: consumption,
      unit: unit,
      displayConsumption: displayConsumption,
    );
    return response;
  }
}
