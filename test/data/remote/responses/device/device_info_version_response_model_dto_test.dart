import "package:esim_open_source/data/remote/responses/device/device_info_action_data_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/device/device_info_version_response_model_dto.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("DeviceInfoVersionResponseModel Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "action": <String, dynamic>{
          "name": "Test Action",
          "id": 123,
          "tag": "test_tag",
        },
        "version": "1.0.0",
        "recordGuid": "guid-123",
        "name": "Device Version",
        "description": "Test version",
        "buttonAccept": "Accept",
        "buttonDenied": "Deny",
        "createdDate": "2024-01-01",
      };

      // Act
      final DeviceInfoVersionResponseModelDto model =
          DeviceInfoVersionResponseModelDto.fromJson(json);

      // Assert
      expect(model.action, isNotNull);
      expect(model.action?.name, "Test Action");
      expect(model.version, "1.0.0");
      expect(model.recordGuid, "guid-123");
      expect(model.name, "Device Version");
      expect(model.description, "Test version");
      expect(model.buttonAccept, "Accept");
      expect(model.buttonDenied, "Deny");
      expect(model.createdDate, "2024-01-01");
    });

    test("fromJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final DeviceInfoVersionResponseModelDto model =
          DeviceInfoVersionResponseModelDto.fromJson(json);

      // Assert
      expect(model.action, isNull);
      expect(model.version, isNull);
      expect(model.recordGuid, isNull);
      expect(model.name, isNull);
      expect(model.description, isNull);
      expect(model.buttonAccept, isNull);
      expect(model.buttonDenied, isNull);
      expect(model.createdDate, isNull);
    });

    test("fromJson handles null action", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "version": "2.0.0",
        "recordGuid": "guid-456",
      };

      // Act
      final DeviceInfoVersionResponseModelDto model =
          DeviceInfoVersionResponseModelDto.fromJson(json);

      // Assert
      expect(model.action, isNull);
      expect(model.version, "2.0.0");
      expect(model.recordGuid, "guid-456");
    });

    test("fromJson with explicit null action", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "action": null,
        "version": "1.5.0",
      };

      // Act
      final DeviceInfoVersionResponseModelDto model =
          DeviceInfoVersionResponseModelDto.fromJson(json);

      // Assert
      expect(model.action, isNull);
      expect(model.version, "1.5.0");
    });

    test("constructor assigns values correctly", () {
      // Arrange
      final DeviceInfoActionDataResponseModelDto action =
          DeviceInfoActionDataResponseModelDto(
        name: "Action",
        id: 456,
      );

      // Act
      final DeviceInfoVersionResponseModelDto model =
          DeviceInfoVersionResponseModelDto(
        action: action,
        version: "1.2.3",
        recordGuid: "guid-789",
        name: "Version Name",
        description: "Version Description",
        buttonAccept: "OK",
        buttonDenied: "Cancel",
        createdDate: "2024-02-01",
      );

      // Assert
      expect(model.action, action);
      expect(model.version, "1.2.3");
      expect(model.recordGuid, "guid-789");
      expect(model.name, "Version Name");
      expect(model.description, "Version Description");
      expect(model.buttonAccept, "OK");
      expect(model.buttonDenied, "Cancel");
      expect(model.createdDate, "2024-02-01");
    });

    test("constructor with all null fields", () {
      // Act
      final DeviceInfoVersionResponseModelDto model =
          DeviceInfoVersionResponseModelDto();

      // Assert
      expect(model.action, isNull);
      expect(model.version, isNull);
      expect(model.recordGuid, isNull);
      expect(model.name, isNull);
      expect(model.description, isNull);
      expect(model.buttonAccept, isNull);
      expect(model.buttonDenied, isNull);
      expect(model.createdDate, isNull);
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final DeviceInfoActionDataResponseModelDto action =
          DeviceInfoActionDataResponseModelDto(
        name: "Test",
        id: 789,
      );
      final DeviceInfoVersionResponseModelDto model =
          DeviceInfoVersionResponseModelDto(
        action: action,
        version: "1.0.0",
        recordGuid: "guid-123",
        name: "Device Version",
        description: "Test description",
        buttonAccept: "Accept",
        buttonDenied: "Deny",
        createdDate: "2024-01-01",
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["action"], isNotNull);
      expect(json["version"], "1.0.0");
      expect(json["recordGuid"], "guid-123");
      expect(json["name"], "Device Version");
      expect(json["description"], "Test description");
      expect(json["buttonAccept"], "Accept");
      expect(json["buttonDenied"], "Deny");
      expect(json["createdDate"], "2024-01-01");
    });

    test("toJson handles null fields", () {
      // Arrange
      final DeviceInfoVersionResponseModelDto model =
          DeviceInfoVersionResponseModelDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["action"], isNull);
      expect(json["version"], isNull);
      expect(json["recordGuid"], isNull);
      expect(json["name"], isNull);
      expect(json["description"], isNull);
      expect(json["buttonAccept"], isNull);
      expect(json["buttonDenied"], isNull);
      expect(json["createdDate"], isNull);
    });

    test("toJson includes nested action correctly", () {
      // Arrange
      final DeviceInfoActionDataResponseModelDto action =
          DeviceInfoActionDataResponseModelDto(
        name: "Update Action",
        id: 999,
        tag: "update",
      );
      final DeviceInfoVersionResponseModelDto model =
          DeviceInfoVersionResponseModelDto(action: action);

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["action"], isNotNull);
      final Map<String, dynamic> actionJson =
          json["action"] as Map<String, dynamic>;
      expect(actionJson["name"], "Update Action");
      expect(actionJson["id"], 999);
      expect(actionJson["tag"], "update");
    });

    test("roundtrip fromJson and toJson preserves data", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "action": <String, dynamic>{
          "name": "Test Action",
          "id": 123,
        },
        "version": "1.0.0",
        "recordGuid": "guid-123",
        "name": "Device Version",
        "description": "Test description",
        "buttonAccept": "Accept",
        "buttonDenied": "Deny",
        "createdDate": "2024-01-01",
      };

      // Act
      final DeviceInfoVersionResponseModelDto model =
          DeviceInfoVersionResponseModelDto.fromJson(originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(resultJson["version"], originalJson["version"]);
      expect(resultJson["recordGuid"], originalJson["recordGuid"]);
      expect(resultJson["name"], originalJson["name"]);
      expect(resultJson["description"], originalJson["description"]);
      expect(resultJson["buttonAccept"], originalJson["buttonAccept"]);
      expect(resultJson["buttonDenied"], originalJson["buttonDenied"]);
      expect(resultJson["createdDate"], originalJson["createdDate"]);
    });

    test("handles empty string values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "version": "",
        "name": "",
        "description": "",
        "buttonAccept": "",
        "buttonDenied": "",
        "createdDate": "",
      };

      // Act
      final DeviceInfoVersionResponseModelDto model =
          DeviceInfoVersionResponseModelDto.fromJson(json);

      // Assert
      expect(model.version, "");
      expect(model.name, "");
      expect(model.description, "");
      expect(model.buttonAccept, "");
      expect(model.buttonDenied, "");
      expect(model.createdDate, "");
    });

    test("handles special characters in strings", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "name": "José's Device",
        "description": "O'Brien's Update",
        "version": "1.0-beta+1",
      };

      // Act
      final DeviceInfoVersionResponseModelDto model =
          DeviceInfoVersionResponseModelDto.fromJson(json);

      // Assert
      expect(model.name, "José's Device");
      expect(model.description, "O'Brien's Update");
      expect(model.version, "1.0-beta+1");
    });

    test("multiple instances are independent", () {
      // Act
      final DeviceInfoVersionResponseModelDto model1 =
          DeviceInfoVersionResponseModelDto(
        version: "1.0.0",
        recordGuid: "guid-1",
      );
      final DeviceInfoVersionResponseModelDto model2 =
          DeviceInfoVersionResponseModelDto(
        version: "2.0.0",
        recordGuid: "guid-2",
      );

      // Assert
      expect(model1.version, "1.0.0");
      expect(model1.recordGuid, "guid-1");
      expect(model2.version, "2.0.0");
      expect(model2.recordGuid, "guid-2");
    });

    test("toDomain converts dto to domain model with all fields", () {
      // Arrange
      final DeviceInfoActionDataResponseModelDto action =
          DeviceInfoActionDataResponseModelDto(
        name: "Update",
        id: 123,
      );
      final DeviceInfoVersionResponseModelDto model =
          DeviceInfoVersionResponseModelDto(
        action: action,
        version: "1.0.0",
        recordGuid: "guid-123",
        name: "Version Name",
        description: "Version Desc",
        buttonAccept: "OK",
        buttonDenied: "Cancel",
        createdDate: "2024-01-01",
      );

      // Act
      final dynamic domainModel = model.toDomain();

      // Assert
      expect(domainModel, isNotNull);
      expect(domainModel.version, "1.0.0");
      expect(domainModel.recordGuid, "guid-123");
      expect(domainModel.name, "Version Name");
      expect(domainModel.action, isNotNull);
    });

    test("toDomain converts dto to domain model with null fields", () {
      // Arrange
      final DeviceInfoVersionResponseModelDto model =
          DeviceInfoVersionResponseModelDto();

      // Act
      final dynamic domainModel = model.toDomain();

      // Assert
      expect(domainModel, isNotNull);
      expect(domainModel.version, isNull);
      expect(domainModel.action, isNull);
    });
  });
}
