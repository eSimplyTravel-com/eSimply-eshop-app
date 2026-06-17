import "dart:convert";

import "package:esim_open_source/data/remote/responses/auth/auth_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/auth/user_info_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/data/response/auth/user_info_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for AuthResponseModelDto
/// Tests JSON serialization/deserialization and model methods
void main() {
  group("AuthResponseModelDto Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "access_token": "access_token_value",
        "refresh_token": "refresh_token_value",
        "user_info": <String, dynamic>{
          "is_verified": true,
          "referral_code": "ref_123",
          "user_token": "user_token_value",
          "role_name": "admin",
          "balance": 100.0,
          "currency_code": "USD",
          "msisdn": "1234567890",
          "first_name": "John",
          "last_name": "Doe",
          "language": "en",
          "country": "US",
          "country_code": "US",
          "email": "john@example.com",
        },
        "user_token": "user_token_value",
        "is_verified": true,
      };

      // Act
      final AuthResponseModelDto model = AuthResponseModelDto.fromJson(json);

      // Assert
      expect(model.accessToken, "access_token_value");
      expect(model.refreshToken, "refresh_token_value");
      expect(model.userInfo, isNotNull);
      expect(model.userInfo?.firstName, "John");
      expect(model.userToken, "user_token_value");
      expect(model.isVerified, true);
    });

    test("fromJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final AuthResponseModelDto model = AuthResponseModelDto.fromJson(json);

      // Assert
      expect(model.accessToken, isNull);
      expect(model.refreshToken, isNull);
      expect(model.userInfo, isNull);
      expect(model.userToken, isNull);
      expect(model.isVerified, isNull);
    });

    test("fromJson handles null userInfo", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "access_token": "token",
        "user_info": null,
      };

      // Act
      final AuthResponseModelDto model = AuthResponseModelDto.fromJson(json);

      // Assert
      expect(model.accessToken, "token");
      expect(model.userInfo, isNull);
    });

    test("fromJson with explicit null values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "access_token": null,
        "refresh_token": null,
        "user_token": null,
        "is_verified": null,
      };

      // Act
      final AuthResponseModelDto model = AuthResponseModelDto.fromJson(json);

      // Assert
      expect(model.accessToken, isNull);
      expect(model.refreshToken, isNull);
      expect(model.userToken, isNull);
      expect(model.isVerified, isNull);
    });

    test("fromAPIJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "access_token": "api_access_token",
        "refresh_token": "api_refresh_token",
        "user_info": <String, dynamic>{
          "is_verified": true,
          "first_name": "Jane",
        },
        "user_token": "api_user_token",
        "is_verified": true,
      };

      // Act
      final AuthResponseModelDto model =
          AuthResponseModelDto.fromAPIJson(json: json);

      // Assert
      expect(model.accessToken, "api_access_token");
      expect(model.refreshToken, "api_refresh_token");
      expect(model.userInfo, isNotNull);
      expect(model.userToken, "api_user_token");
      expect(model.isVerified, true);
    });

    test("fromAPIJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final AuthResponseModelDto model =
          AuthResponseModelDto.fromAPIJson(json: json);

      // Assert
      expect(model.accessToken, isNull);
      expect(model.refreshToken, isNull);
      expect(model.userInfo, isNull);
    });

    test("fromJson and fromAPIJson produce identical results", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "access_token": "token",
        "refresh_token": "refresh",
        "user_token": "user_tok",
        "is_verified": true,
      };

      // Act
      final AuthResponseModelDto fromJsonModel =
          AuthResponseModelDto.fromJson(json);
      final AuthResponseModelDto fromAPIJsonModel =
          AuthResponseModelDto.fromAPIJson(json: json);

      // Assert
      expect(fromJsonModel.accessToken, fromAPIJsonModel.accessToken);
      expect(fromJsonModel.refreshToken, fromAPIJsonModel.refreshToken);
      expect(fromJsonModel.userToken, fromAPIJsonModel.userToken);
      expect(fromJsonModel.isVerified, fromAPIJsonModel.isVerified);
    });

    test("constructor assigns values correctly", () {
      // Arrange
      final UserInfoResponseModelDto userInfo = UserInfoResponseModelDto(
        firstName: "Test",
      );

      // Act
      final AuthResponseModelDto model = AuthResponseModelDto(
        accessToken: "token",
        refreshToken: "refresh",
        userInfo: userInfo,
        userToken: "user_tok",
        isVerified: true,
      );

      // Assert
      expect(model.accessToken, "token");
      expect(model.refreshToken, "refresh");
      expect(model.userInfo, isNotNull);
      expect(model.userInfo?.firstName, "Test");
      expect(model.userToken, "user_tok");
      expect(model.isVerified, true);
    });

    test("constructor with minimal fields", () {
      // Act
      final AuthResponseModelDto model = AuthResponseModelDto();

      // Assert
      expect(model.accessToken, isNull);
      expect(model.refreshToken, isNull);
      expect(model.userInfo, isNull);
      expect(model.userToken, isNull);
      expect(model.isVerified, isNull);
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final UserInfoResponseModelDto userInfo = UserInfoResponseModelDto(
        firstName: "John",
        lastName: "Doe",
      );
      final AuthResponseModelDto model = AuthResponseModelDto(
        accessToken: "access",
        refreshToken: "refresh",
        userInfo: userInfo,
        userToken: "user_tok",
        isVerified: false,
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["access_token"], "access");
      expect(json["refresh_token"], "refresh");
      expect(json["user_token"], "user_tok");
      expect(json["is_verified"], false);
      expect(json["user_info"], isNotNull);
    });

    test("toJson handles null fields", () {
      // Arrange
      final AuthResponseModelDto model = AuthResponseModelDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["access_token"], isNull);
      expect(json["refresh_token"], isNull);
      expect(json["user_info"], isNull);
      expect(json["user_token"], isNull);
      expect(json["is_verified"], isNull);
    });

    test("toJson includes nested userInfo correctly", () {
      // Arrange
      final UserInfoResponseModelDto nested = UserInfoResponseModelDto(
        firstName: "Jane",
        balance: 250,
      );
      final AuthResponseModelDto model = AuthResponseModelDto(
        userInfo: nested,
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["user_info"], isNotNull);
      expect(json["user_info"]["first_name"], "Jane");
      expect(json["user_info"]["balance"], 250.0);
    });

    test("copyWith creates new instance with updated fields", () {
      // Arrange
      final AuthResponseModelDto original = AuthResponseModelDto(
        accessToken: "original_token",
        refreshToken: "original_refresh",
      );

      // Act
      final AuthResponseModelDto updated = original.copyWith(
        accessToken: "new_token",
      );

      // Assert
      expect(updated.accessToken, "new_token");
      expect(updated.refreshToken, "original_refresh");
      expect(original.accessToken, "original_token");
    });

    test("copyWith without parameters returns same values", () {
      // Arrange
      final AuthResponseModelDto original = AuthResponseModelDto(
        accessToken: "token",
        refreshToken: "refresh",
        isVerified: true,
      );

      // Act
      final AuthResponseModelDto copied = original.copyWith();

      // Assert
      expect(copied.accessToken, original.accessToken);
      expect(copied.refreshToken, original.refreshToken);
      expect(copied.isVerified, original.isVerified);
    });

    test("copyWith preserves null values when not specified", () {
      // Arrange
      final AuthResponseModelDto original = AuthResponseModelDto(
        accessToken: "token",
      );

      // Act
      final AuthResponseModelDto updated = original.copyWith(
        refreshToken: "new_refresh",
      );

      // Assert
      expect(updated.accessToken, "token");
      expect(updated.refreshToken, "new_refresh");
      expect(updated.userInfo, isNull);
    });

    test("copyWith can update nested userInfo", () {
      // Arrange
      final UserInfoResponseModelDto originalUserInfo =
          UserInfoResponseModelDto(
        firstName: "John",
      );
      final UserInfoResponseModelDto updatedUserInfo = UserInfoResponseModelDto(
        firstName: "Jane",
      );
      final AuthResponseModelDto original = AuthResponseModelDto(
        userInfo: originalUserInfo,
      );

      // Act
      final AuthResponseModelDto result = original.copyWith(
        userInfo: updatedUserInfo,
      );

      // Assert
      expect(result.userInfo?.firstName, "Jane");
      expect(original.userInfo?.firstName, "John");
    });

    test("copyWith preserves original instance", () {
      // Arrange
      final AuthResponseModelDto original = AuthResponseModelDto(
        accessToken: "original",
      );

      // Act
      final AuthResponseModelDto updated = original.copyWith(
        accessToken: "updated",
      );

      // Assert
      expect(original.accessToken, "original");
      expect(updated.accessToken, "updated");
    });

    test("fromJsonString parses JSON string correctly", () {
      // Arrange
      final String jsonString = """
      {
        "access_token": "string_token",
        "refresh_token": "string_refresh",
        "user_token": "string_user_token",
        "is_verified": true
      }
      """;

      // Act
      final AuthResponseModelDto model =
          AuthResponseModelDto.fromJsonString(jsonString);

      // Assert
      expect(model.accessToken, "string_token");
      expect(model.refreshToken, "string_refresh");
      expect(model.userToken, "string_user_token");
      expect(model.isVerified, true);
    });

    test("toJsonString converts model to JSON string", () {
      // Arrange
      final AuthResponseModelDto model = AuthResponseModelDto(
        accessToken: "token_value",
        isVerified: false,
      );

      // Act
      final String jsonString = model.toJsonString();
      final Map<String, dynamic> decoded = jsonDecode(jsonString);

      // Assert
      expect(decoded["access_token"], "token_value");
      expect(decoded["is_verified"], false);
    });

    test("toJsonString produces valid JSON", () {
      // Arrange
      final AuthResponseModelDto model = AuthResponseModelDto(
        accessToken: "token",
      );

      // Act
      final String jsonString = model.toJsonString();

      // Assert
      expect(() => jsonDecode(jsonString), returnsNormally);
      final dynamic decoded = jsonDecode(jsonString);
      expect(decoded, isA<Map<String, dynamic>>());
    });

    test("fromJsonString handles whitespace in JSON", () {
      // Arrange
      final String jsonString = """

      {
        "access_token":    "token",
        "refresh_token": "refresh"
      }

      """;

      // Act
      final AuthResponseModelDto model =
          AuthResponseModelDto.fromJsonString(jsonString);

      // Assert
      expect(model.accessToken, "token");
      expect(model.refreshToken, "refresh");
    });

    test("roundtrip fromJson and toJson preserves data", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "access_token": "token_123",
        "refresh_token": "refresh_456",
        "user_token": "user_789",
        "is_verified": true,
      };

      // Act
      final AuthResponseModelDto model =
          AuthResponseModelDto.fromJson(originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(resultJson["access_token"], originalJson["access_token"]);
      expect(resultJson["refresh_token"], originalJson["refresh_token"]);
      expect(resultJson["user_token"], originalJson["user_token"]);
      expect(resultJson["is_verified"], originalJson["is_verified"]);
    });

    test("roundtrip fromJsonString and toJsonString preserves data", () {
      // Arrange
      final AuthResponseModelDto original = AuthResponseModelDto(
        accessToken: "token_abc",
        refreshToken: "refresh_xyz",
        isVerified: true,
      );

      // Act
      final String jsonString = original.toJsonString();
      final AuthResponseModelDto parsed =
          AuthResponseModelDto.fromJsonString(jsonString);

      // Assert
      expect(parsed.accessToken, original.accessToken);
      expect(parsed.refreshToken, original.refreshToken);
      expect(parsed.isVerified, original.isVerified);
    });

    test("handles empty string values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "access_token": "",
        "refresh_token": "",
        "user_token": "",
      };

      // Act
      final AuthResponseModelDto model = AuthResponseModelDto.fromJson(json);

      // Assert
      expect(model.accessToken, "");
      expect(model.refreshToken, "");
      expect(model.userToken, "");
    });

    test("handles special characters in strings", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "access_token": r"token_with_special_!@#$%",
        "refresh_token": "refresh_with_'quotes'",
      };

      // Act
      final AuthResponseModelDto model = AuthResponseModelDto.fromJson(json);

      // Assert
      expect(model.accessToken, r"token_with_special_!@#$%");
      expect(model.refreshToken, "refresh_with_'quotes'");
    });

    test("multiple instances are independent", () {
      // Act
      final AuthResponseModelDto model1 = AuthResponseModelDto(
        accessToken: "token1",
        isVerified: true,
      );
      final AuthResponseModelDto model2 = AuthResponseModelDto(
        accessToken: "token2",
        isVerified: false,
      );

      // Assert
      expect(model1.accessToken, "token1");
      expect(model1.isVerified, true);
      expect(model2.accessToken, "token2");
      expect(model2.isVerified, false);
    });

    test("boolean field handles true value", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "is_verified": true,
      };

      // Act
      final AuthResponseModelDto model = AuthResponseModelDto.fromJson(json);

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
      final AuthResponseModelDto model = AuthResponseModelDto.fromJson(json);

      // Assert
      expect(model.isVerified, false);
      expect(model.isVerified, isA<bool>());
    });

    test("fromDomain creates dto with all fields populated", () {
      // Arrange
      final AuthResponseModel domain = AuthResponseModel(
        accessToken: "access_token",
        refreshToken: "refresh_token",
        userInfo: UserInfoResponseModel(firstName: "John"),
        userToken: "user_token",
        isVerified: true,
      );

      // Act
      final AuthResponseModelDto dto = AuthResponseModelDto.fromDomain(domain);

      // Assert
      expect(dto.accessToken, "access_token");
      expect(dto.refreshToken, "refresh_token");
      expect(dto.userInfo, isNotNull);
      expect(dto.userInfo?.firstName, "John");
      expect(dto.userToken, "user_token");
      expect(dto.isVerified, true);
    });

    test("fromDomain handles null userInfo", () {
      // Arrange
      final AuthResponseModel domain = AuthResponseModel(
        accessToken: "token",
      );

      // Act
      final AuthResponseModelDto dto = AuthResponseModelDto.fromDomain(domain);

      // Assert
      expect(dto.accessToken, "token");
      expect(dto.userInfo, isNull);
    });

    test("fromDomain handles null fields", () {
      // Arrange
      final AuthResponseModel domain = AuthResponseModel();

      // Act
      final AuthResponseModelDto dto = AuthResponseModelDto.fromDomain(domain);

      // Assert
      expect(dto.accessToken, isNull);
      expect(dto.refreshToken, isNull);
      expect(dto.userInfo, isNull);
      expect(dto.userToken, isNull);
      expect(dto.isVerified, isNull);
    });

    test("toDomain converts dto to domain model with all fields", () {
      // Arrange
      final AuthResponseModelDto dto = AuthResponseModelDto(
        accessToken: "access_token",
        refreshToken: "refresh_token",
        userInfo: UserInfoResponseModelDto(firstName: "Jane"),
        userToken: "user_token",
        isVerified: true,
      );

      // Act
      final AuthResponseModel domain = dto.toDomain();

      // Assert
      expect(domain.accessToken, "access_token");
      expect(domain.refreshToken, "refresh_token");
      expect(domain.userInfo, isNotNull);
      expect(domain.userInfo?.firstName, "Jane");
      expect(domain.userToken, "user_token");
      expect(domain.isVerified, true);
    });

    test("toDomain handles null userInfo", () {
      // Arrange
      final AuthResponseModelDto dto = AuthResponseModelDto(
        accessToken: "token",
      );

      // Act
      final AuthResponseModel domain = dto.toDomain();

      // Assert
      expect(domain.accessToken, "token");
      expect(domain.userInfo, isNull);
    });

    test("toDomain handles null fields", () {
      // Arrange
      final AuthResponseModelDto dto = AuthResponseModelDto();

      // Act
      final AuthResponseModel domain = dto.toDomain();

      // Assert
      expect(domain.accessToken, isNull);
      expect(domain.userInfo, isNull);
      expect(domain.isVerified, isNull);
    });

    test("fromDomain and toDomain roundtrip preserves data", () {
      // Arrange
      final AuthResponseModel original = AuthResponseModel(
        accessToken: "access",
        refreshToken: "refresh",
        userToken: "user_tok",
        isVerified: false,
      );

      // Act
      final AuthResponseModelDto dto =
          AuthResponseModelDto.fromDomain(original);
      final AuthResponseModel result = dto.toDomain();

      // Assert
      expect(result.accessToken, original.accessToken);
      expect(result.refreshToken, original.refreshToken);
      expect(result.userToken, original.userToken);
      expect(result.isVerified, original.isVerified);
    });
  });
}
