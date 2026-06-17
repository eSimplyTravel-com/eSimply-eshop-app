import "package:esim_open_source/domain/data/response/bundles/bundle_category_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for BundleResponseModel
void main() {
  group("BundleResponseModel Tests", () {
    test("constructor assigns values correctly", () {
      // Arrange
      final BundleCategoryResponseModel category = BundleCategoryResponseModel(
        type: "GLOBAL",
        code: "G1",
        title: "Global",
      );
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(countryCode: "US"),
      ];

      // Act
      final BundleResponseModel model = BundleResponseModel(
        displayTitle: "5GB 30 Days",
        displaySubtitle: "Global",
        bundleCode: "GLOBAL001",
        bundleCategory: category,
        bundleMarketingName: "Global Plan",
        bundleName: "Global Bundle",
        countCountries: 200,
        currencyCode: "USD",
        gprsLimitDisplay: "5 GB",
        price: 19.99,
        priceDisplay: "19.99 USD",
        unlimited: false,
        validity: 30,
        validityLabel: "Day",
        countries: countries,
        icon: "https://example.com/icon.png",
        label: "BEST_VALUE",
      );

      // Assert
      expect(model.displayTitle, "5GB 30 Days");
      expect(model.displaySubtitle, "Global");
      expect(model.bundleCode, "GLOBAL001");
      expect(model.bundleCategory, category);
      expect(model.bundleMarketingName, "Global Plan");
      expect(model.bundleName, "Global Bundle");
      expect(model.countCountries, 200);
      expect(model.currencyCode, "USD");
      expect(model.gprsLimitDisplay, "5 GB");
      expect(model.price, 19.99);
      expect(model.priceDisplay, "19.99 USD");
      expect(model.unlimited, false);
      expect(model.validity, 30);
      expect(model.validityLabel, "Day");
      expect(model.countries, countries);
      expect(model.icon, "https://example.com/icon.png");
      expect(model.label, "BEST_VALUE");
    });

    test("constructor with all null values", () {
      // Act
      final BundleResponseModel model = BundleResponseModel();

      // Assert
      expect(model.displayTitle, isNull);
      expect(model.bundleCode, isNull);
      expect(model.bundleCategory, isNull);
      expect(model.countries, isNull);
    });

    test("isCruise returns true when category type is CRUISE", () {
      // Arrange
      final BundleCategoryResponseModel category = BundleCategoryResponseModel(
        type: "CRUISE",
      );

      // Act
      final BundleResponseModel model = BundleResponseModel(
        bundleCategory: category,
      );

      // Assert
      expect(model.isCruise, true);
    });

    test("isCruise returns false when category type is GLOBAL", () {
      // Arrange
      final BundleCategoryResponseModel category = BundleCategoryResponseModel(
        type: "GLOBAL",
      );

      // Act
      final BundleResponseModel model = BundleResponseModel(
        bundleCategory: category,
      );

      // Assert
      expect(model.isCruise, false);
    });

    test("isCruise returns false when bundleCategory is null", () {
      // Act
      final BundleResponseModel model = BundleResponseModel(
        
      );

      // Assert
      expect(model.isCruise, false);
    });

    test("getMockGlobalBundles returns non-empty list", () {
      // Act
      final List<BundleResponseModel> bundles =
          BundleResponseModel.getMockGlobalBundles();

      // Assert
      expect(bundles, isNotEmpty);
      expect(bundles.length, greaterThan(0));
    });

    test("getMockGlobalBundles all items have bundleCode", () {
      // Act
      final List<BundleResponseModel> bundles =
          BundleResponseModel.getMockGlobalBundles();

      // Assert
      for (final BundleResponseModel bundle in bundles) {
        expect(bundle.bundleCode, isNotNull);
      }
    });

    test("getMockGlobalBundles all items have bundleName", () {
      // Act
      final List<BundleResponseModel> bundles =
          BundleResponseModel.getMockGlobalBundles();

      // Assert
      for (final BundleResponseModel bundle in bundles) {
        expect(bundle.bundleName, isNotNull);
      }
    });

    test("getMockGlobalBundles all items have price", () {
      // Act
      final List<BundleResponseModel> bundles =
          BundleResponseModel.getMockGlobalBundles();

      // Assert
      for (final BundleResponseModel bundle in bundles) {
        expect(bundle.price, isNotNull);
        expect(bundle.price, greaterThan(0));
      }
    });

    test("getMockGlobalBundles all items have countries list", () {
      // Act
      final List<BundleResponseModel> bundles =
          BundleResponseModel.getMockGlobalBundles();

      // Assert
      for (final BundleResponseModel bundle in bundles) {
        expect(bundle.countries, isNotNull);
      }
    });

    test("price as double value", () {
      // Act
      final BundleResponseModel model = BundleResponseModel(
        price: 9.99,
      );

      // Assert
      expect(model.price, 9.99);
    });

    test("price as integer value", () {
      // Act
      final BundleResponseModel model = BundleResponseModel(
        price: 50,
      );

      // Assert
      expect(model.price, 50.0);
    });

    test("validity as integer", () {
      // Act
      final BundleResponseModel model = BundleResponseModel(
        validity: 7,
      );

      // Assert
      expect(model.validity, 7);
    });

    test("countCountries as integer", () {
      // Act
      final BundleResponseModel model = BundleResponseModel(
        countCountries: 150,
      );

      // Assert
      expect(model.countCountries, 150);
    });

    test("unlimited flag true", () {
      // Act
      final BundleResponseModel model = BundleResponseModel(
        unlimited: true,
      );

      // Assert
      expect(model.unlimited, true);
    });

    test("unlimited flag false", () {
      // Act
      final BundleResponseModel model = BundleResponseModel(
        unlimited: false,
      );

      // Assert
      expect(model.unlimited, false);
    });

    test("countries list empty", () {
      // Act
      final BundleResponseModel model = BundleResponseModel(
        countries: <CountryResponseModel>[],
      );

      // Assert
      expect(model.countries, isNotNull);
      expect(model.countries, isEmpty);
    });

    test("countries list with multiple items", () {
      // Arrange
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(countryCode: "US"),
        CountryResponseModel(countryCode: "CA"),
        CountryResponseModel(countryCode: "MX"),
      ];

      // Act
      final BundleResponseModel model = BundleResponseModel(
        countries: countries,
      );

      // Assert
      expect(model.countries?.length, 3);
    });

    test("validityLabel formats", () {
      // Act
      final BundleResponseModel model1 =
          BundleResponseModel(validityLabel: "Day");
      final BundleResponseModel model2 =
          BundleResponseModel(validityLabel: "Month");
      final BundleResponseModel model3 =
          BundleResponseModel(validityLabel: "Year");

      // Assert
      expect(model1.validityLabel, "Day");
      expect(model2.validityLabel, "Month");
      expect(model3.validityLabel, "Year");
    });

    test("currency code formats", () {
      // Act
      final BundleResponseModel model1 =
          BundleResponseModel(currencyCode: "USD");
      final BundleResponseModel model2 =
          BundleResponseModel(currencyCode: "EUR");
      final BundleResponseModel model3 =
          BundleResponseModel(currencyCode: "GBP");

      // Assert
      expect(model1.currencyCode, "USD");
      expect(model2.currencyCode, "EUR");
      expect(model3.currencyCode, "GBP");
    });

    test("empty string for label", () {
      // Act
      final BundleResponseModel model = BundleResponseModel(
        label: "",
      );

      // Assert
      expect(model.label, "");
    });

    test("label with custom value", () {
      // Act
      final BundleResponseModel model = BundleResponseModel(
        label: "BEST_VALUE",
      );

      // Assert
      expect(model.label, "BEST_VALUE");
    });

    test("bundleCategory with nested model", () {
      // Arrange
      final BundleCategoryResponseModel category = BundleCategoryResponseModel(
        type: "CRUISE",
        code: "C001",
        title: "Cruise",
      );

      // Act
      final BundleResponseModel model = BundleResponseModel(
        bundleCategory: category,
      );

      // Assert
      expect(model.bundleCategory?.type, "CRUISE");
      expect(model.bundleCategory?.code, "C001");
      expect(model.bundleCategory?.title, "Cruise");
    });

    test("multiple instances are independent", () {
      // Act
      final BundleResponseModel model1 = BundleResponseModel(
        bundleCode: "BUNDLE1",
        price: 10,
      );
      final BundleResponseModel model2 = BundleResponseModel(
        bundleCode: "BUNDLE2",
        price: 20,
      );

      // Assert
      expect(model1.bundleCode, "BUNDLE1");
      expect(model2.bundleCode, "BUNDLE2");
      expect(model1.price, 10.0);
      expect(model2.price, 20.0);
    });

    test("response type is correct", () {
      // Act
      final BundleResponseModel model = BundleResponseModel();

      // Assert
      expect(model, isA<BundleResponseModel>());
    });

    test("getMockGlobalBundles consistency", () {
      // Act
      final List<BundleResponseModel> bundles1 =
          BundleResponseModel.getMockGlobalBundles();
      final List<BundleResponseModel> bundles2 =
          BundleResponseModel.getMockGlobalBundles();

      // Assert
      expect(bundles1.length, bundles2.length);
      expect(bundles1[0].bundleCode, bundles2[0].bundleCode);
    });

    test("ValidityLabelEnum.fromString recognizes 'day'", () {
      // Act
      final ValidityLabelEnum? result = ValidityLabelEnum.fromString("day");

      // Assert
      expect(result, ValidityLabelEnum.days);
    });

    test("ValidityLabelEnum.fromString recognizes 'week'", () {
      // Act
      final ValidityLabelEnum? result = ValidityLabelEnum.fromString("week");

      // Assert
      expect(result, ValidityLabelEnum.weeks);
    });

    test("ValidityLabelEnum.fromString recognizes 'month'", () {
      // Act
      final ValidityLabelEnum? result = ValidityLabelEnum.fromString("month");

      // Assert
      expect(result, ValidityLabelEnum.months);
    });

    test("ValidityLabelEnum.fromString recognizes 'year'", () {
      // Act
      final ValidityLabelEnum? result = ValidityLabelEnum.fromString("year");

      // Assert
      expect(result, ValidityLabelEnum.years);
    });

    test("ValidityLabelEnum.fromString with uppercase 'WEEK'", () {
      // Act
      final ValidityLabelEnum? result = ValidityLabelEnum.fromString("WEEK");

      // Assert
      expect(result, ValidityLabelEnum.weeks);
    });

    test("ValidityLabelEnum.fromString with uppercase 'MONTH'", () {
      // Act
      final ValidityLabelEnum? result = ValidityLabelEnum.fromString("MONTH");

      // Assert
      expect(result, ValidityLabelEnum.months);
    });

    test("ValidityLabelEnum.fromString with uppercase 'YEAR'", () {
      // Act
      final ValidityLabelEnum? result = ValidityLabelEnum.fromString("YEAR");

      // Assert
      expect(result, ValidityLabelEnum.years);
    });

    test("ValidityLabelEnum.getValidityDisplay for weeks singular count", () {
      // Act
      final String result = ValidityLabelEnum.weeks.getValidityDisplay(1);

      // Assert
      expect(result, contains("1"));
      expect(result, contains("week"));
    });

    test("ValidityLabelEnum.getValidityDisplay for weeks plural count", () {
      // Act
      final String result = ValidityLabelEnum.weeks.getValidityDisplay(4);

      // Assert
      expect(result, contains("4"));
      expect(result, contains("week"));
    });

    test("ValidityLabelEnum.getValidityDisplay for months singular count", () {
      // Act
      final String result = ValidityLabelEnum.months.getValidityDisplay(1);

      // Assert
      expect(result, contains("1"));
      expect(result, contains("month"));
    });

    test("ValidityLabelEnum.getValidityDisplay for months plural count", () {
      // Act
      final String result = ValidityLabelEnum.months.getValidityDisplay(3);

      // Assert
      expect(result, contains("3"));
      expect(result, contains("month"));
    });

    test("ValidityLabelEnum.getValidityDisplay for years singular count", () {
      // Act
      final String result = ValidityLabelEnum.years.getValidityDisplay(1);

      // Assert
      expect(result, contains("1"));
      expect(result, contains("year"));
    });

    test("ValidityLabelEnum.getValidityDisplay for years plural count", () {
      // Act
      final String result = ValidityLabelEnum.years.getValidityDisplay(2);

      // Assert
      expect(result, contains("2"));
      expect(result, contains("year"));
    });

    test("ValidityLabelEnum.getValidityDisplay for days singular count", () {
      // Act
      final String result = ValidityLabelEnum.days.getValidityDisplay(1);

      // Assert
      expect(result, contains("1"));
      expect(result, contains("day"));
    });

    test("ValidityLabelEnum.getValidityDisplay for days plural count", () {
      // Act
      final String result = ValidityLabelEnum.days.getValidityDisplay(5);

      // Assert
      expect(result, contains("5"));
      expect(result, contains("day"));
    });

    test("ValidityLabelEnum.getValidityDisplay with null count", () {
      // Act
      final String result = ValidityLabelEnum.weeks.getValidityDisplay(null);

      // Assert
      expect(result, contains("null"));
      expect(result, contains("week"));
    });

    test("ValidityLabelEnum.getValidityDisplay with zero count", () {
      // Act
      final String result = ValidityLabelEnum.months.getValidityDisplay(0);

      // Assert
      expect(result, contains("0"));
      expect(result, contains("month"));
    });

    test("BundleResponseModel.getValidityDisplay with Day label", () {
      // Act
      final BundleResponseModel model = BundleResponseModel(
        validityLabel: "Day",
        validity: 7,
      );

      final String? result = model.getValidityDisplay();

      // Assert
      expect(result, isNotNull);
      expect(result, contains("day"));
    });

    test("BundleResponseModel.getValidityDisplay with Week label", () {
      // Act
      final BundleResponseModel model = BundleResponseModel(
        validityLabel: "Week",
        validity: 2,
      );

      final String? result = model.getValidityDisplay();

      // Assert
      expect(result, isNotNull);
      expect(result, contains("week"));
    });

    test("BundleResponseModel.getValidityDisplay with Month label", () {
      // Act
      final BundleResponseModel model = BundleResponseModel(
        validityLabel: "Month",
        validity: 1,
      );

      final String? result = model.getValidityDisplay();

      // Assert
      expect(result, isNotNull);
      expect(result, contains("month"));
    });

    test("BundleResponseModel.getValidityDisplay with Year label", () {
      // Act
      final BundleResponseModel model = BundleResponseModel(
        validityLabel: "Year",
        validity: 3,
      );

      final String? result = model.getValidityDisplay();

      // Assert
      expect(result, isNotNull);
      expect(result, contains("year"));
    });

    test("BundleResponseModel.getValidityDisplay with null validityLabel", () {
      // Act
      final BundleResponseModel model = BundleResponseModel(
        validity: 7,
      );

      final String? result = model.getValidityDisplay();

      // Assert
      expect(result, isNull);
    });

    test("BundleResponseModel.getValidityDisplay with unknown label", () {
      // Act
      final BundleResponseModel model = BundleResponseModel(
        validityLabel: "Unknown",
        validity: 7,
      );

      final String? result = model.getValidityDisplay();

      // Assert
      expect(result, isNull);
    });

    test("ValidityLabelEnum.toString returns type", () {
      // Assert
      expect(ValidityLabelEnum.days.toString(), "day");
      expect(ValidityLabelEnum.weeks.toString(), "week");
      expect(ValidityLabelEnum.months.toString(), "month");
      expect(ValidityLabelEnum.years.toString(), "year");
    });
  });
}
