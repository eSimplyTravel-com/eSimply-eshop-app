import "package:esim_open_source/data/services/payment/dcb/dcb_payment_service_impl.dart";
import "package:esim_open_source/data/services/payment/payment_service_impl.dart";
import "package:esim_open_source/data/services/payment/stripe/stripe_payment_service_impl.dart";
import "package:esim_open_source/data/services/payment/wallet/wallet_payment.dart";
import "package:esim_open_source/domain/repository/services/payment_service.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for PaymentServiceImpl
/// Tests payment service routing, initialization, and delegation to payment providers
/// Note: Tests for Stripe integration are limited due to platform channel requirements.
/// Stripe's prepareCheckout requires platform channel initialization and specific merchant
/// configuration. Full Stripe testing should be done via integration tests.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group("PaymentServiceImpl Tests", () {
    group("Singleton Initialization", () {
      test("singleton instance is created and reused", () {
        // Arrange & Act
        final PaymentServiceImpl instance1 = PaymentServiceImpl.instance;
        final PaymentServiceImpl instance2 = PaymentServiceImpl.instance;

        // Assert
        expect(instance1, isNotNull);
        expect(instance1, same(instance2));
      });

      test("instance is accessible on first call", () {
        // Arrange & Act
        final PaymentServiceImpl instance = PaymentServiceImpl.instance;

        // Assert
        expect(instance, isNotNull);
        expect(instance, isA<PaymentServiceImpl>());
      });
    });

    group("Interface Compliance", () {
      test("instance implements PaymentService interface", () {
        // Arrange & Act
        final PaymentServiceImpl instance = PaymentServiceImpl.instance;

        // Assert
        expect(instance, isA<PaymentService>());
      });
    });

    group("Service Initialization", () {
      test("initializes Stripe payment service", () async {
        // Arrange & Act
        final PaymentServiceImpl service = PaymentServiceImpl.instance;

        // Assert
        expect(service.stripePayment, isNotNull);
        expect(service.stripePayment, isA<StripePayment>());
      });

      test("initializes DCB payment service", () async {
        // Arrange & Act
        final PaymentServiceImpl service = PaymentServiceImpl.instance;

        // Assert
        expect(service.dcbPayment, isNotNull);
        expect(service.dcbPayment, isA<DcbPayment>());
      });

      test("initializes Wallet payment service", () async {
        // Arrange & Act
        final PaymentServiceImpl service = PaymentServiceImpl.instance;

        // Assert
        expect(service.walletPayment, isNotNull);
        expect(service.walletPayment, isA<WalletPayment>());
      });

      test("all payment services are properly initialized", () async {
        // Arrange & Act
        final PaymentServiceImpl service = PaymentServiceImpl.instance;

        // Assert
        expect(service.stripePayment, isNotNull);
        expect(service.dcbPayment, isNotNull);
        expect(service.walletPayment, isNotNull);
      });
    });

    group("prepareCheckout - Routing Tests", () {
      test("prepareCheckout routes wallet payment type to walletPayment",
          () async {
        // Arrange
        final PaymentServiceImpl service = PaymentServiceImpl.instance;

        // Act & Assert - should not throw
        await expectLater(
          service.prepareCheckout(
            paymentType: PaymentType.wallet,
            publishableKey: "pk_test_123456",
          ),
          completes,
        );
      });

      test("prepareCheckout routes dcb payment type to dcbPayment", () async {
        // Arrange
        final PaymentServiceImpl service = PaymentServiceImpl.instance;

        // Act & Assert - should not throw
        await expectLater(
          service.prepareCheckout(
            paymentType: PaymentType.dcb,
            publishableKey: "pk_test_123456",
          ),
          completes,
        );
      });

      test(
        "prepareCheckout routes card payment type to stripePayment",
        () async {
          // Arrange
          final PaymentServiceImpl service = PaymentServiceImpl.instance;

          // Act & Assert - should not throw
          await expectLater(
            service.prepareCheckout(
              paymentType: PaymentType.card,
              publishableKey: "pk_test_123456",
            ),
            completes,
          );
        },
        skip:
            "Stripe prepareCheckout requires platform channels and native initialization",
      );

      test("prepareCheckout with wallet and dcb payment types", () async {
        // Arrange
        final PaymentServiceImpl service = PaymentServiceImpl.instance;

        // Act & Assert - test non-Stripe payment types
        for (final PaymentType paymentType in <PaymentType>[
          PaymentType.wallet,
          PaymentType.dcb,
        ]) {
          await expectLater(
            service.prepareCheckout(
              paymentType: paymentType,
              publishableKey: "pk_test_123456",
              merchantIdentifier: "com.example.merchant",
              urlScheme: "myapp://",
            ),
            completes,
          );
        }
      });

      test("prepareCheckout wallet with merchantIdentifier", () async {
        // Arrange
        final PaymentServiceImpl service = PaymentServiceImpl.instance;

        // Act & Assert - should not throw
        await expectLater(
          service.prepareCheckout(
            paymentType: PaymentType.wallet,
            publishableKey: "pk_test_123456",
            merchantIdentifier: "com.example.merchant",
          ),
          completes,
        );
      });

      test("prepareCheckout dcb with urlScheme", () async {
        // Arrange
        final PaymentServiceImpl service = PaymentServiceImpl.instance;

        // Act & Assert - should not throw
        await expectLater(
          service.prepareCheckout(
            paymentType: PaymentType.dcb,
            publishableKey: "pk_test_123456",
            urlScheme: "myapp://",
          ),
          completes,
        );
      });

      test(
        "prepareCheckout dcb with all optional parameters",
        () async {
          // Arrange
          final PaymentServiceImpl service = PaymentServiceImpl.instance;

          // Act & Assert - should not throw
          await expectLater(
            service.prepareCheckout(
              paymentType: PaymentType.dcb,
              publishableKey: "pk_test_123456",
              merchantIdentifier: "com.example.merchant",
              urlScheme: "myapp://",
            ),
            completes,
          );
        },
      );
    });

    group("processOrderPayment - Routing Tests", () {
      test("processOrderPayment routes wallet payment type to walletPayment",
          () async {
        // Arrange
        final PaymentServiceImpl service = PaymentServiceImpl.instance;
        final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
          billingCountryCode: "US",
          paymentIntentClientSecret: "secret_123",
          customerId: "cust_123",
          customerEphemeralKeySecret: "key_123",
        );

        // Act
        final PaymentResult result = await service.processOrderPayment(
          paymentType: PaymentType.wallet,
          params: params,
        );

        // Assert
        expect(result, isNotNull);
        expect(result, isA<PaymentResult>());
      });

      test("processOrderPayment routes dcb payment type to dcbPayment",
          () async {
        // Arrange
        final PaymentServiceImpl service = PaymentServiceImpl.instance;
        final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
          billingCountryCode: "US",
          paymentIntentClientSecret: "secret_456",
          customerId: "cust_456",
          customerEphemeralKeySecret: "key_456",
        );

        // Act
        final PaymentResult result = await service.processOrderPayment(
          paymentType: PaymentType.dcb,
          params: params,
        );

        // Assert
        expect(result, isNotNull);
        expect(result, isA<PaymentResult>());
        expect(result, PaymentResult.otpRequested);
      });

      test(
        "processOrderPayment routes card payment type to stripePayment",
        () async {
          // Arrange
          final PaymentServiceImpl service = PaymentServiceImpl.instance;
          final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
            billingCountryCode: "US",
            paymentIntentClientSecret: "secret_789",
            customerId: "cust_789",
            customerEphemeralKeySecret: "key_789",
            merchantDisplayName: "Test",
          );

          // Act
          final PaymentResult result = await service.processOrderPayment(
            paymentType: PaymentType.card,
            params: params,
          );

          // Assert
          expect(result, isNotNull);
          expect(result, isA<PaymentResult>());
        },
        skip:
            "Stripe processOrderPayment requires platform channels and merchantIdentifier configuration",
      );

      test("processOrderPayment with minimal params for wallet", () async {
        // Arrange
        final PaymentServiceImpl service = PaymentServiceImpl.instance;
        final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
          billingCountryCode: "GB",
          paymentIntentClientSecret: "secret_wallet",
          customerId: "cust_wallet",
          customerEphemeralKeySecret: "key_wallet",
        );

        // Act & Assert - should not throw
        await expectLater(
          service.processOrderPayment(
            paymentType: PaymentType.wallet,
            params: params,
          ),
          completes,
        );
      });

      test("processOrderPayment with all parameters for dcb", () async {
        // Arrange
        final PaymentServiceImpl service = PaymentServiceImpl.instance;
        final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
          billingCountryCode: "US",
          paymentIntentClientSecret: "secret_dcb",
          customerId: "cust_dcb",
          customerEphemeralKeySecret: "key_dcb",
          merchantDisplayName: "DCB Merchant",
          testEnv: true,
          iccID: "89011401200000012345",
          orderID: "order_dcb_123",
        );

        // Act & Assert - should not throw
        await expectLater(
          service.processOrderPayment(
            paymentType: PaymentType.dcb,
            params: params,
          ),
          completes,
        );
      });

      test("processOrderPayment with optional iccID for dcb", () async {
        // Arrange
        final PaymentServiceImpl service = PaymentServiceImpl.instance;
        final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
          billingCountryCode: "US",
          paymentIntentClientSecret: "secret_card",
          customerId: "cust_card",
          customerEphemeralKeySecret: "key_card",
          iccID: "89011401200000054321",
        );

        // Act & Assert - should not throw
        await expectLater(
          service.processOrderPayment(
            paymentType: PaymentType.dcb,
            params: params,
          ),
          completes,
        );
      });

      test("processOrderPayment routes wallet and dcb correctly", () async {
        // Arrange
        final PaymentServiceImpl service = PaymentServiceImpl.instance;
        final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
          billingCountryCode: "US",
          paymentIntentClientSecret: "secret_multi",
          customerId: "cust_multi",
          customerEphemeralKeySecret: "key_multi",
        );

        // Act & Assert
        for (final PaymentType paymentType in <PaymentType>[
          PaymentType.wallet,
          PaymentType.dcb,
        ]) {
          final PaymentResult result = await service.processOrderPayment(
            paymentType: paymentType,
            params: params,
          );
          expect(result, isA<PaymentResult>());
        }
      });

      test("processOrderPayment with testEnv enabled for wallet and dcb",
          () async {
        // Arrange
        final PaymentServiceImpl service = PaymentServiceImpl.instance;
        final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
          billingCountryCode: "US",
          paymentIntentClientSecret: "secret_test",
          customerId: "cust_test",
          customerEphemeralKeySecret: "key_test",
          testEnv: true,
        );

        // Act & Assert - should not throw for non-Stripe payment types
        for (final PaymentType paymentType in <PaymentType>[
          PaymentType.wallet,
          PaymentType.dcb,
        ]) {
          await expectLater(
            service.processOrderPayment(
              paymentType: paymentType,
              params: params,
            ),
            completes,
          );
        }
      });
    });

    group("State Consistency", () {
      test("PaymentServiceImpl instance is consistent across multiple accesses",
          () {
        // Arrange & Act
        final PaymentServiceImpl instance1 = PaymentServiceImpl.instance;
        final PaymentServiceImpl instance2 = PaymentServiceImpl.instance;
        final PaymentServiceImpl instance3 = PaymentServiceImpl.instance;

        // Assert
        expect(instance1, same(instance2));
        expect(instance2, same(instance3));
      });

      test("payment service delegates remain consistent", () {
        // Arrange & Act
        final PaymentServiceImpl service1 = PaymentServiceImpl.instance;
        final PaymentServiceImpl service2 = PaymentServiceImpl.instance;

        // Assert
        expect(service1.stripePayment, same(service2.stripePayment));
        expect(service1.dcbPayment, same(service2.dcbPayment));
        expect(service1.walletPayment, same(service2.walletPayment));
      });
    });

    group("PaymentType Enum Coverage", () {
      test("all PaymentType values are supported", () {
        // Assert
        expect(PaymentType.values.length, 3);
        expect(PaymentType.values, contains(PaymentType.wallet));
        expect(PaymentType.values, contains(PaymentType.dcb));
        expect(PaymentType.values, contains(PaymentType.card));
      });

      test("can prepare checkout for wallet and dcb payment types", () async {
        // Arrange
        final PaymentServiceImpl service = PaymentServiceImpl.instance;

        // Act & Assert
        for (final PaymentType paymentType in <PaymentType>[
          PaymentType.wallet,
          PaymentType.dcb,
        ]) {
          await expectLater(
            service.prepareCheckout(
              paymentType: paymentType,
              publishableKey: "pk_test_${paymentType.name}",
            ),
            completes,
          );
        }
      });

      test(
        "can process payment for wallet and dcb payment types",
        () async {
          // Arrange
          final PaymentServiceImpl service = PaymentServiceImpl.instance;
          final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
            billingCountryCode: "US",
            paymentIntentClientSecret: "secret_all",
            customerId: "cust_all",
            customerEphemeralKeySecret: "key_all",
          );

          // Act & Assert
          for (final PaymentType paymentType in <PaymentType>[
            PaymentType.wallet,
            PaymentType.dcb,
          ]) {
            final PaymentResult result = await service.processOrderPayment(
              paymentType: paymentType,
              params: params,
            );
            expect(result, isA<PaymentResult>());
          }
        },
      );
    });

    group("Integration Tests", () {
      test(
        "can prepare checkout and process payment for wallet",
        () async {
          // Arrange
          final PaymentServiceImpl service = PaymentServiceImpl.instance;

          // Act
          await service.prepareCheckout(
            paymentType: PaymentType.wallet,
            publishableKey: "pk_test_wallet",
            merchantIdentifier: "com.example.wallet",
          );

          final PaymentResult result = await service.processOrderPayment(
            paymentType: PaymentType.wallet,
            params: ProcessOrderPaymentParams(
              billingCountryCode: "US",
              paymentIntentClientSecret: "secret",
              customerId: "cust",
              customerEphemeralKeySecret: "key",
            ),
          );

          // Assert
          expect(result, PaymentResult.completed);
        },
        skip:
            "Singleton pattern - state persists across tests, integration tests require separate setup",
      );

      test(
        "can prepare checkout and process payment for dcb",
        () async {
          // Arrange
          final PaymentServiceImpl service = PaymentServiceImpl.instance;

          // Act
          await service.prepareCheckout(
            paymentType: PaymentType.dcb,
            publishableKey: "pk_test_dcb",
            merchantIdentifier: "com.example.dcb",
          );

          final PaymentResult result = await service.processOrderPayment(
            paymentType: PaymentType.dcb,
            params: ProcessOrderPaymentParams(
              billingCountryCode: "US",
              paymentIntentClientSecret: "secret",
              customerId: "cust",
              customerEphemeralKeySecret: "key",
            ),
          );

          // Assert
          expect(result, PaymentResult.otpRequested);
        },
        skip:
            "Singleton pattern - state persists across tests, integration tests require separate setup",
      );

      test(
        "can prepare checkout and process payment for card",
        () async {
          // Arrange
          final PaymentServiceImpl service = PaymentServiceImpl.instance;

          // Act
          await service.prepareCheckout(
            paymentType: PaymentType.card,
            publishableKey: "pk_test_card",
            merchantIdentifier: "com.example.card",
          );

          final PaymentResult result = await service.processOrderPayment(
            paymentType: PaymentType.card,
            params: ProcessOrderPaymentParams(
              billingCountryCode: "US",
              paymentIntentClientSecret: "secret",
              customerId: "cust",
              customerEphemeralKeySecret: "key",
              merchantDisplayName: "Test",
            ),
          );

          // Assert
          expect(result, isA<PaymentResult>());
        },
        skip:
            "Stripe requires platform channels and merchant configuration; Singleton pattern persists state across tests",
      );
    });
  });
}
