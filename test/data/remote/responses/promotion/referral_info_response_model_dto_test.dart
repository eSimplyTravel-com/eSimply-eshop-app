import "dart:convert";

import "package:esim_open_source/data/remote/responses/promotion/referral_info_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/promotion/referral_info_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for ReferralInfoResponseModelDto
/// Tests JSON serialization/deserialization and model methods
void main() {
  group("ReferralInfoResponseModelDto Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "amount": 50.0,
        "currency": "USD",
        "type": "referral",
        "message": "Referral reward",
      };

      // Act
      final ReferralInfoResponseModelDto model =
          ReferralInfoResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.amount, 50.0);
      expect(model.currency, "USD");
      expect(model.type, "referral");
      expect(model.message, "Referral reward");
    });

    test("fromJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final ReferralInfoResponseModelDto model =
          ReferralInfoResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.amount, isNull);
      expect(model.currency, isNull);
      expect(model.type, isNull);
      expect(model.message, isNull);
    });

    test("fromJson handles null amount", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "currency": "EUR",
        "type": "bonus",
      };

      // Act
      final ReferralInfoResponseModelDto model =
          ReferralInfoResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.amount, isNull);
      expect(model.currency, "EUR");
    });

    test("fromJson handles null currency", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "amount": 25.0,
        "type": "cashback",
      };

      // Act
      final ReferralInfoResponseModelDto model =
          ReferralInfoResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.currency, isNull);
      expect(model.amount, 25.0);
    });

    test("fromJson handles null type", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "amount": 30.0,
        "currency": "GBP",
      };

      // Act
      final ReferralInfoResponseModelDto model =
          ReferralInfoResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.type, isNull);
      expect(model.amount, 30.0);
    });

    test("fromJson handles null message", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "amount": 40.0,
        "currency": "CAD",
      };

      // Act
      final ReferralInfoResponseModelDto model =
          ReferralInfoResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.message, isNull);
      expect(model.amount, 40.0);
    });

    test("fromJson with explicit null values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "amount": null,
        "currency": null,
        "type": null,
        "message": null,
      };

      // Act
      final ReferralInfoResponseModelDto model =
          ReferralInfoResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.amount, isNull);
      expect(model.currency, isNull);
      expect(model.type, isNull);
      expect(model.message, isNull);
    });

    test("constructor assigns values correctly", () {
      // Act
      final ReferralInfoResponseModelDto model = ReferralInfoResponseModelDto(
        amount: 100.0,
        currency: "AUD",
        type: "sign_up",
        message: "Welcome bonus",
      );

      // Assert
      expect(model.amount, 100.0);
      expect(model.currency, "AUD");
      expect(model.type, "sign_up");
      expect(model.message, "Welcome bonus");
    });

    test("all fields are nullable", () {
      // Act
      final ReferralInfoResponseModelDto model = ReferralInfoResponseModelDto();

      // Assert
      expect(model.amount, isNull);
      expect(model.currency, isNull);
      expect(model.type, isNull);
      expect(model.message, isNull);
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final ReferralInfoResponseModelDto model = ReferralInfoResponseModelDto(
        amount: 50.0,
        currency: "USD",
        type: "referral",
        message: "Referral reward",
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["amount"], 50.0);
      expect(json["currency"], "USD");
      expect(json["type"], "referral");
      expect(json["message"], "Referral reward");
    });

    test("toJson handles null fields", () {
      // Arrange
      final ReferralInfoResponseModelDto model = ReferralInfoResponseModelDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["amount"], isNull);
      expect(json["currency"], isNull);
      expect(json["type"], isNull);
      expect(json["message"], isNull);
    });

    test("copyWith creates new instance with updated fields", () {
      // Arrange
      final ReferralInfoResponseModelDto original =
          ReferralInfoResponseModelDto(
        amount: 50.0,
        currency: "USD",
        type: "referral",
        message: "Original message",
      );

      // Act
      final ReferralInfoResponseModelDto updated = original.copyWith(
        amount: 75.0,
        message: "Updated message",
      );

      // Assert
      expect(updated.amount, 75.0);
      expect(updated.currency, "USD");
      expect(updated.type, "referral");
      expect(updated.message, "Updated message");
    });

    test("copyWith without parameters returns same values", () {
      // Arrange
      final ReferralInfoResponseModelDto original =
          ReferralInfoResponseModelDto(
        amount: 50.0,
        currency: "USD",
        type: "referral",
        message: "Test message",
      );

      // Act
      final ReferralInfoResponseModelDto copied = original.copyWith();

      // Assert
      expect(copied.amount, original.amount);
      expect(copied.currency, original.currency);
      expect(copied.type, original.type);
      expect(copied.message, original.message);
    });

    test("copyWith preserves null values when not specified", () {
      // Arrange
      final ReferralInfoResponseModelDto original =
          ReferralInfoResponseModelDto(
        amount: 50.0,
        currency: "USD",
      );

      // Act
      final ReferralInfoResponseModelDto updated = original.copyWith(
        message: "New message",
      );

      // Assert
      expect(updated.amount, 50.0);
      expect(updated.currency, "USD");
      expect(updated.type, isNull);
      expect(updated.message, "New message");
    });

    test("copyWith preserves original instance", () {
      // Arrange
      final ReferralInfoResponseModelDto original =
          ReferralInfoResponseModelDto(
        amount: 50.0,
        currency: "USD",
      );

      // Act
      final ReferralInfoResponseModelDto updated = original.copyWith(
        amount: 100.0,
      );

      // Assert
      expect(original.amount, 50.0);
      expect(updated.amount, 100.0);
    });

    test("toJsonString converts model to JSON string", () {
      // Arrange
      final ReferralInfoResponseModelDto model = ReferralInfoResponseModelDto(
        amount: 50.0,
        currency: "USD",
        type: "referral",
        message: "Test message",
      );

      // Act
      final String jsonString = model.toJsonString();
      final Map<String, dynamic> decoded = jsonDecode(jsonString);

      // Assert
      expect(decoded["amount"], 50.0);
      expect(decoded["currency"], "USD");
      expect(decoded["type"], "referral");
      expect(decoded["message"], "Test message");
    });

    test("toJsonString produces valid JSON", () {
      // Arrange
      final ReferralInfoResponseModelDto model = ReferralInfoResponseModelDto(
        amount: 50.0,
        currency: "USD",
      );

      // Act
      final String jsonString = model.toJsonString();

      // Assert
      expect(() => jsonDecode(jsonString), returnsNormally);
      final dynamic decoded = jsonDecode(jsonString);
      expect(decoded, isA<Map<String, dynamic>>());
    });

    test("referralInfoFromJsonString parses JSON string correctly", () {
      // Arrange
      final String jsonString = """
      {
        "amount": 50.0,
        "currency": "USD",
        "type": "referral",
        "message": "Test message"
      }
      """;

      // Act
      final ReferralInfoResponseModelDto model =
          ReferralInfoResponseModelDto.referralInfoFromJsonString(jsonString);

      // Assert
      expect(model.amount, 50.0);
      expect(model.currency, "USD");
      expect(model.type, "referral");
      expect(model.message, "Test message");
    });

    test("referralInfoFromJsonString handles whitespace in JSON", () {
      // Arrange
      final String jsonString = """


      {
        "amount":    50.0,
        "currency":    "USD"
      }


      """;

      // Act
      final ReferralInfoResponseModelDto model =
          ReferralInfoResponseModelDto.referralInfoFromJsonString(jsonString);

      // Assert
      expect(model.amount, 50.0);
      expect(model.currency, "USD");
    });

    test("referralInfoFromJsonString throws on invalid JSON", () {
      // Arrange
      final String invalidJson = "{ invalid json }";

      // Act & Assert
      expect(
        () => ReferralInfoResponseModelDto.referralInfoFromJsonString(
          invalidJson,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test("fromDomain creates instance from domain model", () {
      // Arrange
      final ReferralInfoResponseModel domain = ReferralInfoResponseModel(
        amount: 75.0,
        currency: "EUR",
        type: "referral",
        message: "Domain message",
      );

      // Act
      final ReferralInfoResponseModelDto dto =
          ReferralInfoResponseModelDto.fromDomain(domain);

      // Assert
      expect(dto.amount, 75.0);
      expect(dto.currency, "EUR");
      expect(dto.type, "referral");
      expect(dto.message, "Domain message");
    });

    test("toDomain maps all fields correctly", () {
      // Arrange
      final ReferralInfoResponseModelDto model = ReferralInfoResponseModelDto(
        amount: 50.0,
        currency: "USD",
        type: "referral",
        message: "Test message",
      );

      // Act
      final ReferralInfoResponseModel domain = model.toDomain();

      // Assert
      expect(domain.amount, 50.0);
      expect(domain.currency, "USD");
      expect(domain.type, "referral");
      expect(domain.message, "Test message");
    });

    test("toDomain handles null fields", () {
      // Arrange
      final ReferralInfoResponseModelDto model = ReferralInfoResponseModelDto(
        amount: 50.0,
      );

      // Act
      final ReferralInfoResponseModel domain = model.toDomain();

      // Assert
      expect(domain.amount, 50.0);
      expect(domain.currency, isNull);
      expect(domain.type, isNull);
      expect(domain.message, isNull);
    });

    test("roundtrip fromJson and toJson preserves data", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "amount": 50.0,
        "currency": "USD",
        "type": "referral",
        "message": "Test message",
      };

      // Act
      final ReferralInfoResponseModelDto model =
          ReferralInfoResponseModelDto.fromJson(json: originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(resultJson["amount"], originalJson["amount"]);
      expect(resultJson["currency"], originalJson["currency"]);
      expect(resultJson["type"], originalJson["type"]);
      expect(resultJson["message"], originalJson["message"]);
    });

    test("roundtrip fromJsonString and toJsonString preserves data", () {
      // Arrange
      final ReferralInfoResponseModelDto original =
          ReferralInfoResponseModelDto(
        amount: 50.0,
        currency: "USD",
        type: "referral",
        message: "Test message",
      );

      // Act
      final String jsonString = original.toJsonString();
      final ReferralInfoResponseModelDto parsed =
          ReferralInfoResponseModelDto.referralInfoFromJsonString(jsonString);

      // Assert
      expect(parsed.amount, original.amount);
      expect(parsed.currency, original.currency);
      expect(parsed.type, original.type);
      expect(parsed.message, original.message);
    });

    test("handles amount as integer", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "amount": 100,
      };

      // Act
      final ReferralInfoResponseModelDto model =
          ReferralInfoResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.amount, 100);
    });

    test("handles amount as double", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "amount": 99.99,
      };

      // Act
      final ReferralInfoResponseModelDto model =
          ReferralInfoResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.amount, 99.99);
    });

    test("handles zero amount", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "amount": 0,
      };

      // Act
      final ReferralInfoResponseModelDto model =
          ReferralInfoResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.amount, 0);
    });

    test("handles negative amount", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "amount": -10.0,
      };

      // Act
      final ReferralInfoResponseModelDto model =
          ReferralInfoResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.amount, -10.0);
    });

    test("handles large amount values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "amount": 999999.99,
      };

      // Act
      final ReferralInfoResponseModelDto model =
          ReferralInfoResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.amount, 999999.99);
    });

    test("fromJson handles empty string values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "currency": "",
        "type": "",
        "message": "",
      };

      // Act
      final ReferralInfoResponseModelDto model =
          ReferralInfoResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.currency, "");
      expect(model.type, "");
      expect(model.message, "");
    });

    test("fromJson with special characters in strings", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "currency": "USD€",
        "message": "Bonus: O'Reilly's offer!",
      };

      // Act
      final ReferralInfoResponseModelDto model =
          ReferralInfoResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.currency, "USD€");
      expect(model.message, "Bonus: O'Reilly's offer!");
    });

    test("multiple instances are independent", () {
      // Act
      final ReferralInfoResponseModelDto model1 = ReferralInfoResponseModelDto(
        amount: 50.0,
        currency: "USD",
      );
      final ReferralInfoResponseModelDto model2 = ReferralInfoResponseModelDto(
        amount: 100.0,
        currency: "EUR",
      );

      // Assert
      expect(model1.amount, 50.0);
      expect(model1.currency, "USD");
      expect(model2.amount, 100.0);
      expect(model2.currency, "EUR");
    });

    test("toJson preserves amount precision", () {
      // Arrange
      final ReferralInfoResponseModelDto model = ReferralInfoResponseModelDto(
        amount: 123.456789,
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["amount"], 123.456789);
    });
  });
}
