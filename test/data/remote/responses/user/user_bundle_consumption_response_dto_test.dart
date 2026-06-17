import "package:esim_open_source/data/remote/responses/user/user_bundle_consumption_response_dto.dart";
import "package:esim_open_source/domain/data/response/user/user_bundle_consumption_response.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for UserBundleConsumptionResponseDto
/// Tests JSON serialization/deserialization and model methods
void main() {
  group("UserBundleConsumptionResponseDto Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "data_allocated": 100.0,
        "data_used": 25.5,
        "data_remaining": 74.5,
        "data_allocated_display": "100 GB",
        "data_used_display": "25.5 GB",
        "data_remaining_display": "74.5 GB",
        "plan_status": "active",
        "expiry_date": "2024-12-31",
      };

      // Act
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto.fromJson(json: json);

      // Assert
      expect(model.dataAllocated, 100.0);
      expect(model.dataUsed, 25.5);
      expect(model.dataRemaining, 74.5);
      expect(model.dataAllocatedDisplay, "100 GB");
      expect(model.dataUsedDisplay, "25.5 GB");
      expect(model.dataRemainingDisplay, "74.5 GB");
      expect(model.planStatus, "active");
      expect(model.expiryDate, "2024-12-31");
    });

    test("fromJson handles null fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto.fromJson(json: json);

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

    test("fromJson handles null dataAllocated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "data_used": 10.0,
        "data_remaining": 90.0,
      };

      // Act
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto.fromJson(json: json);

      // Assert
      expect(model.dataAllocated, isNull);
      expect(model.dataUsed, 10.0);
      expect(model.dataRemaining, 90.0);
    });

    test("fromJson handles null dataUsed", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "data_allocated": 100.0,
        "data_remaining": 100.0,
      };

      // Act
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto.fromJson(json: json);

      // Assert
      expect(model.dataUsed, isNull);
      expect(model.dataAllocated, 100.0);
      expect(model.dataRemaining, 100.0);
    });

    test("fromJson handles null dataRemaining", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "data_allocated": 100.0,
        "data_used": 50.0,
      };

      // Act
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto.fromJson(json: json);

      // Assert
      expect(model.dataRemaining, isNull);
      expect(model.dataAllocated, 100.0);
      expect(model.dataUsed, 50.0);
    });

    test("fromJson with explicit null numeric values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "data_allocated": null,
        "data_used": null,
      };

      // Act
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto.fromJson(json: json);

      // Assert
      expect(model.dataAllocated, isNull);
      expect(model.dataUsed, isNull);
    });

    test("fromJson handles dataAllocated as integer", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "data_allocated": 100,
      };

      // Act
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto.fromJson(json: json);

      // Assert
      expect(model.dataAllocated, 100);
      expect(model.dataAllocated, isA<num>());
    });

    test("fromJson handles dataAllocated as double", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "data_allocated": 99.99,
      };

      // Act
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto.fromJson(json: json);

      // Assert
      expect(model.dataAllocated, 99.99);
    });

    test("fromJson handles dataUsed as integer", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "data_used": 50,
      };

      // Act
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto.fromJson(json: json);

      // Assert
      expect(model.dataUsed, 50);
      expect(model.dataUsed, isA<num>());
    });

    test("fromJson handles dataRemaining as double", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "data_remaining": 74.5,
      };

      // Act
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto.fromJson(json: json);

      // Assert
      expect(model.dataRemaining, 74.5);
    });

    test("constructor assigns values correctly", () {
      // Act
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto(
        dataAllocated: 100.0,
        dataUsed: 25.5,
        dataRemaining: 74.5,
        dataAllocatedDisplay: "100 GB",
        dataUsedDisplay: "25.5 GB",
        dataRemainingDisplay: "74.5 GB",
        planStatus: "active",
        expiryDate: "2024-12-31",
      );

      // Assert
      expect(model.dataAllocated, 100.0);
      expect(model.dataUsed, 25.5);
      expect(model.dataRemaining, 74.5);
      expect(model.dataAllocatedDisplay, "100 GB");
      expect(model.dataUsedDisplay, "25.5 GB");
      expect(model.dataRemainingDisplay, "74.5 GB");
      expect(model.planStatus, "active");
      expect(model.expiryDate, "2024-12-31");
    });

    test("constructor with partial fields", () {
      // Act
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto(
        dataAllocated: 100.0,
        planStatus: "active",
      );

      // Assert
      expect(model.dataAllocated, 100.0);
      expect(model.planStatus, "active");
      expect(model.dataUsed, isNull);
      expect(model.dataRemaining, isNull);
    });

    test("all fields are nullable", () {
      // Act
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto();

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

    test("toJson returns correct map with all fields", () {
      // Arrange
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto(
        dataAllocated: 100.0,
        dataUsed: 25.5,
        dataRemaining: 74.5,
        dataAllocatedDisplay: "100 GB",
        dataUsedDisplay: "25.5 GB",
        dataRemainingDisplay: "74.5 GB",
        planStatus: "active",
        expiryDate: "2024-12-31",
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["data_allocated"], 100.0);
      expect(json["data_used"], 25.5);
      expect(json["data_remaining"], 74.5);
      expect(json["data_allocated_display"], "100 GB");
      expect(json["data_used_display"], "25.5 GB");
      expect(json["data_remaining_display"], "74.5 GB");
      expect(json["plan_status"], "active");
      expect(json["expiry_date"], "2024-12-31");
    });

    test("toJson handles null fields", () {
      // Arrange
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["data_allocated"], isNull);
      expect(json["data_used"], isNull);
      expect(json["data_remaining"], isNull);
      expect(json["data_allocated_display"], isNull);
      expect(json["data_used_display"], isNull);
      expect(json["data_remaining_display"], isNull);
      expect(json["plan_status"], isNull);
      expect(json["expiry_date"], isNull);
    });

    test("copyWith creates new instance with updated fields", () {
      // Arrange
      final UserBundleConsumptionResponseDto original =
          UserBundleConsumptionResponseDto(
        dataAllocated: 100.0,
        dataUsed: 25.5,
        planStatus: "active",
      );

      // Act
      final UserBundleConsumptionResponseDto updated = original.copyWith(
        UserBundleConsumptionResponseParamsDto(
          consumptionData: ConsumptionDataParamsDto(dataUsed: 50.0),
        ),
      );

      // Assert
      expect(updated.dataUsed, 50.0);
      expect(updated.dataAllocated, 100.0);
      expect(updated.planStatus, "active");
    });

    test("copyWith without parameters returns same values", () {
      // Arrange
      final UserBundleConsumptionResponseDto original =
          UserBundleConsumptionResponseDto(
        dataAllocated: 100.0,
        dataUsed: 25.5,
        planStatus: "active",
      );

      // Act
      final UserBundleConsumptionResponseDto copied = original.copyWith();

      // Assert
      expect(copied.dataAllocated, original.dataAllocated);
      expect(copied.dataUsed, original.dataUsed);
      expect(copied.planStatus, original.planStatus);
    });

    test("copyWith preserves null values when not specified", () {
      // Arrange
      final UserBundleConsumptionResponseDto original =
          UserBundleConsumptionResponseDto(
        dataAllocated: 100.0,
      );

      // Act
      final UserBundleConsumptionResponseDto updated = original.copyWith(
        UserBundleConsumptionResponseParamsDto(
          consumptionData: ConsumptionDataParamsDto(dataUsed: 25.0),
        ),
      );

      // Assert
      expect(updated.dataAllocated, 100.0);
      expect(updated.dataUsed, 25.0);
      expect(updated.dataRemaining, isNull);
      expect(updated.dataAllocatedDisplay, isNull);
    });

    test("copyWith preserves original instance", () {
      // Arrange
      final UserBundleConsumptionResponseDto original =
          UserBundleConsumptionResponseDto(
        dataAllocated: 100.0,
      );

      // Act
      final UserBundleConsumptionResponseDto updated = original.copyWith(
        UserBundleConsumptionResponseParamsDto(
          consumptionData: ConsumptionDataParamsDto(dataAllocated: 200.0),
        ),
      );

      // Assert
      expect(original.dataAllocated, 100.0);
      expect(updated.dataAllocated, 200.0);
    });

    test("copyWith can update dataAllocatedDisplay", () {
      // Arrange
      final UserBundleConsumptionResponseDto original =
          UserBundleConsumptionResponseDto(
        dataAllocatedDisplay: "100 GB",
      );

      // Act
      final UserBundleConsumptionResponseDto updated = original.copyWith(
        UserBundleConsumptionResponseParamsDto(
          consumptionDisplay:
              ConsumptionDisplayParamsDto(dataAllocatedDisplay: "200 GB"),
        ),
      );

      // Assert
      expect(updated.dataAllocatedDisplay, "200 GB");
      expect(original.dataAllocatedDisplay, "100 GB");
    });

    test("roundtrip fromJson and toJson preserves data", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "data_allocated": 100.0,
        "data_used": 25.5,
        "data_remaining": 74.5,
        "data_allocated_display": "100 GB",
        "data_used_display": "25.5 GB",
        "data_remaining_display": "74.5 GB",
        "plan_status": "active",
        "expiry_date": "2024-12-31",
      };

      // Act
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto.fromJson(json: originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(resultJson["data_allocated"], originalJson["data_allocated"]);
      expect(resultJson["data_used"], originalJson["data_used"]);
      expect(resultJson["data_remaining"], originalJson["data_remaining"]);
      expect(
        resultJson["data_allocated_display"],
        originalJson["data_allocated_display"],
      );
      expect(
        resultJson["data_used_display"],
        originalJson["data_used_display"],
      );
      expect(
        resultJson["data_remaining_display"],
        originalJson["data_remaining_display"],
      );
      expect(resultJson["plan_status"], originalJson["plan_status"]);
      expect(resultJson["expiry_date"], originalJson["expiry_date"]);
    });

    test("fromJson handles empty string values", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "data_allocated_display": "",
        "plan_status": "",
        "expiry_date": "",
      };

      // Act
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto.fromJson(json: json);

      // Assert
      expect(model.dataAllocatedDisplay, "");
      expect(model.planStatus, "");
      expect(model.expiryDate, "");
    });

    test("fromJson with special characters in strings", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "plan_status": "active/paused",
        "expiry_date": "2024-12-31T23:59:59Z",
        "data_allocated_display": "100.5 GB (50% bonus)",
      };

      // Act
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto.fromJson(json: json);

      // Assert
      expect(model.planStatus, "active/paused");
      expect(model.expiryDate, "2024-12-31T23:59:59Z");
      expect(model.dataAllocatedDisplay, "100.5 GB (50% bonus)");
    });

    test("multiple instances are independent", () {
      // Act
      final UserBundleConsumptionResponseDto model1 =
          UserBundleConsumptionResponseDto(dataAllocated: 100.0);
      final UserBundleConsumptionResponseDto model2 =
          UserBundleConsumptionResponseDto(dataAllocated: 200.0);

      // Assert
      expect(model1.dataAllocated, 100.0);
      expect(model2.dataAllocated, 200.0);
    });

    test("handles zero dataAllocated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "data_allocated": 0,
      };

      // Act
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto.fromJson(json: json);

      // Assert
      expect(model.dataAllocated, 0);
    });

    test("handles negative dataUsed (edge case)", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "data_used": -1,
      };

      // Act
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto.fromJson(json: json);

      // Assert
      expect(model.dataUsed, -1);
    });

    test("toJson preserves dataRemaining precision", () {
      // Arrange
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto(
        dataRemaining: 74.123456789,
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["data_remaining"], 74.123456789);
    });

    test("toDomain maps all fields correctly", () {
      // Arrange
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto(
        dataAllocated: 100.0,
        dataUsed: 25.5,
        dataRemaining: 74.5,
        dataAllocatedDisplay: "100 GB",
        dataUsedDisplay: "25.5 GB",
        dataRemainingDisplay: "74.5 GB",
        planStatus: "active",
        expiryDate: "2024-12-31",
      );

      // Act
      final UserBundleConsumptionResponse domain = model.toDomain();

      // Assert
      expect(domain.dataAllocated, 100.0);
      expect(domain.dataUsed, 25.5);
      expect(domain.dataRemaining, 74.5);
      expect(domain.dataAllocatedDisplay, "100 GB");
      expect(domain.dataUsedDisplay, "25.5 GB");
      expect(domain.dataRemainingDisplay, "74.5 GB");
      expect(domain.planStatus, "active");
      expect(domain.expiryDate, "2024-12-31");
    });

    test("toDomain handles null fields", () {
      // Arrange
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto();

      // Act
      final UserBundleConsumptionResponse domain = model.toDomain();

      // Assert
      expect(domain.dataAllocated, isNull);
      expect(domain.dataUsed, isNull);
      expect(domain.dataRemaining, isNull);
      expect(domain.dataAllocatedDisplay, isNull);
      expect(domain.dataUsedDisplay, isNull);
      expect(domain.dataRemainingDisplay, isNull);
      expect(domain.planStatus, isNull);
      expect(domain.expiryDate, isNull);
    });

    test("toDomain with partial fields", () {
      // Arrange
      final UserBundleConsumptionResponseDto model =
          UserBundleConsumptionResponseDto(
        dataAllocated: 100.0,
        planStatus: "active",
      );

      // Act
      final UserBundleConsumptionResponse domain = model.toDomain();

      // Assert
      expect(domain.dataAllocated, 100.0);
      expect(domain.planStatus, "active");
      expect(domain.dataUsed, isNull);
      expect(domain.dataRemaining, isNull);
    });
  });
}
