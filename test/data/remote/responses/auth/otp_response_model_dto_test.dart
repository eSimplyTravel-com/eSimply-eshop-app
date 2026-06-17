import "dart:convert";

import "package:esim_open_source/data/remote/responses/auth/otp_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/auth/otp_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for OtpResponseModelDto
/// Tests JSON serialization/deserialization and model methods
void main() {
  group("OtpResponseModelDto Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "otp_expiration": 300,
      };

      // Act
      final OtpResponseModelDto model =
          OtpResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.otpExpiration, 300);
    });

    test("fromJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final OtpResponseModelDto model =
          OtpResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.otpExpiration, isNull);
    });

    test("fromJson with explicit null value", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "otp_expiration": null,
      };

      // Act
      final OtpResponseModelDto model =
          OtpResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.otpExpiration, isNull);
    });

    test("fromAPIJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "otp_expiration": 600,
      };

      // Act
      final OtpResponseModelDto model =
          OtpResponseModelDto.fromAPIJson(json: json);

      // Assert
      expect(model.otpExpiration, 600);
    });

    test("fromAPIJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final OtpResponseModelDto model =
          OtpResponseModelDto.fromAPIJson(json: json);

      // Assert
      expect(model.otpExpiration, isNull);
    });

    test("fromJson and fromAPIJson produce identical results", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "otp_expiration": 480,
      };

      // Act
      final OtpResponseModelDto fromJsonModel =
          OtpResponseModelDto.fromJson(json: json);
      final OtpResponseModelDto fromAPIJsonModel =
          OtpResponseModelDto.fromAPIJson(json: json);

      // Assert
      expect(fromJsonModel.otpExpiration, fromAPIJsonModel.otpExpiration);
    });

    test("constructor assigns values correctly", () {
      // Act
      final OtpResponseModelDto model = OtpResponseModelDto(
        otpExpiration: 180,
      );

      // Assert
      expect(model.otpExpiration, 180);
    });

    test("constructor with null value", () {
      // Act
      final OtpResponseModelDto model = OtpResponseModelDto();

      // Assert
      expect(model.otpExpiration, isNull);
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final OtpResponseModelDto model = OtpResponseModelDto(
        otpExpiration: 450,
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["otp_expiration"], 450);
    });

    test("toJson handles null fields", () {
      // Arrange
      final OtpResponseModelDto model = OtpResponseModelDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["otp_expiration"], isNull);
    });

    test("copyWith creates new instance with updated fields", () {
      // Arrange
      final OtpResponseModelDto original = OtpResponseModelDto(
        otpExpiration: 300,
      );

      // Act
      final OtpResponseModelDto updated = original.copyWith(
        otpExpiration: 600,
      );

      // Assert
      expect(updated.otpExpiration, 600);
      expect(original.otpExpiration, 300);
    });

    test("copyWith without parameters returns same values", () {
      // Arrange
      final OtpResponseModelDto original = OtpResponseModelDto(
        otpExpiration: 500,
      );

      // Act
      final OtpResponseModelDto copied = original.copyWith();

      // Assert
      expect(copied.otpExpiration, original.otpExpiration);
    });

    test("copyWith preserves original instance", () {
      // Arrange
      final OtpResponseModelDto original = OtpResponseModelDto(
        otpExpiration: 200,
      );

      // Act
      final OtpResponseModelDto updated = original.copyWith(
        otpExpiration: 400,
      );

      // Assert
      expect(original.otpExpiration, 200);
      expect(updated.otpExpiration, 400);
    });

    test("fromJsonString parses JSON string correctly", () {
      // Arrange
      final String jsonString = """
      {
        "otp_expiration": 720
      }
      """;

      // Act
      final OtpResponseModelDto model =
          OtpResponseModelDto.fromJsonString(jsonString);

      // Assert
      expect(model.otpExpiration, 720);
    });

    test("toJsonString converts model to JSON string", () {
      // Arrange
      final OtpResponseModelDto model = OtpResponseModelDto(
        otpExpiration: 360,
      );

      // Act
      final String jsonString = model.toJsonString();
      final Map<String, dynamic> decoded = jsonDecode(jsonString);

      // Assert
      expect(decoded["otp_expiration"], 360);
    });

    test("toJsonString produces valid JSON", () {
      // Arrange
      final OtpResponseModelDto model = OtpResponseModelDto(
        otpExpiration: 300,
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
        "otp_expiration":    300
      }

      """;

      // Act
      final OtpResponseModelDto model =
          OtpResponseModelDto.fromJsonString(jsonString);

      // Assert
      expect(model.otpExpiration, 300);
    });

    test("roundtrip fromJson and toJson preserves data", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "otp_expiration": 900,
      };

      // Act
      final OtpResponseModelDto model =
          OtpResponseModelDto.fromJson(json: originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(resultJson["otp_expiration"], originalJson["otp_expiration"]);
    });

    test("roundtrip fromJsonString and toJsonString preserves data", () {
      // Arrange
      final OtpResponseModelDto original = OtpResponseModelDto(
        otpExpiration: 240,
      );

      // Act
      final String jsonString = original.toJsonString();
      final OtpResponseModelDto parsed =
          OtpResponseModelDto.fromJsonString(jsonString);

      // Assert
      expect(parsed.otpExpiration, original.otpExpiration);
    });

    test("handles zero expiration", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "otp_expiration": 0,
      };

      // Act
      final OtpResponseModelDto model =
          OtpResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.otpExpiration, 0);
    });

    test("handles negative expiration", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "otp_expiration": -1,
      };

      // Act
      final OtpResponseModelDto model =
          OtpResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.otpExpiration, -1);
    });

    test("handles large expiration values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "otp_expiration": 86400,
      };

      // Act
      final OtpResponseModelDto model =
          OtpResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.otpExpiration, 86400);
    });

    test("handles various expiration times", () {
      // Test common OTP expiration times
      final List<int> expirationTimes = <int>[
        30,
        60,
        120,
        300,
        600,
        900,
      ];

      for (final int expiration in expirationTimes) {
        final OtpResponseModelDto model = OtpResponseModelDto(
          otpExpiration: expiration,
        );
        expect(model.otpExpiration, expiration);
      }
    });

    test("multiple instances are independent", () {
      // Act
      final OtpResponseModelDto model1 =
          OtpResponseModelDto(otpExpiration: 100);
      final OtpResponseModelDto model2 =
          OtpResponseModelDto(otpExpiration: 200);

      // Assert
      expect(model1.otpExpiration, 100);
      expect(model2.otpExpiration, 200);
    });

    test("toDomain converts dto to domain model", () {
      // Arrange
      final OtpResponseModelDto dto = OtpResponseModelDto(
        otpExpiration: 300,
      );

      // Act
      final OtpResponseModel domain = dto.toDomain();

      // Assert
      expect(domain.otpExpiration, 300);
    });

    test("toDomain handles null value", () {
      // Arrange
      final OtpResponseModelDto dto = OtpResponseModelDto();

      // Act
      final OtpResponseModel domain = dto.toDomain();

      // Assert
      expect(domain.otpExpiration, isNull);
    });
  });
}
