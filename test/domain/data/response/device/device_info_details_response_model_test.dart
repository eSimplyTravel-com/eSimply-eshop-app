import "package:esim_open_source/domain/data/response/device/device_info_details_response_model.dart";
import "package:esim_open_source/domain/data/response/device/device_info_version_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for DeviceInfoDetailsResponseModel
/// Tests constructor, field assignment, and nested model handling
void main() {
  group("DeviceInfoDetailsResponseModel Tests", () {
    test("constructor assigns all values correctly", () {
      // Arrange
      final DeviceInfoVersionResponseModel version =
          DeviceInfoVersionResponseModel(version: "1.0.0");

      // Act
      final DeviceInfoDetailsResponseModel model =
          DeviceInfoDetailsResponseModel(
        recordGuid: "guid-123",
        deviceId: "device-456",
        token: "token-789",
        platformTag: "android",
        osTag: "Android 12",
        appGuid: "app-guid-123",
        appSettings: <String, dynamic>{"setting1": "value1"},
        version: version,
      );

      // Assert
      expect(model.recordGuid, "guid-123");
      expect(model.deviceId, "device-456");
      expect(model.token, "token-789");
      expect(model.platformTag, "android");
      expect(model.osTag, "Android 12");
      expect(model.appGuid, "app-guid-123");
      expect(model.appSettings, isNotNull);
      expect(model.version, version);
    });

    test("constructor with partial fields", () {
      // Act
      final DeviceInfoDetailsResponseModel model =
          DeviceInfoDetailsResponseModel(
        recordGuid: "guid-123",
        deviceId: "device-456",
      );

      // Assert
      expect(model.recordGuid, "guid-123");
      expect(model.deviceId, "device-456");
      expect(model.token, isNull);
      expect(model.platformTag, isNull);
      expect(model.osTag, isNull);
      expect(model.appGuid, isNull);
      expect(model.appSettings, isNull);
      expect(model.version, isNull);
    });

    test("constructor with no fields creates nullable instance", () {
      // Act
      final DeviceInfoDetailsResponseModel model =
          DeviceInfoDetailsResponseModel();

      // Assert
      expect(model.recordGuid, isNull);
      expect(model.deviceId, isNull);
      expect(model.token, isNull);
      expect(model.platformTag, isNull);
      expect(model.osTag, isNull);
      expect(model.appGuid, isNull);
      expect(model.appSettings, isNull);
      expect(model.version, isNull);
    });

    test("handles nested version object", () {
      // Arrange
      final DeviceInfoVersionResponseModel version =
          DeviceInfoVersionResponseModel(
        version: "2.1.0",
        name: "Version Name",
      );

      // Act
      final DeviceInfoDetailsResponseModel model =
          DeviceInfoDetailsResponseModel(version: version);

      // Assert
      expect(model.version, isNotNull);
      expect(model.version?.version, "2.1.0");
      expect(model.version?.name, "Version Name");
    });

    test("handles null version field", () {
      // Act
      final DeviceInfoDetailsResponseModel model =
          DeviceInfoDetailsResponseModel(
        version: null,
        deviceId: "device-123",
      );

      // Assert
      expect(model.version, isNull);
      expect(model.deviceId, "device-123");
    });

    test("handles platform tags correctly", () {
      // Act
      final DeviceInfoDetailsResponseModel modelAndroid =
          DeviceInfoDetailsResponseModel(platformTag: "android");
      final DeviceInfoDetailsResponseModel modelIOS =
          DeviceInfoDetailsResponseModel(platformTag: "ios");
      final DeviceInfoDetailsResponseModel modelWeb =
          DeviceInfoDetailsResponseModel(platformTag: "web");

      // Assert
      expect(modelAndroid.platformTag, "android");
      expect(modelIOS.platformTag, "ios");
      expect(modelWeb.platformTag, "web");
    });

    test("handles OS tags with version numbers", () {
      // Act
      final DeviceInfoDetailsResponseModel model1 =
          DeviceInfoDetailsResponseModel(osTag: "Android 12");
      final DeviceInfoDetailsResponseModel model2 =
          DeviceInfoDetailsResponseModel(osTag: "iOS 16.1");
      final DeviceInfoDetailsResponseModel model3 =
          DeviceInfoDetailsResponseModel(osTag: "Windows 11");

      // Assert
      expect(model1.osTag, "Android 12");
      expect(model2.osTag, "iOS 16.1");
      expect(model3.osTag, "Windows 11");
    });

    test("handles dynamic appSettings field", () {
      // Arrange
      final dynamic settingsMap = <String, dynamic>{
        "language": "en",
        "theme": "dark",
        "notifications": true,
        "nested": <String, dynamic>{"value": "deep"},
      };

      // Act
      final DeviceInfoDetailsResponseModel model =
          DeviceInfoDetailsResponseModel(appSettings: settingsMap);

      // Assert
      expect(model.appSettings, isNotNull);
      expect(model.appSettings, settingsMap);
    });

    test("handles dynamic appSettings as list", () {
      // Act
      final DeviceInfoDetailsResponseModel model =
          DeviceInfoDetailsResponseModel(
        appSettings: <dynamic>["item1", "item2", 123],
      );

      // Assert
      expect(model.appSettings, isNotNull);
      expect(model.appSettings, isA<List<dynamic>>());
    });

    test("handles empty string values", () {
      // Act
      final DeviceInfoDetailsResponseModel model =
          DeviceInfoDetailsResponseModel(
        recordGuid: "",
        deviceId: "",
        token: "",
        platformTag: "",
        osTag: "",
        appGuid: "",
      );

      // Assert
      expect(model.recordGuid, "");
      expect(model.deviceId, "");
      expect(model.token, "");
      expect(model.platformTag, "");
      expect(model.osTag, "");
      expect(model.appGuid, "");
    });

    test("handles special characters in strings", () {
      // Act
      final DeviceInfoDetailsResponseModel model =
          DeviceInfoDetailsResponseModel(
        recordGuid: "guid-abc-123-def-456",
        deviceId: "device:mobile:123",
        token: "token_special_abc123",
        appGuid: "app-guid-special's-name",
      );

      // Assert
      expect(model.recordGuid, "guid-abc-123-def-456");
      expect(model.deviceId, "device:mobile:123");
      expect(model.token, "token_special_abc123");
      expect(model.appGuid, "app-guid-special's-name");
    });

    test("multiple instances are independent", () {
      // Arrange
      final DeviceInfoVersionResponseModel version1 =
          DeviceInfoVersionResponseModel(version: "1.0.0");
      final DeviceInfoVersionResponseModel version2 =
          DeviceInfoVersionResponseModel(version: "2.0.0");

      // Act
      final DeviceInfoDetailsResponseModel model1 =
          DeviceInfoDetailsResponseModel(
        deviceId: "device-1",
        version: version1,
      );
      final DeviceInfoDetailsResponseModel model2 =
          DeviceInfoDetailsResponseModel(
        deviceId: "device-2",
        version: version2,
      );

      // Assert
      expect(model1.deviceId, "device-1");
      expect(model1.version?.version, "1.0.0");
      expect(model2.deviceId, "device-2");
      expect(model2.version?.version, "2.0.0");
    });

    test("nested version remains unchanged when model fields are set", () {
      // Arrange
      final DeviceInfoVersionResponseModel version =
          DeviceInfoVersionResponseModel(
        version: "1.0.0",
        name: "Original Version",
      );
      final DeviceInfoDetailsResponseModel model =
          DeviceInfoDetailsResponseModel(version: version);

      // Act
      model.deviceId = "new-device-id";
      model.platformTag = "ios";

      // Assert
      expect(model.version?.version, "1.0.0");
      expect(model.version?.name, "Original Version");
      expect(model.deviceId, "new-device-id");
      expect(model.platformTag, "ios");
    });

    test("handles all guid fields independently", () {
      // Act
      final DeviceInfoDetailsResponseModel model =
          DeviceInfoDetailsResponseModel(
        recordGuid: "record-guid-123",
        appGuid: "app-guid-456",
      );

      // Assert
      expect(model.recordGuid, "record-guid-123");
      expect(model.appGuid, "app-guid-456");
      expect(model.deviceId, isNull);
    });

    test("handles long string values", () {
      // Arrange
      final String longString = "A" * 500;

      // Act
      final DeviceInfoDetailsResponseModel model =
          DeviceInfoDetailsResponseModel(
        token: longString,
      );

      // Assert
      expect(model.token?.length, 500);
      expect(model.token, longString);
    });

    test("handles complex nested appSettings with multiple levels", () {
      // Arrange
      final dynamic complexSettings = <String, dynamic>{
        "level1": <String, dynamic>{
          "level2": <String, dynamic>{
            "level3": "deeply_nested_value",
          },
        },
        "array": <dynamic>[1, 2, 3],
      };

      // Act
      final DeviceInfoDetailsResponseModel model =
          DeviceInfoDetailsResponseModel(appSettings: complexSettings);

      // Assert
      expect(model.appSettings, isNotNull);
      expect(model.appSettings, complexSettings);
    });

    test("handles mixed null and non-null fields with nested object", () {
      // Arrange
      final DeviceInfoVersionResponseModel version =
          DeviceInfoVersionResponseModel(version: "1.5.0");

      // Act
      final DeviceInfoDetailsResponseModel model =
          DeviceInfoDetailsResponseModel(
        recordGuid: "guid-123",
        deviceId: null,
        token: "token-xyz",
        platformTag: null,
        osTag: "Android 13",
        appGuid: null,
        appSettings: <String, dynamic>{"key": "value"},
        version: version,
      );

      // Assert
      expect(model.recordGuid, "guid-123");
      expect(model.deviceId, isNull);
      expect(model.token, "token-xyz");
      expect(model.platformTag, isNull);
      expect(model.osTag, "Android 13");
      expect(model.appGuid, isNull);
      expect(model.appSettings, isNotNull);
      expect(model.version, isNotNull);
    });

    test("handles null appSettings", () {
      // Act
      final DeviceInfoDetailsResponseModel model =
          DeviceInfoDetailsResponseModel(
        deviceId: "device-123",
        appSettings: null,
      );

      // Assert
      expect(model.deviceId, "device-123");
      expect(model.appSettings, isNull);
    });
  });
}
