import "package:esim_open_source/domain/data/response/bundles/bundle_consumption_response.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for BundleConsumptionResponse
void main() {
  group("BundleConsumptionResponse Tests", () {
    test("constructor assigns values correctly", () {
      // Act
      final BundleConsumptionResponse response = BundleConsumptionResponse(
        consumption: 500,
        unit: "MB",
        displayConsumption: "500 MB",
      );

      // Assert
      expect(response.consumption, 500);
      expect(response.unit, "MB");
      expect(response.displayConsumption, "500 MB");
    });

    test("constructor with all null values", () {
      // Act
      final BundleConsumptionResponse response = BundleConsumptionResponse();

      // Assert
      expect(response.consumption, isNull);
      expect(response.unit, isNull);
      expect(response.displayConsumption, isNull);
    });

    test("constructor with partial null values", () {
      // Act
      final BundleConsumptionResponse response = BundleConsumptionResponse(
        consumption: 1000,
        unit: null,
        displayConsumption: null,
      );

      // Assert
      expect(response.consumption, 1000);
      expect(response.unit, isNull);
      expect(response.displayConsumption, isNull);
    });

    test("consumption as double value", () {
      // Act
      final BundleConsumptionResponse response = BundleConsumptionResponse(
        consumption: 250.5,
      );

      // Assert
      expect(response.consumption, 250.5);
    });

    test("consumption as zero", () {
      // Act
      final BundleConsumptionResponse response = BundleConsumptionResponse(
        consumption: 0,
      );

      // Assert
      expect(response.consumption, 0);
    });

    test("copyWith updates single field", () {
      // Arrange
      final BundleConsumptionResponse original = BundleConsumptionResponse(
        consumption: 500,
        unit: "MB",
        displayConsumption: "500 MB",
      );

      // Act
      final BundleConsumptionResponse updated = original.copyWith(
        consumption: 750,
      );

      // Assert
      expect(updated.consumption, 750);
      expect(updated.unit, "MB");
      expect(updated.displayConsumption, "500 MB");
    });

    test("copyWith updates multiple fields", () {
      // Arrange
      final BundleConsumptionResponse original = BundleConsumptionResponse(
        consumption: 500,
        unit: "MB",
        displayConsumption: "500 MB",
      );

      // Act
      final BundleConsumptionResponse updated = original.copyWith(
        consumption: 1000,
        unit: "GB",
        displayConsumption: "1 GB",
      );

      // Assert
      expect(updated.consumption, 1000);
      expect(updated.unit, "GB");
      expect(updated.displayConsumption, "1 GB");
    });

    test("copyWith without parameters returns same values", () {
      // Arrange
      final BundleConsumptionResponse original = BundleConsumptionResponse(
        consumption: 500,
        unit: "MB",
        displayConsumption: "500 MB",
      );

      // Act
      final BundleConsumptionResponse copied = original.copyWith();

      // Assert
      expect(copied.consumption, original.consumption);
      expect(copied.unit, original.unit);
      expect(copied.displayConsumption, original.displayConsumption);
    });

    test("copyWith preserves null values when not specified", () {
      // Arrange
      final BundleConsumptionResponse original = BundleConsumptionResponse(
        consumption: 500,
      );

      // Act
      final BundleConsumptionResponse updated = original.copyWith(
        unit: "MB",
      );

      // Assert
      expect(updated.consumption, 500);
      expect(updated.unit, "MB");
      expect(updated.displayConsumption, isNull);
    });

    test("copyWith creates new instance", () {
      // Arrange
      final BundleConsumptionResponse original = BundleConsumptionResponse(
        consumption: 500,
        unit: "MB",
        displayConsumption: "500 MB",
      );

      // Act
      final BundleConsumptionResponse updated = original.copyWith(
        consumption: 750,
      );

      // Assert
      expect(identical(original, updated), false);
      expect(original.consumption, 500);
      expect(updated.consumption, 750);
    });

    test("consumption getter returns correct value", () {
      // Arrange
      final BundleConsumptionResponse response = BundleConsumptionResponse(
        consumption: 1500,
      );

      // Act
      final num? consumption = response.consumption;

      // Assert
      expect(consumption, 1500);
    });

    test("unit getter returns correct value", () {
      // Arrange
      final BundleConsumptionResponse response = BundleConsumptionResponse(
        unit: "GB",
      );

      // Act
      final String? unit = response.unit;

      // Assert
      expect(unit, "GB");
    });

    test("displayConsumption getter returns correct value", () {
      // Arrange
      final BundleConsumptionResponse response = BundleConsumptionResponse(
        displayConsumption: "1.5 GB",
      );

      // Act
      final String? displayConsumption = response.displayConsumption;

      // Assert
      expect(displayConsumption, "1.5 GB");
    });

    test("empty display consumption string", () {
      // Act
      final BundleConsumptionResponse response = BundleConsumptionResponse(
        displayConsumption: "",
      );

      // Assert
      expect(response.displayConsumption, "");
    });

    test("special characters in unit", () {
      // Act
      final BundleConsumptionResponse response = BundleConsumptionResponse(
        unit: "MB/s",
      );

      // Assert
      expect(response.unit, "MB/s");
    });

    test("multiple instances are independent", () {
      // Act
      final BundleConsumptionResponse response1 = BundleConsumptionResponse(
        consumption: 500,
        unit: "MB",
      );
      final BundleConsumptionResponse response2 = BundleConsumptionResponse(
        consumption: 1000,
        unit: "GB",
      );

      // Assert
      expect(response1.consumption, 500);
      expect(response2.consumption, 1000);
      expect(response1.unit, "MB");
      expect(response2.unit, "GB");
    });

    test("response type is correct", () {
      // Act
      final BundleConsumptionResponse response = BundleConsumptionResponse();

      // Assert
      expect(response, isA<BundleConsumptionResponse>());
    });
  });
}
