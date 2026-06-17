import "package:esim_open_source/domain/data/response/bundles/bundle_category_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/transaction_history_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for PurchaseEsimBundleResponseModel
void main() {
  group("PurchaseEsimBundleResponseModel Tests", () {
    test("constructor assigns values correctly", () {
      // Arrange
      final BundleCategoryResponseModel category = BundleCategoryResponseModel(type: "CRUISE");
      final List<CountryResponseModel> countries = <CountryResponseModel>[
        CountryResponseModel(countryCode: "US"),
      ];

      // Act
      final PurchaseEsimBundleResponseModel model = PurchaseEsimBundleResponseModel(
        isTopupAllowed: true,
        planStarted: true,
        bundleExpired: false,
        labelName: "Test Label",
        orderNumber: "ORDER123",
        orderStatus: "active",
        bundleCode: "BUNDLE001",
        bundleCategory: category,
        bundleName: "Test Bundle",
        countries: countries,
      );

      // Assert
      expect(model.isTopupAllowed, true);
      expect(model.planStarted, true);
      expect(model.bundleExpired, false);
      expect(model.labelName, "Test Label");
      expect(model.orderNumber, "ORDER123");
      expect(model.orderStatus, "active");
      expect(model.bundleCode, "BUNDLE001");
      expect(model.bundleCategory, category);
      expect(model.bundleName, "Test Bundle");
      expect(model.countries, countries);
    });

    test("constructor with all null values", () {
      // Act
      final PurchaseEsimBundleResponseModel model = PurchaseEsimBundleResponseModel();

      // Assert
      expect(model.isTopupAllowed, isNull);
      expect(model.planStarted, isNull);
      expect(model.bundleExpired, isNull);
      expect(model.labelName, isNull);
      expect(model.orderNumber, isNull);
    });

    test("getStatusText returns active for active status", () {
      // Act
      final PurchaseEsimBundleResponseModel model = PurchaseEsimBundleResponseModel(
        orderStatus: "active",
      );

      // Assert
      expect(model.getStatusText(), isNotEmpty);
    });

    test("getStatusText returns inactive for inactive status", () {
      // Act
      final PurchaseEsimBundleResponseModel model = PurchaseEsimBundleResponseModel(
        orderStatus: "inactive",
      );

      // Assert
      expect(model.getStatusText(), isNotEmpty);
    });

    test("getStatusText returns expired for expired status", () {
      // Act
      final PurchaseEsimBundleResponseModel model = PurchaseEsimBundleResponseModel(
        orderStatus: "expired",
      );

      // Assert
      expect(model.getStatusText(), isNotEmpty);
    });

    test("getStatusText returns empty for unknown status", () {
      // Act
      final PurchaseEsimBundleResponseModel model = PurchaseEsimBundleResponseModel(
        orderStatus: "unknown",
      );

      // Assert
      expect(model.getStatusText(), "");
    });

    test("copyWith updates single field", () {
      // Arrange
      final PurchaseEsimBundleResponseModel original = PurchaseEsimBundleResponseModel(
        orderStatus: "active",
        bundleName: "Original",
      );

      // Act
      final PurchaseEsimBundleResponseModel updated = original.copyWith(
        PurchaseEsimBundleResponseModelParams(
          orderInfo: PurchaseOrderInfoParams(orderStatus: "inactive"),
        ),
      );

      // Assert
      expect(updated.orderStatus, "inactive");
      expect(updated.bundleName, "Original");
    });

    test("copyWith updates multiple fields", () {
      // Arrange
      final PurchaseEsimBundleResponseModel original = PurchaseEsimBundleResponseModel(
        orderStatus: "active",
        bundleName: "Original",
        isTopupAllowed: true,
      );

      // Act
      final PurchaseEsimBundleResponseModel updated = original.copyWith(
        PurchaseEsimBundleResponseModelParams(
          orderInfo: PurchaseOrderInfoParams(orderStatus: "expired"),
          bundleInfo: BundleInfoParams(bundleName: "Updated"),
        ),
      );

      // Assert
      expect(updated.orderStatus, "expired");
      expect(updated.bundleName, "Updated");
      expect(updated.isTopupAllowed, true);
    });

    test("copyWith creates new instance", () {
      // Arrange
      final PurchaseEsimBundleResponseModel original = PurchaseEsimBundleResponseModel(
        orderStatus: "active",
      );

      // Act
      final PurchaseEsimBundleResponseModel updated = original.copyWith(
        PurchaseEsimBundleResponseModelParams(
          orderInfo: PurchaseOrderInfoParams(orderStatus: "inactive"),
        ),
      );

      // Assert
      expect(identical(original, updated), false);
      expect(original.orderStatus, "active");
      expect(updated.orderStatus, "inactive");
    });

    test("mockItems returns non-empty list", () {
      // Act
      final List<PurchaseEsimBundleResponseModel> items = PurchaseEsimBundleResponseModel.mockItems();

      // Assert
      expect(items, isNotEmpty);
      expect(items.length, greaterThan(0));
    });

    test("mockItems all items have required fields", () {
      // Act
      final List<PurchaseEsimBundleResponseModel> items = PurchaseEsimBundleResponseModel.mockItems();

      // Assert
      for (final PurchaseEsimBundleResponseModel item in items) {
        expect(item.bundleName, isNotNull);
        expect(item.iccid, isNotNull);
        expect(item.countries, isNotNull);
      }
    });

    test("getDisplayName returns bundleName when no transactionHistory", () {
      // Act
      final PurchaseEsimBundleResponseModel model = PurchaseEsimBundleResponseModel(
        bundleName: "Test Bundle",
        transactionHistory: null,
      );

      // Assert
      expect(model.getDisplayName(), "Test Bundle");
    });

    test("getDisplayName returns bundleName when transactionHistory is empty", () {
      // Act
      final PurchaseEsimBundleResponseModel model = PurchaseEsimBundleResponseModel(
        bundleName: "Test Bundle",
        transactionHistory: <TransactionHistoryResponseModel>[],
      );

      // Assert
      expect(model.getDisplayName(), "Test Bundle");
    });

    test("countries list can be empty", () {
      // Act
      final PurchaseEsimBundleResponseModel model = PurchaseEsimBundleResponseModel(
        countries: <CountryResponseModel>[],
      );

      // Assert
      expect(model.countries, isNotNull);
      expect(model.countries, isEmpty);
    });

    test("bundleMessage list can be empty", () {
      // Act
      final PurchaseEsimBundleResponseModel model = PurchaseEsimBundleResponseModel(
        bundleMessage: <String>[],
      );

      // Assert
      expect(model.bundleMessage, isNotNull);
      expect(model.bundleMessage, isEmpty);
    });

    test("bundleMessage with multiple items", () {
      // Arrange
      final List<String> messages = <String>["Message1", "Message2", "Message3"];

      // Act
      final PurchaseEsimBundleResponseModel model = PurchaseEsimBundleResponseModel(
        bundleMessage: messages,
      );

      // Assert
      expect(model.bundleMessage?.length, 3);
    });

    test("price as integer value", () {
      // Act
      final PurchaseEsimBundleResponseModel model = PurchaseEsimBundleResponseModel(
        price: 100,
      );

      // Assert
      expect(model.price, 100);
    });

    test("price as decimal value", () {
      // Act
      final PurchaseEsimBundleResponseModel model = PurchaseEsimBundleResponseModel(
        price: 99.99,
      );

      // Assert
      expect(model.price, 99.99);
    });

    test("validity as integer", () {
      // Act
      final PurchaseEsimBundleResponseModel model = PurchaseEsimBundleResponseModel(
        validity: 30,
      );

      // Assert
      expect(model.validity, 30);
    });

    test("unlimited flag true", () {
      // Act
      final PurchaseEsimBundleResponseModel model = PurchaseEsimBundleResponseModel(
        unlimited: true,
      );

      // Assert
      expect(model.unlimited, true);
    });

    test("unlimited flag false", () {
      // Act
      final PurchaseEsimBundleResponseModel model = PurchaseEsimBundleResponseModel(
        unlimited: false,
      );

      // Assert
      expect(model.unlimited, false);
    });

    test("multiple instances are independent", () {
      // Act
      final PurchaseEsimBundleResponseModel model1 = PurchaseEsimBundleResponseModel(
        bundleName: "Bundle1",
        orderStatus: "active",
      );
      final PurchaseEsimBundleResponseModel model2 = PurchaseEsimBundleResponseModel(
        bundleName: "Bundle2",
        orderStatus: "inactive",
      );

      // Assert
      expect(model1.bundleName, "Bundle1");
      expect(model2.bundleName, "Bundle2");
      expect(model1.orderStatus, "active");
      expect(model2.orderStatus, "inactive");
    });

    test("response type is correct", () {
      // Act
      final PurchaseEsimBundleResponseModel model = PurchaseEsimBundleResponseModel();

      // Assert
      expect(model, isA<PurchaseEsimBundleResponseModel>());
    });
  });
}
