import "package:esim_open_source/data/remote/responses/device/device_info_action_data_response_model_dto.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("DeviceInfoActionDataResponseModel Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "name": "Test Action",
        "id": 123,
        "tag": "test_tag",
        "description": "Test description",
        "isActive": true,
        "isEditable": false,
        "category": "test_category",
        "details": <dynamic>["detail1", "detail2"],
        "recordGuid": "guid-123",
      };

      // Act
      final DeviceInfoActionDataResponseModelDto model =
          DeviceInfoActionDataResponseModelDto.fromJson(json);

      // Assert
      expect(model.name, "Test Action");
      expect(model.id, 123);
      expect(model.tag, "test_tag");
      expect(model.description, "Test description");
      expect(model.isActive, true);
      expect(model.isEditable, false);
      expect(model.category, "test_category");
      expect(model.details, isNotNull);
      expect(model.details?.length, 2);
      expect(model.recordGuid, "guid-123");
    });

    test("fromJson handles null details", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "name": "Test",
      };

      // Act
      final DeviceInfoActionDataResponseModelDto model =
          DeviceInfoActionDataResponseModelDto.fromJson(json);

      // Assert
      expect(model.name, "Test");
      expect(model.details, isEmpty);
    });

    test("constructor assigns values correctly", () {
      // Act
      final DeviceInfoActionDataResponseModelDto model =
          DeviceInfoActionDataResponseModelDto(
        name: "Action",
        id: 456,
        tag: "tag",
        description: "Description",
        isActive: false,
        isEditable: true,
        category: "category",
        details: <dynamic>["detail"],
        recordGuid: "guid-456",
      );

      // Assert
      expect(model.name, "Action");
      expect(model.id, 456);
      expect(model.tag, "tag");
      expect(model.description, "Description");
      expect(model.isActive, false);
      expect(model.isEditable, true);
      expect(model.category, "category");
      expect(model.details?.length, 1);
      expect(model.recordGuid, "guid-456");
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final DeviceInfoActionDataResponseModelDto model =
          DeviceInfoActionDataResponseModelDto(
        name: "Test",
        id: 789,
        tag: "test_tag",
        description: "Test desc",
        isActive: true,
        isEditable: false,
        category: "cat",
        details: <dynamic>["d1", "d2"],
        recordGuid: "guid-789",
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["name"], "Test");
      expect(json["id"], 789);
      expect(json["tag"], "test_tag");
      expect(json["description"], "Test desc");
      expect(json["isActive"], true);
      expect(json["isEditable"], false);
      expect(json["category"], "cat");
      expect(json["details"], isNotNull);
      expect(json["recordGuid"], "guid-789");
    });

    test("toJson handles null fields", () {
      // Arrange
      final DeviceInfoActionDataResponseModelDto model =
          DeviceInfoActionDataResponseModelDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["name"], isNull);
      expect(json["id"], isNull);
      expect(json["tag"], isNull);
      expect(json["description"], isNull);
      expect(json["isActive"], isNull);
      expect(json["isEditable"], isNull);
      expect(json["category"], isNull);
      expect(json["details"], isNull);
      expect(json["recordGuid"], isNull);
    });
  });
}
