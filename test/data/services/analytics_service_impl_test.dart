import "package:esim_open_source/data/services/analytics_service_impl.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_core_platform_interface/test.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../helpers/test_environment_setup.dart";
import "../../helpers/view_helper.dart";
import "../../locator_test.mocks.dart";

/// Unit tests for AnalyticsServiceImpl and AnalyticEvent classes
/// Tests event creation, analytics service interface, and event structures.
///
/// The service depends on Firebase Analytics (pigeon channel), Facebook App
/// Events (method channel) and App Tracking Transparency (method channel).
/// These platform channels are mocked below so the service methods can be
/// exercised in a pure unit-test environment.
Future<void> main() async {
  await prepareTest();

  const String fbAnalyticsLogEventChannel =
      "dev.flutter.pigeon.firebase_analytics_platform_interface."
      "FirebaseAnalyticsHostApi.logEvent";
  const String fbAnalyticsSetUserIdChannel =
      "dev.flutter.pigeon.firebase_analytics_platform_interface."
      "FirebaseAnalyticsHostApi.setUserId";

  // Stored analytics consent. `null` means the user has never been asked, which
  // is the state a fresh install is in.
  bool? storedConsent;

  // Call counter, so the consent tests can assert that nothing reached the SDK
  // rather than merely that the futures completed.
  int firebaseLogEventCount = 0;

  void mockPigeonVoidReply(String channel) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(
      channel,
      (ByteData? message) async =>
          const StandardMessageCodec().encodeMessage(<Object?>[null]),
    );
  }

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    // setupTest() fires the legacy initFirebaseMock() without awaiting it and it
    // fails silently against the pigeon-based firebase_core. Register the proper
    // pigeon mock so the default Firebase app initializes for
    // FirebaseAnalytics.instance.
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();

    mockPigeonVoidReply(fbAnalyticsLogEventChannel);
    mockPigeonVoidReply(fbAnalyticsSetUserIdChannel);

    storedConsent = null;
    firebaseLogEventCount = 0;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(
      fbAnalyticsLogEventChannel,
      (ByteData? message) async {
        firebaseLogEventCount++;
        return const StandardMessageCodec().encodeMessage(<Object?>[null]);
      },
    );

    final MockLocalStorageService mockLocalStorageService =
        locator<LocalStorageService>() as MockLocalStorageService;
    when(mockLocalStorageService.getBool(LocalStorageKeys.analyticsConsent))
        .thenAnswer((_) => storedConsent);
    when(
      mockLocalStorageService.setBool(
        LocalStorageKeys.analyticsConsent,
        value: anyNamed("value"),
      ),
    ).thenAnswer((Invocation i) async {
      storedConsent = i.namedArguments[#value] as bool;
      return true;
    });
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      ..setMockMessageHandler(fbAnalyticsLogEventChannel, null)
      ..setMockMessageHandler(fbAnalyticsSetUserIdChannel, null);
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("AnalyticEvent Tests", () {
    test("AnalyticsEvent can be created with event name", () {
      final AnalyticsEvent event = AnalyticsEvent("test_event");

      expect(event.eventName, "test_event");
      expect(event.parameters, isNull);
    });

    test("appCheckApp event is created correctly", () {
      final AnalyticEvent event = AnalyticEvent.appCheckApp();

      expect(event, isA<AnalyticEvent>());
      expect(event.eventName, "app_check_app");
    });

    test("appCheckBackend event is created correctly", () {
      final AnalyticEvent event = AnalyticEvent.appCheckBackend();

      expect(event, isA<AnalyticEvent>());
      expect(event.eventName, "app_check_backend");
    });

    test("contactUsClicked event is created correctly", () {
      final AnalyticEvent event = AnalyticEvent.contactUsClicked();

      expect(event, isA<AnalyticEvent>());
      expect(event.eventName, "contact_us_clicked");
    });

    test("userGuideOpened event is created correctly", () {
      final AnalyticEvent event = AnalyticEvent.userGuideOpened();

      expect(event, isA<AnalyticEvent>());
      expect(event.eventName, "user_guide_opened");
    });

    test("regionsClicked event is created correctly", () {
      final AnalyticEvent event = AnalyticEvent.regionsClicked();

      expect(event, isA<AnalyticEvent>());
      expect(event.eventName, "regions_clicked");
    });
  });

  group("CampaignEvent Tests", () {
    test("firstOpenCampaign event is created with correct parameters", () {
      final AnalyticEvent event = AnalyticEvent.firstOpenCampaign(
        utm: "test_utm",
        platform: "ios",
      );

      expect(event, isA<CampaignEvent>());
      expect(event.eventName, "first_open_campaign");
      expect(event.parameters, isNotNull);
      expect(event.parameters?["utm"], "test_utm");
      expect(event.parameters?["platform"], "ios");
    });

    test("loginSuccess event is created with correct parameters", () {
      final AnalyticEvent event = AnalyticEvent.loginSuccess(
        utm: "campaign_utm",
        platform: "android",
      );

      expect(event, isA<CampaignEvent>());
      expect(event.eventName, "campaign_login");
      expect(event.parameters, isNotNull);
      expect(event.parameters?["utm"], "campaign_utm");
      expect(event.parameters?["platform"], "android");
    });

    test("CampaignEvent parameters contain utm and platform", () {
      final CampaignEvent event = CampaignEvent(
        "test_campaign",
        utm: "test_utm_source",
        platform: "web",
      );

      final Map<String, Object>? params = event.parameters;
      expect(params, isNotNull);
      expect(params?.length, 2);
      expect(params?["utm"], "test_utm_source");
      expect(params?["platform"], "web");
    });
  });

  group("PurchaseSuccessEvent Tests", () {
    test("buySuccess event is created with correct parameters", () {
      final AnalyticEvent event = AnalyticEvent.buySuccess(
        utm: "purchase_utm",
        platform: "ios",
        amount: "99.99",
        currency: "USD",
      );

      expect(event, isA<PurchaseSuccessEvent>());
      expect(event.eventName, "campaign_buy");
      expect(event.parameters, isNotNull);
      expect(event.parameters?["utm"], "purchase_utm");
      expect(event.parameters?["platform"], "ios");
      expect(event.parameters?["amount"], "99.99");
      expect(event.parameters?["currency"], "USD");
    });

    test("buyTopUpSuccess event is created with correct parameters", () {
      final AnalyticEvent event = AnalyticEvent.buyTopUpSuccess(
        utm: "topup_utm",
        platform: "android",
        amount: "19.99",
        currency: "EUR",
      );

      expect(event, isA<PurchaseSuccessEvent>());
      expect(event.eventName, "campaign_topup");
      expect(event.parameters, isNotNull);
      expect(event.parameters?["utm"], "topup_utm");
      expect(event.parameters?["platform"], "android");
      expect(event.parameters?["amount"], "19.99");
      expect(event.parameters?["currency"], "EUR");
    });

    test("PurchaseSuccessEvent parameters contain all required fields", () {
      final PurchaseSuccessEvent event = PurchaseSuccessEvent(
        "test_purchase",
        utm: "utm_value",
        platform: "ios",
        amount: "50.00",
        currency: "GBP",
      );

      final Map<String, Object>? params = event.parameters;
      expect(params, isNotNull);
      expect(params?.length, 4);
      expect(params?["utm"], "utm_value");
      expect(params?["platform"], "ios");
      expect(params?["amount"], "50.00");
      expect(params?["currency"], "GBP");
    });
  });

  group("BundleDetailEvent / CreateOrderEvent / StripePaymentEvent Tests", () {
    test("bundleDetail event is created with correct parameters", () {
      final AnalyticEvent event = AnalyticEvent.bundleDetail(
        bundleCode: "code",
        bundleName: "name",
        user: "user",
      );

      expect(event, isA<BundleDetailEvent>());
      expect(event.eventName, "bundle_detail");
      expect(event.parameters?["bundleCode"], "code");
      expect(event.parameters?["bundleName"], "name");
      expect(event.parameters?["user"], "user");
    });

    test("createOrder event is created with correct parameters", () {
      final AnalyticEvent event = AnalyticEvent.createOrder(
        bundleCode: "code",
        bundleName: "name",
        user: "user",
        orderId: "order",
        method: "Card",
      );

      expect(event, isA<CreateOrderEvent>());
      expect(event.eventName, "create_order");
      expect(event.parameters?["orderId"], "order");
      expect(event.parameters?["method"], "Card");
    });

    test("stripePay event is created with Card method", () {
      final AnalyticEvent event = AnalyticEvent.stripePay(
        bundleCode: "code",
        bundleName: "name",
        user: "user",
        orderId: "order",
      );

      expect(event, isA<StripePaymentEvent>());
      expect(event.eventName, "stripe_pay");
      expect(event.parameters?["method"], "Card");
    });

    test("stripePaymentSuccessful event is created correctly", () {
      final AnalyticEvent event = AnalyticEvent.stripePaymentSuccessful(
        bundleCode: "code",
        bundleName: "name",
        user: "user",
        orderId: "order",
      );

      expect(event.eventName, "stripe_payment_successful");
      expect(event.parameters?["method"], "Card");
    });

    test("walletPaymentSuccessful event is created with Wallet method", () {
      final AnalyticEvent event = AnalyticEvent.walletPaymentSuccessful(
        bundleCode: "code",
        bundleName: "name",
        user: "user",
        orderId: "order",
      );

      expect(event.eventName, "wallet_payment_successful");
      expect(event.parameters?["method"], "Wallet");
    });
  });

  group("AnalyticsServiceImpl Tests", () {
    test("singleton instance is created and reused", () {
      final AnalyticsServiceImpl instance1 = AnalyticsServiceImpl.instance;
      final AnalyticsServiceImpl instance2 = AnalyticsServiceImpl.instance;

      expect(instance1, isNotNull);
      expect(instance1, same(instance2));
    });

    test("instance implements AnalyticsService interface", () {
      final AnalyticsServiceImpl instance = AnalyticsServiceImpl.instance;

      expect(instance, isA<AnalyticsService>());
    });

    test("configure completes when tracking is already authorized", () async {
      storedConsent = true;
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;

      await expectLater(service.configure(), completes);
    });

    test("consent is null until the user has been asked", () async {
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;
      await service.configure();

      // "not asked" must stay distinguishable from "refused" — only the first
      // may be turned into a prompt.
      expect(service.analyticsConsent, isNull);
    });

    test("no event reaches Firebase until consent is granted", () async {
      storedConsent = null;
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;
      await service.configure();

      await service.logEvent(event: AnalyticEvent.appCheckApp());
      await service.setUserId("hashed_email");

      expect(firebaseLogEventCount, 0);
    });

    test("a refusal keeps events off", () async {
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;
      await service.setAnalyticsConsent(granted: false);

      await service.logEvent(event: AnalyticEvent.appCheckApp());

      expect(storedConsent, isFalse);
      expect(service.analyticsConsent, isFalse);
      expect(firebaseLogEventCount, 0);
    });

    test("granting consent persists it and lets events through", () async {
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;

      await service.setAnalyticsConsent(granted: true);
      await service.logEvent(event: AnalyticEvent.appCheckApp());

      expect(storedConsent, isTrue);
      expect(service.analyticsConsent, isTrue);
      expect(firebaseLogEventCount, greaterThan(0));
    });

    test("consent survives a restart without asking again", () async {
      storedConsent = true;
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;

      await service.configure();
      await service.logEvent(event: AnalyticEvent.appCheckApp());

      expect(firebaseLogEventCount, greaterThan(0));
    });

    test("withdrawing consent stops events that were previously allowed",
        () async {
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;

      await service.setAnalyticsConsent(granted: true);
      await service.logEvent(event: AnalyticEvent.appCheckApp());
      final int afterGrant = firebaseLogEventCount;

      await service.setAnalyticsConsent(granted: false);
      await service.logEvent(event: AnalyticEvent.appCheckApp());

      expect(afterGrant, greaterThan(0));
      expect(firebaseLogEventCount, afterGrant);
    });


    test("configure with analytics flags disabled completes", () async {
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;

      await expectLater(
        service.configure(
          firebaseAnalytics: false,
        ),
        completes,
      );
    });

    test("logEvent logs to both providers when enabled", () async {
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;
      await service.configure();

      await expectLater(
        service.logEvent(event: AnalyticEvent.appCheckApp()),
        completes,
      );
    });

    test("logEvent skips providers when disabled", () async {
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;
      await service.configure(
        firebaseAnalytics: false,
      );

      await expectLater(
        service.logEvent(event: AnalyticEvent.contactUsClicked()),
        completes,
      );
    });

    test("setUserId sets the firebase user id when enabled", () async {
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;
      await service.configure();

      await expectLater(service.setUserId("hashed_email"), completes);
    });

    test("setUserId accepts null", () async {
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;
      await service.configure();

      await expectLater(service.setUserId(null), completes);
    });

    test("setUserId does nothing when firebase disabled", () async {
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;
      await service.configure(
        firebaseAnalytics: false,
      );

      await expectLater(service.setUserId("hashed_email"), completes);
    });

    test("logFireBaseEvent completes for a parameterized event", () async {
      final AnalyticsServiceImpl service = AnalyticsServiceImpl.instance;

      await expectLater(
        service.logFireBaseEvent(
          event: AnalyticEvent.loginSuccess(utm: "x", platform: "ios"),
        ),
        completes,
      );
    });

  });

  group("AnalyticsService Interface Tests", () {
    test("different event types have different event names", () {
      final AnalyticEvent appCheck = AnalyticEvent.appCheckApp();
      final AnalyticEvent contactUs = AnalyticEvent.contactUsClicked();
      final AnalyticEvent userGuide = AnalyticEvent.userGuideOpened();

      expect(appCheck.eventName, isNot(equals(contactUs.eventName)));
      expect(contactUs.eventName, isNot(equals(userGuide.eventName)));
      expect(userGuide.eventName, isNot(equals(appCheck.eventName)));
    });

    test("simple events have no parameters", () {
      expect(AnalyticEvent.appCheckApp().parameters, isNull);
      expect(AnalyticEvent.contactUsClicked().parameters, isNull);
      expect(AnalyticEvent.regionsClicked().parameters, isNull);
    });

    test("purchase events have more parameters than campaign events", () {
      final AnalyticEvent campaignEvent = AnalyticEvent.loginSuccess(
        utm: "test",
        platform: "ios",
      );
      final AnalyticEvent purchaseEvent = AnalyticEvent.buySuccess(
        utm: "test",
        platform: "ios",
        amount: "10.00",
        currency: "USD",
      );

      expect(campaignEvent.parameters?.length, 2);
      expect(purchaseEvent.parameters?.length, 4);
    });
  });
}
