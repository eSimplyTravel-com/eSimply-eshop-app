import "package:esim_open_source/data/remote/responses/auth/user_info_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/auth/user_info_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for UserInfoResponseModelDto
/// Tests JSON serialization/deserialization and model methods
void main() {
  group("UserInfoResponseModelDto Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "is_verified": true,
        "referral_code": "REF123",
        "user_token": "token_123",
        "role_name": "admin",
        "balance": 150.5,
        "currency_code": "USD",
        "msisdn": "1234567890",
        "first_name": "John",
        "last_name": "Doe",
        "language": "en",
        "country": "United States",
        "country_code": "US",
        "email": "john@example.com",
      };

      // Act
      final UserInfoResponseModelDto model =
          UserInfoResponseModelDto.fromJson(json);

      // Assert
      expect(model.isVerified, true);
      expect(model.referralCode, "REF123");
      expect(model.userToken, "token_123");
      expect(model.roleName, "admin");
      expect(model.balance, 150.5);
      expect(model.currencyCode, "USD");
      expect(model.msisdn, "1234567890");
      expect(model.firstName, "John");
      expect(model.lastName, "Doe");
      expect(model.language, "en");
      expect(model.country, "United States");
      expect(model.countryCode, "US");
      expect(model.email, "john@example.com");
    });

    test("fromJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final UserInfoResponseModelDto model =
          UserInfoResponseModelDto.fromJson(json);

      // Assert
      expect(model.isVerified, isNull);
      expect(model.referralCode, isNull);
      expect(model.userToken, isNull);
      expect(model.roleName, isNull);
      expect(model.balance, 0.0);
      expect(model.currencyCode, isNull);
      expect(model.msisdn, isNull);
      expect(model.firstName, isNull);
      expect(model.lastName, isNull);
      expect(model.language, isNull);
      expect(model.country, isNull);
      expect(model.countryCode, isNull);
      expect(model.email, isNull);
    });

    test("fromJson handles null balance field", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "is_verified": true,
      };

      // Act
      final UserInfoResponseModelDto model =
          UserInfoResponseModelDto.fromJson(json);

      // Assert
      expect(model.balance, 0.0);
    });

    test("fromJson with explicit null values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "is_verified": null,
        "referral_code": null,
        "user_token": null,
        "role_name": null,
        "balance": null,
        "currency_code": null,
      };

      // Act
      final UserInfoResponseModelDto model =
          UserInfoResponseModelDto.fromJson(json);

      // Assert
      expect(model.isVerified, isNull);
      expect(model.referralCode, isNull);
      expect(model.userToken, isNull);
      expect(model.roleName, isNull);
      expect(model.balance, 0.0);
      expect(model.currencyCode, isNull);
    });

    test("fromJson handles balance as integer", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "balance": 100,
      };

      // Act
      final UserInfoResponseModelDto model =
          UserInfoResponseModelDto.fromJson(json);

      // Assert
      expect(model.balance, 100.0);
      expect(model.balance, isA<double>());
    });

    test("fromJson handles balance as double", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "balance": 99.99,
      };

      // Act
      final UserInfoResponseModelDto model =
          UserInfoResponseModelDto.fromJson(json);

      // Assert
      expect(model.balance, 99.99);
      expect(model.balance, isA<double>());
    });

    test("constructor assigns values correctly", () {
      // Act
      final UserInfoResponseModelDto model = UserInfoResponseModelDto(
        isVerified: true,
        firstName: "Jane",
        lastName: "Smith",
        balance: 200,
        email: "jane@example.com",
      );

      // Assert
      expect(model.isVerified, true);
      expect(model.firstName, "Jane");
      expect(model.lastName, "Smith");
      expect(model.balance, 200.0);
      expect(model.email, "jane@example.com");
    });

    test("constructor with minimal fields", () {
      // Act
      final UserInfoResponseModelDto model = UserInfoResponseModelDto();

      // Assert
      expect(model.isVerified, isNull);
      expect(model.firstName, isNull);
      expect(model.balance, isNull);
      expect(model.email, isNull);
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final UserInfoResponseModelDto model = UserInfoResponseModelDto(
        isVerified: true,
        firstName: "John",
        lastName: "Doe",
        balance: 500.75,
        email: "john@example.com",
        currencyCode: "EUR",
        country: "Germany",
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["is_verified"], true);
      expect(json["first_name"], "John");
      expect(json["last_name"], "Doe");
      expect(json["balance"], 500.75);
      expect(json["email"], "john@example.com");
      expect(json["currency_code"], "EUR");
      expect(json["country"], "Germany");
    });

    test("toJson handles null fields", () {
      // Arrange
      final UserInfoResponseModelDto model = UserInfoResponseModelDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["is_verified"], isNull);
      expect(json["first_name"], isNull);
      expect(json["last_name"], isNull);
      expect(json["email"], isNull);
      expect(json["balance"], isNull);
    });

    test("toJson preserves balance precision", () {
      // Arrange
      final UserInfoResponseModelDto model = UserInfoResponseModelDto(
        balance: 123.456789,
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["balance"], 123.456789);
    });

    test("roundtrip fromJson and toJson preserves data", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "is_verified": true,
        "first_name": "John",
        "last_name": "Doe",
        "balance": 500.5,
        "currency_code": "USD",
        "email": "john@example.com",
      };

      // Act
      final UserInfoResponseModelDto model =
          UserInfoResponseModelDto.fromJson(originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(resultJson["is_verified"], originalJson["is_verified"]);
      expect(resultJson["first_name"], originalJson["first_name"]);
      expect(resultJson["last_name"], originalJson["last_name"]);
      expect(resultJson["balance"], originalJson["balance"]);
      expect(resultJson["currency_code"], originalJson["currency_code"]);
      expect(resultJson["email"], originalJson["email"]);
    });

    test("handles empty string values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "first_name": "",
        "last_name": "",
        "email": "",
        "referral_code": "",
      };

      // Act
      final UserInfoResponseModelDto model =
          UserInfoResponseModelDto.fromJson(json);

      // Assert
      expect(model.firstName, "");
      expect(model.lastName, "");
      expect(model.email, "");
      expect(model.referralCode, "");
    });

    test("handles special characters in strings", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "first_name": "José",
        "last_name": "O'Brien",
        "email": "test+tag@example.com",
      };

      // Act
      final UserInfoResponseModelDto model =
          UserInfoResponseModelDto.fromJson(json);

      // Assert
      expect(model.firstName, "José");
      expect(model.lastName, "O'Brien");
      expect(model.email, "test+tag@example.com");
    });

    test("handles zero balance", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "balance": 0,
      };

      // Act
      final UserInfoResponseModelDto model =
          UserInfoResponseModelDto.fromJson(json);

      // Assert
      expect(model.balance, 0.0);
    });

    test("handles negative balance", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "balance": -100.5,
      };

      // Act
      final UserInfoResponseModelDto model =
          UserInfoResponseModelDto.fromJson(json);

      // Assert
      expect(model.balance, -100.5);
    });

    test("handles large balance values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "balance": 999999.99,
      };

      // Act
      final UserInfoResponseModelDto model =
          UserInfoResponseModelDto.fromJson(json);

      // Assert
      expect(model.balance, 999999.99);
    });

    test("boolean field handles true value", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "is_verified": true,
      };

      // Act
      final UserInfoResponseModelDto model =
          UserInfoResponseModelDto.fromJson(json);

      // Assert
      expect(model.isVerified, true);
      expect(model.isVerified, isA<bool>());
    });

    test("boolean field handles false value", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "is_verified": false,
      };

      // Act
      final UserInfoResponseModelDto model =
          UserInfoResponseModelDto.fromJson(json);

      // Assert
      expect(model.isVerified, false);
      expect(model.isVerified, isA<bool>());
    });

    test("multiple instances are independent", () {
      // Act
      final UserInfoResponseModelDto model1 = UserInfoResponseModelDto(
        firstName: "John",
        balance: 100,
      );
      final UserInfoResponseModelDto model2 = UserInfoResponseModelDto(
        firstName: "Jane",
        balance: 200,
      );

      // Assert
      expect(model1.firstName, "John");
      expect(model1.balance, 100.0);
      expect(model2.firstName, "Jane");
      expect(model2.balance, 200.0);
    });

    test("handles all field combinations", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "is_verified": true,
        "referral_code": "REF_CODE",
        "user_token": "TOKEN",
        "role_name": "user",
        "balance": 500.0,
        "currency_code": "GBP",
        "msisdn": "+447911123456",
        "first_name": "Mary",
        "last_name": "Johnson",
        "language": "fr",
        "country": "France",
        "country_code": "FR",
        "email": "mary@example.com",
      };

      // Act
      final UserInfoResponseModelDto model =
          UserInfoResponseModelDto.fromJson(json);

      // Assert
      expect(model.isVerified, true);
      expect(model.referralCode, "REF_CODE");
      expect(model.userToken, "TOKEN");
      expect(model.roleName, "user");
      expect(model.balance, 500.0);
      expect(model.currencyCode, "GBP");
      expect(model.msisdn, "+447911123456");
      expect(model.firstName, "Mary");
      expect(model.lastName, "Johnson");
      expect(model.language, "fr");
      expect(model.country, "France");
      expect(model.countryCode, "FR");
      expect(model.email, "mary@example.com");
    });

    test("fromDomain creates dto with all fields populated", () {
      // Arrange
      final UserInfoResponseModel domain = UserInfoResponseModel(
        isVerified: true,
        referralCode: "REF123",
        userToken: "token_123",
        roleName: "admin",
        balance: 150.5,
        currencyCode: "USD",
        msisdn: "1234567890",
        firstName: "John",
        lastName: "Doe",
        language: "en",
        country: "United States",
        countryCode: "US",
        email: "john@example.com",
      );

      // Act
      final UserInfoResponseModelDto dto =
          UserInfoResponseModelDto.fromDomain(domain);

      // Assert
      expect(dto.isVerified, true);
      expect(dto.referralCode, "REF123");
      expect(dto.userToken, "token_123");
      expect(dto.roleName, "admin");
      expect(dto.balance, 150.5);
      expect(dto.currencyCode, "USD");
      expect(dto.msisdn, "1234567890");
      expect(dto.firstName, "John");
      expect(dto.lastName, "Doe");
      expect(dto.language, "en");
      expect(dto.country, "United States");
      expect(dto.countryCode, "US");
      expect(dto.email, "john@example.com");
    });

    test("fromDomain handles null fields", () {
      // Arrange
      final UserInfoResponseModel domain = UserInfoResponseModel();

      // Act
      final UserInfoResponseModelDto dto =
          UserInfoResponseModelDto.fromDomain(domain);

      // Assert
      expect(dto.isVerified, isNull);
      expect(dto.referralCode, isNull);
      expect(dto.balance, isNull);
      expect(dto.email, isNull);
    });

    test("toDomain converts dto to domain model with all fields", () {
      // Arrange
      final UserInfoResponseModelDto dto = UserInfoResponseModelDto(
        isVerified: true,
        referralCode: "REF123",
        userToken: "token_123",
        roleName: "admin",
        balance: 150.5,
        currencyCode: "USD",
        msisdn: "1234567890",
        firstName: "John",
        lastName: "Doe",
        language: "en",
        country: "United States",
        countryCode: "US",
        email: "john@example.com",
      );

      // Act
      final UserInfoResponseModel domain = dto.toDomain();

      // Assert
      expect(domain.isVerified, true);
      expect(domain.referralCode, "REF123");
      expect(domain.userToken, "token_123");
      expect(domain.roleName, "admin");
      expect(domain.balance, 150.5);
      expect(domain.currencyCode, "USD");
      expect(domain.msisdn, "1234567890");
      expect(domain.firstName, "John");
      expect(domain.lastName, "Doe");
      expect(domain.language, "en");
      expect(domain.country, "United States");
      expect(domain.countryCode, "US");
      expect(domain.email, "john@example.com");
    });

    test("toDomain handles null fields", () {
      // Arrange
      final UserInfoResponseModelDto dto = UserInfoResponseModelDto();

      // Act
      final UserInfoResponseModel domain = dto.toDomain();

      // Assert
      expect(domain.isVerified, isNull);
      expect(domain.referralCode, isNull);
      expect(domain.balance, isNull);
      expect(domain.email, isNull);
    });

    test("fromDomain and toDomain roundtrip preserves data", () {
      // Arrange
      final UserInfoResponseModel original = UserInfoResponseModel(
        firstName: "Jane",
        lastName: "Smith",
        balance: 99.99,
        email: "jane@example.com",
        isVerified: false,
      );

      // Act
      final UserInfoResponseModelDto dto =
          UserInfoResponseModelDto.fromDomain(original);
      final UserInfoResponseModel result = dto.toDomain();

      // Assert
      expect(result.firstName, original.firstName);
      expect(result.lastName, original.lastName);
      expect(result.balance, original.balance);
      expect(result.email, original.email);
      expect(result.isVerified, original.isVerified);
    });
  });
}
