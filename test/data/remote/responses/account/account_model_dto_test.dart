import "package:esim_open_source/data/remote/responses/account/account_model_dto.dart";
import "package:esim_open_source/domain/data/response/account/account_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for AccountModelDto
/// Tests JSON serialization/deserialization and model methods
void main() {
  group("AccountModelDto Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "recordGuid": "guid-123",
        "accountNumber": "ACC-456",
        "currentBalance": 100.0,
        "previousBalance": 90.0,
        "lockedBalance": 10.0,
        "previousLockedBalance": 5.0,
        "currencyCode": "USD",
        "accountTypeTag": "PREPAID",
        "isPrimary": true,
      };

      // Act
      final AccountModelDto model = AccountModelDto.fromJson(json: json);

      // Assert
      expect(model.recordGuid, "guid-123");
      expect(model.accountNumber, "ACC-456");
      expect(model.currentBalance, 100.0);
      expect(model.previousBalance, 90.0);
      expect(model.lockedBalance, 10.0);
      expect(model.previousLockedBalance, 5.0);
      expect(model.currencyCode, "USD");
      expect(model.accountTypeTag, "PREPAID");
      expect(model.isPrimary, true);
    });

    test("fromJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final AccountModelDto model = AccountModelDto.fromJson(json: json);

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

    test("fromJson handles null recordGuid", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "accountNumber": "ACC-789",
        "currencyCode": "EUR",
      };

      // Act
      final AccountModelDto model = AccountModelDto.fromJson(json: json);

      // Assert
      expect(model.recordGuid, isNull);
      expect(model.accountNumber, "ACC-789");
      expect(model.currencyCode, "EUR");
    });

    test("fromJson handles null currentBalance", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "recordGuid": "guid-456",
        "accountNumber": "ACC-123",
      };

      // Act
      final AccountModelDto model = AccountModelDto.fromJson(json: json);

      // Assert
      expect(model.currentBalance, isNull);
      expect(model.recordGuid, "guid-456");
    });

    test("fromJson with explicit null values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "recordGuid": null,
        "accountNumber": null,
        "currentBalance": null,
        "isPrimary": null,
      };

      // Act
      final AccountModelDto model = AccountModelDto.fromJson(json: json);

      // Assert
      expect(model.recordGuid, isNull);
      expect(model.accountNumber, isNull);
      expect(model.currentBalance, isNull);
      expect(model.isPrimary, isNull);
    });

    test("constructor assigns values correctly", () {
      // Act
      final AccountModelDto model = AccountModelDto(
        recordGuid: "guid-789",
        accountNumber: "ACC-999",
        currentBalance: 250.5,
        previousBalance: 200.0,
        lockedBalance: 25.0,
        previousLockedBalance: 20.0,
        currencyCode: "GBP",
        accountTypeTag: "POSTPAID",
        isPrimary: false,
      );

      // Assert
      expect(model.recordGuid, "guid-789");
      expect(model.accountNumber, "ACC-999");
      expect(model.currentBalance, 250.5);
      expect(model.previousBalance, 200.0);
      expect(model.lockedBalance, 25.0);
      expect(model.previousLockedBalance, 20.0);
      expect(model.currencyCode, "GBP");
      expect(model.accountTypeTag, "POSTPAID");
      expect(model.isPrimary, false);
    });

    test("constructor with minimal fields", () {
      // Act
      final AccountModelDto model = AccountModelDto(
        recordGuid: "guid-123",
      );

      // Assert
      expect(model.recordGuid, "guid-123");
      expect(model.accountNumber, isNull);
      expect(model.currentBalance, isNull);
      expect(model.isPrimary, isNull);
    });

    test("all fields are nullable", () {
      // Act
      final AccountModelDto model = AccountModelDto();

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

    test("toJson returns correct map with all fields", () {
      // Arrange
      final AccountModelDto model = AccountModelDto(
        recordGuid: "guid-123",
        accountNumber: "ACC-456",
        currentBalance: 500.0,
        previousBalance: 450.0,
        lockedBalance: 50.0,
        previousLockedBalance: 45.0,
        currencyCode: "USD",
        accountTypeTag: "PREPAID",
        isPrimary: true,
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["recordGuid"], "guid-123");
      expect(json["accountNumber"], "ACC-456");
      expect(json["currentBalance"], 500.0);
      expect(json["previousBalance"], 450.0);
      expect(json["lockedBalance"], 50.0);
      expect(json["previousLockedBalance"], 45.0);
      expect(json["currencyCode"], "USD");
      expect(json["accountTypeTag"], "PREPAID");
      expect(json["isPrimary"], true);
    });

    test("toJson handles null fields", () {
      // Arrange
      final AccountModelDto model = AccountModelDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["recordGuid"], isNull);
      expect(json["accountNumber"], isNull);
      expect(json["currentBalance"], isNull);
      expect(json["previousBalance"], isNull);
      expect(json["lockedBalance"], isNull);
      expect(json["previousLockedBalance"], isNull);
      expect(json["currencyCode"], isNull);
      expect(json["accountTypeTag"], isNull);
      expect(json["isPrimary"], isNull);
    });

    test("copyWith creates new instance with updated fields", () {
      // Arrange
      final AccountModelDto original = AccountModelDto(
        recordGuid: "guid-123",
        accountNumber: "ACC-456",
        currentBalance: 100.0,
      );

      // Act
      final AccountModelDto updated = original.copyWith(
        AccountModelParamsDto(
          accountProperties: AccountPropertiesParamsDto(
            recordGuid: "guid-789",
          ),
        ),
      );

      // Assert
      expect(updated.recordGuid, "guid-789");
      expect(updated.accountNumber, "ACC-456");
      expect(updated.currentBalance, 100.0);
      expect(original.recordGuid, "guid-123");
    });

    test("copyWith without parameters returns same values", () {
      // Arrange
      final AccountModelDto original = AccountModelDto(
        recordGuid: "guid-123",
        accountNumber: "ACC-456",
        isPrimary: true,
      );

      // Act
      final AccountModelDto copied = original.copyWith();

      // Assert
      expect(copied.recordGuid, original.recordGuid);
      expect(copied.accountNumber, original.accountNumber);
      expect(copied.isPrimary, original.isPrimary);
    });

    test("copyWith preserves null values when not specified", () {
      // Arrange
      final AccountModelDto original = AccountModelDto(
        recordGuid: "guid-123",
      );

      // Act
      final AccountModelDto updated = original.copyWith(
        AccountModelParamsDto(
          accountProperties: AccountPropertiesParamsDto(
            accountNumber: "ACC-789",
          ),
        ),
      );

      // Assert
      expect(updated.recordGuid, "guid-123");
      expect(updated.accountNumber, "ACC-789");
      expect(updated.currentBalance, isNull);
    });

    test("copyWith preserves original instance", () {
      // Arrange
      final AccountModelDto original = AccountModelDto(
        recordGuid: "guid-123",
      );

      // Act
      final AccountModelDto updated = original.copyWith(
        AccountModelParamsDto(
          accountProperties: AccountPropertiesParamsDto(
            recordGuid: "guid-updated",
          ),
        ),
      );

      // Assert
      expect(original.recordGuid, "guid-123");
      expect(updated.recordGuid, "guid-updated");
    });

    test("copyWith can update balance info", () {
      // Arrange
      final AccountModelDto original = AccountModelDto(
        currentBalance: 100.0,
      );

      // Act
      final AccountModelDto updated = original.copyWith(
        AccountModelParamsDto(
          balanceInfo: AccountBalanceParamsDto(
            currentBalance: 150.0,
          ),
        ),
      );

      // Assert
      expect(updated.currentBalance, 150.0);
      expect(original.currentBalance, 100.0);
    });

    test("fromJsonList creates list from json array", () {
      // Arrange
      final List<dynamic> jsonList = <dynamic>[
        <String, dynamic>{
          "recordGuid": "guid-1",
          "accountNumber": "ACC-001",
          "currentBalance": 100.0,
        },
        <String, dynamic>{
          "recordGuid": "guid-2",
          "accountNumber": "ACC-002",
          "currentBalance": 200.0,
        },
      ];

      // Act
      final List<AccountModelDto> models =
          AccountModelDto.fromJsonList(json: jsonList);

      // Assert
      expect(models.length, 2);
      expect(models[0].recordGuid, "guid-1");
      expect(models[0].accountNumber, "ACC-001");
      expect(models[0].currentBalance, 100.0);
      expect(models[1].recordGuid, "guid-2");
      expect(models[1].currentBalance, 200.0);
    });

    test("fromJsonList handles empty list", () {
      // Arrange
      final List<dynamic> jsonList = <dynamic>[];

      // Act
      final List<AccountModelDto> models =
          AccountModelDto.fromJsonList(json: jsonList);

      // Assert
      expect(models, isEmpty);
    });

    test("roundtrip fromJson and toJson preserves data", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "recordGuid": "guid-123",
        "accountNumber": "ACC-456",
        "currentBalance": 750.5,
        "previousBalance": 700.0,
        "lockedBalance": 50.0,
        "previousLockedBalance": 45.0,
        "currencyCode": "USD",
        "accountTypeTag": "PREPAID",
        "isPrimary": false,
      };

      // Act
      final AccountModelDto model =
          AccountModelDto.fromJson(json: originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(resultJson["recordGuid"], originalJson["recordGuid"]);
      expect(resultJson["accountNumber"], originalJson["accountNumber"]);
      expect(resultJson["currentBalance"], originalJson["currentBalance"]);
      expect(resultJson["previousBalance"], originalJson["previousBalance"]);
      expect(resultJson["lockedBalance"], originalJson["lockedBalance"]);
      expect(resultJson["previousLockedBalance"],
          originalJson["previousLockedBalance"],);
      expect(resultJson["currencyCode"], originalJson["currencyCode"]);
      expect(resultJson["accountTypeTag"], originalJson["accountTypeTag"]);
      expect(resultJson["isPrimary"], originalJson["isPrimary"]);
    });

    test("handles empty string values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "recordGuid": "",
        "accountNumber": "",
        "currencyCode": "",
        "accountTypeTag": "",
      };

      // Act
      final AccountModelDto model = AccountModelDto.fromJson(json: json);

      // Assert
      expect(model.recordGuid, "");
      expect(model.accountNumber, "");
      expect(model.currencyCode, "");
      expect(model.accountTypeTag, "");
    });

    test("handles special characters in strings", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "recordGuid": r"guid-with-special-!@#$%",
        "accountNumber": "ACC-with-'quotes'",
      };

      // Act
      final AccountModelDto model = AccountModelDto.fromJson(json: json);

      // Assert
      expect(model.recordGuid, r"guid-with-special-!@#$%");
      expect(model.accountNumber, "ACC-with-'quotes'");
    });

    test("multiple instances are independent", () {
      // Act
      final AccountModelDto model1 = AccountModelDto(
        recordGuid: "guid-1",
        currentBalance: 100.0,
      );
      final AccountModelDto model2 = AccountModelDto(
        recordGuid: "guid-2",
        currentBalance: 200.0,
      );

      // Assert
      expect(model1.recordGuid, "guid-1");
      expect(model1.currentBalance, 100.0);
      expect(model2.recordGuid, "guid-2");
      expect(model2.currentBalance, 200.0);
    });

    test("handles zero balance values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "currentBalance": 0,
        "previousBalance": 0,
        "lockedBalance": 0,
      };

      // Act
      final AccountModelDto model = AccountModelDto.fromJson(json: json);

      // Assert
      expect(model.currentBalance, 0);
      expect(model.previousBalance, 0);
      expect(model.lockedBalance, 0);
    });

    test("handles negative balance values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "currentBalance": -50.5,
        "previousBalance": -40.0,
      };

      // Act
      final AccountModelDto model = AccountModelDto.fromJson(json: json);

      // Assert
      expect(model.currentBalance, -50.5);
      expect(model.previousBalance, -40.0);
    });

    test("toJson preserves balance precision", () {
      // Arrange
      final AccountModelDto model = AccountModelDto(
        currentBalance: 123.456789,
        previousBalance: 98.765432,
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["currentBalance"], 123.456789);
      expect(json["previousBalance"], 98.765432);
    });

    test("boolean field handles true value", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "isPrimary": true,
      };

      // Act
      final AccountModelDto model = AccountModelDto.fromJson(json: json);

      // Assert
      expect(model.isPrimary, true);
      expect(model.isPrimary, isA<bool>());
    });

    test("boolean field handles false value", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "isPrimary": false,
      };

      // Act
      final AccountModelDto model = AccountModelDto.fromJson(json: json);

      // Assert
      expect(model.isPrimary, false);
      expect(model.isPrimary, isA<bool>());
    });

    test("accountType returns prepaid when accountTypeTag is PREPAID", () {
      // Arrange
      final AccountModelDto model = AccountModelDto(
        accountTypeTag: "PREPAID",
      );

      // Act
      final AccountsType accountType = model.accountType;

      // Assert
      expect(accountType, AccountsType.prepaid);
    });

    test(
        "accountType returns prepaid when accountTypeTag is prepaid (lowercase)",
        () {
      // Arrange
      final AccountModelDto model = AccountModelDto(
        accountTypeTag: "prepaid",
      );

      // Act
      final AccountsType accountType = model.accountType;

      // Assert
      expect(accountType, AccountsType.prepaid);
    });

    test("accountType returns postpaid when accountTypeTag is POSTPAID", () {
      // Arrange
      final AccountModelDto model = AccountModelDto(
        accountTypeTag: "POSTPAID",
      );

      // Act
      final AccountsType accountType = model.accountType;

      // Assert
      expect(accountType, AccountsType.postpaid);
    });

    test(
        "accountType returns postpaid when accountTypeTag is postpaid (lowercase)",
        () {
      // Arrange
      final AccountModelDto model = AccountModelDto(
        accountTypeTag: "postpaid",
      );

      // Act
      final AccountsType accountType = model.accountType;

      // Assert
      expect(accountType, AccountsType.postpaid);
    });

    test("accountType returns unknown when accountTypeTag is unrecognized", () {
      // Arrange
      final AccountModelDto model = AccountModelDto(
        accountTypeTag: "UNKNOWN",
      );

      // Act
      final AccountsType accountType = model.accountType;

      // Assert
      expect(accountType, AccountsType.unknown);
    });

    test("accountType returns unknown when accountTypeTag is null", () {
      // Arrange
      final AccountModelDto model = AccountModelDto();

      // Act
      final AccountsType accountType = model.accountType;

      // Assert
      expect(accountType, AccountsType.unknown);
    });

    test("toDomain converts dto to domain model with all fields", () {
      // Arrange
      final AccountModelDto dto = AccountModelDto(
        recordGuid: "guid-123",
        accountNumber: "ACC-456",
        currentBalance: 500.0,
        previousBalance: 450.0,
        lockedBalance: 50.0,
        previousLockedBalance: 45.0,
        currencyCode: "USD",
        accountTypeTag: "PREPAID",
        isPrimary: true,
      );

      // Act
      final AccountModel domain = dto.toDomain();

      // Assert
      expect(domain.recordGuid, "guid-123");
      expect(domain.accountNumber, "ACC-456");
      expect(domain.currentBalance, 500.0);
      expect(domain.previousBalance, 450.0);
      expect(domain.lockedBalance, 50.0);
      expect(domain.previousLockedBalance, 45.0);
      expect(domain.currencyCode, "USD");
      expect(domain.accountTypeTag, "PREPAID");
      expect(domain.isPrimary, true);
    });

    test("toDomain handles null fields", () {
      // Arrange
      final AccountModelDto dto = AccountModelDto();

      // Act
      final AccountModel domain = dto.toDomain();

      // Assert
      expect(domain.recordGuid, isNull);
      expect(domain.accountNumber, isNull);
      expect(domain.currentBalance, isNull);
      expect(domain.previousBalance, isNull);
      expect(domain.lockedBalance, isNull);
      expect(domain.previousLockedBalance, isNull);
      expect(domain.currencyCode, isNull);
      expect(domain.accountTypeTag, isNull);
      expect(domain.isPrimary, isNull);
    });

    test("toDomain with partial data", () {
      // Arrange
      final AccountModelDto dto = AccountModelDto(
        recordGuid: "guid-123",
        currentBalance: 100.0,
      );

      // Act
      final AccountModel domain = dto.toDomain();

      // Assert
      expect(domain.recordGuid, "guid-123");
      expect(domain.currentBalance, 100.0);
      expect(domain.accountNumber, isNull);
      expect(domain.currencyCode, isNull);
    });

    test("fromJson and toDomain roundtrip preserves data", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "recordGuid": "guid-123",
        "accountNumber": "ACC-456",
        "currentBalance": 750.5,
        "currencyCode": "USD",
        "accountTypeTag": "PREPAID",
        "isPrimary": true,
      };

      // Act
      final AccountModelDto dto = AccountModelDto.fromJson(json: originalJson);
      final AccountModel domain = dto.toDomain();

      // Assert
      expect(domain.recordGuid, originalJson["recordGuid"]);
      expect(domain.accountNumber, originalJson["accountNumber"]);
      expect(domain.currentBalance, originalJson["currentBalance"]);
      expect(domain.currencyCode, originalJson["currencyCode"]);
      expect(domain.accountTypeTag, originalJson["accountTypeTag"]);
      expect(domain.isPrimary, originalJson["isPrimary"]);
    });

    test("handles integer balance as numeric value", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "currentBalance": 100,
        "previousBalance": 90,
      };

      // Act
      final AccountModelDto model = AccountModelDto.fromJson(json: json);

      // Assert
      expect(model.currentBalance, 100);
      expect(model.previousBalance, 90);
    });

    test("handles double balance as numeric value", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "currentBalance": 99.99,
        "previousBalance": 88.88,
      };

      // Act
      final AccountModelDto model = AccountModelDto.fromJson(json: json);

      // Assert
      expect(model.currentBalance, 99.99);
      expect(model.previousBalance, 88.88);
    });

    test("fromJsonList with mixed null and populated items", () {
      // Arrange
      final List<dynamic> jsonList = <dynamic>[
        <String, dynamic>{
          "recordGuid": "guid-1",
          "accountNumber": "ACC-001",
        },
        <String, dynamic>{
          "recordGuid": null,
          "accountNumber": "ACC-002",
        },
      ];

      // Act
      final List<AccountModelDto> models =
          AccountModelDto.fromJsonList(json: jsonList);

      // Assert
      expect(models.length, 2);
      expect(models[0].recordGuid, "guid-1");
      expect(models[1].recordGuid, isNull);
      expect(models[1].accountNumber, "ACC-002");
    });

    test("accountType getter is case-insensitive", () {
      // Arrange
      final AccountModelDto model1 = AccountModelDto(
        accountTypeTag: "PrePaid",
      );
      final AccountModelDto model2 = AccountModelDto(
        accountTypeTag: "PostPaid",
      );

      // Act
      final AccountsType type1 = model1.accountType;
      final AccountsType type2 = model2.accountType;

      // Assert
      expect(type1, AccountsType.prepaid);
      expect(type2, AccountsType.postpaid);
    });
  });
}
