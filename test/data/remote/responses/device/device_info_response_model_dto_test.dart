import "package:esim_open_source/data/remote/responses/device/device_info_details_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/device/device_info_response_model_dto.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("DeviceInfoResponseModel Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "device": <String, dynamic>{
          "recordGuid": "guid-123",
          "deviceId": "device-456",
          "token": "token-789",
          "platformTag": "android",
          "osTag": "Android",
          "appGuid": "app-guid-123",
          "appSettings": <String, dynamic>{"setting1": "value1"},
        },
      };

      // Act
      final DeviceInfoResponseModelDto model =
          DeviceInfoResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.device, isNotNull);
      expect(model.device?.recordGuid, "guid-123");
      expect(model.device?.deviceId, "device-456");
      expect(model.device?.token, "token-789");
    });

    test("fromJson handles null device", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final DeviceInfoResponseModelDto model =
          DeviceInfoResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.device, isNull);
    });

    test("fromJson with explicit null device", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "device": null,
      };

      // Act
      final DeviceInfoResponseModelDto model =
          DeviceInfoResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.device, isNull);
    });

    test("constructor assigns values correctly", () {
      // Arrange
      final DeviceInfoDetailsResponseModelDto device =
          DeviceInfoDetailsResponseModelDto(
        recordGuid: "guid-789",
        deviceId: "device-123",
      );

      // Act
      final DeviceInfoResponseModelDto model =
          DeviceInfoResponseModelDto(device: device);

      // Assert
      expect(model.device, device);
      expect(model.device?.recordGuid, "guid-789");
    });

    test("constructor with null device", () {
      // Act
      final DeviceInfoResponseModelDto model = DeviceInfoResponseModelDto();

      // Assert
      expect(model.device, isNull);
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final DeviceInfoDetailsResponseModelDto device =
          DeviceInfoDetailsResponseModelDto(
        recordGuid: "guid-123",
        deviceId: "device-456",
        token: "token-789",
      );
      final DeviceInfoResponseModelDto model =
          DeviceInfoResponseModelDto(device: device);

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["device"], isNotNull);
      expect(
          (json["device"] as Map<String, dynamic>)["recordGuid"], "guid-123");
    });

    test("toJson handles null device", () {
      // Arrange
      final DeviceInfoResponseModelDto model = DeviceInfoResponseModelDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["device"], isNull);
    });

    test("toJson includes nested device correctly", () {
      // Arrange
      final DeviceInfoDetailsResponseModelDto device =
          DeviceInfoDetailsResponseModelDto(
        recordGuid: "guid-456",
        deviceId: "device-789",
        token: "token-abc",
        platformTag: "ios",
      );
      final DeviceInfoResponseModelDto model =
          DeviceInfoResponseModelDto(device: device);

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["device"], isNotNull);
      final Map<String, dynamic> deviceJson =
          json["device"] as Map<String, dynamic>;
      expect(deviceJson["recordGuid"], "guid-456");
      expect(deviceJson["deviceId"], "device-789");
      expect(deviceJson["token"], "token-abc");
      expect(deviceJson["platformTag"], "ios");
    });

    test("roundtrip fromJson and toJson preserves data", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "device": <String, dynamic>{
          "recordGuid": "guid-123",
          "deviceId": "device-456",
          "token": "token-789",
        },
      };

      // Act
      final DeviceInfoResponseModelDto model =
          DeviceInfoResponseModelDto.fromJson(json: originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(
        (resultJson["device"] as Map<String, dynamic>)["recordGuid"],
        originalJson["device"]["recordGuid"],
      );
      expect(
        (resultJson["device"] as Map<String, dynamic>)["deviceId"],
        originalJson["device"]["deviceId"],
      );
    });

    test("multiple instances are independent", () {
      // Act
      final DeviceInfoDetailsResponseModelDto device1 =
          DeviceInfoDetailsResponseModelDto(recordGuid: "guid-1");
      final DeviceInfoDetailsResponseModelDto device2 =
          DeviceInfoDetailsResponseModelDto(recordGuid: "guid-2");
      final DeviceInfoResponseModelDto model1 =
          DeviceInfoResponseModelDto(device: device1);
      final DeviceInfoResponseModelDto model2 =
          DeviceInfoResponseModelDto(device: device2);

      // Assert
      expect(model1.device?.recordGuid, "guid-1");
      expect(model2.device?.recordGuid, "guid-2");
    });

    test("toDomain converts dto to domain model with device", () {
      // Arrange
      final DeviceInfoDetailsResponseModelDto device =
          DeviceInfoDetailsResponseModelDto(
        recordGuid: "guid-123",
        deviceId: "device-456",
      );
      final DeviceInfoResponseModelDto model =
          DeviceInfoResponseModelDto(device: device);

      // Act
      final dynamic domainModel = model.toDomain();

      // Assert
      expect(domainModel, isNotNull);
      expect(domainModel.device, isNotNull);
    });

    test("toDomain converts dto to domain model with null device", () {
      // Arrange
      final DeviceInfoResponseModelDto model = DeviceInfoResponseModelDto();

      // Act
      final dynamic domainModel = model.toDomain();

      // Assert
      expect(domainModel, isNotNull);
      expect(domainModel.device, isNull);
    });
  });
}
