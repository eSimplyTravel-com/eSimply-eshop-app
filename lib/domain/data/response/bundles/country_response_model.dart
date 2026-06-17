class CountryResponseModel {
  CountryResponseModel({
    this.id,
    this.country,
    this.iso3Code,
    this.zoneName,
    this.countryCode,
    this.alternativeCountry,
    this.icon,
    this.operatorList,
  });

  final String? id;
  final String? country;
  final String? iso3Code;
  final String? zoneName;
  final String? countryCode;
  final String? alternativeCountry;
  final String? icon;
  final List<String>? operatorList;

  static List<CountryResponseModel> getMockCountries() {
    return <CountryResponseModel>[
      CountryResponseModel(
        country: "Abkhazia",
        countryCode: "GE",
        iso3Code: "KAZ",
        zoneName: "",
        icon: "https://flagsapi.com/GE/flat/64.png",
        alternativeCountry: "Georgia",
      ),
      CountryResponseModel(
        country: "Aland Islands",
        countryCode: "FI",
        iso3Code: "FIN",
        zoneName: "",
        icon: "https://flagsapi.com/FI/flat/64.png",
        alternativeCountry: "Finland",
      ),
      CountryResponseModel(
        country: "Albania",
        countryCode: "AL",
        iso3Code: "ALB",
        zoneName: "",
        icon: "https://flagsapi.com/AL/flat/64.png",
        alternativeCountry: "Albania",
      ),
      CountryResponseModel(
        country: "Algeria",
        countryCode: "DZ",
        iso3Code: "DZA",
        zoneName: "",
        icon: "https://flagsapi.com/DZ/flat/64.png",
        alternativeCountry: "Algeria",
      ),
      CountryResponseModel(
        country: "American Samoa",
        countryCode: "AS",
        iso3Code: "CAN",
        zoneName: "",
        icon: "https://flagsapi.com/AS/flat/64.png",
      ),
      CountryResponseModel(
        country: "Andorra",
        countryCode: "AD",
        iso3Code: "AND",
        zoneName: "",
        icon: "https://flagsapi.com/AD/flat/64.png",
        alternativeCountry: "Andorra",
      ),
      CountryResponseModel(
        country: "Angola",
        countryCode: "AO",
        iso3Code: "AGO",
        zoneName: "",
        icon: "https://flagsapi.com/AO/flat/64.png",
        alternativeCountry: "Angola",
      ),
      CountryResponseModel(
        country: "Anguilla",
        countryCode: "AI",
        iso3Code: "AIA",
        zoneName: "",
        icon: "https://flagsapi.com/AI/flat/64.png",
      ),
      CountryResponseModel(
        country: "Antarctica",
        countryCode: "CC",
        zoneName: "",
        icon: "https://flagsapi.com/CC/flat/64.png",
      ),
      CountryResponseModel(
        country: "Antigua and Barbuda",
        countryCode: "AG",
        iso3Code: "ATG",
        zoneName: "",
        icon: "https://flagsapi.com/AG/flat/64.png",
        alternativeCountry: "Antigua and Barbuda",
      ),
      CountryResponseModel(
        country: "Argentina",
        countryCode: "AR",
        iso3Code: "ARG",
        zoneName: "",
        icon: "https://flagsapi.com/AR/flat/64.png",
        alternativeCountry: "Argentina",
      ),
      CountryResponseModel(
        country: "Armenia",
        countryCode: "AM",
        iso3Code: "ARM",
        zoneName: "",
        icon: "https://flagsapi.com/AM/flat/64.png",
        alternativeCountry: "Armenia",
      ),
      CountryResponseModel(
        country: "Aruba",
        countryCode: "AW",
        iso3Code: "ABW",
        zoneName: "",
        icon: "https://flagsapi.com/AW/flat/64.png",
      ),
      CountryResponseModel(
        country: "Australia",
        countryCode: "AU",
        iso3Code: "AUS",
        zoneName: "",
        icon: "https://flagsapi.com/AU/flat/64.png",
        alternativeCountry: "Australia",
      ),
      CountryResponseModel(
        country: "Austria",
        countryCode: "AT",
        iso3Code: "AUT",
        zoneName: "",
        icon: "https://flagsapi.com/AT/flat/64.png",
        alternativeCountry: "Austria",
      ),
      CountryResponseModel(
        country: "Azerbaijan",
        countryCode: "AZ",
        iso3Code: "AZE",
        zoneName: "",
        icon: "https://flagsapi.com/AZ/flat/64.png",
        alternativeCountry: "Azerbaijan",
      ),
      CountryResponseModel(
        country: "Bahamas",
        countryCode: "BS",
        iso3Code: "BHS",
        zoneName: "",
        icon: "https://flagsapi.com/BS/flat/64.png",
        alternativeCountry: "Bahamas",
      ),
      CountryResponseModel(
        country: "Bahrain",
        countryCode: "BH",
        iso3Code: "BHR",
        zoneName: "",
        icon: "https://flagsapi.com/BH/flat/64.png",
        alternativeCountry: "Bahrain",
      ),
      CountryResponseModel(
        country: "Bangladesh",
        countryCode: "BD",
        iso3Code: "BGD",
        zoneName: "",
        icon: "https://flagsapi.com/BD/flat/64.png",
        alternativeCountry: "Bangladesh",
      ),
      CountryResponseModel(
        country: "Barbados",
        countryCode: "BB",
        iso3Code: "BRB",
        zoneName: "",
        icon: "https://flagsapi.com/BB/flat/64.png",
        alternativeCountry: "Barbados",
      ),
      CountryResponseModel(
        country: "Belarus",
        countryCode: "BY",
        iso3Code: "BLR",
        zoneName: "",
        icon: "https://flagsapi.com/BY/flat/64.png",
        alternativeCountry: "Belarus",
      ),
      CountryResponseModel(
        country: "Belgium",
        countryCode: "BE",
        iso3Code: "BEL",
        zoneName: "",
        icon: "https://flagsapi.com/BE/flat/64.png",
        alternativeCountry: "Belgium",
      ),
      CountryResponseModel(
        country: "Belize",
        countryCode: "BZ",
        iso3Code: "BLZ",
        zoneName: "",
        icon: "https://flagsapi.com/BZ/flat/64.png",
        alternativeCountry: "Belize",
      ),
    ];
  }
}
