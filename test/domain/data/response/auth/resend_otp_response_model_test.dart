import "package:esim_open_source/domain/data/response/auth/resend_otp_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for ResendOtpResponseModel
/// Tests constructor, copyWith, toJson, and field management
void main() {
  group("ResendOtpResponseModel Tests", () {
    test("constructor assigns all values correctly", () {
      // Act
      final ResendOtpResponseModel model = ResendOtpResponseModel(
        status: "success",
        totalCount: 1,
        data: "OTP sent",
        title: "OTP Sent",
        message: "OTP has been sent to your number",
        developerMessage: "OTP validation successful",
        responseCode: 200,
      );

      // Assert
      expect(model.status, "success");
      expect(model.totalCount, 1);
      expect(model.data, "OTP sent");
      expect(model.title, "OTP Sent");
      expect(model.message, "OTP has been sent to your number");
      expect(model.developerMessage, "OTP validation successful");
      expect(model.responseCode, 200);
    });

    test("all fields are nullable", () {
      // Act
      final ResendOtpResponseModel model = ResendOtpResponseModel();

      // Assert
      expect(model.status, isNull);
      expect(model.totalCount, isNull);
      expect(model.data, isNull);
      expect(model.title, isNull);
      expect(model.message, isNull);
      expect(model.developerMessage, isNull);
      expect(model.responseCode, isNull);
    });

    test("constructor with partial fields", () {
      // Act
      final ResendOtpResponseModel model = ResendOtpResponseModel(
        status: "success",
        totalCount: 1,
        responseCode: 200,
      );

      // Assert
      expect(model.status, "success");
      expect(model.totalCount, 1);
      expect(model.responseCode, 200);
      expect(model.data, isNull);
      expect(model.title, isNull);
      expect(model.message, isNull);
      expect(model.developerMessage, isNull);
    });

    test("getter status returns correct value", () {
      // Arrange
      final ResendOtpResponseModel model = ResendOtpResponseModel(
        status: "pending",
      );

      // Act
      final String? result = model.status;

      // Assert
      expect(result, "pending");
    });

    test("getter totalCount returns correct value", () {
      // Arrange
      final ResendOtpResponseModel model = ResendOtpResponseModel(
        totalCount: 5,
      );

      // Act
      final int? result = model.totalCount;

      // Assert
      expect(result, 5);
    });

    test("getter data returns correct value", () {
      // Arrange
      final ResendOtpResponseModel model = ResendOtpResponseModel(
        data: "data123",
      );

      // Act
      final String? result = model.data;

      // Assert
      expect(result, "data123");
    });

    test("getter title returns correct value", () {
      // Arrange
      final ResendOtpResponseModel model = ResendOtpResponseModel(
        title: "Success",
      );

      // Act
      final String? result = model.title;

      // Assert
      expect(result, "Success");
    });

    test("getter message returns correct value", () {
      // Arrange
      final ResendOtpResponseModel model = ResendOtpResponseModel(
        message: "Operation completed",
      );

      // Act
      final String? result = model.message;

      // Assert
      expect(result, "Operation completed");
    });

    test("getter developerMessage returns correct value", () {
      // Arrange
      final ResendOtpResponseModel model = ResendOtpResponseModel(
        developerMessage: "Debug info",
      );

      // Act
      final String? result = model.developerMessage;

      // Assert
      expect(result, "Debug info");
    });

    test("getter responseCode returns correct value", () {
      // Arrange
      final ResendOtpResponseModel model = ResendOtpResponseModel(
        responseCode: 400,
      );

      // Act
      final int? result = model.responseCode;

      // Assert
      expect(result, 400);
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final ResendOtpResponseModel model = ResendOtpResponseModel(
        status: "success",
        totalCount: 1,
        data: "OTP sent",
        title: "OTP Sent",
        message: "OTP has been sent",
        developerMessage: "Validation passed",
        responseCode: 200,
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["status"], "success");
      expect(json["totalCount"], 1);
      expect(json["data"], "OTP sent");
      expect(json["title"], "OTP Sent");
      expect(json["message"], "OTP has been sent");
      expect(json["developerMessage"], "Validation passed");
      expect(json["responseCode"], 200);
    });

    test("toJson handles null fields", () {
      // Arrange
      final ResendOtpResponseModel model = ResendOtpResponseModel();

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

    test("toJson returns Map<String, dynamic>", () {
      // Arrange
      final ResendOtpResponseModel model = ResendOtpResponseModel(
        status: "success",
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json, isA<Map<String, dynamic>>());
    });

    test("toJson with partial fields", () {
      // Arrange
      final ResendOtpResponseModel model = ResendOtpResponseModel(
        status: "success",
        responseCode: 200,
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["status"], "success");
      expect(json["responseCode"], 200);
      expect(json["totalCount"], isNull);
      expect(json["data"], isNull);
      expect(json["title"], isNull);
      expect(json["message"], isNull);
      expect(json["developerMessage"], isNull);
    });

    test("copyWith creates new instance with updated status", () {
      // Arrange
      final ResendOtpResponseModel original = ResendOtpResponseModel(
        status: "success",
        responseCode: 200,
      );

      // Act
      final ResendOtpResponseModel updated = original.copyWith(
        status: "failed",
      );

      // Assert
      expect(updated.status, "failed");
      expect(updated.responseCode, 200);
    });

    test("copyWith creates new instance with updated totalCount", () {
      // Arrange
      final ResendOtpResponseModel original = ResendOtpResponseModel(
        totalCount: 1,
      );

      // Act
      final ResendOtpResponseModel updated = original.copyWith(
        totalCount: 5,
      );

      // Assert
      expect(updated.totalCount, 5);
    });

    test("copyWith creates new instance with updated data", () {
      // Arrange
      final ResendOtpResponseModel original = ResendOtpResponseModel(
        data: "original data",
      );

      // Act
      final ResendOtpResponseModel updated = original.copyWith(
        data: "new data",
      );

      // Assert
      expect(updated.data, "new data");
    });

    test("copyWith creates new instance with updated title", () {
      // Arrange
      final ResendOtpResponseModel original = ResendOtpResponseModel(
        title: "Old Title",
      );

      // Act
      final ResendOtpResponseModel updated = original.copyWith(
        title: "New Title",
      );

      // Assert
      expect(updated.title, "New Title");
    });

    test("copyWith creates new instance with updated message", () {
      // Arrange
      final ResendOtpResponseModel original = ResendOtpResponseModel(
        message: "Original message",
      );

      // Act
      final ResendOtpResponseModel updated = original.copyWith(
        message: "Updated message",
      );

      // Assert
      expect(updated.message, "Updated message");
    });

    test("copyWith creates new instance with updated developerMessage", () {
      // Arrange
      final ResendOtpResponseModel original = ResendOtpResponseModel(
        developerMessage: "Original debug",
      );

      // Act
      final ResendOtpResponseModel updated = original.copyWith(
        developerMessage: "Updated debug",
      );

      // Assert
      expect(updated.developerMessage, "Updated debug");
    });

    test("copyWith creates new instance with updated responseCode", () {
      // Arrange
      final ResendOtpResponseModel original = ResendOtpResponseModel(
        responseCode: 200,
      );

      // Act
      final ResendOtpResponseModel updated = original.copyWith(
        responseCode: 400,
      );

      // Assert
      expect(updated.responseCode, 400);
    });

    test("copyWith without parameters returns same values", () {
      // Arrange
      final ResendOtpResponseModel original = ResendOtpResponseModel(
        status: "success",
        totalCount: 1,
        data: "OTP sent",
        title: "OTP Sent",
        message: "OTP has been sent",
        developerMessage: "Validation passed",
        responseCode: 200,
      );

      // Act
      final ResendOtpResponseModel copied = original.copyWith();

      // Assert
      expect(copied.status, original.status);
      expect(copied.totalCount, original.totalCount);
      expect(copied.data, original.data);
      expect(copied.title, original.title);
      expect(copied.message, original.message);
      expect(copied.developerMessage, original.developerMessage);
      expect(copied.responseCode, original.responseCode);
    });

    test("copyWith preserves original instance", () {
      // Arrange
      final ResendOtpResponseModel original = ResendOtpResponseModel(
        status: "success",
        responseCode: 200,
      );

      // Act
      final ResendOtpResponseModel updated = original.copyWith(
        status: "failed",
        responseCode: 400,
      );

      // Assert
      expect(original.status, "success");
      expect(original.responseCode, 200);
      expect(updated.status, "failed");
      expect(updated.responseCode, 400);
    });

    test("copyWith preserves null values when not specified", () {
      // Arrange
      final ResendOtpResponseModel original = ResendOtpResponseModel(
        status: "success",
      );

      // Act
      final ResendOtpResponseModel updated = original.copyWith(
        responseCode: 200,
      );

      // Assert
      expect(updated.status, "success");
      expect(updated.responseCode, 200);
      expect(updated.totalCount, isNull);
      expect(updated.data, isNull);
      expect(updated.title, isNull);
      expect(updated.message, isNull);
      expect(updated.developerMessage, isNull);
    });

    test("copyWith with null value preserves original", () {
      // Arrange
      final ResendOtpResponseModel original = ResendOtpResponseModel(
        status: "success",
        data: "OTP sent",
      );

      // Act
      final ResendOtpResponseModel updated = original.copyWith(
        data: null,
      );

      // Assert
      // copyWith uses ?? operator, so null preserves original value
      expect(updated.status, "success");
      expect(updated.data, "OTP sent");
    });

    test("handles empty string fields", () {
      // Act
      final ResendOtpResponseModel model = ResendOtpResponseModel(
        status: "",
        data: "",
        title: "",
        message: "",
        developerMessage: "",
      );

      // Assert
      expect(model.status, "");
      expect(model.data, "");
      expect(model.title, "");
      expect(model.message, "");
      expect(model.developerMessage, "");
    });

    test("handles special characters in strings", () {
      // Act
      final ResendOtpResponseModel model = ResendOtpResponseModel(
        status: "success",
        title: "OTP Sent: 123-456",
        message: "Message with apostrophe and quotes",
      );

      // Assert
      expect(model.status, "success");
      expect(model.title, "OTP Sent: 123-456");
      expect(model.message, "Message with apostrophe and quotes");
    });

    test("handles zero totalCount", () {
      // Act
      final ResendOtpResponseModel model = ResendOtpResponseModel(
        totalCount: 0,
      );

      // Assert
      expect(model.totalCount, 0);
    });

    test("handles negative totalCount", () {
      // Act
      final ResendOtpResponseModel model = ResendOtpResponseModel(
        totalCount: -1,
      );

      // Assert
      expect(model.totalCount, -1);
    });

    test("handles large totalCount values", () {
      // Act
      final ResendOtpResponseModel model = ResendOtpResponseModel(
        totalCount: 999999,
      );

      // Assert
      expect(model.totalCount, 999999);
    });

    test("handles HTTP status codes in responseCode", () {
      // Act
      final ResendOtpResponseModel model200 = ResendOtpResponseModel(
        responseCode: 200,
      );
      final ResendOtpResponseModel model400 = ResendOtpResponseModel(
        responseCode: 400,
      );
      final ResendOtpResponseModel model500 = ResendOtpResponseModel(
        responseCode: 500,
      );

      // Assert
      expect(model200.responseCode, 200);
      expect(model400.responseCode, 400);
      expect(model500.responseCode, 500);
    });

    test("multiple instances are independent", () {
      // Act
      final ResendOtpResponseModel model1 = ResendOtpResponseModel(
        status: "success",
        responseCode: 200,
      );
      final ResendOtpResponseModel model2 = ResendOtpResponseModel(
        status: "failed",
        responseCode: 400,
      );

      // Assert
      expect(model1.status, "success");
      expect(model1.responseCode, 200);
      expect(model2.status, "failed");
      expect(model2.responseCode, 400);
    });

    test("copyWith preserves original when creating multiple copies", () {
      // Arrange
      final ResendOtpResponseModel original = ResendOtpResponseModel(
        status: "success",
        responseCode: 200,
      );

      // Act
      final ResendOtpResponseModel copy1 = original.copyWith();
      final ResendOtpResponseModel copy2 = original.copyWith(
        status: "pending",
      );

      // Assert
      expect(original.status, "success");
      expect(copy1.status, "success");
      expect(copy2.status, "pending");
    });

    test("toJson and copyWith work together correctly", () {
      // Arrange
      final ResendOtpResponseModel original = ResendOtpResponseModel(
        status: "success",
        responseCode: 200,
      );

      // Act
      final ResendOtpResponseModel updated = original.copyWith(
        status: "pending",
      );
      final Map<String, dynamic> json = updated.toJson();

      // Assert
      expect(json["status"], "pending");
      expect(json["responseCode"], 200);
    });

    test("handles null status with other fields populated", () {
      // Act
      final ResendOtpResponseModel model = ResendOtpResponseModel(
        totalCount: 1,
        data: "OTP sent",
        responseCode: 200,
      );

      // Assert
      expect(model.status, isNull);
      expect(model.totalCount, 1);
      expect(model.data, "OTP sent");
      expect(model.responseCode, 200);
    });

    test("handles null responseCode with other fields populated", () {
      // Act
      final ResendOtpResponseModel model = ResendOtpResponseModel(
        status: "success",
        totalCount: 1,
        data: "OTP sent",
      );

      // Assert
      expect(model.responseCode, isNull);
      expect(model.status, "success");
      expect(model.totalCount, 1);
      expect(model.data, "OTP sent");
    });
  });
}
