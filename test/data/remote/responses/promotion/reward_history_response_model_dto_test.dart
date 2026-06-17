import "package:esim_open_source/data/remote/responses/promotion/reward_history_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/promotion/reward_history_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for RewardHistoryResponseModelDto
/// Tests JSON serialization/deserialization and model methods
void main() {
  group("RewardHistoryResponseModelDto Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "is_referral": false,
        "amount": r"$5.00",
        "name": "Global 1GB 7Days",
        "promotion_name": "10% Cashback",
        "date": "1747125626",
      };

      // Act
      final RewardHistoryResponseModelDto model =
          RewardHistoryResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.isReferral, false);
      expect(model.amount, r"$5.00");
      expect(model.name, "Global 1GB 7Days");
      expect(model.promotionName, "10% Cashback");
      expect(model.date, "1747125626");
    });

    test("fromJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final RewardHistoryResponseModelDto model =
          RewardHistoryResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.isReferral, isNull);
      expect(model.amount, isNull);
      expect(model.name, isNull);
      expect(model.promotionName, isNull);
      expect(model.date, isNull);
    });

    test("fromJson handles null is_referral", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "amount": r"$5.00",
        "name": "Global 1GB 7Days",
      };

      // Act
      final RewardHistoryResponseModelDto model =
          RewardHistoryResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.isReferral, isNull);
      expect(model.amount, r"$5.00");
    });

    test("fromJson handles null amount", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "is_referral": true,
        "name": "Test User",
      };

      // Act
      final RewardHistoryResponseModelDto model =
          RewardHistoryResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.amount, isNull);
      expect(model.isReferral, true);
    });

    test("fromJson handles null name", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "is_referral": false,
        "amount": r"$10.00",
      };

      // Act
      final RewardHistoryResponseModelDto model =
          RewardHistoryResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.name, isNull);
      expect(model.amount, r"$10.00");
    });

    test("fromJson handles null promotion_name", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "is_referral": true,
        "name": "User Email",
      };

      // Act
      final RewardHistoryResponseModelDto model =
          RewardHistoryResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.promotionName, isNull);
      expect(model.isReferral, true);
    });

    test("fromJson handles null date", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "amount": r"$8.00",
        "name": "Bundle Name",
      };

      // Act
      final RewardHistoryResponseModelDto model =
          RewardHistoryResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.date, isNull);
      expect(model.amount, r"$8.00");
    });

    test("fromJson with explicit null values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "is_referral": null,
        "amount": null,
        "name": null,
        "promotion_name": null,
        "date": null,
      };

      // Act
      final RewardHistoryResponseModelDto model =
          RewardHistoryResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.isReferral, isNull);
      expect(model.amount, isNull);
      expect(model.name, isNull);
      expect(model.promotionName, isNull);
      expect(model.date, isNull);
    });

    test("constructor assigns values correctly", () {
      // Act
      final RewardHistoryResponseModelDto model = RewardHistoryResponseModelDto(
        isReferral: true,
        amount: r"$15.00",
        name: "Test Bundle",
        promotionName: "Referral Bonus",
        date: "1747125626",
      );

      // Assert
      expect(model.isReferral, true);
      expect(model.amount, r"$15.00");
      expect(model.name, "Test Bundle");
      expect(model.promotionName, "Referral Bonus");
      expect(model.date, "1747125626");
    });

    test("all fields are nullable", () {
      // Act
      final RewardHistoryResponseModelDto model =
          RewardHistoryResponseModelDto();

      // Assert
      expect(model.isReferral, isNull);
      expect(model.amount, isNull);
      expect(model.name, isNull);
      expect(model.promotionName, isNull);
      expect(model.date, isNull);
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final RewardHistoryResponseModelDto model = RewardHistoryResponseModelDto(
        isReferral: false,
        amount: r"$5.00",
        name: "Global 1GB 7Days",
        promotionName: "10% Cashback",
        date: "1747125626",
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["is_referral"], false);
      expect(json["amount"], r"$5.00");
      expect(json["name"], "Global 1GB 7Days");
      expect(json["promotion_name"], "10% Cashback");
      expect(json["date"], "1747125626");
    });

    test("toJson handles null fields", () {
      // Arrange
      final RewardHistoryResponseModelDto model =
          RewardHistoryResponseModelDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["is_referral"], isNull);
      expect(json["amount"], isNull);
      expect(json["name"], isNull);
      expect(json["promotion_name"], isNull);
      expect(json["date"], isNull);
    });

    test("fromJsonList creates list from json array", () {
      // Arrange
      final List<Map<String, dynamic>> jsonList = <Map<String, dynamic>>[
        <String, dynamic>{
          "is_referral": false,
          "amount": r"$5.00",
          "name": "Global 1GB 7Days",
        },
        <String, dynamic>{
          "is_referral": true,
          "amount": r"$5.00",
          "name": "kareem_chaheen123@yahoo.com",
        },
      ];

      // Act
      final List<RewardHistoryResponseModelDto> models =
          RewardHistoryResponseModelDto.fromJsonList(json: jsonList);

      // Assert
      expect(models.length, 2);
      expect(models[0].isReferral, false);
      expect(models[0].name, "Global 1GB 7Days");
      expect(models[1].isReferral, true);
      expect(models[1].name, "kareem_chaheen123@yahoo.com");
    });

    test("fromJsonList handles empty list", () {
      // Arrange
      final List<dynamic> jsonList = <dynamic>[];

      // Act
      final List<RewardHistoryResponseModelDto> models =
          RewardHistoryResponseModelDto.fromJsonList(json: jsonList);

      // Assert
      expect(models, isEmpty);
    });

    test("toDomain maps all fields correctly", () {
      // Arrange
      final RewardHistoryResponseModelDto model = RewardHistoryResponseModelDto(
        isReferral: false,
        amount: r"$5.00",
        name: "Global 1GB 7Days",
        promotionName: "10% Cashback",
        date: "1747125626",
      );

      // Act
      final RewardHistoryResponseModel domain = model.toDomain();

      // Assert
      expect(domain.isReferral, false);
      expect(domain.amount, r"$5.00");
      expect(domain.name, "Global 1GB 7Days");
      expect(domain.promotionName, "10% Cashback");
      expect(domain.date, "1747125626");
    });

    test("toDomain handles null fields", () {
      // Arrange
      final RewardHistoryResponseModelDto model =
          RewardHistoryResponseModelDto(name: "Test");

      // Act
      final RewardHistoryResponseModel domain = model.toDomain();

      // Assert
      expect(domain.name, "Test");
      expect(domain.isReferral, isNull);
      expect(domain.amount, isNull);
      expect(domain.promotionName, isNull);
      expect(domain.date, isNull);
    });

    test("roundtrip fromJson and toJson preserves data", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "is_referral": false,
        "amount": r"$5.00",
        "name": "Global 1GB 7Days",
        "promotion_name": "10% Cashback",
        "date": "1747125626",
      };

      // Act
      final RewardHistoryResponseModelDto model =
          RewardHistoryResponseModelDto.fromJson(json: originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(resultJson["is_referral"], originalJson["is_referral"]);
      expect(resultJson["amount"], originalJson["amount"]);
      expect(resultJson["name"], originalJson["name"]);
      expect(resultJson["promotion_name"], originalJson["promotion_name"]);
      expect(resultJson["date"], originalJson["date"]);
    });

    test("fromJson handles empty string values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "amount": "",
        "name": "",
        "promotion_name": "",
      };

      // Act
      final RewardHistoryResponseModelDto model =
          RewardHistoryResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.amount, "");
      expect(model.name, "");
      expect(model.promotionName, "");
    });

    test("fromJson with special characters in strings", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "name": "José García",
        "promotion_name": "O'Reilly's Offer",
      };

      // Act
      final RewardHistoryResponseModelDto model =
          RewardHistoryResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.name, "José García");
      expect(model.promotionName, "O'Reilly's Offer");
    });

    test("mockData returns list of rewards", () {
      // Act
      final List<RewardHistoryResponseModelDto> items =
          RewardHistoryResponseModelDto.mockData;

      // Assert
      expect(items, isNotEmpty);
      expect(items.length, 2);
    });

    test("mockData all items have required fields", () {
      // Act
      final List<RewardHistoryResponseModelDto> items =
          RewardHistoryResponseModelDto.mockData;

      // Assert
      for (final RewardHistoryResponseModelDto item in items) {
        expect(item.isReferral, isNotNull);
        expect(item.amount, isNotNull);
      }
    });

    test("mockData first item has expected values", () {
      // Act
      final List<RewardHistoryResponseModelDto> items =
          RewardHistoryResponseModelDto.mockData;
      final RewardHistoryResponseModelDto first = items[0];

      // Assert
      expect(first.isReferral, false);
      expect(first.name, "Global 1GB 7Days");
      expect(first.promotionName, "10% Cashback");
      expect(first.amount, r"$5.00");
      expect(first.date, "1747125626");
    });

    test("mockData second item is referral", () {
      // Act
      final List<RewardHistoryResponseModelDto> items =
          RewardHistoryResponseModelDto.mockData;
      final RewardHistoryResponseModelDto second = items[1];

      // Assert
      expect(second.isReferral, true);
      expect(second.name, "kareem_chaheen123@yahoo.com");
      expect(second.promotionName, "");
    });

    test("handles boolean is_referral true", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "is_referral": true,
      };

      // Act
      final RewardHistoryResponseModelDto model =
          RewardHistoryResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.isReferral, true);
      expect(model.isReferral, isA<bool>());
    });

    test("handles boolean is_referral false", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "is_referral": false,
      };

      // Act
      final RewardHistoryResponseModelDto model =
          RewardHistoryResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.isReferral, false);
      expect(model.isReferral, isA<bool>());
    });

    test("multiple instances are independent", () {
      // Act
      final RewardHistoryResponseModelDto model1 =
          RewardHistoryResponseModelDto(name: "Bundle 1");
      final RewardHistoryResponseModelDto model2 =
          RewardHistoryResponseModelDto(name: "Bundle 2");

      // Assert
      expect(model1.name, "Bundle 1");
      expect(model2.name, "Bundle 2");
    });
  });
}
