import "package:esim_open_source/domain/data/response/auth/user_info_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for UserInfoResponseModel
/// Tests constructor and field management
void main() {
  group("UserInfoResponseModel Tests", () {
    test("constructor assigns all values correctly", () {
      // Act
      final UserInfoResponseModel model = UserInfoResponseModel(
        isVerified: true,
        referralCode: "REF123",
        userToken: "token123",
        roleName: "admin",
        balance: 100.50,
        currencyCode: "USD",
        msisdn: "1234567890",
        firstName: "John",
        lastName: "Doe",
        language: "en",
        country: "USA",
        countryCode: "US",
        email: "john@example.com",
      );

      // Assert
      expect(model.isVerified, true);
      expect(model.referralCode, "REF123");
      expect(model.userToken, "token123");
      expect(model.roleName, "admin");
      expect(model.balance, 100.50);
      expect(model.currencyCode, "USD");
      expect(model.msisdn, "1234567890");
      expect(model.firstName, "John");
      expect(model.lastName, "Doe");
      expect(model.language, "en");
      expect(model.country, "USA");
      expect(model.countryCode, "US");
      expect(model.email, "john@example.com");
    });

    test("all fields are nullable", () {
      // Act
      final UserInfoResponseModel model = UserInfoResponseModel();

      // Assert
      expect(model.isVerified, isNull);
      expect(model.referralCode, isNull);
      expect(model.userToken, isNull);
      expect(model.roleName, isNull);
      expect(model.balance, isNull);
      expect(model.currencyCode, isNull);
      expect(model.msisdn, isNull);
      expect(model.firstName, isNull);
      expect(model.lastName, isNull);
      expect(model.language, isNull);
      expect(model.country, isNull);
      expect(model.countryCode, isNull);
      expect(model.email, isNull);
    });

    test("constructor with partial fields", () {
      // Act
      final UserInfoResponseModel model = UserInfoResponseModel(
        firstName: "John",
        lastName: "Doe",
        email: "john@example.com",
      );

      // Assert
      expect(model.firstName, "John");
      expect(model.lastName, "Doe");
      expect(model.email, "john@example.com");
      expect(model.isVerified, isNull);
      expect(model.referralCode, isNull);
      expect(model.userToken, isNull);
      expect(model.roleName, isNull);
      expect(model.balance, isNull);
      expect(model.currencyCode, isNull);
      expect(model.msisdn, isNull);
      expect(model.language, isNull);
      expect(model.country, isNull);
      expect(model.countryCode, isNull);
    });

    test("getter isVerified returns correct value", () {
      // Arrange
      final UserInfoResponseModel model = UserInfoResponseModel(
        isVerified: true,
      );

      // Act
      final bool? result = model.isVerified;

      // Assert
      expect(result, true);
    });

    test("getter referralCode returns correct value", () {
      // Arrange
      final UserInfoResponseModel model = UserInfoResponseModel(
        referralCode: "REF456",
      );

      // Act
      final String? result = model.referralCode;

      // Assert
      expect(result, "REF456");
    });

    test("getter userToken returns correct value", () {
      // Arrange
      final UserInfoResponseModel model = UserInfoResponseModel(
        userToken: "token456",
      );

      // Act
      final String? result = model.userToken;

      // Assert
      expect(result, "token456");
    });

    test("getter roleName returns correct value", () {
      // Arrange
      final UserInfoResponseModel model = UserInfoResponseModel(
        roleName: "user",
      );

      // Act
      final String? result = model.roleName;

      // Assert
      expect(result, "user");
    });

    test("getter balance returns correct value", () {
      // Arrange
      final UserInfoResponseModel model = UserInfoResponseModel(
        balance: 250.75,
      );

      // Act
      final double? result = model.balance;

      // Assert
      expect(result, 250.75);
    });

    test("getter currencyCode returns correct value", () {
      // Arrange
      final UserInfoResponseModel model = UserInfoResponseModel(
        currencyCode: "EUR",
      );

      // Act
      final String? result = model.currencyCode;

      // Assert
      expect(result, "EUR");
    });

    test("getter msisdn returns correct value", () {
      // Arrange
      final UserInfoResponseModel model = UserInfoResponseModel(
        msisdn: "9876543210",
      );

      // Act
      final String? result = model.msisdn;

      // Assert
      expect(result, "9876543210");
    });

    test("getter firstName returns correct value", () {
      // Arrange
      final UserInfoResponseModel model = UserInfoResponseModel(
        firstName: "Jane",
      );

      // Act
      final String? result = model.firstName;

      // Assert
      expect(result, "Jane");
    });

    test("getter lastName returns correct value", () {
      // Arrange
      final UserInfoResponseModel model = UserInfoResponseModel(
        lastName: "Smith",
      );

      // Act
      final String? result = model.lastName;

      // Assert
      expect(result, "Smith");
    });

    test("getter language returns correct value", () {
      // Arrange
      final UserInfoResponseModel model = UserInfoResponseModel(
        language: "fr",
      );

      // Act
      final String? result = model.language;

      // Assert
      expect(result, "fr");
    });

    test("getter country returns correct value", () {
      // Arrange
      final UserInfoResponseModel model = UserInfoResponseModel(
        country: "France",
      );

      // Act
      final String? result = model.country;

      // Assert
      expect(result, "France");
    });

    test("getter countryCode returns correct value", () {
      // Arrange
      final UserInfoResponseModel model = UserInfoResponseModel(
        countryCode: "FR",
      );

      // Act
      final String? result = model.countryCode;

      // Assert
      expect(result, "FR");
    });

    test("getter email returns correct value", () {
      // Arrange
      final UserInfoResponseModel model = UserInfoResponseModel(
        email: "jane@example.com",
      );

      // Act
      final String? result = model.email;

      // Assert
      expect(result, "jane@example.com");
    });

    test("handles zero balance", () {
      // Act
      final UserInfoResponseModel model = UserInfoResponseModel(
        balance: 0.0,
      );

      // Assert
      expect(model.balance, 0.0);
    });

    test("handles negative balance", () {
      // Act
      final UserInfoResponseModel model = UserInfoResponseModel(
        balance: -50.0,
      );

      // Assert
      expect(model.balance, -50.0);
    });

    test("handles large balance values", () {
      // Act
      final UserInfoResponseModel model = UserInfoResponseModel(
        balance: 999999.99,
      );

      // Assert
      expect(model.balance, 999999.99);
    });

    test("handles balance as integer", () {
      // Act
      final UserInfoResponseModel model = UserInfoResponseModel(
        balance: 100.0,
      );

      // Assert
      expect(model.balance, 100.0);
      expect(model.balance, isA<double>());
    });

    test("handles empty string fields", () {
      // Act
      final UserInfoResponseModel model = UserInfoResponseModel(
        referralCode: "",
        userToken: "",
        roleName: "",
        currencyCode: "",
        msisdn: "",
        firstName: "",
        lastName: "",
        language: "",
        country: "",
        countryCode: "",
        email: "",
      );

      // Assert
      expect(model.referralCode, "");
      expect(model.userToken, "");
      expect(model.roleName, "");
      expect(model.currencyCode, "");
      expect(model.msisdn, "");
      expect(model.firstName, "");
      expect(model.lastName, "");
      expect(model.language, "");
      expect(model.country, "");
      expect(model.countryCode, "");
      expect(model.email, "");
    });

    test("handles special characters in firstName", () {
      // Act
      final UserInfoResponseModel model = UserInfoResponseModel(
        firstName: "José",
      );

      // Assert
      expect(model.firstName, "José");
    });

    test("handles special characters in lastName", () {
      // Act
      final UserInfoResponseModel model = UserInfoResponseModel(
        lastName: "O'Brien",
      );

      // Assert
      expect(model.lastName, "O'Brien");
    });

    test("handles special characters in email", () {
      // Act
      final UserInfoResponseModel model = UserInfoResponseModel(
        email: "user+test@example.com",
      );

      // Assert
      expect(model.email, "user+test@example.com");
    });

    test("handles isVerified as false", () {
      // Act
      final UserInfoResponseModel model = UserInfoResponseModel(
        isVerified: false,
      );

      // Assert
      expect(model.isVerified, false);
    });

    test("multiple instances are independent", () {
      // Act
      final UserInfoResponseModel model1 = UserInfoResponseModel(
        firstName: "John",
        balance: 100.0,
      );
      final UserInfoResponseModel model2 = UserInfoResponseModel(
        firstName: "Jane",
        balance: 200.0,
      );

      // Assert
      expect(model1.firstName, "John");
      expect(model1.balance, 100.0);
      expect(model2.firstName, "Jane");
      expect(model2.balance, 200.0);
    });

    test("handles null isVerified with other fields populated", () {
      // Act
      final UserInfoResponseModel model = UserInfoResponseModel(
        referralCode: "REF123",
        userToken: "token123",
        roleName: "admin",
        balance: 100.0,
      );

      // Assert
      expect(model.isVerified, isNull);
      expect(model.referralCode, "REF123");
      expect(model.userToken, "token123");
      expect(model.roleName, "admin");
      expect(model.balance, 100.0);
    });

    test("handles null balance with other fields populated", () {
      // Act
      final UserInfoResponseModel model = UserInfoResponseModel(
        firstName: "John",
        lastName: "Doe",
        email: "john@example.com",
      );

      // Assert
      expect(model.balance, isNull);
      expect(model.firstName, "John");
      expect(model.lastName, "Doe");
      expect(model.email, "john@example.com");
    });
  });
}
