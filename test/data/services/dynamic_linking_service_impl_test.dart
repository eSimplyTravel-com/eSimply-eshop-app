import "package:esim_open_source/data/services/dynamic_linking_service_impl.dart";
import "package:esim_open_source/domain/repository/services/dynamic_linking_service.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for DynamicLinkingServiceImpl.
///
/// DynamicLinkingServiceImpl wraps the static flutter_branch_sdk API, which
/// communicates over a method channel ("flutter_branch_sdk/message") and an
/// event channel ("flutter_branch_sdk/event"). Both channels are mocked so the
/// service's init, link-generation and session-listening logic can be exercised
/// without the native Branch SDK.
///
/// Note: on a non-iOS test host the tracking methods short-circuit to
/// `notSupported` inside the SDK, so the iOS-only switch arms of
/// requestTrackingAuthorization / getTrackingAuthorizationStatus are not
/// reachable in unit tests.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel messageChannel =
      MethodChannel("flutter_branch_sdk/message");
  const EventChannel eventChannel = EventChannel("flutter_branch_sdk/event");

  // Per-test control over the getShortUrl response and whether it throws.
  Map<dynamic, dynamic> shortUrlResponse = <dynamic, dynamic>{
    "success": true,
    "url": "https://branch.link/short",
  };
  bool getShortUrlThrows = false;

  // Event channel behaviour for listSession().
  Object? eventToEmit;
  bool emitError = false;

  setUp(() {
    shortUrlResponse = <dynamic, dynamic>{
      "success": true,
      "url": "https://branch.link/short",
    };
    getShortUrlThrows = false;
    eventToEmit = null;
    emitError = false;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(messageChannel, (MethodCall call) async {
      switch (call.method) {
        case "init":
          return null;
        case "validateSDKIntegration":
          return null;
        case "getShortUrl":
          if (getShortUrlThrows) {
            throw PlatformException(code: "ERR", message: "boom");
          }
          return shortUrlResponse;
        case "requestTrackingAuthorization":
        case "getTrackingAuthorizationStatus":
          return 3; // authorized (unused on non-iOS host)
        default:
          return null;
      }
    });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(
      eventChannel,
      MockStreamHandler.inline(
        onListen: (Object? arguments, MockStreamHandlerEventSink events) {
          if (emitError) {
            events.error(code: "INIT_ERR", message: "session error");
          } else if (eventToEmit != null) {
            events.success(eventToEmit);
          }
          events.endOfStream();
        },
      ),
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      ..setMockMethodCallHandler(messageChannel, null)
      ..setMockStreamHandler(eventChannel, null);
  });

  group("DynamicLinkingTrackingStatus Tests", () {
    test("all enum values are defined", () {
      expect(DynamicLinkingTrackingStatus.values.length, 5);
    });

    test("enum values have correct names", () {
      expect(DynamicLinkingTrackingStatus.notDetermined.name, "notDetermined");
      expect(DynamicLinkingTrackingStatus.restricted.name, "restricted");
      expect(DynamicLinkingTrackingStatus.denied.name, "denied");
      expect(DynamicLinkingTrackingStatus.authorized.name, "authorized");
      expect(DynamicLinkingTrackingStatus.notSupported.name, "notSupported");
    });

    test("enum can be used in switch statements", () {
      String getStatusMessage(DynamicLinkingTrackingStatus status) {
        return switch (status) {
          DynamicLinkingTrackingStatus.notDetermined => "Not asked",
          DynamicLinkingTrackingStatus.restricted => "Restricted",
          DynamicLinkingTrackingStatus.denied => "Denied",
          DynamicLinkingTrackingStatus.authorized => "Authorized",
          DynamicLinkingTrackingStatus.notSupported => "Not supported",
        };
      }

      expect(
        getStatusMessage(DynamicLinkingTrackingStatus.notDetermined),
        "Not asked",
      );
    });
  });

  group("DynamicLinkingServiceImpl Tests", () {
    test("can be instantiated and implements the interface", () {
      final DynamicLinkingServiceImpl service = DynamicLinkingServiceImpl();
      expect(service, isA<DynamicLinkingService>());
    });

    test("multiple instances can be created", () {
      final DynamicLinkingServiceImpl service1 = DynamicLinkingServiceImpl();
      final DynamicLinkingServiceImpl service2 = DynamicLinkingServiceImpl();
      expect(service1, isNot(same(service2)));
    });

    test("initialize sets up the Branch session listener", () async {
      final DynamicLinkingServiceImpl service = DynamicLinkingServiceImpl();

      await service.initialize(
        onDeepLink: ({required Uri uri, required bool isInitial}) {},
        validateSDKIntegration: true,
      );

      await service.dispose();
    });

    test("initialize forwards a deep link from the session stream", () async {
      eventToEmit = <dynamic, dynamic>{
        "original_url": "https://deep.link/path",
      };

      final DynamicLinkingServiceImpl service = DynamicLinkingServiceImpl();

      Uri? receivedUri;
      bool? receivedIsInitial;
      await service.initialize(
        onDeepLink: ({required Uri uri, required bool isInitial}) {
          receivedUri = uri;
          receivedIsInitial = isInitial;
        },
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(receivedUri, Uri.parse("https://deep.link/path"));
      expect(receivedIsInitial, isFalse);

      await service.dispose();
    });

    test("initialize handles a session stream error", () async {
      emitError = true;

      final DynamicLinkingServiceImpl service = DynamicLinkingServiceImpl();

      await service.initialize(
        onDeepLink: ({required Uri uri, required bool isInitial}) {},
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));

      await service.dispose();
    });

    test("requestTrackingAuthorization returns a status", () async {
      final DynamicLinkingServiceImpl service = DynamicLinkingServiceImpl();
      await service.initialize(
        onDeepLink: ({required Uri uri, required bool isInitial}) {},
      );

      final DynamicLinkingTrackingStatus status =
          await service.requestTrackingAuthorization();

      expect(status, isA<DynamicLinkingTrackingStatus>());
    });

    test("getTrackingAuthorizationStatus returns a status", () async {
      final DynamicLinkingServiceImpl service = DynamicLinkingServiceImpl();
      await service.initialize(
        onDeepLink: ({required Uri uri, required bool isInitial}) {},
      );

      final DynamicLinkingTrackingStatus status =
          await service.getTrackingAuthorizationStatus();

      expect(status, isA<DynamicLinkingTrackingStatus>());
    });

    test("generateBranchLink returns the generated url on success", () async {
      final DynamicLinkingServiceImpl service = DynamicLinkingServiceImpl();
      await service.initialize(
        onDeepLink: ({required Uri uri, required bool isInitial}) {},
      );

      final String? link = await service.generateBranchLink(
        deepLinkUrl: "https://example.com/deep",
        referUserID: "user-123",
        title: "Title",
        description: "Description",
      );

      expect(link, "https://branch.link/short");
    });

    test("generateBranchLink returns null when the SDK reports failure",
        () async {
      shortUrlResponse = <dynamic, dynamic>{
        "success": false,
        "errorCode": "100",
        "errorMessage": "failed",
      };

      final DynamicLinkingServiceImpl service = DynamicLinkingServiceImpl();
      await service.initialize(
        onDeepLink: ({required Uri uri, required bool isInitial}) {},
      );

      final String? link = await service.generateBranchLink(
        deepLinkUrl: "https://example.com/deep",
      );

      expect(link, isNull);
    });

    test("generateBranchLink returns null when the SDK throws", () async {
      getShortUrlThrows = true;

      final DynamicLinkingServiceImpl service = DynamicLinkingServiceImpl();
      await service.initialize(
        onDeepLink: ({required Uri uri, required bool isInitial}) {},
      );

      final String? link = await service.generateBranchLink(
        deepLinkUrl: "https://example.com/deep",
      );

      expect(link, isNull);
    });

    test("dispose can be called multiple times", () async {
      final DynamicLinkingServiceImpl service = DynamicLinkingServiceImpl();

      await service.dispose();
      await service.dispose();

      expect(true, isTrue);
    });
  });
}
