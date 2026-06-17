import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";

class CountryResponseModelDto {
  CountryResponseModelDto({
    this.id,
    this.country,
    this.iso3Code,
    this.zoneName,
    this.countryCode,
    this.alternativeCountry,
    this.icon,
    this.operatorList,
  });

  // Factory method to create an instance from a JSON map
  factory CountryResponseModelDto.fromJson(Map<String, dynamic> json) {
    return CountryResponseModelDto(
      id: json["id"],
      alternativeCountry: json["alternative_country"],
      country: json["country"],
      countryCode: json["country_code"],
      iso3Code: json["iso3_code"],
      zoneName: json["zone_name"],
      icon: json["icon"],
      operatorList: json["operator_list"] != null
          ? List<String>.from(json["operator_list"])
          : <String>[],
    );
  }

  final String? id;
  final String? country;
  final String? iso3Code;
  final String? zoneName;
  final String? countryCode;
  final String? alternativeCountry;
  final String? icon;
  final List<String>? operatorList;

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "alternative_country": alternativeCountry,
      "country": country,
      "country_code": countryCode,
      "iso2_code": iso3Code,
      "zone_name": zoneName,
      "icon": icon,
      "operator_list": operatorList,
    };
  }

  static List<CountryResponseModelDto> getMockCountries() {
    return <CountryResponseModelDto>[
      CountryResponseModelDto(
        country: "Abkhazia",
        countryCode: "GE",
        iso3Code: "KAZ",
        zoneName: "",
        icon: "https://flagsapi.com/GE/flat/64.png",
        alternativeCountry: "Georgia",
      ),
      CountryResponseModelDto(
        country: "Aland Islands",
        countryCode: "FI",
        iso3Code: "FIN",
        zoneName: "",
        icon: "https://flagsapi.com/FI/flat/64.png",
        alternativeCountry: "Finland",
      ),
      CountryResponseModelDto(
        country: "Albania",
        countryCode: "AL",
        iso3Code: "ALB",
        zoneName: "",
        icon: "https://flagsapi.com/AL/flat/64.png",
        alternativeCountry: "Albania",
      ),
      CountryResponseModelDto(
        country: "Algeria",
        countryCode: "DZ",
        iso3Code: "DZA",
        zoneName: "",
        icon: "https://flagsapi.com/DZ/flat/64.png",
        alternativeCountry: "Algeria",
      ),
      CountryResponseModelDto(
        country: "American Samoa",
        countryCode: "AS",
        iso3Code: "CAN",
        zoneName: "",
        icon: "https://flagsapi.com/AS/flat/64.png",
      ),
      CountryResponseModelDto(
        country: "Andorra",
        countryCode: "AD",
        iso3Code: "AND",
        zoneName: "",
        icon: "https://flagsapi.com/AD/flat/64.png",
        alternativeCountry: "Andorra",
      ),
      CountryResponseModelDto(
        country: "Angola",
        countryCode: "AO",
        iso3Code: "AGO",
        zoneName: "",
        icon: "https://flagsapi.com/AO/flat/64.png",
        alternativeCountry: "Angola",
      ),
      CountryResponseModelDto(
        country: "Anguilla",
        countryCode: "AI",
        iso3Code: "AIA",
        zoneName: "",
        icon: "https://flagsapi.com/AI/flat/64.png",
      ),
      CountryResponseModelDto(
        country: "Antarctica",
        countryCode: "CC",
        zoneName: "",
        icon: "https://flagsapi.com/CC/flat/64.png",
      ),
      CountryResponseModelDto(
        country: "Antigua and Barbuda",
        countryCode: "AG",
        iso3Code: "ATG",
        zoneName: "",
        icon: "https://flagsapi.com/AG/flat/64.png",
        alternativeCountry: "Antigua and Barbuda",
      ),
      CountryResponseModelDto(
        country: "Argentina",
        countryCode: "AR",
        iso3Code: "ARG",
        zoneName: "",
        icon: "https://flagsapi.com/AR/flat/64.png",
        alternativeCountry: "Argentina",
      ),
      CountryResponseModelDto(
        country: "Armenia",
        countryCode: "AM",
        iso3Code: "ARM",
        zoneName: "",
        icon: "https://flagsapi.com/AM/flat/64.png",
        alternativeCountry: "Armenia",
      ),
      CountryResponseModelDto(
        country: "Aruba",
        countryCode: "AW",
        iso3Code: "ABW",
        zoneName: "",
        icon: "https://flagsapi.com/AW/flat/64.png",
      ),
      CountryResponseModelDto(
        country: "Australia",
        countryCode: "AU",
        iso3Code: "AUS",
        zoneName: "",
        icon: "https://flagsapi.com/AU/flat/64.png",
        alternativeCountry: "Australia",
      ),
      CountryResponseModelDto(
        country: "Austria",
        countryCode: "AT",
        iso3Code: "AUT",
        zoneName: "",
        icon: "https://flagsapi.com/AT/flat/64.png",
        alternativeCountry: "Austria",
      ),
      CountryResponseModelDto(
        country: "Azerbaijan",
        countryCode: "AZ",
        iso3Code: "AZE",
        zoneName: "",
        icon: "https://flagsapi.com/AZ/flat/64.png",
        alternativeCountry: "Azerbaijan",
      ),
      CountryResponseModelDto(
        country: "Bahamas",
        countryCode: "BS",
        iso3Code: "BHS",
        zoneName: "",
        icon: "https://flagsapi.com/BS/flat/64.png",
        alternativeCountry: "Bahamas",
      ),
      CountryResponseModelDto(
        country: "Bahrain",
        countryCode: "BH",
        iso3Code: "BHR",
        zoneName: "",
        icon: "https://flagsapi.com/BH/flat/64.png",
        alternativeCountry: "Bahrain",
      ),
      CountryResponseModelDto(
        country: "Bangladesh",
        countryCode: "BD",
        iso3Code: "BGD",
        zoneName: "",
        icon: "https://flagsapi.com/BD/flat/64.png",
        alternativeCountry: "Bangladesh",
      ),
      CountryResponseModelDto(
        country: "Barbados",
        countryCode: "BB",
        iso3Code: "BRB",
        zoneName: "",
        icon: "https://flagsapi.com/BB/flat/64.png",
        alternativeCountry: "Barbados",
      ),
      CountryResponseModelDto(
        country: "Belarus",
        countryCode: "BY",
        iso3Code: "BLR",
        zoneName: "",
        icon: "https://flagsapi.com/BY/flat/64.png",
        alternativeCountry: "Belarus",
      ),
      CountryResponseModelDto(
        country: "Belgium",
        countryCode: "BE",
        iso3Code: "BEL",
        zoneName: "",
        icon: "https://flagsapi.com/BE/flat/64.png",
        alternativeCountry: "Belgium",
      ),
      CountryResponseModelDto(
        country: "Belize",
        countryCode: "BZ",
        iso3Code: "BLZ",
        zoneName: "",
        icon: "https://flagsapi.com/BZ/flat/64.png",
        alternativeCountry: "Belize",
      ),
    ];
  }

  CountryResponseModel toDomain() {
    CountryResponseModel response = CountryResponseModel(
      id: id,
      country: country,
      iso3Code: iso3Code,
      zoneName: zoneName,
      countryCode: countryCode,
      alternativeCountry: alternativeCountry,
      icon: icon,
      operatorList: operatorList,
    );

    return response;
  }

  CountryResponseModelDto fromDomain(CountryResponseModel? model) {
    CountryResponseModelDto response = CountryResponseModelDto(
      id: model?.id,
      country: model?.country,
      iso3Code: model?.iso3Code,
      zoneName: model?.zoneName,
      countryCode: model?.countryCode,
      alternativeCountry: model?.alternativeCountry,
      icon: model?.icon,
      operatorList: model?.operatorList,
    );

    return response;
  }
}
