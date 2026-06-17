import "package:esim_open_source/data/services/payment/stripe/stripe_payment_service_impl.dart";
import "package:esim_open_source/domain/repository/services/payment_service.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:flutter/services.dart";
import "package:flutter_stripe/flutter_stripe.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for StripePayment (stripe_payment_service_impl.dart).
///
/// flutter_stripe talks to native code over the "flutter.stripe/payments"
/// method channel. The channel is mocked here so prepareCheckout and
/// processOrderPayment (init + present payment sheet) can be exercised, along
/// with their Stripe-exception and generic-error branches.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // flutter_stripe uses a JSONMethodCodec on this channel; the mock must match.
  const MethodChannel channel =
      MethodChannel("flutter.stripe/payments", JSONMethodCodec());

  // Per-method overrides for the mocked native side.
  Object? Function(MethodCall call)? handler;

  setUp(() {
    handler = (MethodCall call) => <String, dynamic>{};
    Stripe.publishableKey = "pk_test_123456";
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      return handler?.call(call);
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  ProcessOrderPaymentParams buildParams() => ProcessOrderPaymentParams(
        billingCountryCode: "US",
        paymentIntentClientSecret: "pi_secret",
        customerId: "cust_1",
        customerEphemeralKeySecret: "ek_secret",
      );

  group("StripePayment singleton", () {
    test("singleton instance is created and reused", () {
      final StripePayment instance1 = StripePayment.instance;
      final StripePayment instance2 = StripePayment.instance;

      expect(instance1, isNotNull);
      expect(instance1, same(instance2));
    });
  });

  group("prepareCheckout", () {
    test("applies the Stripe settings without throwing", () async {
      final StripePayment service = StripePayment.instance;

      await expectLater(
        service.prepareCheckout(
          publishableKey: "pk_test_123456",
          merchantIdentifier: "com.example.merchant",
          urlScheme: "myapp",
        ),
        completes,
      );
    });
  });

  group("processOrderPayment", () {
    test("returns completed when the payment sheet flow succeeds", () async {
      handler = (MethodCall call) => <String, dynamic>{};
      final StripePayment service = StripePayment.instance;

      final PaymentResult result = await service.processOrderPayment(
        params: buildParams(),
      );

      expect(result, PaymentResult.completed);
    });

    test("throws an Exception when Stripe reports an error", () async {
      handler = (MethodCall call) {
        if (call.method == "presentPaymentSheet") {
          return <String, dynamic>{
            "error": <String, dynamic>{
              "code": "Failed",
              "message": "card declined",
              "localizedMessage": "card declined",
            },
          };
        }
        return <String, dynamic>{};
      };
      final StripePayment service = StripePayment.instance;

      await expectLater(
        service.processOrderPayment(params: buildParams()),
        throwsA(isA<Exception>()),
      );
    });

    test("rethrows unforeseen platform errors", () async {
      handler = (MethodCall call) {
        if (call.method == "presentPaymentSheet") {
          throw PlatformException(code: "NATIVE", message: "boom");
        }
        return <String, dynamic>{};
      };
      final StripePayment service = StripePayment.instance;

      await expectLater(
        service.processOrderPayment(params: buildParams()),
        throwsA(isA<Object>()),
      );
    });
  });

  group("ProcessOrderPaymentParams", () {
    test("stores required fields and applies defaults", () {
      final ProcessOrderPaymentParams params = ProcessOrderPaymentParams(
        billingCountryCode: "US",
        paymentIntentClientSecret: "secret",
        customerId: "customer",
        customerEphemeralKeySecret: "key",
      );

      expect(params.billingCountryCode, "US");
      expect(params.paymentIntentClientSecret, "secret");
      expect(params.customerId, "customer");
      expect(params.customerEphemeralKeySecret, "key");
      expect(params.merchantDisplayName, "Esim");
      expect(params.testEnv, isFalse);
      expect(params.iccID, isNull);
      expect(params.orderID, isNull);
    });

    test("stores all optional fields", () {
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

      expect(params.merchantDisplayName, "Custom");
      expect(params.testEnv, isTrue);
      expect(params.iccID, "89011401200000012345");
      expect(params.orderID, "order_123");
    });
  });

  group("PaymentResult enum", () {
    test("defines all values with correct names", () {
      expect(PaymentResult.values.length, 3);
      expect(PaymentResult.completed.name, "completed");
      expect(PaymentResult.canceled.name, "canceled");
      expect(PaymentResult.otpRequested.name, "otpRequested");
    });

    test("can be used in switch statements", () {
      String message(PaymentResult status) => switch (status) {
            PaymentResult.completed => "Payment Complete",
            PaymentResult.canceled => "Payment Canceled",
            PaymentResult.otpRequested => "OTP Required",
          };

      expect(message(PaymentResult.completed), "Payment Complete");
      expect(message(PaymentResult.canceled), "Payment Canceled");
      expect(message(PaymentResult.otpRequested), "OTP Required");
    });
  });
}
