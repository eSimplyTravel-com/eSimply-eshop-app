import "package:esim_open_source/domain/data/response/device/device_info_action_data_response_model.dart";
import "package:esim_open_source/domain/data/response/device/device_info_version_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for DeviceInfoVersionResponseModel
/// Tests constructor, field assignment, and nested model handling
void main() {
  group("DeviceInfoVersionResponseModel Tests", () {
    test("constructor assigns all values correctly", () {
      // Arrange
      final DeviceInfoActionDataResponseModel action =
          DeviceInfoActionDataResponseModel(
        name: "Action",
        id: 1,
      );

      // Act
      final DeviceInfoVersionResponseModel model =
          DeviceInfoVersionResponseModel(
        action: action,
        version: "1.0.0",
        recordGuid: "guid-123",
        name: "Version Name",
        description: "Version description",
        buttonAccept: "Accept",
        buttonDenied: "Deny",
        createdDate: "2023-01-01",
      );

      // Assert
      expect(model.action, action);
      expect(model.version, "1.0.0");
      expect(model.recordGuid, "guid-123");
      expect(model.name, "Version Name");
      expect(model.description, "Version description");
      expect(model.buttonAccept, "Accept");
      expect(model.buttonDenied, "Deny");
      expect(model.createdDate, "2023-01-01");
    });

    test("constructor with partial fields", () {
      // Act
      final DeviceInfoVersionResponseModel model =
          DeviceInfoVersionResponseModel(
        version: "2.0.0",
        name: "Partial Version",
      );

      // Assert
      expect(model.action, isNull);
      expect(model.version, "2.0.0");
      expect(model.name, "Partial Version");
      expect(model.recordGuid, isNull);
      expect(model.description, isNull);
      expect(model.buttonAccept, isNull);
      expect(model.buttonDenied, isNull);
      expect(model.createdDate, isNull);
    });

    test("constructor with no fields creates nullable instance", () {
      // Act
      final DeviceInfoVersionResponseModel model =
          DeviceInfoVersionResponseModel();

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

    test("handles nested action object", () {
      // Arrange
      final DeviceInfoActionDataResponseModel action =
          DeviceInfoActionDataResponseModel(
        name: "Test Action",
        id: 42,
        tag: "test_tag",
        isActive: true,
      );

      // Act
      final DeviceInfoVersionResponseModel model =
          DeviceInfoVersionResponseModel(action: action);

      // Assert
      expect(model.action, isNotNull);
      expect(model.action?.name, "Test Action");
      expect(model.action?.id, 42);
      expect(model.action?.tag, "test_tag");
      expect(model.action?.isActive, true);
    });

    test("handles null action field", () {
      // Act
      final DeviceInfoVersionResponseModel model =
          DeviceInfoVersionResponseModel(
        action: null,
        version: "1.0.0",
      );

      // Assert
      expect(model.action, isNull);
      expect(model.version, "1.0.0");
    });

    test("handles version string variations", () {
      // Act
      final DeviceInfoVersionResponseModel modelStandard =
          DeviceInfoVersionResponseModel(version: "1.2.3");
      final DeviceInfoVersionResponseModel modelWithBuild =
          DeviceInfoVersionResponseModel(version: "1.2.3+100");
      final DeviceInfoVersionResponseModel modelSingle =
          DeviceInfoVersionResponseModel(version: "2");

      // Assert
      expect(modelStandard.version, "1.2.3");
      expect(modelWithBuild.version, "1.2.3+100");
      expect(modelSingle.version, "2");
    });

    test("handles empty string values", () {
      // Act
      final DeviceInfoVersionResponseModel model =
          DeviceInfoVersionResponseModel(
        version: "",
        recordGuid: "",
        name: "",
        description: "",
        buttonAccept: "",
        buttonDenied: "",
        createdDate: "",
      );

      // Assert
      expect(model.version, "");
      expect(model.recordGuid, "");
      expect(model.name, "");
      expect(model.description, "");
      expect(model.buttonAccept, "");
      expect(model.buttonDenied, "");
      expect(model.createdDate, "");
    });

    test("handles special characters in strings", () {
      // Act
      final DeviceInfoVersionResponseModel model =
          DeviceInfoVersionResponseModel(
        version: "v1.0.0-beta+build.123",
        name: "Version's Name: Beta!",
        description: "Description with special chars",
        recordGuid: "guid-abc-123-def-456",
        buttonAccept: "Accept & Continue",
        buttonDenied: "Reject 'n' Deny",
      );

      // Assert
      expect(model.version, "v1.0.0-beta+build.123");
      expect(model.name, "Version's Name: Beta!");
      expect(model.description, "Description with special chars");
      expect(model.recordGuid, "guid-abc-123-def-456");
      expect(model.buttonAccept, "Accept & Continue");
      expect(model.buttonDenied, "Reject 'n' Deny");
    });

    test("handles various date formats", () {
      // Act
      final DeviceInfoVersionResponseModel modelISO =
          DeviceInfoVersionResponseModel(createdDate: "2023-01-01T12:00:00Z");
      final DeviceInfoVersionResponseModel modelUS =
          DeviceInfoVersionResponseModel(createdDate: "01/01/2023");
      final DeviceInfoVersionResponseModel modelEU =
          DeviceInfoVersionResponseModel(createdDate: "01-01-2023");
      final DeviceInfoVersionResponseModel modelUnix =
          DeviceInfoVersionResponseModel(createdDate: "1672531200");

      // Assert
      expect(modelISO.createdDate, "2023-01-01T12:00:00Z");
      expect(modelUS.createdDate, "01/01/2023");
      expect(modelEU.createdDate, "01-01-2023");
      expect(modelUnix.createdDate, "1672531200");
    });

    test("multiple instances are independent", () {
      // Arrange
      final DeviceInfoActionDataResponseModel action1 =
          DeviceInfoActionDataResponseModel(name: "Action 1", id: 1);
      final DeviceInfoActionDataResponseModel action2 =
          DeviceInfoActionDataResponseModel(name: "Action 2", id: 2);

      // Act
      final DeviceInfoVersionResponseModel model1 =
          DeviceInfoVersionResponseModel(
        action: action1,
        version: "1.0.0",
      );
      final DeviceInfoVersionResponseModel model2 =
          DeviceInfoVersionResponseModel(
        action: action2,
        version: "2.0.0",
      );

      // Assert
      expect(model1.action?.name, "Action 1");
      expect(model1.version, "1.0.0");
      expect(model2.action?.name, "Action 2");
      expect(model2.version, "2.0.0");
    });

    test("nested action remains unchanged when model fields are set", () {
      // Arrange
      final DeviceInfoActionDataResponseModel action =
          DeviceInfoActionDataResponseModel(
        name: "Original Action",
        id: 5,
      );
      final DeviceInfoVersionResponseModel model =
          DeviceInfoVersionResponseModel(action: action);

      // Act
      model.version = "2.0.0";
      model.name = "Updated Name";

      // Assert
      expect(model.action?.name, "Original Action");
      expect(model.action?.id, 5);
      expect(model.version, "2.0.0");
      expect(model.name, "Updated Name");
    });

    test("handles all button fields independently", () {
      // Act
      final DeviceInfoVersionResponseModel model =
          DeviceInfoVersionResponseModel(
        buttonAccept: "Yes",
        buttonDenied: "No",
      );
      final DeviceInfoVersionResponseModel modelEmpty =
          DeviceInfoVersionResponseModel(
        buttonAccept: "",
        buttonDenied: "",
      );
      final DeviceInfoVersionResponseModel modelNull =
          DeviceInfoVersionResponseModel(
        buttonAccept: null,
        buttonDenied: null,
      );

      // Assert
      expect(model.buttonAccept, "Yes");
      expect(model.buttonDenied, "No");
      expect(modelEmpty.buttonAccept, "");
      expect(modelEmpty.buttonDenied, "");
      expect(modelNull.buttonAccept, isNull);
      expect(modelNull.buttonDenied, isNull);
    });

    test("handles mixed null and non-null fields with nested object", () {
      // Arrange
      final DeviceInfoActionDataResponseModel action =
          DeviceInfoActionDataResponseModel(name: "Action");

      // Act
      final DeviceInfoVersionResponseModel model =
          DeviceInfoVersionResponseModel(
        action: action,
        version: "1.0.0",
        recordGuid: null,
        name: "Test",
        description: null,
        buttonAccept: "OK",
        buttonDenied: null,
        createdDate: "2023-01-01",
      );

      // Assert
      expect(model.action, isNotNull);
      expect(model.version, "1.0.0");
      expect(model.recordGuid, isNull);
      expect(model.name, "Test");
      expect(model.description, isNull);
      expect(model.buttonAccept, "OK");
      expect(model.buttonDenied, isNull);
      expect(model.createdDate, "2023-01-01");
    });

    test("handles very long string values", () {
      // Arrange
      final String longString = "A" * 1000;

      // Act
      final DeviceInfoVersionResponseModel model =
          DeviceInfoVersionResponseModel(
        description: longString,
      );

      // Assert
      expect(model.description?.length, 1000);
      expect(model.description, longString);
    });
  });
}
