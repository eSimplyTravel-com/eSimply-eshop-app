import "package:esim_open_source/domain/data/response/user/user_bundle_consumption_response.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for UserBundleConsumptionResponse
/// Tests constructor, getters, copyWith, and field assignment
void main() {
  group("UserBundleConsumptionResponse Tests", () {
    test("constructor assigns all values correctly", () {
      // Act
      final UserBundleConsumptionResponse model = UserBundleConsumptionResponse(
        dataAllocated: 100,
        dataUsed: 50,
        dataRemaining: 50,
        dataAllocatedDisplay: "100 GB",
        dataUsedDisplay: "50 GB",
        dataRemainingDisplay: "50 GB",
        planStatus: "active",
        expiryDate: "2026-12-31",
      );

      // Assert
      expect(model.dataAllocated, 100);
      expect(model.dataUsed, 50);
      expect(model.dataRemaining, 50);
      expect(model.dataAllocatedDisplay, "100 GB");
      expect(model.dataUsedDisplay, "50 GB");
      expect(model.dataRemainingDisplay, "50 GB");
      expect(model.planStatus, "active");
      expect(model.expiryDate, "2026-12-31");
    });

    test("constructor with minimal fields", () {
      // Act
      final UserBundleConsumptionResponse model = UserBundleConsumptionResponse(
        dataAllocated: 50,
      );

      // Assert
      expect(model.dataAllocated, 50);
      expect(model.dataUsed, isNull);
      expect(model.dataRemaining, isNull);
      expect(model.dataAllocatedDisplay, isNull);
    });

    test("all fields are nullable", () {
      // Act
      final UserBundleConsumptionResponse model =
          UserBundleConsumptionResponse();

      // Assert
      expect(model.dataAllocated, isNull);
      expect(model.dataUsed, isNull);
      expect(model.dataRemaining, isNull);
      expect(model.dataAllocatedDisplay, isNull);
      expect(model.dataUsedDisplay, isNull);
      expect(model.dataRemainingDisplay, isNull);
      expect(model.planStatus, isNull);
      expect(model.expiryDate, isNull);
    });

    test("dataAllocated getter returns correct value", () {
      // Act
      final UserBundleConsumptionResponse model = UserBundleConsumptionResponse(
        dataAllocated: 200,
      );

      // Assert
      expect(model.dataAllocated, 200);
    });

    test("dataUsed getter returns correct value", () {
      // Act
      final UserBundleConsumptionResponse model = UserBundleConsumptionResponse(
        dataUsed: 75,
      );

      // Assert
      expect(model.dataUsed, 75);
    });

    test("dataRemaining getter returns correct value", () {
      // Act
      final UserBundleConsumptionResponse model = UserBundleConsumptionResponse(
        dataRemaining: 125,
      );

      // Assert
      expect(model.dataRemaining, 125);
    });

    test("dataAllocatedDisplay getter returns correct value", () {
      // Act
      final UserBundleConsumptionResponse model = UserBundleConsumptionResponse(
        dataAllocatedDisplay: "200 GB",
      );

      // Assert
      expect(model.dataAllocatedDisplay, "200 GB");
    });

    test("dataUsedDisplay getter returns correct value", () {
      // Act
      final UserBundleConsumptionResponse model = UserBundleConsumptionResponse(
        dataUsedDisplay: "75 GB",
      );

      // Assert
      expect(model.dataUsedDisplay, "75 GB");
    });

    test("dataRemainingDisplay getter returns correct value", () {
      // Act
      final UserBundleConsumptionResponse model = UserBundleConsumptionResponse(
        dataRemainingDisplay: "125 GB",
      );

      // Assert
      expect(model.dataRemainingDisplay, "125 GB");
    });

    test("planStatus getter returns correct value", () {
      // Act
      final UserBundleConsumptionResponse model = UserBundleConsumptionResponse(
        planStatus: "suspended",
      );

      // Assert
      expect(model.planStatus, "suspended");
    });

    test("expiryDate getter returns correct value", () {
      // Act
      final UserBundleConsumptionResponse model = UserBundleConsumptionResponse(
        expiryDate: "2027-06-02",
      );

      // Assert
      expect(model.expiryDate, "2027-06-02");
    });

    test("copyWith creates new instance with updated fields", () {
      // Arrange
      final UserBundleConsumptionResponse original =
          UserBundleConsumptionResponse(
        dataAllocated: 100,
        dataUsed: 50,
        dataRemaining: 50,
        planStatus: "active",
      );

      // Act
      final UserBundleConsumptionResponse updated = original.copyWith(
        UserBundleConsumptionResponseParams(
          consumptionData: ConsumptionDataParams(dataAllocated: 150),
        ),
      );

      // Assert
      expect(updated.dataAllocated, 150);
      expect(updated.dataUsed, 50);
      expect(updated.dataRemaining, 50);
      expect(updated.planStatus, "active");
    });

    test("copyWith without parameters returns same values", () {
      // Arrange
      final UserBundleConsumptionResponse original =
          UserBundleConsumptionResponse(
        dataAllocated: 100,
        dataUsed: 50,
        dataRemaining: 50,
        dataAllocatedDisplay: "100 GB",
      );

      // Act
      final UserBundleConsumptionResponse copied = original.copyWith();

      // Assert
      expect(copied.dataAllocated, original.dataAllocated);
      expect(copied.dataUsed, original.dataUsed);
      expect(copied.dataRemaining, original.dataRemaining);
      expect(copied.dataAllocatedDisplay, original.dataAllocatedDisplay);
    });

    test("copyWith preserves null values when not specified", () {
      // Arrange
      final UserBundleConsumptionResponse original =
          UserBundleConsumptionResponse(
        dataAllocated: 100,
        dataUsedDisplay: "50 GB",
      );

      // Act
      final UserBundleConsumptionResponse updated = original.copyWith(
        UserBundleConsumptionResponseParams(
          consumptionData: ConsumptionDataParams(dataRemaining: 50),
        ),
      );

      // Assert
      expect(updated.dataAllocated, 100);
      expect(updated.dataRemaining, 50);
      expect(updated.dataUsedDisplay, "50 GB");
      expect(updated.dataUsed, isNull);
    });

    test("copyWith preserves original instance", () {
      // Arrange
      final UserBundleConsumptionResponse original =
          UserBundleConsumptionResponse(
        dataAllocated: 100,
        planStatus: "active",
      );

      // Act
      final UserBundleConsumptionResponse updated = original.copyWith(
        UserBundleConsumptionResponseParams(
          consumptionData: ConsumptionDataParams(dataAllocated: 200),
        ),
      );

      // Assert
      expect(original.dataAllocated, 100);
      expect(updated.dataAllocated, 200);
      expect(original.planStatus, "active");
      expect(updated.planStatus, "active");
    });

    test("copyWith updates multiple fields", () {
      // Arrange
      final UserBundleConsumptionResponse original =
          UserBundleConsumptionResponse(
        dataAllocated: 100,
        dataUsed: 50,
        dataRemaining: 50,
        planStatus: "active",
      );

      // Act
      final UserBundleConsumptionResponse updated = original.copyWith(
        UserBundleConsumptionResponseParams(
          consumptionData: ConsumptionDataParams(
            dataAllocated: 200,
            dataUsed: 100,
            dataRemaining: 100,
          ),
          planInfo: ConsumptionPlanParams(planStatus: "suspended"),
        ),
      );

      // Assert
      expect(updated.dataAllocated, 200);
      expect(updated.dataUsed, 100);
      expect(updated.dataRemaining, 100);
      expect(updated.planStatus, "suspended");
    });

    test("handles empty string values", () {
      // Act
      final UserBundleConsumptionResponse model = UserBundleConsumptionResponse(
        dataAllocatedDisplay: "",
        dataUsedDisplay: "",
        planStatus: "",
        expiryDate: "",
      );

      // Assert
      expect(model.dataAllocatedDisplay, "");
      expect(model.dataUsedDisplay, "");
      expect(model.planStatus, "");
      expect(model.expiryDate, "");
    });

    test("handles zero data values", () {
      // Act
      final UserBundleConsumptionResponse model = UserBundleConsumptionResponse(
        dataAllocated: 0,
        dataUsed: 0,
        dataRemaining: 0,
      );

      // Assert
      expect(model.dataAllocated, 0);
      expect(model.dataUsed, 0);
      expect(model.dataRemaining, 0);
    });

    test("handles negative data values", () {
      // Act
      final UserBundleConsumptionResponse model = UserBundleConsumptionResponse(
        dataAllocated: -10,
        dataUsed: -5,
        dataRemaining: -15,
      );

      // Assert
      expect(model.dataAllocated, -10);
      expect(model.dataUsed, -5);
      expect(model.dataRemaining, -15);
    });

    test("handles decimal data values", () {
      // Act
      final UserBundleConsumptionResponse model = UserBundleConsumptionResponse(
        dataAllocated: 100.5,
        dataUsed: 50.25,
        dataRemaining: 50.25,
      );

      // Assert
      expect(model.dataAllocated, 100.5);
      expect(model.dataUsed, 50.25);
      expect(model.dataRemaining, 50.25);
    });

    test("handles special characters in string fields", () {
      // Act
      final UserBundleConsumptionResponse model = UserBundleConsumptionResponse(
        dataAllocatedDisplay: "100 GB's",
        dataUsedDisplay: "50 GB (approx)",
        planStatus: "active/suspended",
        expiryDate: "2026-12-31T23:59:59Z",
      );

      // Assert
      expect(model.dataAllocatedDisplay, "100 GB's");
      expect(model.dataUsedDisplay, "50 GB (approx)");
      expect(model.planStatus, "active/suspended");
      expect(model.expiryDate, "2026-12-31T23:59:59Z");
    });

    test("multiple instances are independent", () {
      // Act
      final UserBundleConsumptionResponse model1 =
          UserBundleConsumptionResponse(
        dataAllocated: 100,
        planStatus: "active",
      );
      final UserBundleConsumptionResponse model2 =
          UserBundleConsumptionResponse(
        dataAllocated: 200,
        planStatus: "suspended",
      );

      // Assert
      expect(model1.dataAllocated, 100);
      expect(model1.planStatus, "active");
      expect(model2.dataAllocated, 200);
      expect(model2.planStatus, "suspended");
    });

    test("copyWith uses default values when null passed", () {
      // Arrange
      final UserBundleConsumptionResponse original =
          UserBundleConsumptionResponse(
        dataAllocated: 100,
        dataAllocatedDisplay: "100 GB",
        planStatus: "active",
      );

      // Act - passing null keeps original values due to ?? operator in copyWith
      final UserBundleConsumptionResponse updated = original.copyWith(
        UserBundleConsumptionResponseParams(
          // ignore: avoid_redundant_argument_values
          consumptionData: ConsumptionDataParams(dataAllocated: null),
          consumptionDisplay:
              // ignore: avoid_redundant_argument_values
              ConsumptionDisplayParams(dataAllocatedDisplay: null),
        ),
      );

      // Assert
      expect(updated.dataAllocated, 100);
      expect(updated.dataAllocatedDisplay, "100 GB");
      expect(updated.planStatus, "active");
    });

    test("large numeric values are handled correctly", () {
      // Act
      final UserBundleConsumptionResponse model = UserBundleConsumptionResponse(
        dataAllocated: 999999999,
        dataUsed: 888888888,
        dataRemaining: 111111111,
      );

      // Assert
      expect(model.dataAllocated, 999999999);
      expect(model.dataUsed, 888888888);
      expect(model.dataRemaining, 111111111);
    });

    test("all display fields can be updated independently", () {
      // Arrange
      final UserBundleConsumptionResponse model = UserBundleConsumptionResponse(
        dataAllocatedDisplay: "100 GB",
        dataUsedDisplay: "50 GB",
        dataRemainingDisplay: "50 GB",
      );

      // Act
      final UserBundleConsumptionResponse updated = model.copyWith(
        UserBundleConsumptionResponseParams(
          consumptionDisplay: ConsumptionDisplayParams(dataUsedDisplay: "75 GB"),
        ),
      );

      // Assert
      expect(updated.dataAllocatedDisplay, "100 GB");
      expect(updated.dataUsedDisplay, "75 GB");
      expect(updated.dataRemainingDisplay, "50 GB");
    });

    test("plan status values are preserved correctly", () {
      // Act
      final UserBundleConsumptionResponse activeModel =
          UserBundleConsumptionResponse(planStatus: "active");
      final UserBundleConsumptionResponse suspendedModel =
          UserBundleConsumptionResponse(planStatus: "suspended");
      final UserBundleConsumptionResponse expiredModel =
          UserBundleConsumptionResponse(planStatus: "expired");

      // Assert
      expect(activeModel.planStatus, "active");
      expect(suspendedModel.planStatus, "suspended");
      expect(expiredModel.planStatus, "expired");
    });
  });
}
