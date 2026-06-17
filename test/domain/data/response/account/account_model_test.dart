import "package:esim_open_source/domain/data/response/account/account_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for AccountModel
/// Tests constructor, getters, copyWith, and computed properties
void main() {
  group("AccountModel Tests", () {
    test("constructor assigns all values correctly", () {
      // Act
      final AccountModel model = AccountModel(
        recordGuid: "guid-123",
        accountNumber: "ACC-001",
        currentBalance: 150.50,
        previousBalance: 200.00,
        lockedBalance: 50.00,
        previousLockedBalance: 75.00,
        currencyCode: "USD",
        accountTypeTag: "PREPAID",
        isPrimary: true,
      );

      // Assert
      expect(model.recordGuid, "guid-123");
      expect(model.accountNumber, "ACC-001");
      expect(model.currentBalance, 150.50);
      expect(model.previousBalance, 200.00);
      expect(model.lockedBalance, 50.00);
      expect(model.previousLockedBalance, 75.00);
      expect(model.currencyCode, "USD");
      expect(model.accountTypeTag, "PREPAID");
      expect(model.isPrimary, true);
    });

    test("constructor with minimal fields", () {
      // Act
      final AccountModel model = AccountModel(
        recordGuid: "guid-456",
      );

      // Assert
      expect(model.recordGuid, "guid-456");
      expect(model.accountNumber, isNull);
      expect(model.currentBalance, isNull);
      expect(model.previousBalance, isNull);
      expect(model.isPrimary, isNull);
    });

    test("all fields are nullable", () {
      // Act
      final AccountModel model = AccountModel();

      // Assert
      expect(model.recordGuid, isNull);
      expect(model.accountNumber, isNull);
      expect(model.currentBalance, isNull);
      expect(model.previousBalance, isNull);
      expect(model.lockedBalance, isNull);
      expect(model.previousLockedBalance, isNull);
      expect(model.currencyCode, isNull);
      expect(model.accountTypeTag, isNull);
      expect(model.isPrimary, isNull);
    });

    test("copyWith creates new instance with updated fields", () {
      // Arrange
      final AccountModel original = AccountModel(
        recordGuid: "guid-789",
        accountNumber: "ACC-002",
        currentBalance: 300.00,
        isPrimary: false,
      );

      // Act
      final AccountModel updated = original.copyWith(
        AccountModelParams(
          accountProperties: AccountPropertiesParams(
            accountNumber: "ACC-003",
          ),
        ),
      );

      // Assert
      expect(updated.recordGuid, "guid-789");
      expect(updated.accountNumber, "ACC-003");
      expect(updated.currentBalance, 300.00);
      expect(updated.isPrimary, false);
    });

    test("copyWith without parameters returns same values", () {
      // Arrange
      final AccountModel original = AccountModel(
        recordGuid: "guid-001",
        accountNumber: "ACC-001",
        currentBalance: 100.00,
      );

      // Act
      final AccountModel copied = original.copyWith();

      // Assert
      expect(copied.recordGuid, original.recordGuid);
      expect(copied.accountNumber, original.accountNumber);
      expect(copied.currentBalance, original.currentBalance);
    });

    test("copyWith preserves null values when not specified", () {
      // Arrange
      final AccountModel original = AccountModel(
        recordGuid: "guid-111",
        accountNumber: "ACC-111",
      );

      // Act
      final AccountModel updated = original.copyWith(
        AccountModelParams(
          balanceInfo: AccountBalanceParams(
            currentBalance: 250.00,
          ),
        ),
      );

      // Assert
      expect(updated.recordGuid, "guid-111");
      expect(updated.accountNumber, "ACC-111");
      expect(updated.currentBalance, 250.00);
      expect(updated.previousBalance, isNull);
    });

    test("copyWith preserves original instance", () {
      // Arrange
      final AccountModel original = AccountModel(
        recordGuid: "guid-222",
        currentBalance: 100.00,
      );

      // Act
      final AccountModel updated = original.copyWith(
        AccountModelParams(
          balanceInfo: AccountBalanceParams(
            currentBalance: 200.00,
          ),
        ),
      );

      // Assert — Original unchanged
      expect(original.currentBalance, 100.00);
      expect(updated.currentBalance, 200.00);
    });

    test("copyWith updates multiple fields at once", () {
      // Arrange
      final AccountModel original = AccountModel(
        recordGuid: "guid-333",
        accountNumber: "ACC-333",
        currentBalance: 100.00,
        previousBalance: 150.00,
        currencyCode: "USD",
      );

      // Act
      final AccountModel updated = original.copyWith(
        AccountModelParams(
          balanceInfo: AccountBalanceParams(
            currentBalance: 120.00,
          ),
          accountProperties: AccountPropertiesParams(
            accountNumber: "ACC-334",
            currencyCode: "EUR",
          ),
        ),
      );

      // Assert
      expect(updated.recordGuid, "guid-333");
      expect(updated.accountNumber, "ACC-334");
      expect(updated.currentBalance, 120.00);
      expect(updated.previousBalance, 150.00);
      expect(updated.currencyCode, "EUR");
    });

    test("accountType returns PREPAID when accountTypeTag is PREPAID", () {
      // Act
      final AccountModel model = AccountModel(
        accountTypeTag: "PREPAID",
      );

      // Assert
      expect(model.accountType, AccountsType.prepaid);
    });

    test("accountType returns PREPAID when accountTypeTag is lowercase prepaid",
        () {
      // Act
      final AccountModel model = AccountModel(
        accountTypeTag: "prepaid",
      );

      // Assert
      expect(model.accountType, AccountsType.prepaid);
    });

    test("accountType returns POSTPAID when accountTypeTag is POSTPAID", () {
      // Act
      final AccountModel model = AccountModel(
        accountTypeTag: "POSTPAID",
      );

      // Assert
      expect(model.accountType, AccountsType.postpaid);
    });

    test(
        "accountType returns POSTPAID when accountTypeTag is lowercase postpaid",
        () {
      // Act
      final AccountModel model = AccountModel(
        accountTypeTag: "postpaid",
      );

      // Assert
      expect(model.accountType, AccountsType.postpaid);
    });

    test("accountType returns UNKNOWN when accountTypeTag is null", () {
      // Act
      final AccountModel model = AccountModel(
        
      );

      // Assert
      expect(model.accountType, AccountsType.unknown);
    });

    test("accountType returns UNKNOWN when accountTypeTag is empty string", () {
      // Act
      final AccountModel model = AccountModel(
        accountTypeTag: "",
      );

      // Assert
      expect(model.accountType, AccountsType.unknown);
    });

    test("accountType returns UNKNOWN when accountTypeTag is invalid value",
        () {
      // Act
      final AccountModel model = AccountModel(
        accountTypeTag: "INVALID",
      );

      // Assert
      expect(model.accountType, AccountsType.unknown);
    });

    test("accountType returns UNKNOWN for default empty constructor", () {
      // Act
      final AccountModel model = AccountModel();

      // Assert
      expect(model.accountType, AccountsType.unknown);
    });

    test("handles numeric balance values correctly", () {
      // Act
      final AccountModel model = AccountModel(
        currentBalance: 999.99,
        previousBalance: 1000.00,
        lockedBalance: 50.50,
      );

      // Assert
      expect(model.currentBalance, 999.99);
      expect(model.previousBalance, 1000.00);
      expect(model.lockedBalance, 50.50);
    });

    test("handles zero balance values", () {
      // Act
      final AccountModel model = AccountModel(
        currentBalance: 0.0,
        lockedBalance: 0,
      );

      // Assert
      expect(model.currentBalance, 0.0);
      expect(model.lockedBalance, 0);
    });

    test("handles negative balance values", () {
      // Act
      final AccountModel model = AccountModel(
        currentBalance: -50.00,
        lockedBalance: -25.50,
      );

      // Assert
      expect(model.currentBalance, -50.00);
      expect(model.lockedBalance, -25.50);
    });

    test("multiple instances are independent", () {
      // Act
      final AccountModel model1 = AccountModel(
        recordGuid: "guid-1",
        currentBalance: 100.00,
      );
      final AccountModel model2 = AccountModel(
        recordGuid: "guid-2",
        currentBalance: 200.00,
      );

      // Assert
      expect(model1.recordGuid, "guid-1");
      expect(model1.currentBalance, 100.00);
      expect(model2.recordGuid, "guid-2");
      expect(model2.currentBalance, 200.00);
    });

    test("handles boolean values correctly for isPrimary", () {
      // Act
      final AccountModel modelPrimary = AccountModel(
        isPrimary: true,
      );
      final AccountModel modelNotPrimary = AccountModel(
        isPrimary: false,
      );

      // Assert
      expect(modelPrimary.isPrimary, true);
      expect(modelNotPrimary.isPrimary, false);
    });

    test("copyWith with null balance fields preserves original values", () {
      // Arrange — copyWith uses ?? operator, so passing null preserves original
      final AccountModel original = AccountModel(
        currentBalance: 100.00,
        previousBalance: 150.00,
        lockedBalance: 50.00,
      );

      // Act — Passing null to copyWith parameter uses the ?? operator
      final AccountModel updated = original.copyWith();

      // Assert — All values preserved when no parameters passed
      expect(updated.currentBalance, 100.00);
      expect(updated.previousBalance, 150.00);
      expect(updated.lockedBalance, 50.00);
    });

    test("copyWith preserves accountType computation after update", () {
      // Arrange
      final AccountModel original = AccountModel(
        accountTypeTag: "PREPAID",
      );

      // Act
      final AccountModel updated = original.copyWith(
        AccountModelParams(
          accountProperties: AccountPropertiesParams(
            accountTypeTag: "POSTPAID",
          ),
        ),
      );

      // Assert
      expect(original.accountType, AccountsType.prepaid);
      expect(updated.accountType, AccountsType.postpaid);
    });

    test("handles empty string values for string fields", () {
      // Act
      final AccountModel model = AccountModel(
        recordGuid: "",
        accountNumber: "",
        currencyCode: "",
        accountTypeTag: "",
      );

      // Assert
      expect(model.recordGuid, "");
      expect(model.accountNumber, "");
      expect(model.currencyCode, "");
      expect(model.accountTypeTag, "");
    });

    test("handles special characters in string fields", () {
      // Act
      final AccountModel model = AccountModel(
        recordGuid: "guid-with-special-@#",
        accountNumber: "ACC/001/2024",
        currencyCode: "CHF",
      );

      // Assert
      expect(model.recordGuid, "guid-with-special-@#");
      expect(model.accountNumber, "ACC/001/2024");
      expect(model.currencyCode, "CHF");
    });

    test("copyWith all balance fields at once", () {
      // Arrange
      final AccountModel original = AccountModel(
        currentBalance: 100.00,
        previousBalance: 150.00,
        lockedBalance: 50.00,
        previousLockedBalance: 75.00,
      );

      // Act
      final AccountModel updated = original.copyWith(
        AccountModelParams(
          balanceInfo: AccountBalanceParams(
            currentBalance: 200.00,
            previousBalance: 300.00,
            lockedBalance: 100.00,
            previousLockedBalance: 150.00,
          ),
        ),
      );

      // Assert
      expect(updated.currentBalance, 200.00);
      expect(updated.previousBalance, 300.00);
      expect(updated.lockedBalance, 100.00);
      expect(updated.previousLockedBalance, 150.00);
    });
  });
}
