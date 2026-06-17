import "package:esim_open_source/domain/data/response/app/configuration_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for ConfigurationResponseModel
/// Tests constructor, getters, and copyWith functionality
void main() {
  group("ConfigurationResponseModel Tests", () {
    test("constructor assigns key and value correctly", () {
      // Act
      final ConfigurationResponseModel model = ConfigurationResponseModel(
        key: "WHATSAPP_NUMBER",
        value: "+1234567890",
      );

      // Assert
      expect(model.key, "WHATSAPP_NUMBER");
      expect(model.value, "+1234567890");
    });

    test("constructor with null values", () {
      // Act
      final ConfigurationResponseModel model = ConfigurationResponseModel();

      // Assert
      expect(model.key, isNull);
      expect(model.value, isNull);
    });

    test("constructor with only key", () {
      // Act
      final ConfigurationResponseModel model = ConfigurationResponseModel(
        key: "LOGIN_TYPE",
      );

      // Assert
      expect(model.key, "LOGIN_TYPE");
      expect(model.value, isNull);
    });

    test("constructor with only value", () {
      // Act
      final ConfigurationResponseModel model = ConfigurationResponseModel(
        value: "SOCIAL",
      );

      // Assert
      expect(model.key, isNull);
      expect(model.value, "SOCIAL");
    });

    test("key getter returns correct value", () {
      // Act
      final ConfigurationResponseModel model = ConfigurationResponseModel(
        key: "DEFAULT_CURRENCY",
      );

      // Assert
      expect(model.key, "DEFAULT_CURRENCY");
    });

    test("value getter returns correct value", () {
      // Act
      final ConfigurationResponseModel model = ConfigurationResponseModel(
        value: "USD",
      );

      // Assert
      expect(model.value, "USD");
    });

    test("copyWith replaces key only", () {
      // Arrange
      final ConfigurationResponseModel original = ConfigurationResponseModel(
        key: "OLD_KEY",
        value: "oldValue",
      );

      // Act
      final ConfigurationResponseModel updated = original.copyWith(
        key: "NEW_KEY",
      );

      // Assert
      expect(updated.key, "NEW_KEY");
      expect(updated.value, "oldValue");
    });

    test("copyWith replaces value only", () {
      // Arrange
      final ConfigurationResponseModel original = ConfigurationResponseModel(
        key: "myKey",
        value: "oldValue",
      );

      // Act
      final ConfigurationResponseModel updated = original.copyWith(
        value: "newValue",
      );

      // Assert
      expect(updated.key, "myKey");
      expect(updated.value, "newValue");
    });

    test("copyWith replaces both key and value", () {
      // Arrange
      final ConfigurationResponseModel original = ConfigurationResponseModel(
        key: "oldKey",
        value: "oldValue",
      );

      // Act
      final ConfigurationResponseModel updated = original.copyWith(
        key: "newKey",
        value: "newValue",
      );

      // Assert
      expect(updated.key, "newKey");
      expect(updated.value, "newValue");
    });

    test("copyWith preserves original instance when no parameters provided", () {
      // Arrange
      final ConfigurationResponseModel original = ConfigurationResponseModel(
        key: "myKey",
        value: "myValue",
      );

      // Act
      final ConfigurationResponseModel updated = original.copyWith();

      // Assert
      expect(updated.key, "myKey");
      expect(updated.value, "myValue");
    });

    test("copyWith with null key parameter uses original key", () {
      // Arrange
      final ConfigurationResponseModel original = ConfigurationResponseModel(
        key: "originalKey",
        value: "originalValue",
      );

      // Act
      final ConfigurationResponseModel updated = original.copyWith(
        key: null,
        value: "newValue",
      );

      // Assert
      expect(updated.key, "originalKey");
      expect(updated.value, "newValue");
    });

    test("copyWith with null value parameter uses original value", () {
      // Arrange
      final ConfigurationResponseModel original = ConfigurationResponseModel(
        key: "originalKey",
        value: "originalValue",
      );

      // Act
      final ConfigurationResponseModel updated = original.copyWith(
        key: "newKey",
        value: null,
      );

      // Assert
      expect(updated.key, "newKey");
      expect(updated.value, "originalValue");
    });

    test("copyWith creates new instance", () {
      // Arrange
      final ConfigurationResponseModel original = ConfigurationResponseModel(
        key: "key1",
        value: "value1",
      );

      // Act
      final ConfigurationResponseModel copy = original.copyWith(
        key: "key2",
        value: "value2",
      );

      // Assert
      expect(identical(original, copy), false);
    });

    test("copyWith with empty strings", () {
      // Arrange
      final ConfigurationResponseModel original = ConfigurationResponseModel(
        key: "key",
        value: "value",
      );

      // Act
      final ConfigurationResponseModel updated = original.copyWith(
        key: "",
        value: "",
      );

      // Assert
      expect(updated.key, "");
      expect(updated.value, "");
    });

    test("copyWith from null key to actual key", () {
      // Arrange
      final ConfigurationResponseModel original = ConfigurationResponseModel(
        key: null,
        value: "value",
      );

      // Act
      final ConfigurationResponseModel updated = original.copyWith(
        key: "newKey",
      );

      // Assert
      expect(updated.key, "newKey");
      expect(updated.value, "value");
    });

    test("copyWith from null value to actual value", () {
      // Arrange
      final ConfigurationResponseModel original = ConfigurationResponseModel(
        key: "key",
        value: null,
      );

      // Act
      final ConfigurationResponseModel updated = original.copyWith(
        value: "newValue",
      );

      // Assert
      expect(updated.key, "key");
      expect(updated.value, "newValue");
    });

    test("copyWith from both null to actual values", () {
      // Arrange
      final ConfigurationResponseModel original = ConfigurationResponseModel();

      // Act
      final ConfigurationResponseModel updated = original.copyWith(
        key: "newKey",
        value: "newValue",
      );

      // Assert
      expect(updated.key, "newKey");
      expect(updated.value, "newValue");
    });

    test("multiple copyWith calls chain correctly", () {
      // Arrange
      final ConfigurationResponseModel original = ConfigurationResponseModel(
        key: "key1",
        value: "value1",
      );

      // Act
      final ConfigurationResponseModel step1 = original.copyWith(
        key: "key2",
      );
      final ConfigurationResponseModel step2 = step1.copyWith(
        value: "value2",
      );

      // Assert
      expect(step2.key, "key2");
      expect(step2.value, "value2");
    });

    test("handles configuration keys with various formats", () {
      // Act
      final ConfigurationResponseModel model1 = ConfigurationResponseModel(
        key: "CATALOG.BUNDLES_CACHE_VERSION",
        value: "1.0.0",
      );
      final ConfigurationResponseModel model2 = ConfigurationResponseModel(
        key: "SUPABASE_BASE_URL",
        value: "https://example.com",
      );
      final ConfigurationResponseModel model3 = ConfigurationResponseModel(
        key: "ALLOWED_PAYMENT_TYPES",
        value: "CARD,WALLET",
      );

      // Assert
      expect(model1.key, "CATALOG.BUNDLES_CACHE_VERSION");
      expect(model2.key, "SUPABASE_BASE_URL");
      expect(model3.key, "ALLOWED_PAYMENT_TYPES");
    });

    test("handles values with special characters and spaces", () {
      // Act
      final ConfigurationResponseModel model = ConfigurationResponseModel(
        key: "WHATSAPP_NUMBER",
        value: "+1 (234) 567-8900",
      );

      // Assert
      expect(model.value, "+1 (234) 567-8900");
    });

    test("handles long configuration values", () {
      // Act
      final String longUrl = "https://api.example.com/v1/path?param=value&other=123";
      final ConfigurationResponseModel model = ConfigurationResponseModel(
        key: "SUPABASE_BASE_URL",
        value: longUrl,
      );

      // Assert
      expect(model.value, longUrl);
    });

    test("copyWith preserves original after modification", () {
      // Arrange
      final ConfigurationResponseModel original = ConfigurationResponseModel(
        key: "originalKey",
        value: "originalValue",
      );

      // Act
      final ConfigurationResponseModel modified = original.copyWith(
        key: "modifiedKey",
        value: "modifiedValue",
      );

      // Assert - Original should be unchanged
      expect(original.key, "originalKey");
      expect(original.value, "originalValue");
      // Modified should have new values
      expect(modified.key, "modifiedKey");
      expect(modified.value, "modifiedValue");
    });
  });
}
