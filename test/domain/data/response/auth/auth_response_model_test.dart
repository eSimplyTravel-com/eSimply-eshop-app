import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/data/response/auth/user_info_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for AuthResponseModel
/// Tests constructor, copyWith, and nested field management
void main() {
  group("AuthResponseModel Tests", () {
    test("constructor assigns all values correctly", () {
      // Arrange
      final UserInfoResponseModel userInfo = UserInfoResponseModel(
        firstName: "John",
        lastName: "Doe",
      );

      // Act
      final AuthResponseModel model = AuthResponseModel(
        accessToken: "access123",
        refreshToken: "refresh123",
        userInfo: userInfo,
        userToken: "token123",
        isVerified: true,
      );

      // Assert
      expect(model.accessToken, "access123");
      expect(model.refreshToken, "refresh123");
      expect(model.userInfo, userInfo);
      expect(model.userToken, "token123");
      expect(model.isVerified, true);
    });

    test("all fields are nullable", () {
      // Act
      final AuthResponseModel model = AuthResponseModel();

      // Assert
      expect(model.accessToken, isNull);
      expect(model.refreshToken, isNull);
      expect(model.userInfo, isNull);
      expect(model.userToken, isNull);
      expect(model.isVerified, isNull);
    });

    test("constructor with partial fields", () {
      // Act
      final AuthResponseModel model = AuthResponseModel(
        accessToken: "access123",
        refreshToken: "refresh123",
      );

      // Assert
      expect(model.accessToken, "access123");
      expect(model.refreshToken, "refresh123");
      expect(model.userInfo, isNull);
      expect(model.userToken, isNull);
      expect(model.isVerified, isNull);
    });

    test("getter accessToken returns correct value", () {
      // Arrange
      final AuthResponseModel model = AuthResponseModel(
        accessToken: "access456",
      );

      // Act
      final String? result = model.accessToken;

      // Assert
      expect(result, "access456");
    });

    test("getter refreshToken returns correct value", () {
      // Arrange
      final AuthResponseModel model = AuthResponseModel(
        refreshToken: "refresh456",
      );

      // Act
      final String? result = model.refreshToken;

      // Assert
      expect(result, "refresh456");
    });

    test("getter userInfo returns correct value", () {
      // Arrange
      final UserInfoResponseModel userInfo = UserInfoResponseModel(
        firstName: "Jane",
        email: "jane@example.com",
      );
      final AuthResponseModel model = AuthResponseModel(
        userInfo: userInfo,
      );

      // Act
      final UserInfoResponseModel? result = model.userInfo;

      // Assert
      expect(result, userInfo);
      expect(result?.firstName, "Jane");
      expect(result?.email, "jane@example.com");
    });

    test("getter userToken returns correct value", () {
      // Arrange
      final AuthResponseModel model = AuthResponseModel(
        userToken: "token456",
      );

      // Act
      final String? result = model.userToken;

      // Assert
      expect(result, "token456");
    });

    test("getter isVerified returns correct value", () {
      // Arrange
      final AuthResponseModel model = AuthResponseModel(
        isVerified: false,
      );

      // Act
      final bool? result = model.isVerified;

      // Assert
      expect(result, false);
    });

    test("copyWith creates new instance with updated accessToken", () {
      // Arrange
      final AuthResponseModel original = AuthResponseModel(
        accessToken: "access123",
        refreshToken: "refresh123",
      );

      // Act
      final AuthResponseModel updated = original.copyWith(
        accessToken: "access456",
      );

      // Assert
      expect(updated.accessToken, "access456");
      expect(updated.refreshToken, "refresh123");
    });

    test("copyWith creates new instance with updated refreshToken", () {
      // Arrange
      final AuthResponseModel original = AuthResponseModel(
        accessToken: "access123",
        refreshToken: "refresh123",
      );

      // Act
      final AuthResponseModel updated = original.copyWith(
        refreshToken: "refresh456",
      );

      // Assert
      expect(updated.accessToken, "access123");
      expect(updated.refreshToken, "refresh456");
    });

    test("copyWith creates new instance with updated userInfo", () {
      // Arrange
      final UserInfoResponseModel userInfo1 = UserInfoResponseModel(
        firstName: "John",
      );
      final UserInfoResponseModel userInfo2 = UserInfoResponseModel(
        firstName: "Jane",
      );
      final AuthResponseModel original = AuthResponseModel(
        userInfo: userInfo1,
      );

      // Act
      final AuthResponseModel updated = original.copyWith(
        userInfo: userInfo2,
      );

      // Assert
      expect(updated.userInfo?.firstName, "Jane");
      expect(original.userInfo?.firstName, "John");
    });

    test("copyWith creates new instance with updated userToken", () {
      // Arrange
      final AuthResponseModel original = AuthResponseModel(
        userToken: "token123",
      );

      // Act
      final AuthResponseModel updated = original.copyWith(
        userToken: "token456",
      );

      // Assert
      expect(updated.userToken, "token456");
    });

    test("copyWith creates new instance with updated isVerified", () {
      // Arrange
      final AuthResponseModel original = AuthResponseModel(
        isVerified: true,
      );

      // Act
      final AuthResponseModel updated = original.copyWith(
        isVerified: false,
      );

      // Assert
      expect(updated.isVerified, false);
    });

    test("copyWith without parameters returns same values", () {
      // Arrange
      final UserInfoResponseModel userInfo = UserInfoResponseModel(
        firstName: "John",
      );
      final AuthResponseModel original = AuthResponseModel(
        accessToken: "access123",
        refreshToken: "refresh123",
        userInfo: userInfo,
        userToken: "token123",
        isVerified: true,
      );

      // Act
      final AuthResponseModel copied = original.copyWith();

      // Assert
      expect(copied.accessToken, original.accessToken);
      expect(copied.refreshToken, original.refreshToken);
      expect(copied.userInfo, original.userInfo);
      expect(copied.userToken, original.userToken);
      expect(copied.isVerified, original.isVerified);
    });

    test("copyWith preserves original instance", () {
      // Arrange
      final AuthResponseModel original = AuthResponseModel(
        accessToken: "access123",
        isVerified: true,
      );

      // Act
      final AuthResponseModel updated = original.copyWith(
        accessToken: "access456",
        isVerified: false,
      );

      // Assert
      expect(original.accessToken, "access123");
      expect(original.isVerified, true);
      expect(updated.accessToken, "access456");
      expect(updated.isVerified, false);
    });

    test("copyWith preserves null values when not specified", () {
      // Arrange
      final AuthResponseModel original = AuthResponseModel(
        accessToken: "access123",
      );

      // Act
      final AuthResponseModel updated = original.copyWith(
        refreshToken: "refresh123",
      );

      // Assert
      expect(updated.accessToken, "access123");
      expect(updated.refreshToken, "refresh123");
      expect(updated.userInfo, isNull);
      expect(updated.userToken, isNull);
      expect(updated.isVerified, isNull);
    });

    test("copyWith with null value preserves original", () {
      // Arrange
      final AuthResponseModel original = AuthResponseModel(
        accessToken: "access123",
        refreshToken: "refresh123",
      );

      // Act
      final AuthResponseModel updated = original.copyWith(
        accessToken: null,
      );

      // Assert
      // copyWith uses ?? operator, so null preserves original value
      expect(updated.accessToken, "access123");
      expect(updated.refreshToken, "refresh123");
    });

    test("copyWith can update nested userInfo", () {
      // Arrange
      final UserInfoResponseModel originalUserInfo = UserInfoResponseModel(
        firstName: "John",
      );
      final UserInfoResponseModel updatedUserInfo = UserInfoResponseModel(
        firstName: "Jane",
      );
      final AuthResponseModel original = AuthResponseModel(
        userInfo: originalUserInfo,
      );

      // Act
      final AuthResponseModel result = original.copyWith(
        userInfo: updatedUserInfo,
      );

      // Assert
      expect(result.userInfo?.firstName, "Jane");
      expect(original.userInfo?.firstName, "John");
    });

    test("handles empty string tokens", () {
      // Act
      final AuthResponseModel model = AuthResponseModel(
        accessToken: "",
        refreshToken: "",
        userToken: "",
      );

      // Assert
      expect(model.accessToken, "");
      expect(model.refreshToken, "");
      expect(model.userToken, "");
    });

    test("handles special characters in tokens", () {
      // Act
      final AuthResponseModel model = AuthResponseModel(
        accessToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9",
        refreshToken: "refresh_token_with_special_chars",
      );

      // Assert
      expect(model.accessToken, "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9");
      expect(model.refreshToken, "refresh_token_with_special_chars");
    });

    test("handles isVerified as true", () {
      // Act
      final AuthResponseModel model = AuthResponseModel(
        isVerified: true,
      );

      // Assert
      expect(model.isVerified, true);
    });

    test("handles isVerified as false", () {
      // Act
      final AuthResponseModel model = AuthResponseModel(
        isVerified: false,
      );

      // Assert
      expect(model.isVerified, false);
    });

    test("multiple instances are independent", () {
      // Act
      final AuthResponseModel model1 = AuthResponseModel(
        accessToken: "access1",
        isVerified: true,
      );
      final AuthResponseModel model2 = AuthResponseModel(
        accessToken: "access2",
        isVerified: false,
      );

      // Assert
      expect(model1.accessToken, "access1");
      expect(model1.isVerified, true);
      expect(model2.accessToken, "access2");
      expect(model2.isVerified, false);
    });

    test("handles null accessToken with other fields populated", () {
      // Act
      final AuthResponseModel model = AuthResponseModel(
        refreshToken: "refresh123",
        userToken: "token123",
        isVerified: true,
      );

      // Assert
      expect(model.accessToken, isNull);
      expect(model.refreshToken, "refresh123");
      expect(model.userToken, "token123");
      expect(model.isVerified, true);
    });

    test("handles null userInfo with other fields populated", () {
      // Act
      final AuthResponseModel model = AuthResponseModel(
        accessToken: "access123",
        refreshToken: "refresh123",
        userToken: "token123",
      );

      // Assert
      expect(model.userInfo, isNull);
      expect(model.accessToken, "access123");
      expect(model.refreshToken, "refresh123");
      expect(model.userToken, "token123");
    });

    test("handles null userToken with other fields populated", () {
      // Act
      final AuthResponseModel model = AuthResponseModel(
        accessToken: "access123",
        refreshToken: "refresh123",
        isVerified: true,
      );

      // Assert
      expect(model.userToken, isNull);
      expect(model.accessToken, "access123");
      expect(model.refreshToken, "refresh123");
      expect(model.isVerified, true);
    });

    test("copyWith preserves original when creating multiple copies", () {
      // Arrange
      final AuthResponseModel original = AuthResponseModel(
        accessToken: "access123",
        isVerified: true,
      );

      // Act
      final AuthResponseModel copy1 = original.copyWith();
      final AuthResponseModel copy2 = original.copyWith(
        accessToken: "access456",
      );

      // Assert
      expect(original.accessToken, "access123");
      expect(copy1.accessToken, "access123");
      expect(copy2.accessToken, "access456");
    });
  });
}
