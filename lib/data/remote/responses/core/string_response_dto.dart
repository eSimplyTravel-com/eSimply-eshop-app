import "package:esim_open_source/domain/data/response/core/string_response.dart";

class StringResponseDto {
  StringResponseDto.fromJson({dynamic json}) {
    _stringValue = json;
  }
  bool? _stringValue;
  bool? get stringValue => _stringValue;

  StringResponse toDomain() {
    StringResponse response = StringResponse(
      stringValue: stringValue,
    );

    return response;
  }
}
