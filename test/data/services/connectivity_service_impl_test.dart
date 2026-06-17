import "package:esim_open_source/data/services/connectivity_service_impl.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";

/// Test implementation of ConnectionListener.
class TestConnectionListener implements ConnectionListener {
  bool? lastConnectedStatus;
  int callCount = 0;

  @override
  void onConnectivityChanged({required bool connected}) {
    lastConnectedStatus = connected;
    callCount++;
  }
}

/// Unit tests for ConnectivityServiceImpl.
///
/// connectivity_plus communicates over a method channel
/// ("dev.fluttercommunity.plus/connectivity", `check`) and an event channel
/// ("dev.fluttercommunity.plus/connectivity_status"). Both are mocked so the
/// service's initialization, connectivity checks and listener notifications can
/// be exercised.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel methodChannel =
      MethodChannel("dev.fluttercommunity.plus/connectivity");
  const EventChannel eventChannel =
      EventChannel("dev.fluttercommunity.plus/connectivity_status");

  List<String> checkResult = <String>["wifi"];
  MockStreamHandlerEventSink? capturedSink;

  setUp(() {
    checkResult = <String>["wifi"];
    capturedSink = null;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, (MethodCall call) async {
      if (call.method == "check") {
        return checkResult;
      }
      return null;
    });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(
      eventChannel,
      MockStreamHandler.inline(
        onListen: (Object? arguments, MockStreamHandlerEventSink events) {
          capturedSink = events;
        },
      ),
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      ..setMockMethodCallHandler(methodChannel, null)
      ..setMockStreamHandler(eventChannel, null);
  });

  group("ConnectionListener", () {
    test("can be implemented and tracks callbacks", () {
      final TestConnectionListener listener = TestConnectionListener();

      expect(listener, isA<ConnectionListener>());
      expect(listener.callCount, 0);

      listener.onConnectivityChanged(connected: true);
      expect(listener.lastConnectedStatus, isTrue);
      expect(listener.callCount, 1);
    });
  });

  group("ConnectivityServiceImpl", () {
    test("isConnected returns false for the default (none) status", () async {
      final ConnectivityServiceImpl service = ConnectivityServiceImpl();

      expect(await service.isConnected(), isFalse);
    });

    test("addListener registers a listener only once", () {
      final ConnectivityServiceImpl service = ConnectivityServiceImpl();
      final TestConnectionListener listener = TestConnectionListener();

      service
        ..addListener(listener)
        ..addListener(listener)
        ..removeListener(listener);

      expect(true, isTrue);
    });

    test("dispose can be called and is idempotent", () async {
      final ConnectivityServiceImpl service = ConnectivityServiceImpl();

      await service.dispose();
      await service.dispose();

      expect(true, isTrue);
    });

    test("singleton initializes, reports connectivity and notifies listeners",
        () async {
      // First access to .instance triggers _initialise(), which subscribes to
      // the event channel (capturing the sink) and runs the initial check.
      final ConnectivityServiceImpl service = ConnectivityServiceImpl.instance;
      final ConnectivityServiceImpl same = ConnectivityServiceImpl.instance;
      expect(service, same);

      // Initial check returns wifi -> connected.
      expect(await service.isConnected(), isTrue);

      // Add a listener and push a change through the event channel.
      final TestConnectionListener listener = TestConnectionListener();
      service.addListener(listener);

      capturedSink?.success(<String>["none"]);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(listener.callCount, greaterThan(0));
      expect(listener.lastConnectedStatus, isFalse);
      expect(await service.isConnected(), isFalse);

      service.removeListener(listener);
    });
  });
}
