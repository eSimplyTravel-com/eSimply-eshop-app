import "package:esim_open_source/domain/data/response/device/device_info_action_data_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for DeviceInfoActionDataResponseModel
/// Tests constructor, field assignment, and model behavior
void main() {
  group("DeviceInfoActionDataResponseModel Tests", () {
    test("constructor assigns all values correctly", () {
      // Act
      final DeviceInfoActionDataResponseModel model =
          DeviceInfoActionDataResponseModel(
        name: "Action Name",
        id: 123,
        tag: "action_tag",
        description: "Action description",
        isActive: true,
        isEditable: true,
        category: <String, dynamic>{"type": "category"},
        details: <dynamic>["detail1", "detail2"],
        recordGuid: "guid-123",
      );

      // Assert
      expect(model.name, "Action Name");
      expect(model.id, 123);
      expect(model.tag, "action_tag");
      expect(model.description, "Action description");
      expect(model.isActive, true);
      expect(model.isEditable, true);
      expect(model.category, isNotNull);
      expect(model.details, isNotNull);
      expect(model.details?.length, 2);
      expect(model.recordGuid, "guid-123");
    });

    test("constructor with partial fields", () {
      // Act
      final DeviceInfoActionDataResponseModel model =
          DeviceInfoActionDataResponseModel(
        name: "Partial Action",
        id: 456,
      );

      // Assert
      expect(model.name, "Partial Action");
      expect(model.id, 456);
      expect(model.tag, isNull);
      expect(model.description, isNull);
      expect(model.isActive, isNull);
      expect(model.isEditable, isNull);
      expect(model.category, isNull);
      expect(model.details, isNull);
      expect(model.recordGuid, isNull);
    });

    test("constructor with no fields creates nullable instance", () {
      // Act
      final DeviceInfoActionDataResponseModel model =
          DeviceInfoActionDataResponseModel();

      // Assert
      expect(model.name, isNull);
      expect(model.id, isNull);
      expect(model.tag, isNull);
      expect(model.description, isNull);
      expect(model.isActive, isNull);
      expect(model.isEditable, isNull);
      expect(model.category, isNull);
      expect(model.details, isNull);
      expect(model.recordGuid, isNull);
    });

    test("handles boolean values correctly", () {
      // Act
      final DeviceInfoActionDataResponseModel modelTrue =
          DeviceInfoActionDataResponseModel(
        isActive: true,
        isEditable: false,
      );
      final DeviceInfoActionDataResponseModel modelFalse =
          DeviceInfoActionDataResponseModel(
        isActive: false,
        isEditable: true,
      );

      // Assert
      expect(modelTrue.isActive, true);
      expect(modelTrue.isEditable, false);
      expect(modelFalse.isActive, false);
      expect(modelFalse.isEditable, true);
    });

    test("handles zero and negative id values", () {
      // Act
      final DeviceInfoActionDataResponseModel modelZero =
          DeviceInfoActionDataResponseModel(id: 0);
      final DeviceInfoActionDataResponseModel modelNegative =
          DeviceInfoActionDataResponseModel(id: -1);

      // Assert
      expect(modelZero.id, 0);
      expect(modelNegative.id, -1);
    });

    test("handles large id values", () {
      // Act
      final DeviceInfoActionDataResponseModel model =
          DeviceInfoActionDataResponseModel(id: 999999);

      // Assert
      expect(model.id, 999999);
    });

    test("handles empty string values", () {
      // Act
      final DeviceInfoActionDataResponseModel model =
          DeviceInfoActionDataResponseModel(
        name: "",
        tag: "",
        description: "",
        recordGuid: "",
      );

      // Assert
      expect(model.name, "");
      expect(model.tag, "");
      expect(model.description, "");
      expect(model.recordGuid, "");
    });

    test("handles special characters in strings", () {
      // Act
      final DeviceInfoActionDataResponseModel model =
          DeviceInfoActionDataResponseModel(
        name: "Action's Name: Special!",
        tag: "tag_123-456",
        description: "Description with special chars",
        recordGuid: "guid-abc-123-def",
      );

      // Assert
      expect(model.name, "Action's Name: Special!");
      expect(model.tag, "tag_123-456");
      expect(model.description, "Description with special chars");
      expect(model.recordGuid, "guid-abc-123-def");
    });

    test("handles dynamic category field", () {
      // Arrange
      final dynamic categoryMap = <String, dynamic>{
        "id": 1,
        "name": "Test Category",
        "nested": <String, dynamic>{"value": "nested_value"},
      };

      // Act
      final DeviceInfoActionDataResponseModel model =
          DeviceInfoActionDataResponseModel(category: categoryMap);

      // Assert
      expect(model.category, isNotNull);
      expect(model.category, categoryMap);
    });

    test("handles details list with various types", () {
      // Act
      final DeviceInfoActionDataResponseModel model =
          DeviceInfoActionDataResponseModel(
        details: <dynamic>["string", 123, true, null, 45.67],
      );

      // Assert
      expect(model.details, isNotNull);
      expect(model.details?.length, 5);
      expect(model.details?[0], "string");
      expect(model.details?[1], 123);
      expect(model.details?[2], true);
      expect(model.details?[3], isNull);
      expect(model.details?[4], 45.67);
    });

    test("handles empty details list", () {
      // Act
      final DeviceInfoActionDataResponseModel model =
          DeviceInfoActionDataResponseModel(details: <dynamic>[]);

      // Assert
      expect(model.details, isNotNull);
      expect(model.details, isEmpty);
    });

    test("handles large details list", () {
      // Act
      final List<dynamic> largeList = List<dynamic>.generate(100, (i) => i);
      final DeviceInfoActionDataResponseModel model =
          DeviceInfoActionDataResponseModel(details: largeList);

      // Assert
      expect(model.details?.length, 100);
    });

    test("multiple instances are independent", () {
      // Act
      final DeviceInfoActionDataResponseModel model1 =
          DeviceInfoActionDataResponseModel(
        name: "Action 1",
        id: 1,
        isActive: true,
      );
      final DeviceInfoActionDataResponseModel model2 =
          DeviceInfoActionDataResponseModel(
        name: "Action 2",
        id: 2,
        isActive: false,
      );

      // Assert
      expect(model1.name, "Action 1");
      expect(model1.id, 1);
      expect(model1.isActive, true);
      expect(model2.name, "Action 2");
      expect(model2.id, 2);
      expect(model2.isActive, false);
    });

    test("field mutation affects only the instance", () {
      // Arrange
      final DeviceInfoActionDataResponseModel model1 =
          DeviceInfoActionDataResponseModel(
        name: "Original",
        details: <dynamic>["item1"],
      );
      final DeviceInfoActionDataResponseModel model2 =
          DeviceInfoActionDataResponseModel(
        name: "Copy",
        details: <dynamic>["item1"],
      );

      // Act
      model1.name = "Modified";
      model1.details?.add("item2");

      // Assert
      expect(model1.name, "Modified");
      expect(model1.details?.length, 2);
      expect(model2.name, "Copy");
      expect(model2.details?.length, 1); // Separate instance, unchanged
    });

    test("null checks on nullable fields", () {
      // Act
      final DeviceInfoActionDataResponseModel model1 =
          DeviceInfoActionDataResponseModel(
        name: null,
        id: null,
        isActive: null,
      );
      final DeviceInfoActionDataResponseModel model2 =
          DeviceInfoActionDataResponseModel();

      // Assert
      expect(model1.name, isNull);
      expect(model1.id, isNull);
      expect(model1.isActive, isNull);
      expect(model2.name, isNull);
      expect(model2.id, isNull);
      expect(model2.isActive, isNull);
    });

    test("handles mixed null and non-null fields", () {
      // Act
      final DeviceInfoActionDataResponseModel model =
          DeviceInfoActionDataResponseModel(
        name: "Test",
        id: null,
        tag: "test_tag",
        description: null,
        isActive: true,
        isEditable: null,
      );

      // Assert
      expect(model.name, "Test");
      expect(model.id, isNull);
      expect(model.tag, "test_tag");
      expect(model.description, isNull);
      expect(model.isActive, true);
      expect(model.isEditable, isNull);
    });
  });
}
