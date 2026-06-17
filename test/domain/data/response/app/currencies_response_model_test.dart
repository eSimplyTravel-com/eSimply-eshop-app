import "package:esim_open_source/domain/data/response/app/currencies_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for CurrenciesResponseModel
/// Tests constructor, getters, and field assignment
void main() {
  group("CurrenciesResponseModel Tests", () {
    test("constructor assigns currency correctly", () {
      // Act
      final CurrenciesResponseModel model = CurrenciesResponseModel(
        currency: "USD",
      );

      // Assert
      expect(model.currency, "USD");
    });

    test("constructor with null currency", () {
      // Act
      final CurrenciesResponseModel model = CurrenciesResponseModel();

      // Assert
      expect(model.currency, isNull);
    });

    test("currency field is nullable", () {
      // Act
      final CurrenciesResponseModel model = CurrenciesResponseModel(
        currency: null,
      );

      // Assert
      expect(model.currency, isNull);
    });

    test("currency getter returns correct value", () {
      // Act
      final CurrenciesResponseModel model = CurrenciesResponseModel(
        currency: "EUR",
      );

      // Assert
      expect(model.currency, "EUR");
    });

    test("handles empty string currency", () {
      // Act
      final CurrenciesResponseModel model = CurrenciesResponseModel(
        currency: "",
      );

      // Assert
      expect(model.currency, "");
    });

    test("handles three-letter currency codes", () {
      // Act
      final CurrenciesResponseModel usdModel = CurrenciesResponseModel(
        currency: "USD",
      );
      final CurrenciesResponseModel eurModel = CurrenciesResponseModel(
        currency: "EUR",
      );
      final CurrenciesResponseModel gbpModel = CurrenciesResponseModel(
        currency: "GBP",
      );
      final CurrenciesResponseModel jpyModel = CurrenciesResponseModel(
        currency: "JPY",
      );

      // Assert
      expect(usdModel.currency, "USD");
      expect(eurModel.currency, "EUR");
      expect(gbpModel.currency, "GBP");
      expect(jpyModel.currency, "JPY");
    });

    test("handles lowercase currency codes", () {
      // Act
      final CurrenciesResponseModel model = CurrenciesResponseModel(
        currency: "usd",
      );

      // Assert
      expect(model.currency, "usd");
    });

    test("handles mixed case currency codes", () {
      // Act
      final CurrenciesResponseModel model = CurrenciesResponseModel(
        currency: "Eur",
      );

      // Assert
      expect(model.currency, "Eur");
    });

    test("handles currency with special characters", () {
      // Act
      final CurrenciesResponseModel model = CurrenciesResponseModel(
        currency: "USD/EUR",
      );

      // Assert
      expect(model.currency, "USD/EUR");
    });

    test("handles numeric currency codes", () {
      // Act
      final CurrenciesResponseModel model = CurrenciesResponseModel(
        currency: "840", // ISO 4217 numeric code for USD
      );

      // Assert
      expect(model.currency, "840");
    });

    test("multiple instances are independent", () {
      // Act
      final CurrenciesResponseModel model1 = CurrenciesResponseModel(
        currency: "USD",
      );
      final CurrenciesResponseModel model2 = CurrenciesResponseModel(
        currency: "EUR",
      );

      // Assert
      expect(model1.currency, "USD");
      expect(model2.currency, "EUR");
    });

    test("currency values are preserved", () {
      // Act
      final CurrenciesResponseModel usdModel = CurrenciesResponseModel(
        currency: "USD",
      );
      final CurrenciesResponseModel eurModel = CurrenciesResponseModel(
        currency: "EUR",
      );
      final CurrenciesResponseModel inrModel = CurrenciesResponseModel(
        currency: "INR",
      );

      // Assert
      expect(usdModel.currency, "USD");
      expect(eurModel.currency, "EUR");
      expect(inrModel.currency, "INR");
    });

    test("common currency codes are handled correctly", () {
      // Act & Assert - Test common currencies
      final List<String> currencyCodes = <String>[
        "USD",
        "EUR",
        "GBP",
        "JPY",
        "CHF",
        "CAD",
        "AUD",
        "NZD",
        "INR",
        "SGD",
      ];

      for (final String code in currencyCodes) {
        final CurrenciesResponseModel model = CurrenciesResponseModel(
          currency: code,
        );
        expect(model.currency, code);
      }
    });

    test("handles whitespace in currency code", () {
      // Act
      final CurrenciesResponseModel model = CurrenciesResponseModel(
        currency: " USD ",
      );

      // Assert
      expect(model.currency, " USD ");
    });

    test("handles long currency strings", () {
      // Act
      final String longCurrency = "USD_ALTERNATIVE_CURRENCY_CODE_VERY_LONG";
      final CurrenciesResponseModel model = CurrenciesResponseModel(
        currency: longCurrency,
      );

      // Assert
      expect(model.currency, longCurrency);
    });
  });
}
