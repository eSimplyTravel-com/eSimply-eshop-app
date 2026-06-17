import "dart:async";

import "package:esim_open_source/data/services/local_notification_service.dart";
import "package:esim_open_source/data/services/push_notification_service_impl.dart";
import "package:esim_open_source/domain/repository/services/push_notification_service.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_core_platform_interface/test.dart";
import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/test_environment_setup.dart";
import "../../helpers/view_helper.dart";

/// Unit tests for PushNotificationServiceImpl.
///
/// The service is driven by Firebase Messaging (method channel
/// "plugins.flutter.io/firebase_messaging") and flutter_local_notifications.
/// Both are mocked here.
///
/// Platform limitations (covered by integration tests instead):
///  - The permission-request paths (_requestIOSPermission /
///    _requestAndroidPermission / _setupAndroidNotificationChannel) are gated by
///    dart:io `Platform.isIOS` / `Platform.isAndroid`, which cannot be
///    overridden in unit tests, so they only run on a real device.
///  - `initialise()` calls `FirebaseMessaging.onBackgroundMessage` with a
///    closure; the Dart VM cannot produce a callback handle for a closure in a
///    unit test, so that call throws. As a result the background/initial-message
///    handler setup and the foreground-notification display paths cannot be
///    reached here. The handlers registered *before* that call (foreground
///    message listener and local-notification selection listener) are still
///    exercised.
Future<void> main() async {
  await prepareTest();

  const MethodChannel messagingChannel =
      MethodChannel("plugins.flutter.io/firebase_messaging");
  const MethodChannel flnChannel =
      MethodChannel("dexterous.com/flutter/local_notifications");

  Map<String, dynamic>? initialMessage;

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();

    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    FlutterLocalNotificationsPlatform.instance =
        AndroidFlutterLocalNotificationsPlugin();
    initialMessage = null;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(messagingChannel, (MethodCall call) async {
      switch (call.method) {
        case "Messaging#getToken":
          return <String, dynamic>{"token": "test-fcm-token"};
        case "Messaging#getInitialMessage":
          return initialMessage;
        case "Messaging#requestPermission":
          return <String, dynamic>{"authorizationStatus": 1};
        case "Messaging#setForegroundNotificationPresentationOptions":
          return null;
        default:
          return null;
      }
    });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(flnChannel, (MethodCall call) async {
      if (call.method == "initialize") {
        return true;
      }
      return null;
    });
  });

  tearDown(() async {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      ..setMockMethodCallHandler(messagingChannel, null)
      ..setMockMethodCallHandler(flnChannel, null);
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("PushNotificationServiceImpl", () {
    test("getInstance returns a singleton implementing the interface", () {
      final PushNotificationServiceImpl instance1 =
          PushNotificationServiceImpl.getInstance();
      final PushNotificationServiceImpl instance2 =
          PushNotificationServiceImpl.getInstance();

      expect(instance1, same(instance2));
      expect(instance1, isA<PushNotificationService>());
    });

    test("getFcmToken returns the token from Firebase Messaging", () async {
      final PushNotificationServiceImpl service =
          PushNotificationServiceImpl.getInstance();

      final String? token = await service.getFcmToken();

      expect(token, "test-fcm-token");
    });

    test("local notification selection forwards the payload to the callback",
        () async {
      final PushNotificationServiceImpl service =
          PushNotificationServiceImpl.getInstance();

      Map<String, dynamic>? receivedPayload;
      bool? receivedIsClicked;

      // initialise() wires up the foreground and local-notification handlers and
      // then registers the background handler, which fires an uncatchable async
      // error in the test VM (no callback handle for a closure). runZonedGuarded
      // swallows that fire-and-forget error so the reachable setup is exercised.
      await runZonedGuarded(() async {
        await service.initialise(
          handlePushData: ({
            required bool isClicked,
            required bool isInitial,
            Map<String, dynamic>? handlePushData,
          }) {
            receivedPayload = handlePushData;
            receivedIsClicked = isClicked;
          },
        );

        final LocalNotificationService localNotificationService =
            await LocalNotificationService.getInstance();
        localNotificationService.selectNotificationSubject
            .add(<String, dynamic>{"foo": "bar"});

        await Future<void>.delayed(const Duration(milliseconds: 50));
      }, (Object error, StackTrace stack) {
        // Expected: background handler registration is unavailable in tests.
      });

      expect(receivedPayload, <String, dynamic>{"foo": "bar"});
      expect(receivedIsClicked, isTrue);
    });
  });
}
