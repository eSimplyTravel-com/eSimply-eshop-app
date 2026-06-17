import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for CountryResponseModel
void main() {
  group("CountryResponseModel Tests", () {
    test("constructor assigns values correctly", () {
      // Arrange
      final List<String> operators = <String>["Operator1", "Operator2"];

      // Act
      final CountryResponseModel model = CountryResponseModel(
        id: "1",
        country: "United States",
        iso3Code: "USA",
        zoneName: "North America",
        countryCode: "US",
        alternativeCountry: "USA",
        icon: "https://flagsapi.com/US/flat/64.png",
        operatorList: operators,
      );

      // Assert
      expect(model.id, "1");
      expect(model.country, "United States");
      expect(model.iso3Code, "USA");
      expect(model.zoneName, "North America");
      expect(model.countryCode, "US");
      expect(model.alternativeCountry, "USA");
      expect(model.icon, "https://flagsapi.com/US/flat/64.png");
      expect(model.operatorList, operators);
    });

    test("constructor with all null values", () {
      // Act
      final CountryResponseModel model = CountryResponseModel();

      // Assert
      expect(model.id, isNull);
      expect(model.country, isNull);
      expect(model.iso3Code, isNull);
      expect(model.zoneName, isNull);
      expect(model.countryCode, isNull);
      expect(model.alternativeCountry, isNull);
      expect(model.icon, isNull);
      expect(model.operatorList, isNull);
    });

    test("getMockCountries returns non-empty list", () {
      // Act
      final List<CountryResponseModel> countries = CountryResponseModel.getMockCountries();

      // Assert
      expect(countries, isNotEmpty);
      expect(countries.length, greaterThan(10));
    });

    test("getMockCountries contains expected countries", () {
      // Act
      final List<CountryResponseModel> countries = CountryResponseModel.getMockCountries();

      // Assert
      final List<String> countryNames = countries.map((CountryResponseModel c) => c.country ?? "").toList();
      expect(countryNames, contains("Abkhazia"));
      expect(countryNames, contains("Australia"));
      expect(countryNames, contains("Belgium"));
    });

    test("getMockCountries all items have country code", () {
      // Act
      final List<CountryResponseModel> countries = CountryResponseModel.getMockCountries();

      // Assert
      for (final CountryResponseModel country in countries) {
        expect(country.countryCode, isNotNull);
        expect(country.countryCode?.length, greaterThan(0));
      }
    });

    test("getMockCountries all items have icon", () {
      // Act
      final List<CountryResponseModel> countries = CountryResponseModel.getMockCountries();

      // Assert
      for (final CountryResponseModel country in countries) {
        expect(country.icon, isNotNull);
        expect(country.icon, startsWith("https://"));
      }
    });

    test("getMockCountries items have iso3Code", () {
      // Act
      final List<CountryResponseModel> countries = CountryResponseModel.getMockCountries();

      // Assert
      final List<CountryResponseModel> withCode = countries.where((CountryResponseModel c) => c.iso3Code != null).toList();
      expect(withCode.length, greaterThan(10));
    });

    test("operatorList can be empty", () {
      // Act
      final CountryResponseModel model = CountryResponseModel(
        operatorList: <String>[],
      );

      // Assert
      expect(model.operatorList, isNotNull);
      expect(model.operatorList, isEmpty);
    });

    test("operatorList with single operator", () {
      // Act
      final CountryResponseModel model = CountryResponseModel(
        operatorList: <String>["Operator1"],
      );

      // Assert
      expect(model.operatorList?.length, 1);
      expect(model.operatorList?[0], "Operator1");
    });

    test("operatorList with multiple operators", () {
      // Arrange
      final List<String> operators = <String>["Operator1", "Operator2", "Operator3"];

      // Act
      final CountryResponseModel model = CountryResponseModel(
        operatorList: operators,
      );

      // Assert
      expect(model.operatorList?.length, 3);
    });

    test("empty string for country", () {
      // Act
      final CountryResponseModel model = CountryResponseModel(country: "");

      // Assert
      expect(model.country, "");
    });

    test("empty string for countryCode", () {
      // Act
      final CountryResponseModel model = CountryResponseModel(countryCode: "");

      // Assert
      expect(model.countryCode, "");
    });

    test("two-letter iso country code", () {
      // Act
      final CountryResponseModel model = CountryResponseModel(
        countryCode: "US",
      );

      // Assert
      expect(model.countryCode, "US");
      expect(model.countryCode?.length, 2);
    });

    test("three-letter iso3 code", () {
      // Act
      final CountryResponseModel model = CountryResponseModel(
        iso3Code: "USA",
      );

      // Assert
      expect(model.iso3Code, "USA");
      expect(model.iso3Code?.length, 3);
    });

    test("multiple instances are independent", () {
      // Act
      final CountryResponseModel model1 = CountryResponseModel(
        country: "United States",
        countryCode: "US",
      );
      final CountryResponseModel model2 = CountryResponseModel(
        country: "Canada",
        countryCode: "CA",
      );

      // Assert
      expect(model1.country, "United States");
      expect(model2.country, "Canada");
      expect(model1.countryCode, "US");
      expect(model2.countryCode, "CA");
    });

    test("response type is correct", () {
      // Act
      final CountryResponseModel model = CountryResponseModel();

      // Assert
      expect(model, isA<CountryResponseModel>());
    });

    test("getMockCountries is consistent", () {
      // Act
      final List<CountryResponseModel> countries1 = CountryResponseModel.getMockCountries();
      final List<CountryResponseModel> countries2 = CountryResponseModel.getMockCountries();

      // Assert
      expect(countries1.length, countries2.length);
      expect(countries1[0].country, countries2[0].country);
    });
  });
}
