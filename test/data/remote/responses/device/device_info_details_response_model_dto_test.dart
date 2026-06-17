import "package:esim_open_source/data/remote/responses/device/device_info_details_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/device/device_info_version_response_model_dto.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("DeviceInfoDetailsResponseModel Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "recordGuid": "guid-123",
        "deviceId": "device-456",
        "token": "token-789",
        "platformTag": "android",
        "osTag": "Android",
        "appGuid": "app-guid-123",
        "appSettings": <String, dynamic>{"setting1": "value1"},
        "version": <String, dynamic>{
          "current": "1.0.0",
        },
      };

      // Act
      final DeviceInfoDetailsResponseModelDto model =
          DeviceInfoDetailsResponseModelDto.fromJson(json);

      // Assert
      expect(model.recordGuid, "guid-123");
      expect(model.deviceId, "device-456");
      expect(model.token, "token-789");
      expect(model.platformTag, "android");
      expect(model.osTag, "Android");
      expect(model.appGuid, "app-guid-123");
      expect(model.appSettings, isNotNull);
      expect(model.version, isNotNull);
    });

    test("fromJson handles null version", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "recordGuid": "guid-123",
      };

      // Act
      final DeviceInfoDetailsResponseModelDto model =
          DeviceInfoDetailsResponseModelDto.fromJson(json);

      // Assert
      expect(model.recordGuid, "guid-123");
      expect(model.version, isNull);
    });

    test("constructor assigns values correctly", () {
      // Arrange
      final DeviceInfoVersionResponseModelDto version =
          DeviceInfoVersionResponseModelDto(
        version: "2.0.0",
      );

      // Act
      final DeviceInfoDetailsResponseModelDto model =
          DeviceInfoDetailsResponseModelDto(
        recordGuid: "guid-456",
        deviceId: "device-789",
        token: "token-abc",
        platformTag: "ios",
        osTag: "iOS",
        appGuid: "app-guid-456",
        appSettings: <String, dynamic>{"setting": "value"},
        version: version,
      );

      // Assert
      expect(model.recordGuid, "guid-456");
      expect(model.deviceId, "device-789");
      expect(model.token, "token-abc");
      expect(model.platformTag, "ios");
      expect(model.osTag, "iOS");
      expect(model.appGuid, "app-guid-456");
      expect(model.appSettings, isNotNull);
      expect(model.version, version);
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final DeviceInfoVersionResponseModelDto version =
          DeviceInfoVersionResponseModelDto(
        version: "1.5.0",
      );
      final DeviceInfoDetailsResponseModelDto model =
          DeviceInfoDetailsResponseModelDto(
        recordGuid: "guid-123",
        deviceId: "device-456",
        token: "token-789",
        platformTag: "android",
        osTag: "Android",
        appGuid: "app-guid-123",
        appSettings: <String, dynamic>{"key": "value"},
        version: version,
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["recordGuid"], "guid-123");
      expect(json["deviceId"], "device-456");
      expect(json["token"], "token-789");
      expect(json["platformTag"], "android");
      expect(json["osTag"], "Android");
      expect(json["appGuid"], "app-guid-123");
      expect(json["appSettings"], isNotNull);
      expect(json["version"], isNotNull);
    });

    test("toJson handles null fields", () {
      // Arrange
      final DeviceInfoDetailsResponseModelDto model =
          DeviceInfoDetailsResponseModelDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["recordGuid"], isNull);
      expect(json["deviceId"], isNull);
      expect(json["token"], isNull);
      expect(json["platformTag"], isNull);
      expect(json["osTag"], isNull);
      expect(json["appGuid"], isNull);
      expect(json["appSettings"], isNull);
      expect(json["version"], isNull);
    });
  });
}
