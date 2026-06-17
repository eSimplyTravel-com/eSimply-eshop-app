import "dart:convert";

import "package:esim_open_source/data/remote/responses/auth/resend_otp_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/auth/resend_otp_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for ResendOtpResponseModelDto
/// Tests JSON serialization/deserialization and model methods
void main() {
  group("ResendOtpResponseModelDto Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "status": "success",
        "totalCount": 1,
        "data": "OTP sent",
        "title": "OTP Sent",
        "message": "OTP has been sent to your phone",
        "developerMessage": "OTP sent successfully",
        "responseCode": 200,
      };

      // Act
      final ResendOtpResponseModelDto model =
          ResendOtpResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.status, "success");
      expect(model.totalCount, 1);
      expect(model.data, "OTP sent");
      expect(model.title, "OTP Sent");
      expect(model.message, "OTP has been sent to your phone");
      expect(model.developerMessage, "OTP sent successfully");
      expect(model.responseCode, 200);
    });

    test("fromJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final ResendOtpResponseModelDto model =
          ResendOtpResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.status, isNull);
      expect(model.totalCount, isNull);
      expect(model.data, isNull);
      expect(model.title, isNull);
      expect(model.message, isNull);
      expect(model.developerMessage, isNull);
      expect(model.responseCode, isNull);
    });

    test("fromJson handles null status field", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "status": null,
        "responseCode": 200,
      };

      // Act
      final ResendOtpResponseModelDto model =
          ResendOtpResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.status, isNull);
      expect(model.responseCode, 200);
    });

    test("fromJson with explicit null values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "status": null,
        "totalCount": null,
        "data": null,
        "title": null,
        "message": null,
        "developerMessage": null,
        "responseCode": null,
      };

      // Act
      final ResendOtpResponseModelDto model =
          ResendOtpResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.status, isNull);
      expect(model.totalCount, isNull);
      expect(model.data, isNull);
      expect(model.title, isNull);
      expect(model.message, isNull);
      expect(model.developerMessage, isNull);
      expect(model.responseCode, isNull);
    });

    test("fromAPIJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "status": "pending",
        "totalCount": 2,
        "data": "Resending",
        "title": "Resend",
        "message": "Resending OTP",
        "developerMessage": "Resend in progress",
        "responseCode": 202,
      };

      // Act
      final ResendOtpResponseModelDto model =
          ResendOtpResponseModelDto.fromAPIJson(json: json);

      // Assert
      expect(model.status, "pending");
      expect(model.totalCount, 2);
      expect(model.data, "Resending");
      expect(model.title, "Resend");
      expect(model.message, "Resending OTP");
      expect(model.developerMessage, "Resend in progress");
      expect(model.responseCode, 202);
    });

    test("fromAPIJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final ResendOtpResponseModelDto model =
          ResendOtpResponseModelDto.fromAPIJson(json: json);

      // Assert
      expect(model.status, isNull);
      expect(model.totalCount, isNull);
      expect(model.data, isNull);
    });

    test("fromJson and fromAPIJson produce identical results", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "status": "error",
        "totalCount": 0,
        "responseCode": 400,
      };

      // Act
      final ResendOtpResponseModelDto fromJsonModel =
          ResendOtpResponseModelDto.fromJson(json: json);
      final ResendOtpResponseModelDto fromAPIJsonModel =
          ResendOtpResponseModelDto.fromAPIJson(json: json);

      // Assert
      expect(fromJsonModel.status, fromAPIJsonModel.status);
      expect(fromJsonModel.totalCount, fromAPIJsonModel.totalCount);
      expect(fromJsonModel.responseCode, fromAPIJsonModel.responseCode);
    });

    test("constructor assigns values correctly", () {
      // Act
      final ResendOtpResponseModelDto model = ResendOtpResponseModelDto(
        status: "success",
        totalCount: 1,
        data: "OTP",
        title: "Success",
        message: "Done",
        developerMessage: "OK",
        responseCode: 200,
      );

      // Assert
      expect(model.status, "success");
      expect(model.totalCount, 1);
      expect(model.data, "OTP");
      expect(model.title, "Success");
      expect(model.message, "Done");
      expect(model.developerMessage, "OK");
      expect(model.responseCode, 200);
    });

    test("constructor with minimal fields", () {
      // Act
      final ResendOtpResponseModelDto model = ResendOtpResponseModelDto();

      // Assert
      expect(model.status, isNull);
      expect(model.totalCount, isNull);
      expect(model.data, isNull);
      expect(model.title, isNull);
      expect(model.message, isNull);
      expect(model.developerMessage, isNull);
      expect(model.responseCode, isNull);
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final ResendOtpResponseModelDto model = ResendOtpResponseModelDto(
        status: "success",
        totalCount: 3,
        data: "test_data",
        title: "Test Title",
        message: "Test Message",
        developerMessage: "Test Dev Message",
        responseCode: 201,
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["status"], "success");
      expect(json["totalCount"], 3);
      expect(json["data"], "test_data");
      expect(json["title"], "Test Title");
      expect(json["message"], "Test Message");
      expect(json["developerMessage"], "Test Dev Message");
      expect(json["responseCode"], 201);
    });

    test("toJson handles null fields", () {
      // Arrange
      final ResendOtpResponseModelDto model = ResendOtpResponseModelDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["status"], isNull);
      expect(json["totalCount"], isNull);
      expect(json["data"], isNull);
      expect(json["title"], isNull);
      expect(json["message"], isNull);
      expect(json["developerMessage"], isNull);
      expect(json["responseCode"], isNull);
    });

    test("copyWith creates new instance with updated fields", () {
      // Arrange
      final ResendOtpResponseModelDto original = ResendOtpResponseModelDto(
        status: "success",
        totalCount: 1,
        responseCode: 200,
      );

      // Act
      final ResendOtpResponseModelDto updated = original.copyWith(
        status: "failed",
      );

      // Assert
      expect(updated.status, "failed");
      expect(updated.totalCount, 1);
      expect(updated.responseCode, 200);
      expect(original.status, "success");
    });

    test("copyWith without parameters returns same values", () {
      // Arrange
      final ResendOtpResponseModelDto original = ResendOtpResponseModelDto(
        status: "pending",
        totalCount: 2,
        message: "Pending",
      );

      // Act
      final ResendOtpResponseModelDto copied = original.copyWith();

      // Assert
      expect(copied.status, original.status);
      expect(copied.totalCount, original.totalCount);
      expect(copied.message, original.message);
    });

    test("copyWith preserves null values when not specified", () {
      // Arrange
      final ResendOtpResponseModelDto original = ResendOtpResponseModelDto(
        status: "success",
        data: null,
      );

      // Act
      final ResendOtpResponseModelDto updated = original.copyWith(
        message: "New message",
      );

      // Assert
      expect(updated.status, "success");
      expect(updated.message, "New message");
      expect(updated.data, isNull);
    });

    test("copyWith preserves original instance", () {
      // Arrange
      final ResendOtpResponseModelDto original = ResendOtpResponseModelDto(
        status: "original",
        responseCode: 100,
      );

      // Act
      final ResendOtpResponseModelDto updated = original.copyWith(
        status: "updated",
      );

      // Assert
      expect(original.status, "original");
      expect(updated.status, "updated");
      expect(original.responseCode, 100);
    });

    test("fromJsonString parses JSON string correctly", () {
      // Arrange
      final String jsonString = """
      {
        "status": "success",
        "totalCount": 1,
        "responseCode": 200
      }
      """;

      // Act
      final ResendOtpResponseModelDto model =
          ResendOtpResponseModelDto.fromJsonString(jsonString);

      // Assert
      expect(model.status, "success");
      expect(model.totalCount, 1);
      expect(model.responseCode, 200);
    });

    test("toJsonString converts model to JSON string", () {
      // Arrange
      final ResendOtpResponseModelDto model = ResendOtpResponseModelDto(
        status: "success",
        data: "string_data",
        responseCode: 200,
      );

      // Act
      final String jsonString = model.toJsonString();
      final Map<String, dynamic> decoded = jsonDecode(jsonString);

      // Assert
      expect(decoded["status"], "success");
      expect(decoded["data"], "string_data");
      expect(decoded["responseCode"], 200);
    });

    test("toJsonString produces valid JSON", () {
      // Arrange
      final ResendOtpResponseModelDto model = ResendOtpResponseModelDto(
        status: "pending",
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
        "status":    "success",
        "responseCode":  200
      }

      """;

      // Act
      final ResendOtpResponseModelDto model =
          ResendOtpResponseModelDto.fromJsonString(jsonString);

      // Assert
      expect(model.status, "success");
      expect(model.responseCode, 200);
    });

    test("roundtrip fromJson and toJson preserves data", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "status": "success",
        "totalCount": 1,
        "data": "test",
        "title": "Test",
        "message": "Message",
        "developerMessage": "Dev Message",
        "responseCode": 200,
      };

      // Act
      final ResendOtpResponseModelDto model =
          ResendOtpResponseModelDto.fromJson(json: originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(resultJson["status"], originalJson["status"]);
      expect(resultJson["totalCount"], originalJson["totalCount"]);
      expect(resultJson["data"], originalJson["data"]);
      expect(resultJson["title"], originalJson["title"]);
      expect(resultJson["message"], originalJson["message"]);
      expect(resultJson["developerMessage"], originalJson["developerMessage"]);
      expect(resultJson["responseCode"], originalJson["responseCode"]);
    });

    test("roundtrip fromJsonString and toJsonString preserves data", () {
      // Arrange
      final ResendOtpResponseModelDto original = ResendOtpResponseModelDto(
        status: "pending",
        totalCount: 2,
        responseCode: 202,
      );

      // Act
      final String jsonString = original.toJsonString();
      final ResendOtpResponseModelDto parsed =
          ResendOtpResponseModelDto.fromJsonString(jsonString);

      // Assert
      expect(parsed.status, original.status);
      expect(parsed.totalCount, original.totalCount);
      expect(parsed.responseCode, original.responseCode);
    });

    test("handles empty string values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "status": "",
        "data": "",
        "title": "",
        "message": "",
        "developerMessage": "",
      };

      // Act
      final ResendOtpResponseModelDto model =
          ResendOtpResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.status, "");
      expect(model.data, "");
      expect(model.title, "");
      expect(model.message, "");
      expect(model.developerMessage, "");
    });

    test("handles special characters in strings", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "status": "success_with_!@#",
        "message": "Message with 'quotes'",
        "data": "Data with \"double quotes\"",
      };

      // Act
      final ResendOtpResponseModelDto model =
          ResendOtpResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.status, "success_with_!@#");
      expect(model.message, "Message with 'quotes'");
      expect(model.data, "Data with \"double quotes\"");
    });

    test("handles zero responseCode", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "responseCode": 0,
      };

      // Act
      final ResendOtpResponseModelDto model =
          ResendOtpResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.responseCode, 0);
    });

    test("handles negative responseCode", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "responseCode": -1,
      };

      // Act
      final ResendOtpResponseModelDto model =
          ResendOtpResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.responseCode, -1);
    });

    test("handles large responseCode values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "responseCode": 599,
      };

      // Act
      final ResendOtpResponseModelDto model =
          ResendOtpResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.responseCode, 599);
    });

    test("handles zero totalCount", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "totalCount": 0,
      };

      // Act
      final ResendOtpResponseModelDto model =
          ResendOtpResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.totalCount, 0);
    });

    test("handles negative totalCount", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "totalCount": -5,
      };

      // Act
      final ResendOtpResponseModelDto model =
          ResendOtpResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.totalCount, -5);
    });

    test("handles large totalCount values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "totalCount": 999999,
      };

      // Act
      final ResendOtpResponseModelDto model =
          ResendOtpResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.totalCount, 999999);
    });

    test("multiple instances are independent", () {
      // Act
      final ResendOtpResponseModelDto model1 = ResendOtpResponseModelDto(
        status: "success",
        responseCode: 200,
      );
      final ResendOtpResponseModelDto model2 = ResendOtpResponseModelDto(
        status: "failed",
        responseCode: 400,
      );

      // Assert
      expect(model1.status, "success");
      expect(model1.responseCode, 200);
      expect(model2.status, "failed");
      expect(model2.responseCode, 400);
    });

    test("copyWith updates multiple fields", () {
      // Arrange
      final ResendOtpResponseModelDto original = ResendOtpResponseModelDto(
        status: "success",
        totalCount: 1,
        message: "Original",
        responseCode: 200,
      );

      // Act
      final ResendOtpResponseModelDto updated = original.copyWith(
        status: "updated",
        message: "Updated",
      );

      // Assert
      expect(updated.status, "updated");
      expect(updated.totalCount, 1);
      expect(updated.message, "Updated");
      expect(updated.responseCode, 200);
    });

    test("toDomain converts dto to domain model with all fields", () {
      // Arrange
      final ResendOtpResponseModelDto dto = ResendOtpResponseModelDto(
        status: "success",
        totalCount: 1,
        data: "OTP",
        title: "Success",
        message: "Done",
        developerMessage: "OK",
        responseCode: 200,
      );

      // Act
      final ResendOtpResponseModel domain = dto.toDomain();

      // Assert
      expect(domain.status, "success");
      expect(domain.totalCount, 1);
      expect(domain.data, "OTP");
      expect(domain.title, "Success");
      expect(domain.message, "Done");
      expect(domain.developerMessage, "OK");
      expect(domain.responseCode, 200);
    });

    test("toDomain handles null fields", () {
      // Arrange
      final ResendOtpResponseModelDto dto = ResendOtpResponseModelDto();

      // Act
      final ResendOtpResponseModel domain = dto.toDomain();

      // Assert
      expect(domain.status, isNull);
      expect(domain.totalCount, isNull);
      expect(domain.data, isNull);
      expect(domain.responseCode, isNull);
    });
  });
}
