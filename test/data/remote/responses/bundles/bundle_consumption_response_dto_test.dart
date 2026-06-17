import "dart:convert";
import "package:esim_open_source/data/remote/responses/bundles/bundle_consumption_response_dto.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for BundleConsumptionResponse
/// Tests JSON serialization/deserialization and model methods
void main() {
  group("BundleConsumptionResponse Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "consumption": 500,
        "unit": "MB",
        "display_consumption": "500 MB",
      };

      // Act
      final BundleConsumptionResponseDto model =
          BundleConsumptionResponseDto.fromJson(json: json);

      // Assert
      expect(model.consumption, 500);
      expect(model.unit, "MB");
      expect(model.displayConsumption, "500 MB");
    });

    test("fromJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final BundleConsumptionResponseDto model =
          BundleConsumptionResponseDto.fromJson(json: json);

      // Assert
      expect(model.consumption, isNull);
      expect(model.unit, isNull);
      expect(model.displayConsumption, isNull);
    });

    test("constructor assigns values correctly", () {
      // Act
      final BundleConsumptionResponseDto model = BundleConsumptionResponseDto(
        consumption: 1024,
        unit: "GB",
        displayConsumption: "1 GB",
      );

      // Assert
      expect(model.consumption, 1024);
      expect(model.unit, "GB");
      expect(model.displayConsumption, "1 GB");
    });

    test("copyWith creates new instance with updated values", () {
      // Arrange
      final BundleConsumptionResponseDto original = BundleConsumptionResponseDto(
        consumption: 100,
        unit: "MB",
        displayConsumption: "100 MB",
      );

      // Act
      final BundleConsumptionResponseDto updated = original.copyWith(
        consumption: 200,
      );

      // Assert
      expect(updated.consumption, 200);
      expect(updated.unit, "MB");
      expect(updated.displayConsumption, "100 MB");
    });

    test("copyWith preserves original values when no parameters provided", () {
      // Arrange
      final BundleConsumptionResponseDto original = BundleConsumptionResponseDto(
        consumption: 100,
        unit: "MB",
        displayConsumption: "100 MB",
      );

      // Act
      final BundleConsumptionResponseDto copy = original.copyWith();

      // Assert
      expect(copy.consumption, 100);
      expect(copy.unit, "MB");
      expect(copy.displayConsumption, "100 MB");
    });

    test("copyWith updates all fields", () {
      // Arrange
      final BundleConsumptionResponseDto original = BundleConsumptionResponseDto(
        consumption: 100,
        unit: "MB",
        displayConsumption: "100 MB",
      );

      // Act
      final BundleConsumptionResponseDto updated = original.copyWith(
        consumption: 500,
        unit: "GB",
        displayConsumption: "0.5 GB",
      );

      // Assert
      expect(updated.consumption, 500);
      expect(updated.unit, "GB");
      expect(updated.displayConsumption, "0.5 GB");
    });

    test("toJson returns correct map", () {
      // Arrange
      final BundleConsumptionResponseDto model = BundleConsumptionResponseDto(
        consumption: 750,
        unit: "MB",
        displayConsumption: "750 MB",
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["consumption"], 750);
      expect(json["unit"], "MB");
      expect(json["display_consumption"], "750 MB");
    });

    test("toJson handles null fields", () {
      // Arrange
      final BundleConsumptionResponseDto model = BundleConsumptionResponseDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["consumption"], isNull);
      expect(json["unit"], isNull);
      expect(json["display_consumption"], isNull);
    });

    test("bundleConsumptionResponseFromJson parses JSON string", () {
      // Arrange
      const String jsonString = '{"consumption": 300, "unit": "MB", "display_consumption": "300 MB"}';

      // Act
      final BundleConsumptionResponseDto model =
          bundleConsumptionResponseFromJson(jsonString);

      // Assert
      expect(model.consumption, 300);
      expect(model.unit, "MB");
      expect(model.displayConsumption, "300 MB");
    });

    test("bundleConsumptionResponseToJson converts to JSON string", () {
      // Arrange
      final BundleConsumptionResponseDto model = BundleConsumptionResponseDto(
        consumption: 400,
        unit: "GB",
        displayConsumption: "400 GB",
      );

      // Act
      final String jsonString = bundleConsumptionResponseToJson(model);
      final Map<String, dynamic> decoded = json.decode(jsonString);

      // Assert
      expect(decoded["consumption"], 400);
      expect(decoded["unit"], "GB");
      expect(decoded["display_consumption"], "400 GB");
    });

    test("roundtrip fromJson and toJson preserves data", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "consumption": 999,
        "unit": "TB",
        "display_consumption": "999 TB",
      };

      // Act
      final BundleConsumptionResponseDto model =
          BundleConsumptionResponseDto.fromJson(json: originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(resultJson, originalJson);
    });

    test("getters return correct values", () {
      // Arrange
      final BundleConsumptionResponseDto model = BundleConsumptionResponseDto(
        consumption: 2048,
        unit: "GB",
        displayConsumption: "2 GB",
      );

      // Assert
      expect(model.consumption, 2048);
      expect(model.unit, "GB");
      expect(model.displayConsumption, "2 GB");
    });
  });
}
