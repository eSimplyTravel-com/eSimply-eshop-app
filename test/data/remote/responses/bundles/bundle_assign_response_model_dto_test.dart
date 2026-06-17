import "package:esim_open_source/data/remote/responses/bundles/bundle_assign_response_model_dto.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for BundleAssignResponseModel
/// Tests JSON serialization/deserialization and model methods
void main() {
  group("BundleAssignResponseModel Tests", () {
    test("fromJson creates instance with all fields populated", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{
        "publishable_key": "pk_test_123",
        "merchant_identifier": "merchant_001",
        "billing_country_code": "US",
        "payment_intent_client_secret": "secret_123",
        "customer_id": "cust_123",
        "customer_ephemeral_key_secret": "eph_secret_123",
        "test_env": true,
        "has_tax": true,
        "merchant_display_name": "Test Merchant",
        "stripe_url_scheme": "test-scheme",
        "order_id": "order_123",
        "payment_status": "succeeded",
        "tax_price_display": r"$5.00",
        "total_price_display": r"$105.00",
        "subtotal_price_display": r"$100.00",
      };

      // Act
      final BundleAssignResponseModelDto model =
          BundleAssignResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.publishableKey, "pk_test_123");
      expect(model.merchantIdentifier, "merchant_001");
      expect(model.billingCountryCode, "US");
      expect(model.paymentIntentClientSecret, "secret_123");
      expect(model.customerId, "cust_123");
      expect(model.customerEphemeralKeySecret, "eph_secret_123");
      expect(model.testEnv, true);
      expect(model.hasTax, true);
      expect(model.merchantDisplayName, "Test Merchant");
      expect(model.stripeUrlScheme, "test-scheme");
      expect(model.orderId, "order_123");
      expect(model.paymentStatus, "succeeded");
      expect(model.taxPriceDisplay, r"$5.00");
      expect(model.totalPriceDisplay, r"$105.00");
      expect(model.subtotalPriceDisplay, r"$100.00");
    });

    test("fromJson handles missing fields", () {
      // Arrange
      final Map<String, dynamic> json = <String, dynamic>{};

      // Act
      final BundleAssignResponseModelDto model =
          BundleAssignResponseModelDto.fromJson(json: json);

      // Assert
      expect(model.publishableKey, isNull);
      expect(model.merchantIdentifier, isNull);
      expect(model.hasTax, isNull);
      expect(model.testEnv, isNull);
    });

    test("isTaxExist returns true when hasTax is true", () {
      // Arrange
      final BundleAssignResponseModelDto model = BundleAssignResponseModelDto(
        hasTax: true,
      );

      // Act & Assert
      expect(model.isTaxExist(), true);
    });

    test("isTaxExist returns false when hasTax is false", () {
      // Arrange
      final BundleAssignResponseModelDto model = BundleAssignResponseModelDto(
        hasTax: false,
      );

      // Act & Assert
      expect(model.isTaxExist(), false);
    });

    test("isTaxExist returns false when hasTax is null", () {
      // Arrange
      final BundleAssignResponseModelDto model = BundleAssignResponseModelDto();

      // Act & Assert
      expect(model.isTaxExist(), false);
    });

    test("toJson returns correct map with all fields", () {
      // Arrange
      final BundleAssignResponseModelDto model = BundleAssignResponseModelDto(
        publishableKey: "pk_live_456",
        merchantIdentifier: "merchant_002",
        billingCountryCode: "GB",
        paymentIntentClientSecret: "secret_456",
        customerId: "cust_456",
        customerEphemeralKeySecret: "eph_secret_456",
        testEnv: false,
        hasTax: false,
        merchantDisplayName: "Live Merchant",
        stripeUrlScheme: "live-scheme",
        orderId: "order_456",
        paymentStatus: "pending",
        taxPriceDisplay: r"$0.00",
        totalPriceDisplay: r"$50.00",
        subtotalPriceDisplay: r"$50.00",
      );

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["publishable_key"], "pk_live_456");
      expect(json["merchant_identifier"], "merchant_002");
      expect(json["billing_country_code"], "GB");
      expect(json["payment_intent_client_secret"], "secret_456");
      expect(json["customer_id"], "cust_456");
      expect(json["customer_ephemeral_key_secret"], "eph_secret_456");
      expect(json["test_env"], false);
      expect(json["has_tax"], false);
      expect(json["merchant_display_name"], "Live Merchant");
      expect(json["stripe_url_scheme"], "live-scheme");
      expect(json["order_id"], "order_456");
      expect(json["payment_status"], "pending");
      expect(json["tax_price_display"], r"$0.00");
      expect(json["total_price_display"], r"$50.00");
      expect(json["subtotal_price_display"], r"$50.00");
    });

    test("toJson handles null fields", () {
      // Arrange
      final BundleAssignResponseModelDto model = BundleAssignResponseModelDto();

      // Act
      final Map<String, dynamic> json = model.toJson();

      // Assert
      expect(json["publishable_key"], isNull);
      expect(json["has_tax"], isNull);
      expect(json["test_env"], isNull);
    });

    test("roundtrip fromJson and toJson preserves data", () {
      // Arrange
      final Map<String, dynamic> originalJson = <String, dynamic>{
        "publishable_key": "pk_test_789",
        "merchant_identifier": "merchant_789",
        "has_tax": true,
        "test_env": true,
        "order_id": "order_789",
        "payment_status": "succeeded",
      };

      // Act
      final BundleAssignResponseModelDto model =
          BundleAssignResponseModelDto.fromJson(json: originalJson);
      final Map<String, dynamic> resultJson = model.toJson();

      // Assert
      expect(resultJson["publishable_key"], originalJson["publishable_key"]);
      expect(
        resultJson["merchant_identifier"],
        originalJson["merchant_identifier"],
      );
      expect(resultJson["has_tax"], originalJson["has_tax"]);
      expect(resultJson["test_env"], originalJson["test_env"]);
      expect(resultJson["order_id"], originalJson["order_id"]);
      expect(resultJson["payment_status"], originalJson["payment_status"]);
    });

    test("constructor assigns values correctly", () {
      // Act
      final BundleAssignResponseModelDto model = BundleAssignResponseModelDto(
        publishableKey: "test_key",
        hasTax: true,
        orderId: "123",
      );

      // Assert
      expect(model.publishableKey, "test_key");
      expect(model.hasTax, true);
      expect(model.orderId, "123");
    });

    test("toDomain converts to BundleAssignResponseModel", () {
      // Arrange
      final BundleAssignResponseModelDto dto = BundleAssignResponseModelDto(
        publishableKey: "pk_test_123",
        merchantIdentifier: "merchant_001",
        billingCountryCode: "US",
        paymentIntentClientSecret: "secret_123",
        customerId: "cust_123",
        customerEphemeralKeySecret: "eph_secret_123",
        testEnv: true,
        hasTax: true,
        merchantDisplayName: "Test Merchant",
        stripeUrlScheme: "test-scheme",
        orderId: "order_123",
        paymentStatus: "succeeded",
        taxPriceDisplay: r"$5.00",
        totalPriceDisplay: r"$105.00",
        subtotalPriceDisplay: r"$100.00",
      );

      // Act
      final domain = dto.toDomain();

      // Assert
      expect(domain.publishableKey, "pk_test_123");
      expect(domain.merchantIdentifier, "merchant_001");
      expect(domain.billingCountryCode, "US");
      expect(domain.hasTax, true);
      expect(domain.testEnv, true);
    });

    test("toDomain handles all null fields", () {
      // Arrange
      final BundleAssignResponseModelDto dto = BundleAssignResponseModelDto();

      // Act
      final domain = dto.toDomain();

      // Assert
      expect(domain.publishableKey, isNull);
      expect(domain.merchantIdentifier, isNull);
      expect(domain.hasTax, isNull);
      expect(domain.testEnv, isNull);
    });
  });
}
