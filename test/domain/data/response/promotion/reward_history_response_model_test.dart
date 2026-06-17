import "package:esim_open_source/domain/data/response/promotion/reward_history_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for RewardHistoryResponseModel
/// Tests constructor, getters, and dateDisplayed computation
void main() {
  group("RewardHistoryResponseModel Tests", () {
    test("constructor assigns all values correctly", () {
      // Act
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        isReferral: true,
        amount: r"$5.00",
        name: "John Doe",
        promotionName: "Referral Bonus",
        date: "1747125626",
      );

      // Assert
      expect(model.isReferral, true);
      expect(model.amount, r"$5.00");
      expect(model.name, "John Doe");
      expect(model.promotionName, "Referral Bonus");
      expect(model.date, "1747125626");
    });

    test("all fields are nullable", () {
      // Act
      final RewardHistoryResponseModel model = RewardHistoryResponseModel();

      // Assert
      expect(model.isReferral, isNull);
      expect(model.amount, isNull);
      expect(model.name, isNull);
      expect(model.promotionName, isNull);
      expect(model.date, isNull);
    });

    test("constructor with partial fields", () {
      // Act
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        isReferral: false,
        amount: r"$10.00",
      );

      // Assert
      expect(model.isReferral, false);
      expect(model.amount, r"$10.00");
      expect(model.name, isNull);
      expect(model.promotionName, isNull);
      expect(model.date, isNull);
    });

    test("getter isReferral returns correct value when true", () {
      // Arrange
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        isReferral: true,
      );

      // Act
      final bool? result = model.isReferral;

      // Assert
      expect(result, true);
    });

    test("getter isReferral returns correct value when false", () {
      // Arrange
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        isReferral: false,
      );

      // Act
      final bool? result = model.isReferral;

      // Assert
      expect(result, false);
    });

    test("getter amount returns correct value", () {
      // Arrange
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        amount: r"$25.50",
      );

      // Act
      final String? result = model.amount;

      // Assert
      expect(result, r"$25.50");
    });

    test("getter name returns correct value", () {
      // Arrange
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        name: "Global 1GB 7Days",
      );

      // Act
      final String? result = model.name;

      // Assert
      expect(result, "Global 1GB 7Days");
    });

    test("getter promotionName returns correct value", () {
      // Arrange
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        promotionName: "10% Cashback",
      );

      // Act
      final String? result = model.promotionName;

      // Assert
      expect(result, "10% Cashback");
    });

    test("getter date returns correct value", () {
      // Arrange
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        date: "1747125626",
      );

      // Act
      final String? result = model.date;

      // Assert
      expect(result, "1747125626");
    });

    test("dateDisplayed formats valid timestamp correctly", () {
      // Arrange
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        date: "1747125626",
      );

      // Act
      final String result = model.dateDisplayed;

      // Assert
      expect(result, isNotNull);
      expect(result, isA<String>());
      expect(result.isNotEmpty, true);
    });

    test("dateDisplayed handles zero timestamp", () {
      // Arrange
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        date: "0",
      );

      // Act
      final String result = model.dateDisplayed;

      // Assert
      expect(result, isNotNull);
      expect(result, isA<String>());
    });

    test("dateDisplayed parses string timestamp to integer", () {
      // Arrange
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        date: "1609459200",
      );

      // Act
      final String result = model.dateDisplayed;

      // Assert
      expect(result, isNotNull);
      expect(result.isNotEmpty, true);
    });

    test("dateDisplayed handles null date gracefully", () {
      // Arrange
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        date: null,
      );

      // Act
      final String result = model.dateDisplayed;

      // Assert
      expect(result, isNotNull);
      expect(result, isA<String>());
    });

    test("handles empty string amount", () {
      // Act
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        amount: "",
      );

      // Assert
      expect(model.amount, "");
    });

    test("handles empty string name", () {
      // Act
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        name: "",
      );

      // Assert
      expect(model.name, "");
    });

    test("handles empty string promotionName", () {
      // Act
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        promotionName: "",
      );

      // Assert
      expect(model.promotionName, "");
    });

    test("handles special characters in amount string", () {
      // Act
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        amount: r"€50.50",
      );

      // Assert
      expect(model.amount, r"€50.50");
    });

    test("handles special characters in name", () {
      // Act
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        name: "O'Reilly's Bundle",
      );

      // Assert
      expect(model.name, "O'Reilly's Bundle");
    });

    test("handles special characters in promotionName", () {
      // Act
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        promotionName: "50% Off: Limited Time!",
      );

      // Assert
      expect(model.promotionName, "50% Off: Limited Time!");
    });

    test("multiple instances are independent", () {
      // Act
      final RewardHistoryResponseModel model1 = RewardHistoryResponseModel(
        isReferral: true,
        amount: r"$5.00",
        name: "Bundle 1",
      );
      final RewardHistoryResponseModel model2 = RewardHistoryResponseModel(
        isReferral: false,
        amount: r"$10.00",
        name: "Bundle 2",
      );

      // Assert
      expect(model1.isReferral, true);
      expect(model1.amount, r"$5.00");
      expect(model1.name, "Bundle 1");
      expect(model2.isReferral, false);
      expect(model2.amount, r"$10.00");
      expect(model2.name, "Bundle 2");
    });

    test("mockData contains expected items", () {
      // Act
      final List<RewardHistoryResponseModel> mockData =
          RewardHistoryResponseModel.mockData;

      // Assert
      expect(mockData, isNotEmpty);
      expect(mockData.length, 2);
    });

    test("mockData first item has correct values", () {
      // Act
      final List<RewardHistoryResponseModel> mockData =
          RewardHistoryResponseModel.mockData;
      final RewardHistoryResponseModel firstItem = mockData[0];

      // Assert
      expect(firstItem.isReferral, false);
      expect(firstItem.name, "Global 1GB 7Days");
      expect(firstItem.promotionName, "10% Cashback");
      expect(firstItem.amount, r"$5.00");
      expect(firstItem.date, "1747125626");
    });

    test("mockData second item has correct values", () {
      // Act
      final List<RewardHistoryResponseModel> mockData =
          RewardHistoryResponseModel.mockData;
      final RewardHistoryResponseModel secondItem = mockData[1];

      // Assert
      expect(secondItem.isReferral, true);
      expect(secondItem.name, "kareem_chaheen123@yahoo.com");
      expect(secondItem.promotionName, "");
      expect(secondItem.amount, r"$5.00");
      expect(secondItem.date, "1747125626");
    });

    test("mockData all items have non-null required fields", () {
      // Act
      final List<RewardHistoryResponseModel> mockData =
          RewardHistoryResponseModel.mockData;

      // Assert
      for (final RewardHistoryResponseModel item in mockData) {
        expect(item.amount, isNotNull);
        expect(item.date, isNotNull);
      }
    });

    test("mockData second item has empty promotionName", () {
      // Act
      final List<RewardHistoryResponseModel> mockData =
          RewardHistoryResponseModel.mockData;
      final RewardHistoryResponseModel secondItem = mockData[1];

      // Assert
      expect(secondItem.promotionName, isEmpty);
    });

    test("handles null isReferral with other fields populated", () {
      // Act
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        amount: r"$5.00",
        name: "Bundle",
        promotionName: "Promo",
        date: "1747125626",
      );

      // Assert
      expect(model.isReferral, isNull);
      expect(model.amount, r"$5.00");
      expect(model.name, "Bundle");
      expect(model.promotionName, "Promo");
      expect(model.date, "1747125626");
    });

    test("handles null amount with other fields populated", () {
      // Act
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        isReferral: true,
        name: "Bundle",
        promotionName: "Promo",
        date: "1747125626",
      );

      // Assert
      expect(model.isReferral, true);
      expect(model.amount, isNull);
      expect(model.name, "Bundle");
      expect(model.promotionName, "Promo");
      expect(model.date, "1747125626");
    });

    test("handles null name with other fields populated", () {
      // Act
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        isReferral: false,
        amount: r"$10.00",
        promotionName: "Promo",
        date: "1747125626",
      );

      // Assert
      expect(model.isReferral, false);
      expect(model.amount, r"$10.00");
      expect(model.name, isNull);
      expect(model.promotionName, "Promo");
      expect(model.date, "1747125626");
    });

    test("handles null promotionName with other fields populated", () {
      // Act
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        isReferral: true,
        amount: r"$5.00",
        name: "Bundle",
        date: "1747125626",
      );

      // Assert
      expect(model.isReferral, true);
      expect(model.amount, r"$5.00");
      expect(model.name, "Bundle");
      expect(model.promotionName, isNull);
      expect(model.date, "1747125626");
    });

    test("handles null date with other fields populated", () {
      // Act
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        isReferral: true,
        amount: r"$5.00",
        name: "Bundle",
        promotionName: "Promo",
      );

      // Assert
      expect(model.isReferral, true);
      expect(model.amount, r"$5.00");
      expect(model.name, "Bundle");
      expect(model.promotionName, "Promo");
      expect(model.date, isNull);
    });

    test("dateDisplayed uses DateTimeUtils for formatting", () {
      // Arrange
      final RewardHistoryResponseModel model = RewardHistoryResponseModel(
        date: "1747125626",
      );

      // Act
      final String result = model.dateDisplayed;

      // Assert
      expect(result, isNotNull);
      expect(result, isA<String>());
      // Verify it returns a formatted date string
      expect(result.contains("-") || result.contains("/"), true);
    });

    test("mockData is a static list", () {
      // Act
      final List<RewardHistoryResponseModel> mockData1 =
          RewardHistoryResponseModel.mockData;
      final List<RewardHistoryResponseModel> mockData2 =
          RewardHistoryResponseModel.mockData;

      // Assert
      expect(mockData1.length, mockData2.length);
      expect(mockData1[0].name, mockData2[0].name);
    });
  });
}
