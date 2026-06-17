import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/transaction_history_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for TransactionHistoryResponseModel
void main() {
  group("TransactionHistoryResponseModel Tests", () {
    test("constructor assigns values correctly", () {
      // Arrange
      final BundleResponseModel bundle = BundleResponseModel(bundleCode: "TEST");

      // Act
      final TransactionHistoryResponseModel model = TransactionHistoryResponseModel(
        userOrderId: "ORDER123",
        iccid: "89123456789012345678",
        bundleType: "Global",
        planStarted: true,
        bundleExpired: false,
        createdAt: "2024-01-01",
        bundle: bundle,
      );

      // Assert
      expect(model.userOrderId, "ORDER123");
      expect(model.iccid, "89123456789012345678");
      expect(model.bundleType, "Global");
      expect(model.planStarted, true);
      expect(model.bundleExpired, false);
      expect(model.createdAt, "2024-01-01");
      expect(model.bundle, bundle);
    });

    test("constructor with all null values", () {
      // Act
      final TransactionHistoryResponseModel model = TransactionHistoryResponseModel();

      // Assert
      expect(model.userOrderId, isNull);
      expect(model.iccid, isNull);
      expect(model.bundleType, isNull);
      expect(model.planStarted, isNull);
      expect(model.bundleExpired, isNull);
      expect(model.createdAt, isNull);
      expect(model.bundle, isNull);
    });

    test("constructor with partial null values", () {
      // Act
      final TransactionHistoryResponseModel model = TransactionHistoryResponseModel(
        userOrderId: "ORDER456",
        iccid: null,
        bundleType: "Cruise",
      );

      // Assert
      expect(model.userOrderId, "ORDER456");
      expect(model.iccid, isNull);
      expect(model.bundleType, "Cruise");
      expect(model.planStarted, isNull);
    });

    test("planStarted as false", () {
      // Act
      final TransactionHistoryResponseModel model = TransactionHistoryResponseModel(
        planStarted: false,
      );

      // Assert
      expect(model.planStarted, false);
    });

    test("bundleExpired as true", () {
      // Act
      final TransactionHistoryResponseModel model = TransactionHistoryResponseModel(
        bundleExpired: true,
      );

      // Assert
      expect(model.bundleExpired, true);
    });

    test("nested bundle model is properly stored", () {
      // Arrange
      final BundleResponseModel bundle = BundleResponseModel(
        bundleCode: "NESTED",
        bundleName: "Test Bundle",
      );

      // Act
      final TransactionHistoryResponseModel model = TransactionHistoryResponseModel(
        bundle: bundle,
      );

      // Assert
      expect(model.bundle, isNotNull);
      expect(model.bundle?.bundleCode, "NESTED");
      expect(model.bundle?.bundleName, "Test Bundle");
    });

    test("empty string for userOrderId", () {
      // Act
      final TransactionHistoryResponseModel model = TransactionHistoryResponseModel(
        userOrderId: "",
      );

      // Assert
      expect(model.userOrderId, "");
    });

    test("empty string for iccid", () {
      // Act
      final TransactionHistoryResponseModel model = TransactionHistoryResponseModel(
        iccid: "",
      );

      // Assert
      expect(model.iccid, "");
    });

    test("empty string for bundleType", () {
      // Act
      final TransactionHistoryResponseModel model = TransactionHistoryResponseModel(
        bundleType: "",
      );

      // Assert
      expect(model.bundleType, "");
    });

    test("empty string for createdAt", () {
      // Act
      final TransactionHistoryResponseModel model = TransactionHistoryResponseModel(
        createdAt: "",
      );

      // Assert
      expect(model.createdAt, "");
    });

    test("ISO8601 datetime format for createdAt", () {
      // Act
      final TransactionHistoryResponseModel model = TransactionHistoryResponseModel(
        createdAt: "2024-01-15T10:30:00Z",
      );

      // Assert
      expect(model.createdAt, "2024-01-15T10:30:00Z");
    });

    test("long iccid value", () {
      // Act
      final TransactionHistoryResponseModel model = TransactionHistoryResponseModel(
        iccid: "89012345678901234567890123456789",
      );

      // Assert
      expect(model.iccid, "89012345678901234567890123456789");
    });

    test("alphanumeric userOrderId", () {
      // Act
      final TransactionHistoryResponseModel model = TransactionHistoryResponseModel(
        userOrderId: "ORD-2024-ABC-123",
      );

      // Assert
      expect(model.userOrderId, "ORD-2024-ABC-123");
    });

    test("various bundleType values", () {
      // Act
      final TransactionHistoryResponseModel model1 = TransactionHistoryResponseModel(
        bundleType: "Global",
      );
      final TransactionHistoryResponseModel model2 = TransactionHistoryResponseModel(
        bundleType: "Cruise",
      );
      final TransactionHistoryResponseModel model3 = TransactionHistoryResponseModel(
        bundleType: "Regional",
      );

      // Assert
      expect(model1.bundleType, "Global");
      expect(model2.bundleType, "Cruise");
      expect(model3.bundleType, "Regional");
    });

    test("multiple instances are independent", () {
      // Arrange
      final BundleResponseModel bundle1 = BundleResponseModel(bundleCode: "B1");
      final BundleResponseModel bundle2 = BundleResponseModel(bundleCode: "B2");

      // Act
      final TransactionHistoryResponseModel model1 = TransactionHistoryResponseModel(
        userOrderId: "ORDER1",
        bundle: bundle1,
      );
      final TransactionHistoryResponseModel model2 = TransactionHistoryResponseModel(
        userOrderId: "ORDER2",
        bundle: bundle2,
      );

      // Assert
      expect(model1.userOrderId, "ORDER1");
      expect(model2.userOrderId, "ORDER2");
      expect(model1.bundle?.bundleCode, "B1");
      expect(model2.bundle?.bundleCode, "B2");
    });


    test("response type is correct", () {
      // Act
      final TransactionHistoryResponseModel model = TransactionHistoryResponseModel();

      // Assert
      expect(model, isA<TransactionHistoryResponseModel>());
    });
  });
}
