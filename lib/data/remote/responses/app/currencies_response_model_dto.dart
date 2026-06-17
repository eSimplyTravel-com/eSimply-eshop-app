import "package:esim_open_source/domain/data/response/app/currencies_response_model.dart";
import "package:esim_open_source/utils/parsing_helper.dart";

class CurrenciesResponseModelDto {
  CurrenciesResponseModelDto({
    this.currency,
  });

  // Factory constructor for JSON decoding
  factory CurrenciesResponseModelDto.fromJson(Map<String, dynamic> json) {
    return CurrenciesResponseModelDto(
      currency: json["currency"],
    );
  }

  // Factory constructor for JSON decoding
  factory CurrenciesResponseModelDto.fromAPIJson({dynamic json}) {
    return CurrenciesResponseModelDto(
      currency: json["currency"],
    );
  }

  final String? currency;

  // Method for JSON encoding
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "currency": currency,
    };
  }

  static List<CurrenciesResponseModelDto> fromJsonList({dynamic json}) {
    return fromJsonListTyped(
      parser: CurrenciesResponseModelDto.fromAPIJson,
      json: json,
    );
  }

  CurrenciesResponseModel toDomain() {
    CurrenciesResponseModel response = CurrenciesResponseModel(
      currency: currency,
    );
    return response;
  }
}
