import "package:esim_open_source/data/remote/responses/app/currencies_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/app/currencies_response_model.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("CurrenciesResponseModelDto Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "currency": "USD",
      };

      // Act
      final CurrenciesResponseModelDto model =
          CurrenciesResponseModelDto.fromJson(json);

      // Assert
      expect(model.currency, "USD");
    });

    test("fromJson handles null currency", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "currency": null,
      };

      // Act
      final CurrenciesResponseModelDto model =
          CurrenciesResponseModelDto.fromJson(json);

      // Assert
      expect(model.currency, isNull);
    });

    test("fromJson handles missing currency field", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final CurrenciesResponseModelDto model =
          CurrenciesResponseModelDto.fromJson(json);

      // Assert
      expect(model.currency, isNull);
    });

    test("fromAPIJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "currency": "EUR",
      };

      // Act
      final CurrenciesResponseModelDto model =
          CurrenciesResponseModelDto.fromAPIJson(json: json);

      // Assert
      expect(model.currency, "EUR");
    });

    test("fromAPIJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final CurrenciesResponseModelDto model =
          CurrenciesResponseModelDto.fromAPIJson(json: json);

      // Assert
      expect(model.currency, isNull);
    });

    test("fromJson and fromAPIJson produce identical results", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "currency": "GBP",
      };

      // Act
      final CurrenciesResponseModelDto fromJsonModel =
          CurrenciesResponseModelDto.fromJson(json);
      final CurrenciesResponseModelDto fromAPIJsonModel =
          CurrenciesResponseModelDto.fromAPIJson(json: json);

      // Assert
      expect(fromJsonModel.currency, fromAPIJsonModel.currency);
    });

    test("constructor assigns values correctly", () {
      // Act
      final CurrenciesResponseModelDto model = CurrenciesResponseModelDto(
        currency: "JPY",
      );

      // Assert
      expect(model.currency, "JPY");
    });

    test("constructor with null currency", () {
      // Act
      final CurrenciesResponseModelDto model = CurrenciesResponseModelDto(
        currency: null,
      );

      // Assert
      expect(model.currency, isNull);
    });

    test("constructor without parameters", () {
      // Act
      final CurrenciesResponseModelDto model = CurrenciesResponseModelDto();

      // Assert
      expect(model.currency, isNull);
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final CurrenciesResponseModelDto model = CurrenciesResponseModelDto(
        currency: "CAD",
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["currency"], "CAD");
    });

    test("toJson handles null fields", () {
      // Arrange
      final CurrenciesResponseModelDto model = CurrenciesResponseModelDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["currency"], isNull);
    });

    test("fromJsonList creates list from json array", () {
      // Arrange
      final List<Map<String, dynamic>> jsonList = <Map<String, dynamic>>[
        <String, dynamic>{"currency": "USD"},
        <String, dynamic>{"currency": "EUR"},
        <String, dynamic>{"currency": "GBP"},
      ];

      // Act
      final List<CurrenciesResponseModelDto> models =
          CurrenciesResponseModelDto.fromJsonList(json: jsonList);

      // Assert
      expect(models.length, 3);
      expect(models[0].currency, "USD");
      expect(models[1].currency, "EUR");
      expect(models[2].currency, "GBP");
    });

    test("fromJsonList handles empty list", () {
      // Arrange
      final List<dynamic> jsonList = <dynamic>[];

      // Act
      final List<CurrenciesResponseModelDto> models =
          CurrenciesResponseModelDto.fromJsonList(json: jsonList);

      // Assert
      expect(models, isEmpty);
    });

    test("fromJsonList handles list with null items", () {
      // Arrange
      final List<Map<String, dynamic>> jsonList = <Map<String, dynamic>>[
        <String, dynamic>{"currency": "USD"},
        <String, dynamic>{"currency": null},
        <String, dynamic>{"currency": "EUR"},
      ];

      // Act
      final List<CurrenciesResponseModelDto> models =
          CurrenciesResponseModelDto.fromJsonList(json: jsonList);

      // Assert
      expect(models.length, 3);
      expect(models[0].currency, "USD");
      expect(models[1].currency, isNull);
      expect(models[2].currency, "EUR");
    });

    test("roundtrip fromJson and toJson preserves data", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "currency": "AUD",
      };

      // Act
      final CurrenciesResponseModelDto model =
          CurrenciesResponseModelDto.fromJson(originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(resultJson["currency"], originalJson["currency"]);
    });

    test("handles empty string currency", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "currency": "",
      };

      // Act
      final CurrenciesResponseModelDto model =
          CurrenciesResponseModelDto.fromJson(json);

      // Assert
      expect(model.currency, "");
    });

    test("handles various currency codes", () {
      // Arrange
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
        "ZAR",
      ];

      // Act & Assert
      for (final String code in currencyCodes) {
        final Map<String, dynamic> json = <String, dynamic>{"currency": code};
        final CurrenciesResponseModelDto model =
            CurrenciesResponseModelDto.fromJson(json);
        expect(model.currency, code);
      }
    });

    test("multiple instances are independent", () {
      // Act
      final CurrenciesResponseModelDto model1 = CurrenciesResponseModelDto(
        currency: "USD",
      );
      final CurrenciesResponseModelDto model2 = CurrenciesResponseModelDto(
        currency: "EUR",
      );

      // Assert
      expect(model1.currency, "USD");
      expect(model2.currency, "EUR");
    });

    test("toDomain converts DTO to domain model with currency", () {
      // Arrange
      final CurrenciesResponseModelDto dto = CurrenciesResponseModelDto(
        currency: "USD",
      );

      // Act
      final CurrenciesResponseModel domainModel = dto.toDomain();

      // Assert
      expect(domainModel.currency, "USD");
    });

    test("toDomain converts DTO to domain model with null currency", () {
      // Arrange
      final CurrenciesResponseModelDto dto = CurrenciesResponseModelDto();

      // Act
      final CurrenciesResponseModel domainModel = dto.toDomain();

      // Assert
      expect(domainModel.currency, isNull);
    });

    test("roundtrip toDomain preserves currency data", () {
      // Arrange
      final CurrenciesResponseModelDto originalDto =
          CurrenciesResponseModelDto(
        currency: "GBP",
      );

      // Act
      final CurrenciesResponseModel domainModel = originalDto.toDomain();

      // Assert
      expect(domainModel.currency, "GBP");
    });

    test("toDomain converts multiple different currencies", () {
      // Arrange
      final List<String> currencies = <String>["USD", "EUR", "GBP", "JPY"];

      // Act & Assert
      for (final String currency in currencies) {
        final CurrenciesResponseModelDto dto = CurrenciesResponseModelDto(
          currency: currency,
        );
        final CurrenciesResponseModel domainModel = dto.toDomain();
        expect(domainModel.currency, currency);
      }
    });
  });
}
