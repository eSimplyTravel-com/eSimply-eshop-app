import "package:esim_open_source/domain/data/response/promotion/referral_info_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for ReferralInfoResponseModel
/// Tests constructor, copyWith, and getter methods
void main() {
  group("ReferralInfoResponseModel Tests", () {
    test("constructor assigns values correctly", () {
      // Act
      final ReferralInfoResponseModel model = ReferralInfoResponseModel(
        amount: 100.0,
        currency: "USD",
        type: "referral",
        message: "Referral bonus",
      );

      // Assert
      expect(model.amount, 100.0);
      expect(model.currency, "USD");
      expect(model.type, "referral");
      expect(model.message, "Referral bonus");
    });

    test("all fields are nullable", () {
      // Act
      final ReferralInfoResponseModel model = ReferralInfoResponseModel();

      // Assert
      expect(model.amount, isNull);
      expect(model.currency, isNull);
      expect(model.type, isNull);
      expect(model.message, isNull);
    });

    test("constructor with partial fields", () {
      // Act
      final ReferralInfoResponseModel model = ReferralInfoResponseModel(
        amount: 50.0,
        currency: "EUR",
      );

      // Assert
      expect(model.amount, 50.0);
      expect(model.currency, "EUR");
      expect(model.type, isNull);
      expect(model.message, isNull);
    });

    test("copyWith creates new instance with updated fields", () {
      // Arrange
      final ReferralInfoResponseModel original = ReferralInfoResponseModel(
        amount: 50.0,
        currency: "USD",
        type: "referral",
        message: "Original message",
      );

      // Act
      final ReferralInfoResponseModel updated = original.copyWith(
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
      final ReferralInfoResponseModel original = ReferralInfoResponseModel(
        amount: 50.0,
        currency: "USD",
        type: "referral",
        message: "Test message",
      );

      // Act
      final ReferralInfoResponseModel copied = original.copyWith();

      // Assert
      expect(copied.amount, original.amount);
      expect(copied.currency, original.currency);
      expect(copied.type, original.type);
      expect(copied.message, original.message);
    });

    test("copyWith preserves null values when not specified", () {
      // Arrange
      final ReferralInfoResponseModel original = ReferralInfoResponseModel(
        amount: 50.0,
        currency: "USD",
      );

      // Act
      final ReferralInfoResponseModel updated = original.copyWith(
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
      final ReferralInfoResponseModel original = ReferralInfoResponseModel(
        amount: 50.0,
        currency: "USD",
      );

      // Act
      final ReferralInfoResponseModel updated = original.copyWith(
        amount: 100.0,
      );

      // Assert
      expect(original.amount, 50.0);
      expect(updated.amount, 100.0);
    });

    test("copyWith with all fields updated", () {
      // Arrange
      final ReferralInfoResponseModel original = ReferralInfoResponseModel(
        amount: 50.0,
        currency: "USD",
        type: "referral",
        message: "Original",
      );

      // Act
      final ReferralInfoResponseModel updated = original.copyWith(
        amount: 100.0,
        currency: "EUR",
        type: "bonus",
        message: "Updated",
      );

      // Assert
      expect(updated.amount, 100.0);
      expect(updated.currency, "EUR");
      expect(updated.type, "bonus");
      expect(updated.message, "Updated");
    });


    test("getter amount returns correct value", () {
      // Arrange
      final ReferralInfoResponseModel model = ReferralInfoResponseModel(
        amount: 75.5,
      );

      // Act
      final num? result = model.amount;

      // Assert
      expect(result, 75.5);
    });

    test("getter currency returns correct value", () {
      // Arrange
      final ReferralInfoResponseModel model = ReferralInfoResponseModel(
        currency: "GBP",
      );

      // Act
      final String? result = model.currency;

      // Assert
      expect(result, "GBP");
    });

    test("getter type returns correct value", () {
      // Arrange
      final ReferralInfoResponseModel model = ReferralInfoResponseModel(
        type: "sign_up",
      );

      // Act
      final String? result = model.type;

      // Assert
      expect(result, "sign_up");
    });

    test("getter message returns correct value", () {
      // Arrange
      final ReferralInfoResponseModel model = ReferralInfoResponseModel(
        message: "Welcome bonus",
      );

      // Act
      final String? result = model.message;

      // Assert
      expect(result, "Welcome bonus");
    });

    test("handles amount as integer", () {
      // Act
      final ReferralInfoResponseModel model = ReferralInfoResponseModel(
        amount: 100,
      );

      // Assert
      expect(model.amount, 100);
    });

    test("handles amount as double", () {
      // Act
      final ReferralInfoResponseModel model = ReferralInfoResponseModel(
        amount: 99.99,
      );

      // Assert
      expect(model.amount, 99.99);
    });

    test("handles zero amount", () {
      // Act
      final ReferralInfoResponseModel model = ReferralInfoResponseModel(
        amount: 0,
      );

      // Assert
      expect(model.amount, 0);
    });

    test("handles negative amount", () {
      // Act
      final ReferralInfoResponseModel model = ReferralInfoResponseModel(
        amount: -10.0,
      );

      // Assert
      expect(model.amount, -10.0);
    });

    test("handles large amount values", () {
      // Act
      final ReferralInfoResponseModel model = ReferralInfoResponseModel(
        amount: 999999.99,
      );

      // Assert
      expect(model.amount, 999999.99);
    });

    test("handles empty string values", () {
      // Act
      final ReferralInfoResponseModel model = ReferralInfoResponseModel(
        currency: "",
        type: "",
        message: "",
      );

      // Assert
      expect(model.currency, "");
      expect(model.type, "");
      expect(model.message, "");
    });

    test("handles special characters in strings", () {
      // Act
      final ReferralInfoResponseModel model = ReferralInfoResponseModel(
        currency: "USD€",
        message: "Bonus: O'Reilly's offer!",
      );

      // Assert
      expect(model.currency, "USD€");
      expect(model.message, "Bonus: O'Reilly's offer!");
    });

    test("multiple instances are independent", () {
      // Act
      final ReferralInfoResponseModel model1 = ReferralInfoResponseModel(
        amount: 50.0,
        currency: "USD",
      );
      final ReferralInfoResponseModel model2 = ReferralInfoResponseModel(
        amount: 100.0,
        currency: "EUR",
      );

      // Assert
      expect(model1.amount, 50.0);
      expect(model1.currency, "USD");
      expect(model2.amount, 100.0);
      expect(model2.currency, "EUR");
    });

    test("copyWith creates independent copies", () {
      // Arrange
      final ReferralInfoResponseModel original = ReferralInfoResponseModel(
        amount: 50.0,
        currency: "USD",
      );

      final ReferralInfoResponseModel copy1 = original.copyWith();
      final ReferralInfoResponseModel copy2 = original.copyWith(
        amount: 75.0,
      );

      // Act & Assert
      expect(copy1.amount, 50.0);
      expect(copy1.currency, "USD");
      expect(copy2.amount, 75.0);
      expect(copy2.currency, "USD");
      expect(original.amount, 50.0);
    });

    test("handles null currency with other fields populated", () {
      // Act
      final ReferralInfoResponseModel model = ReferralInfoResponseModel(
        amount: 50.0,
        type: "referral",
        message: "Bonus",
      );

      // Assert
      expect(model.amount, 50.0);
      expect(model.currency, isNull);
      expect(model.type, "referral");
      expect(model.message, "Bonus");
    });

    test("handles null type with other fields populated", () {
      // Act
      final ReferralInfoResponseModel model = ReferralInfoResponseModel(
        amount: 50.0,
        currency: "USD",
        message: "Bonus",
      );

      // Assert
      expect(model.amount, 50.0);
      expect(model.currency, "USD");
      expect(model.type, isNull);
      expect(model.message, "Bonus");
    });

    test("handles null message with other fields populated", () {
      // Act
      final ReferralInfoResponseModel model = ReferralInfoResponseModel(
        amount: 50.0,
        currency: "USD",
        type: "referral",
      );

      // Assert
      expect(model.amount, 50.0);
      expect(model.currency, "USD");
      expect(model.type, "referral");
      expect(model.message, isNull);
    });
  });
}
