import "package:esim_open_source/data/remote/responses/bundles/country_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for CountryResponseModel
/// Tests JSON serialization/deserialization and model methods
void main() {
  group("CountryResponseModel Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "id": "country-001",
        "country": "France",
        "iso3_code": "FRA",
        "zone_name": "Europe",
        "country_code": "FR",
        "alternative_country": "République française",
        "icon": "https://flagsapi.com/FR/flat/64.png",
        "operator_list": <String>["Orange", "SFR", "Bouygues"],
      };

      // Act
      final CountryResponseModelDto model = CountryResponseModelDto.fromJson(json);

      // Assert
      expect(model.id, "country-001");
      expect(model.country, "France");
      expect(model.iso3Code, "FRA");
      expect(model.zoneName, "Europe");
      expect(model.countryCode, "FR");
      expect(model.alternativeCountry, "République française");
      expect(model.icon, "https://flagsapi.com/FR/flat/64.png");
      expect(model.operatorList, <String>["Orange", "SFR", "Bouygues"]);
    });

    test("fromJson handles null operator_list", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "country": "Germany",
        "country_code": "DE",
      };

      // Act
      final CountryResponseModelDto model = CountryResponseModelDto.fromJson(json);

      // Assert
      expect(model.country, "Germany");
      expect(model.operatorList, <String>[]);
    });

    test("fromJson handles missing fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final CountryResponseModelDto model = CountryResponseModelDto.fromJson(json);

      // Assert
      expect(model.id, isNull);
      expect(model.country, isNull);
      expect(model.iso3Code, isNull);
      expect(model.zoneName, isNull);
      expect(model.countryCode, isNull);
      expect(model.alternativeCountry, isNull);
      expect(model.icon, isNull);
      expect(model.operatorList, <String>[]);
    });

    test("fromJson handles empty operator_list", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "country": "Spain",
        "operator_list": <String>[],
      };

      // Act
      final CountryResponseModelDto model = CountryResponseModelDto.fromJson(json);

      // Assert
      expect(model.country, "Spain");
      expect(model.operatorList, <String>[]);
    });

    test("constructor assigns values correctly", () {
      // Act
      final CountryResponseModelDto model = CountryResponseModelDto(
        id: "test-id",
        country: "Italy",
        iso3Code: "ITA",
        zoneName: "Southern Europe",
        countryCode: "IT",
        alternativeCountry: "Italia",
        icon: "https://flagsapi.com/IT/flat/64.png",
        operatorList: <String>["TIM", "Vodafone"],
      );

      // Assert
      expect(model.id, "test-id");
      expect(model.country, "Italy");
      expect(model.iso3Code, "ITA");
      expect(model.zoneName, "Southern Europe");
      expect(model.countryCode, "IT");
      expect(model.alternativeCountry, "Italia");
      expect(model.icon, "https://flagsapi.com/IT/flat/64.png");
      expect(model.operatorList, <String>["TIM", "Vodafone"]);
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final CountryResponseModelDto model = CountryResponseModelDto(
        id: "uk-001",
        country: "United Kingdom",
        iso3Code: "GBR",
        zoneName: "Western Europe",
        countryCode: "GB",
        alternativeCountry: "UK",
        icon: "https://flagsapi.com/GB/flat/64.png",
        operatorList: <String>["EE", "O2", "Vodafone"],
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["id"], "uk-001");
      expect(json["alternative_country"], "UK");
      expect(json["country"], "United Kingdom");
      expect(json["country_code"], "GB");
      expect(json["iso2_code"], "GBR");
      expect(json["zone_name"], "Western Europe");
      expect(json["icon"], "https://flagsapi.com/GB/flat/64.png");
      expect(json["operator_list"], <String>["EE", "O2", "Vodafone"]);
    });

    test("toJson handles null fields", () {
      // Arrange
      final CountryResponseModelDto model = CountryResponseModelDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["id"], isNull);
      expect(json["country"], isNull);
      expect(json["country_code"], isNull);
      expect(json["iso2_code"], isNull);
      expect(json["zone_name"], isNull);
      expect(json["icon"], isNull);
      expect(json["operator_list"], isNull);
    });

    test("getMockCountries returns list of mock countries", () {
      // Act
      final List<CountryResponseModelDto> mockCountries =
          CountryResponseModelDto.getMockCountries();

      // Assert
      expect(mockCountries, isNotEmpty);
      expect(mockCountries.length, greaterThan(20));
    });

    test("getMockCountries first country has expected values", () {
      // Act
      final List<CountryResponseModelDto> mockCountries =
          CountryResponseModelDto.getMockCountries();
      final CountryResponseModelDto firstCountry = mockCountries[0];

      // Assert
      expect(firstCountry.country, "Abkhazia");
      expect(firstCountry.countryCode, "GE");
      expect(firstCountry.iso3Code, "KAZ");
      expect(firstCountry.alternativeCountry, "Georgia");
      expect(firstCountry.icon, "https://flagsapi.com/GE/flat/64.png");
    });

    test("getMockCountries contains expected countries", () {
      // Act
      final List<CountryResponseModelDto> mockCountries =
          CountryResponseModelDto.getMockCountries();
      final List<String?> countryNames =
          mockCountries.map((CountryResponseModelDto c) => c.country).toList();

      // Assert
      expect(countryNames, contains("Albania"));
      expect(countryNames, contains("Belgium"));
      expect(countryNames, contains("Argentina"));
    });

    test("getMockCountries all countries have required fields", () {
      // Act
      final List<CountryResponseModelDto> mockCountries =
          CountryResponseModelDto.getMockCountries();

      // Assert
      for (final CountryResponseModelDto country in mockCountries) {
        expect(country.country, isNotNull);
        expect(country.countryCode, isNotNull);
        expect(country.icon, isNotNull);
        expect(country.icon, contains("https://flagsapi.com"));
      }
    });

    test("roundtrip fromJson and toJson handles data correctly", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "id": "test-123",
        "country": "Canada",
        "iso3_code": "CAN",
        "zone_name": "North America",
        "country_code": "CA",
        "alternative_country": "Canada",
        "icon": "https://flagsapi.com/CA/flat/64.png",
        "operator_list": <String>["Rogers", "Bell"],
      };

      // Act
      final CountryResponseModelDto model =
          CountryResponseModelDto.fromJson(originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(resultJson["id"], originalJson["id"]);
      expect(resultJson["country"], originalJson["country"]);
      expect(resultJson["country_code"], originalJson["country_code"]);
      expect(resultJson["alternative_country"], originalJson["alternative_country"]);
      expect(resultJson["icon"], originalJson["icon"]);
      expect(resultJson["operator_list"], originalJson["operator_list"]);
    });

    test("getMockCountries Belgium has correct values", () {
      // Act
      final List<CountryResponseModelDto> mockCountries =
          CountryResponseModelDto.getMockCountries();
      final CountryResponseModelDto belgium = mockCountries.firstWhere(
        (CountryResponseModelDto c) => c.country == "Belgium",
      );

      // Assert
      expect(belgium.countryCode, "BE");
      expect(belgium.iso3Code, "BEL");
      expect(belgium.alternativeCountry, "Belgium");
      expect(belgium.icon, "https://flagsapi.com/BE/flat/64.png");
    });

    test("toDomain converts to CountryResponseModel", () {
      // Arrange
      final CountryResponseModelDto dto = CountryResponseModelDto(
        id: "uk-001",
        country: "United Kingdom",
        iso3Code: "GBR",
        zoneName: "Western Europe",
        countryCode: "GB",
        alternativeCountry: "UK",
        icon: "https://flagsapi.com/GB/flat/64.png",
        operatorList: <String>["EE", "O2"],
      );

      // Act
      final domain = dto.toDomain();

      // Assert
      expect(domain.id, "uk-001");
      expect(domain.country, "United Kingdom");
      expect(domain.iso3Code, "GBR");
      expect(domain.countryCode, "GB");
      expect(domain.alternativeCountry, "UK");
      expect(domain.operatorList, <String>["EE", "O2"]);
    });

    test("toDomain handles null fields", () {
      // Arrange
      final CountryResponseModelDto dto = CountryResponseModelDto();

      // Act
      final domain = dto.toDomain();

      // Assert
      expect(domain.id, isNull);
      expect(domain.country, isNull);
      expect(domain.countryCode, isNull);
    });

    test("fromDomain converts from CountryResponseModel", () {
      // Arrange
      final CountryResponseModelDto dto = CountryResponseModelDto();
      final domain = CountryResponseModel(
        id: "us-001",
        country: "United States",
        iso3Code: "USA",
        zoneName: "North America",
        countryCode: "US",
        alternativeCountry: "USA",
        icon: "https://flagsapi.com/US/flat/64.png",
        operatorList: <String>["Verizon", "AT&T"],
      );

      // Act
      final result = dto.fromDomain(domain);

      // Assert
      expect(result.id, "us-001");
      expect(result.country, "United States");
      expect(result.countryCode, "US");
      expect(result.operatorList, <String>["Verizon", "AT&T"]);
    });

    test("fromDomain handles null model", () {
      // Arrange
      final CountryResponseModelDto dto = CountryResponseModelDto();

      // Act
      final result = dto.fromDomain(null);

      // Assert
      expect(result.id, isNull);
      expect(result.country, isNull);
      expect(result.countryCode, isNull);
    });
  });
}
