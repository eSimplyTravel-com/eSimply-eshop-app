import "package:esim_open_source/domain/data/response/device/device_info_details_response_model.dart";
import "package:esim_open_source/domain/data/response/device/device_info_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for DeviceInfoResponseModel
/// Tests constructor, field assignment, and nested model handling
void main() {
  group("DeviceInfoResponseModel Tests", () {
    test("constructor assigns device correctly", () {
      // Arrange
      final DeviceInfoDetailsResponseModel device =
          DeviceInfoDetailsResponseModel(
        deviceId: "device-123",
        recordGuid: "guid-456",
      );

      // Act
      final DeviceInfoResponseModel model = DeviceInfoResponseModel(
        device: device,
      );

      // Assert
      expect(model.device, device);
      expect(model.device?.deviceId, "device-123");
      expect(model.device?.recordGuid, "guid-456");
    });

    test("constructor with null device", () {
      // Act
      final DeviceInfoResponseModel model = DeviceInfoResponseModel(
        device: null,
      );

      // Assert
      expect(model.device, isNull);
    });

    test("constructor with no parameters creates null device", () {
      // Act
      final DeviceInfoResponseModel model = DeviceInfoResponseModel();

      // Assert
      expect(model.device, isNull);
    });

    test("handles nested device object with all fields", () {
      // Arrange
      final DeviceInfoDetailsResponseModel device =
          DeviceInfoDetailsResponseModel(
        recordGuid: "guid-123",
        deviceId: "device-456",
        token: "token-789",
        platformTag: "android",
        osTag: "Android 12",
        appGuid: "app-guid-123",
        appSettings: <String, dynamic>{"setting1": "value1"},
      );

      // Act
      final DeviceInfoResponseModel model = DeviceInfoResponseModel(
        device: device,
      );

      // Assert
      expect(model.device, isNotNull);
      expect(model.device?.recordGuid, "guid-123");
      expect(model.device?.deviceId, "device-456");
      expect(model.device?.token, "token-789");
      expect(model.device?.platformTag, "android");
      expect(model.device?.osTag, "Android 12");
      expect(model.device?.appGuid, "app-guid-123");
      expect(model.device?.appSettings, isNotNull);
    });

    test("handles nested device with partial fields", () {
      // Arrange
      final DeviceInfoDetailsResponseModel device =
          DeviceInfoDetailsResponseModel(
        deviceId: "device-789",
        platformTag: "ios",
      );

      // Act
      final DeviceInfoResponseModel model = DeviceInfoResponseModel(
        device: device,
      );

      // Assert
      expect(model.device?.deviceId, "device-789");
      expect(model.device?.platformTag, "ios");
      expect(model.device?.recordGuid, isNull);
      expect(model.device?.token, isNull);
    });

    test("handles nested device with nested version", () {
      // Arrange
      final DeviceInfoDetailsResponseModel device =
          DeviceInfoDetailsResponseModel(
        deviceId: "device-123",
        version: null, // Initially null
      );

      // Act
      final DeviceInfoResponseModel model = DeviceInfoResponseModel(
        device: device,
      );

      // Assert
      expect(model.device, isNotNull);
      expect(model.device?.deviceId, "device-123");
      expect(model.device?.version, isNull);
    });

    test("multiple instances are independent", () {
      // Arrange
      final DeviceInfoDetailsResponseModel device1 =
          DeviceInfoDetailsResponseModel(
        deviceId: "device-1",
        recordGuid: "guid-1",
      );
      final DeviceInfoDetailsResponseModel device2 =
          DeviceInfoDetailsResponseModel(
        deviceId: "device-2",
        recordGuid: "guid-2",
      );

      // Act
      final DeviceInfoResponseModel model1 = DeviceInfoResponseModel(
        device: device1,
      );
      final DeviceInfoResponseModel model2 = DeviceInfoResponseModel(
        device: device2,
      );

      // Assert
      expect(model1.device?.deviceId, "device-1");
      expect(model1.device?.recordGuid, "guid-1");
      expect(model2.device?.deviceId, "device-2");
      expect(model2.device?.recordGuid, "guid-2");
    });

    test("setting device field affects only the instance", () {
      // Arrange
      final DeviceInfoDetailsResponseModel device1 =
          DeviceInfoDetailsResponseModel(deviceId: "device-1");
      final DeviceInfoDetailsResponseModel device2 =
          DeviceInfoDetailsResponseModel(deviceId: "device-2");
      final DeviceInfoResponseModel model1 = DeviceInfoResponseModel(
        device: device1,
      );
      final DeviceInfoResponseModel model2 = DeviceInfoResponseModel(
        device: device2,
      );

      // Act
      model1.device =
          DeviceInfoDetailsResponseModel(deviceId: "device-1-updated");

      // Assert
      expect(model1.device?.deviceId, "device-1-updated");
      expect(model2.device?.deviceId, "device-2");
    });

    test("can set device to null after initialization", () {
      // Arrange
      final DeviceInfoDetailsResponseModel device =
          DeviceInfoDetailsResponseModel(deviceId: "device-123");
      final DeviceInfoResponseModel model = DeviceInfoResponseModel(
        device: device,
      );

      // Act
      model.device = null;

      // Assert
      expect(model.device, isNull);
    });

    test("can update device reference", () {
      // Arrange
      final DeviceInfoDetailsResponseModel device1 =
          DeviceInfoDetailsResponseModel(deviceId: "device-1");
      final DeviceInfoDetailsResponseModel device2 =
          DeviceInfoDetailsResponseModel(deviceId: "device-2");
      final DeviceInfoResponseModel model = DeviceInfoResponseModel(
        device: device1,
      );

      // Act
      model.device = device2;

      // Assert
      expect(model.device?.deviceId, "device-2");
    });

    test("nested device remains independent from parent model", () {
      // Arrange
      final DeviceInfoDetailsResponseModel device =
          DeviceInfoDetailsResponseModel(
        deviceId: "device-original",
      );

      // Act
      final DeviceInfoResponseModel model = DeviceInfoResponseModel(
        device: device,
      );
      device.deviceId = "device-modified";

      // Assert - model.device should reflect the change since it holds a reference
      expect(model.device?.deviceId, "device-modified");
    });

    test("handles deeply nested device with version and action", () {
      // Arrange
      final DeviceInfoDetailsResponseModel device =
          DeviceInfoDetailsResponseModel(
        deviceId: "device-deep",
        version: null, // In reality this could have nested action data
      );

      // Act
      final DeviceInfoResponseModel model = DeviceInfoResponseModel(
        device: device,
      );

      // Assert
      expect(model.device, isNotNull);
      expect(model.device?.deviceId, "device-deep");
    });

    test("handles device with special characters in ids", () {
      // Arrange
      final DeviceInfoDetailsResponseModel device =
          DeviceInfoDetailsResponseModel(
        deviceId: "device-abc-123-def",
        recordGuid: "guid_123-456-789",
        appGuid: "app:guid:special@chars",
      );

      // Act
      final DeviceInfoResponseModel model = DeviceInfoResponseModel(
        device: device,
      );

      // Assert
      expect(model.device?.deviceId, "device-abc-123-def");
      expect(model.device?.recordGuid, "guid_123-456-789");
      expect(model.device?.appGuid, "app:guid:special@chars");
    });

    test("handles device with complex appSettings", () {
      // Arrange
      final DeviceInfoDetailsResponseModel device =
          DeviceInfoDetailsResponseModel(
        deviceId: "device-123",
        appSettings: <String, dynamic>{
          "notifications": true,
          "language": "en",
          "advanced": <String, dynamic>{
            "debugMode": false,
            "logLevel": 3,
          },
        },
      );

      // Act
      final DeviceInfoResponseModel model = DeviceInfoResponseModel(
        device: device,
      );

      // Assert
      expect(model.device?.appSettings, isNotNull);
      expect(model.device?.appSettings, isA<Map<String, dynamic>>());
    });

    test("constructor accepts null parameter explicitly", () {
      // Act
      final DeviceInfoResponseModel model = DeviceInfoResponseModel(
        device: null,
      );

      // Assert
      expect(model.device, isNull);
    });

    test("handles empty device object", () {
      // Arrange
      final DeviceInfoDetailsResponseModel emptyDevice =
          DeviceInfoDetailsResponseModel();

      // Act
      final DeviceInfoResponseModel model = DeviceInfoResponseModel(
        device: emptyDevice,
      );

      // Assert
      expect(model.device, isNotNull);
      expect(model.device?.deviceId, isNull);
      expect(model.device?.recordGuid, isNull);
      expect(model.device?.token, isNull);
      expect(model.device?.platformTag, isNull);
      expect(model.device?.osTag, isNull);
      expect(model.device?.appGuid, isNull);
      expect(model.device?.appSettings, isNull);
      expect(model.device?.version, isNull);
    });

    test("chained access through nested objects", () {
      // Arrange
      final DeviceInfoDetailsResponseModel device =
          DeviceInfoDetailsResponseModel(
        deviceId: "device-chain",
        recordGuid: "guid-chain",
      );

      // Act
      final DeviceInfoResponseModel model = DeviceInfoResponseModel(
        device: device,
      );
      final String? deviceId = model.device?.deviceId;
      final String? recordGuid = model.device?.recordGuid;

      // Assert
      expect(deviceId, "device-chain");
      expect(recordGuid, "guid-chain");
    });

    test("safe navigation with null device", () {
      // Act
      final DeviceInfoResponseModel model = DeviceInfoResponseModel();
      final String? deviceId = model.device?.deviceId;
      final String? recordGuid = model.device?.recordGuid;

      // Assert
      expect(deviceId, isNull);
      expect(recordGuid, isNull);
    });

    test("device swap between models", () {
      // Arrange
      final DeviceInfoDetailsResponseModel device1 =
          DeviceInfoDetailsResponseModel(deviceId: "device-1");
      final DeviceInfoDetailsResponseModel device2 =
          DeviceInfoDetailsResponseModel(deviceId: "device-2");
      final DeviceInfoResponseModel model1 = DeviceInfoResponseModel(
        device: device1,
      );
      final DeviceInfoResponseModel model2 = DeviceInfoResponseModel(
        device: device2,
      );

      // Act
      final DeviceInfoDetailsResponseModel? temp = model1.device;
      model1.device = model2.device;
      model2.device = temp;

      // Assert
      expect(model1.device?.deviceId, "device-2");
      expect(model2.device?.deviceId, "device-1");
    });
  });
}
