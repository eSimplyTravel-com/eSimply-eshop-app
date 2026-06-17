import "package:esim_open_source/data/services/payment/dcb/dcb_payment_service_impl.dart";
import "package:esim_open_source/domain/repository/services/payment_service.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for DcbPayment service
/// Tests DCB payment initialization, checkout preparation, and payment processing
void main() {
  group("DcbPayment Tests", () {
    group("Singleton Initialization", () {
      test("singleton instance is created and reused", () {
        // Arrange & Act
        final DcbPayment instance1 = DcbPayment.instance;
        final DcbPayment instance2 = DcbPayment.instance;

        // Assert
        expect(instance1, isNotNull);
        expect(instance1, same(instance2));
      });

      test("instance is accessible on first call", () {
        // Arrange & Act
        final DcbPayment instance = DcbPayment.instance;

        // Assert
        expect(instance, isNotNull);
        expect(instance, isA<DcbPayment>());
      });
    });

    group("Async Method - prepareCheckout", () {
      test("prepareCheckout can be called without throwing", () async {
        // Arrange
        final DcbPayment service = DcbPayment.instance;

        // Act & Assert - should not throw
        await expectLater(
          service.prepareCheckout(
            publishableKey: "pk_test_123456",
          ),
          completes,
        );
      });

      test("prepareCheckout with merchantIdentifier parameter", () async {
        // Arrange
        final DcbPayment service = DcbPayment.instance;

        // Act & Assert - should not throw
        await expectLater(
          service.prepareCheckout(
            publishableKey: "pk_test_123456",
            merchantIdentifier: "com.example.merchant",
          ),
          completes,
        );
      });

      test("prepareCheckout with urlScheme parameter", () async {
        // Arrange
        final DcbPayment service = DcbPayment.instance;

        // Act & Assert - should not throw
        await expectLater(
          service.prepareCheckout(
            publishableKey: "pk_test_123456",
            urlScheme: "myapp://",
          ),
          completes,
        );
      });

      test("prepareCheckout with all parameters", () async {
        // Arrange
        final DcbPayment service = DcbPayment.instance;

        // Act & Assert - should not throw
        await expectLater(
          service.prepareCheckout(
            publishableKey: "pk_test_123456",
            merchantIdentifier: "com.example.merchant",
            urlScheme: "myapp://",
          ),
          completes,
        );
      });
    });

    group("Async Method - processOrderPayment", () {
      test("processOrderPayment returns PaymentResult", () async {
        // Arrange
        final DcbPayment service = DcbPayment.instance;
        final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
          billingCountryCode: "US",
          paymentIntentClientSecret: "secret_123",
          customerId: "cust_123",
          customerEphemeralKeySecret: "key_123",
        );

        // Act
        final PaymentResult result = await service.processOrderPayment(
          params: params,
        );

        // Assert
        expect(result, isNotNull);
        expect(result, isA<PaymentResult>());
      });

      test("processOrderPayment returns otpRequested result", () async {
        // Arrange
        final DcbPayment service = DcbPayment.instance;
        final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
          billingCountryCode: "GB",
          paymentIntentClientSecret: "secret_456",
          customerId: "cust_456",
          customerEphemeralKeySecret: "key_456",
        );

        // Act
        final PaymentResult result = await service.processOrderPayment(
          params: params,
        );

        // Assert
        expect(result, PaymentResult.otpRequested);
      });

      test("processOrderPayment with minimal params", () async {
        // Arrange
        final DcbPayment service = DcbPayment.instance;
        final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
          billingCountryCode: "US",
          paymentIntentClientSecret: "secret_789",
          customerId: "cust_789",
          customerEphemeralKeySecret: "key_789",
        );

        // Act & Assert - should not throw
        await expectLater(
          service.processOrderPayment(params: params),
          completes,
        );
      });

      test("processOrderPayment with optional iccID parameter", () async {
        // Arrange
        final DcbPayment service = DcbPayment.instance;
        final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
          billingCountryCode: "US",
          paymentIntentClientSecret: "secret_abc",
          customerId: "cust_abc",
          customerEphemeralKeySecret: "key_abc",
          iccID: "89011401200000012345",
        );

        // Act & Assert - should not throw
        await expectLater(
          service.processOrderPayment(params: params),
          completes,
        );
      });

      test("processOrderPayment with optional orderID parameter", () async {
        // Arrange
        final DcbPayment service = DcbPayment.instance;
        final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
          billingCountryCode: "US",
          paymentIntentClientSecret: "secret_def",
          customerId: "cust_def",
          customerEphemeralKeySecret: "key_def",
          orderID: "order_12345",
        );

        // Act & Assert - should not throw
        await expectLater(
          service.processOrderPayment(params: params),
          completes,
        );
      });

      test("processOrderPayment with custom merchant display name", () async {
        // Arrange
        final DcbPayment service = DcbPayment.instance;
        final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
          billingCountryCode: "US",
          paymentIntentClientSecret: "secret_ghi",
          customerId: "cust_ghi",
          customerEphemeralKeySecret: "key_ghi",
          merchantDisplayName: "Custom Merchant",
        );

        // Act & Assert - should not throw
        await expectLater(
          service.processOrderPayment(params: params),
          completes,
        );
      });

      test("processOrderPayment with testEnv flag enabled", () async {
        // Arrange
        final DcbPayment service = DcbPayment.instance;
        final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
          billingCountryCode: "US",
          paymentIntentClientSecret: "secret_jkl",
          customerId: "cust_jkl",
          customerEphemeralKeySecret: "key_jkl",
          testEnv: true,
        );

        // Act & Assert - should not throw
        await expectLater(
          service.processOrderPayment(params: params),
          completes,
        );
      });

      test("processOrderPayment with all parameters", () async {
        // Arrange
        final DcbPayment service = DcbPayment.instance;
        final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
          billingCountryCode: "US",
          paymentIntentClientSecret: "secret_mno",
          customerId: "cust_mno",
          customerEphemeralKeySecret: "key_mno",
          merchantDisplayName: "Full Test Merchant",
          testEnv: true,
          iccID: "89011401200000054321",
          orderID: "order_54321",
        );

        // Act & Assert - should not throw
        await expectLater(
          service.processOrderPayment(params: params),
          completes,
        );
      });
    });

    group("ProcessOrderPaymentParams Tests", () {
      test("ProcessOrderPaymentParams can be instantiated with required fields",
          () {
        // Arrange & Act
        final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
          billingCountryCode: "US",
          paymentIntentClientSecret: "secret",
          customerId: "customer",
          customerEphemeralKeySecret: "key",
        );

        // Assert
        expect(params.billingCountryCode, "US");
        expect(params.paymentIntentClientSecret, "secret");
        expect(params.customerId, "customer");
        expect(params.customerEphemeralKeySecret, "key");
        expect(params.merchantDisplayName, "Esim");
        expect(params.testEnv, isFalse);
        expect(params.iccID, isNull);
        expect(params.orderID, isNull);
      });

      test("ProcessOrderPaymentParams uses default merchantDisplayName", () {
        // Arrange & Act
        final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
          billingCountryCode: "GB",
          paymentIntentClientSecret: "secret_123",
          customerId: "cust_123",
          customerEphemeralKeySecret: "key_123",
        );

        // Assert
        expect(params.merchantDisplayName, "Esim");
      });

      test("ProcessOrderPaymentParams uses default testEnv as false", () {
        // Arrange & Act
        final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
          billingCountryCode: "US",
          paymentIntentClientSecret: "secret",
          customerId: "cust",
          customerEphemeralKeySecret: "key",
        );

        // Assert
        expect(params.testEnv, isFalse);
      });

      test("ProcessOrderPaymentParams stores all optional fields", () {
        // Arrange & Act
        final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
          billingCountryCode: "US",
          paymentIntentClientSecret: "secret",
          customerId: "cust",
          customerEphemeralKeySecret: "key",
          merchantDisplayName: "Custom",
          testEnv: true,
          iccID: "89011401200000012345",
          orderID: "order_123",
        );

        // Assert
        expect(params.merchantDisplayName, "Custom");
        expect(params.testEnv, isTrue);
        expect(params.iccID, "89011401200000012345");
        expect(params.orderID, "order_123");
      });
    });

    group("PaymentResult Enum Tests", () {
      test("PaymentResult.completed is defined", () {
        // Assert
        expect(PaymentResult.completed, isNotNull);
        expect(PaymentResult.completed, isA<PaymentResult>());
      });

      test("PaymentResult.canceled is defined", () {
        // Assert
        expect(PaymentResult.canceled, isNotNull);
        expect(PaymentResult.canceled, isA<PaymentResult>());
      });

      test("PaymentResult.otpRequested is defined", () {
        // Assert
        expect(PaymentResult.otpRequested, isNotNull);
        expect(PaymentResult.otpRequested, isA<PaymentResult>());
      });

      test("all PaymentResult values are defined", () {
        // Assert
        expect(PaymentResult.values.length, 3);
        expect(PaymentResult.values, contains(PaymentResult.completed));
        expect(PaymentResult.values, contains(PaymentResult.canceled));
        expect(PaymentResult.values, contains(PaymentResult.otpRequested));
      });

      test("PaymentResult enum values have correct names", () {
        // Assert
        expect(PaymentResult.completed.name, "completed");
        expect(PaymentResult.canceled.name, "canceled");
        expect(PaymentResult.otpRequested.name, "otpRequested");
      });

      test("PaymentResult can be used in switch statements", () {
        // Arrange
        String getPaymentStatus(PaymentResult status) {
          return switch (status) {
            PaymentResult.completed => "Payment Complete",
            PaymentResult.canceled => "Payment Canceled",
            PaymentResult.otpRequested => "OTP Required",
          };
        }

        // Act & Assert
        expect(getPaymentStatus(PaymentResult.completed), "Payment Complete");
        expect(getPaymentStatus(PaymentResult.canceled), "Payment Canceled");
        expect(getPaymentStatus(PaymentResult.otpRequested), "OTP Required");
      });
    });

    group("State Consistency", () {
      test("DcbPayment instance is consistent across multiple accesses", () {
        // Arrange & Act
        final DcbPayment instance1 = DcbPayment.instance;
        final DcbPayment instance2 = DcbPayment.instance;
        final DcbPayment instance3 = DcbPayment.instance;

        // Assert
        expect(instance1, same(instance2));
        expect(instance2, same(instance3));
      });
    });

    group(
      "Integration Tests",
      () {
        test("can prepare checkout and then process payment", () async {
          // Arrange
          final DcbPayment service = DcbPayment.instance;

          // Act
          await service.prepareCheckout(
            publishableKey: "pk_test_123456",
            merchantIdentifier: "com.example.merchant",
          );

          final PaymentResult result = await service.processOrderPayment(
            params: ProcessOrderPaymentParams(
              billingCountryCode: "US",
              paymentIntentClientSecret: "secret",
              customerId: "cust",
              customerEphemeralKeySecret: "key",
            ),
          );

          // Assert
          expect(result, PaymentResult.otpRequested);
        });

        test("can call processOrderPayment without prepareCheckout", () async {
          // Arrange
          final DcbPayment service = DcbPayment.instance;

          // Act
          final PaymentResult result = await service.processOrderPayment(
            params: ProcessOrderPaymentParams(
              billingCountryCode: "US",
              paymentIntentClientSecret: "secret",
              customerId: "cust",
              customerEphemeralKeySecret: "key",
            ),
          );

          // Assert
          expect(result, PaymentResult.otpRequested);
        });
      },
      skip:
          "Singleton pattern - state persists across tests, integration tests require separate setup",
    );
  });
}
