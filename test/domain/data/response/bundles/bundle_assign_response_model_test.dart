import "package:esim_open_source/domain/data/response/bundles/bundle_assign_response_model.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for BundleAssignResponseModel
void main() {
  group("BundleAssignResponseModel Tests", () {
    test("constructor assigns values correctly", () {
      // Act
      final BundleAssignResponseModel model = BundleAssignResponseModel(
        publishableKey: "pk_test_123",
        merchantIdentifier: "merchant_id",
        billingCountryCode: "US",
        paymentIntentClientSecret: "pi_secret_123",
        customerId: "cus_123",
        customerEphemeralKeySecret: "ek_secret_123",
        testEnv: true,
        hasTax: true,
        merchantDisplayName: "Test Merchant",
        stripeUrlScheme: "stripe_scheme",
        orderId: "order_123",
        paymentStatus: "COMPLETED",
        taxPriceDisplay: "10.00",
        subtotalPriceDisplay: "90.00",
        totalPriceDisplay: "100.00",
      );

      // Assert
      expect(model.publishableKey, "pk_test_123");
      expect(model.merchantIdentifier, "merchant_id");
      expect(model.billingCountryCode, "US");
      expect(model.paymentIntentClientSecret, "pi_secret_123");
      expect(model.customerId, "cus_123");
      expect(model.customerEphemeralKeySecret, "ek_secret_123");
      expect(model.testEnv, true);
      expect(model.hasTax, true);
      expect(model.merchantDisplayName, "Test Merchant");
      expect(model.stripeUrlScheme, "stripe_scheme");
      expect(model.orderId, "order_123");
      expect(model.paymentStatus, "COMPLETED");
      expect(model.taxPriceDisplay, "10.00");
      expect(model.subtotalPriceDisplay, "90.00");
      expect(model.totalPriceDisplay, "100.00");
    });

    test("constructor with all null values", () {
      // Act
      final BundleAssignResponseModel model = BundleAssignResponseModel();

      // Assert
      expect(model.publishableKey, isNull);
      expect(model.merchantIdentifier, isNull);
      expect(model.billingCountryCode, isNull);
      expect(model.paymentIntentClientSecret, isNull);
      expect(model.customerId, isNull);
      expect(model.customerEphemeralKeySecret, isNull);
      expect(model.testEnv, isNull);
      expect(model.hasTax, isNull);
      expect(model.merchantDisplayName, isNull);
      expect(model.stripeUrlScheme, isNull);
      expect(model.orderId, isNull);
      expect(model.paymentStatus, isNull);
      expect(model.taxPriceDisplay, isNull);
      expect(model.subtotalPriceDisplay, isNull);
      expect(model.totalPriceDisplay, isNull);
    });

    test("isTaxExist returns true when hasTax is true", () {
      // Act
      final BundleAssignResponseModel model = BundleAssignResponseModel(
        hasTax: true,
      );

      // Assert
      expect(model.isTaxExist(), true);
    });

    test("isTaxExist returns false when hasTax is false", () {
      // Act
      final BundleAssignResponseModel model = BundleAssignResponseModel(
        hasTax: false,
      );

      // Assert
      expect(model.isTaxExist(), false);
    });

    test("isTaxExist returns false when hasTax is null", () {
      // Act
      final BundleAssignResponseModel model = BundleAssignResponseModel(
        hasTax: null,
      );

      // Assert
      expect(model.isTaxExist(), false);
    });

    test("testEnv true indicates test environment", () {
      // Act
      final BundleAssignResponseModel model = BundleAssignResponseModel(
        testEnv: true,
      );

      // Assert
      expect(model.testEnv, true);
    });

    test("testEnv false indicates production environment", () {
      // Act
      final BundleAssignResponseModel model = BundleAssignResponseModel(
        testEnv: false,
      );

      // Assert
      expect(model.testEnv, false);
    });

    test("paymentStatus COMPLETED", () {
      // Act
      final BundleAssignResponseModel model = BundleAssignResponseModel(
        paymentStatus: "COMPLETED",
      );

      // Assert
      expect(model.paymentStatus, "COMPLETED");
    });

    test("paymentStatus PENDING", () {
      // Act
      final BundleAssignResponseModel model = BundleAssignResponseModel(
        paymentStatus: "PENDING",
      );

      // Assert
      expect(model.paymentStatus, "PENDING");
    });

    test("paymentStatus FAILED", () {
      // Act
      final BundleAssignResponseModel model = BundleAssignResponseModel(
        paymentStatus: "FAILED",
      );

      // Assert
      expect(model.paymentStatus, "FAILED");
    });

    test("empty publishableKey string", () {
      // Act
      final BundleAssignResponseModel model = BundleAssignResponseModel(
        publishableKey: "",
      );

      // Assert
      expect(model.publishableKey, "");
    });

    test("empty merchantDisplayName string", () {
      // Act
      final BundleAssignResponseModel model = BundleAssignResponseModel(
        merchantDisplayName: "",
      );

      // Assert
      expect(model.merchantDisplayName, "");
    });

    test("currency codes in priceDisplay", () {
      // Act
      final BundleAssignResponseModel model = BundleAssignResponseModel(
        taxPriceDisplay: "USD 10.00",
        totalPriceDisplay: "USD 100.00",
      );

      // Assert
      expect(model.taxPriceDisplay, "USD 10.00");
      expect(model.totalPriceDisplay, "USD 100.00");
    });

    test("country code format", () {
      // Act
      final BundleAssignResponseModel model = BundleAssignResponseModel(
        billingCountryCode: "GB",
      );

      // Assert
      expect(model.billingCountryCode, "GB");
      expect(model.billingCountryCode?.length, 2);
    });

    test("multiple instances are independent", () {
      // Act
      final BundleAssignResponseModel model1 = BundleAssignResponseModel(
        orderId: "ORDER1",
        paymentStatus: "COMPLETED",
      );
      final BundleAssignResponseModel model2 = BundleAssignResponseModel(
        orderId: "ORDER2",
        paymentStatus: "PENDING",
      );

      // Assert
      expect(model1.orderId, "ORDER1");
      expect(model2.orderId, "ORDER2");
      expect(model1.paymentStatus, "COMPLETED");
      expect(model2.paymentStatus, "PENDING");
    });

    test("response type is correct", () {
      // Act
      final BundleAssignResponseModel model = BundleAssignResponseModel();

      // Assert
      expect(model, isA<BundleAssignResponseModel>());
    });

    test("stripe keys are non-empty strings", () {
      // Act
      final BundleAssignResponseModel model = BundleAssignResponseModel(
        publishableKey: "pk_test_1234567890",
        paymentIntentClientSecret: "pi_test_secret_1234567890",
      );

      // Assert
      expect(model.publishableKey, isNotEmpty);
      expect(model.paymentIntentClientSecret, isNotEmpty);
    });
  });
}
