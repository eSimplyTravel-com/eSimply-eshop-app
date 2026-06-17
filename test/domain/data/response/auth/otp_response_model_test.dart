import "package:esim_open_source/domain/data/response/auth/otp_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for OtpResponseModel
/// Tests constructor, copyWith, and field management
void main() {
  group("OtpResponseModel Tests", () {
    test("constructor assigns all values correctly", () {
      // Act
      final OtpResponseModel model = OtpResponseModel(
        otpExpiration: 3600,
      );

      // Assert
      expect(model.otpExpiration, 3600);
    });

    test("all fields are nullable", () {
      // Act
      final OtpResponseModel model = OtpResponseModel();

      // Assert
      expect(model.otpExpiration, isNull);
    });

    test("constructor with null otpExpiration", () {
      // Act
      final OtpResponseModel model = OtpResponseModel(
        otpExpiration: null,
      );

      // Assert
      expect(model.otpExpiration, isNull);
    });

    test("getter otpExpiration returns correct value", () {
      // Arrange
      final OtpResponseModel model = OtpResponseModel(
        otpExpiration: 7200,
      );

      // Act
      final int? result = model.otpExpiration;

      // Assert
      expect(result, 7200);
    });

    test("copyWith creates new instance with updated otpExpiration", () {
      // Arrange
      final OtpResponseModel original = OtpResponseModel(
        otpExpiration: 3600,
      );

      // Act
      final OtpResponseModel updated = original.copyWith(
        otpExpiration: 7200,
      );

      // Assert
      expect(updated.otpExpiration, 7200);
    });

    test("copyWith without parameters returns same values", () {
      // Arrange
      final OtpResponseModel original = OtpResponseModel(
        otpExpiration: 3600,
      );

      // Act
      final OtpResponseModel copied = original.copyWith();

      // Assert
      expect(copied.otpExpiration, original.otpExpiration);
    });

    test("copyWith preserves original instance", () {
      // Arrange
      final OtpResponseModel original = OtpResponseModel(
        otpExpiration: 3600,
      );

      // Act
      final OtpResponseModel updated = original.copyWith(
        otpExpiration: 7200,
      );

      // Assert
      expect(original.otpExpiration, 3600);
      expect(updated.otpExpiration, 7200);
    });

    test("copyWith with null value preserves original", () {
      // Arrange
      final OtpResponseModel original = OtpResponseModel(
        otpExpiration: 3600,
      );

      // Act
      final OtpResponseModel updated = original.copyWith(
        otpExpiration: null,
      );

      // Assert
      // copyWith uses ?? operator, so null preserves original value
      expect(updated.otpExpiration, 3600);
    });

    test("handles zero otpExpiration", () {
      // Act
      final OtpResponseModel model = OtpResponseModel(
        otpExpiration: 0,
      );

      // Assert
      expect(model.otpExpiration, 0);
    });

    test("handles negative otpExpiration", () {
      // Act
      final OtpResponseModel model = OtpResponseModel(
        otpExpiration: -1,
      );

      // Assert
      expect(model.otpExpiration, -1);
    });

    test("handles large otpExpiration values", () {
      // Act
      final OtpResponseModel model = OtpResponseModel(
        otpExpiration: 999999999,
      );

      // Assert
      expect(model.otpExpiration, 999999999);
    });

    test("multiple instances are independent", () {
      // Act
      final OtpResponseModel model1 = OtpResponseModel(
        otpExpiration: 3600,
      );
      final OtpResponseModel model2 = OtpResponseModel(
        otpExpiration: 7200,
      );

      // Assert
      expect(model1.otpExpiration, 3600);
      expect(model2.otpExpiration, 7200);
    });

    test("copyWith preserves original when creating multiple copies", () {
      // Arrange
      final OtpResponseModel original = OtpResponseModel(
        otpExpiration: 3600,
      );

      // Act
      final OtpResponseModel copy1 = original.copyWith();
      final OtpResponseModel copy2 = original.copyWith(
        otpExpiration: 5400,
      );

      // Assert
      expect(original.otpExpiration, 3600);
      expect(copy1.otpExpiration, 3600);
      expect(copy2.otpExpiration, 5400);
    });
  });
}
