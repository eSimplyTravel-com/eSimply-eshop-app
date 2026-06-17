import "dart:convert";

import "package:esim_open_source/domain/data/response/app/configuration_response_model.dart";
import "package:esim_open_source/utils/parsing_helper.dart";

class ConfigurationResponseModelDto {
  ConfigurationResponseModelDto({
    String? key,
    String? value,
  }) {
    _key = key;
    _value = value;
  }

  ConfigurationResponseModelDto.fromJson({dynamic json}) {
    _key = json["key"];
    _value = json["value"];
  }

  factory ConfigurationResponseModelDto.fromDomain(
    ConfigurationResponseModel model,
  ) =>
      ConfigurationResponseModelDto(
        key: model.key,
        value: model.value,
      );

  String? _key;
  String? _value;

  ConfigurationResponseModelDto copyWith({
    String? key,
    String? value,
  }) =>
      ConfigurationResponseModelDto(
        key: key ?? _key,
        value: value ?? _value,
      );

  String? get key => _key;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["key"] = _key;
    map["value"] = _value;
    return map;
  }

  static List<ConfigurationResponseModelDto> fromJsonList({dynamic json}) {
    return fromJsonListTyped(
      parser: ConfigurationResponseModelDto.fromJson,
      json: json,
    );
  }

  static String toJsonListString(List<ConfigurationResponseModelDto> models) {
    final List<Map<String, dynamic>> jsonList = models
        .map((ConfigurationResponseModelDto model) => model.toJson())
        .toList();
    return jsonEncode(jsonList);
  }

  static List<ConfigurationResponseModelDto> fromJsonListString(
    String jsonString,
  ) {
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((dynamic json) => ConfigurationResponseModelDto.fromJson(json: json))
        .toList();
  }

  ConfigurationResponseModel toDomain() {
    ConfigurationResponseModel response = ConfigurationResponseModel(
      key: key,
      value: value,
    );
    return response;
  }
}
