import "dart:io";

import "package:esim_open_source/data/services/local_notification_service.dart";
import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:flutter_test/flutter_test.dart";
import "package:path_provider_platform_interface/path_provider_platform_interface.dart";
import "package:plugin_platform_interface/plugin_platform_interface.dart";

/// Fake path provider that returns the system temp directory, so the service's
/// file download can write to a real, writable location in tests.
class _FakePathProvider extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async =>
      Directory.systemTemp.path;
}

/// Unit tests for LocalNotificationService.
///
/// flutter_local_notifications talks to native code over the
/// "dexterous.com/flutter/local_notifications" method channel. The channel is
/// mocked (and the target platform forced to Android) so the service can
/// initialize and show notifications without the native plugin.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel flnChannel =
      MethodChannel("dexterous.com/flutter/local_notifications");

  final List<MethodCall> flnCalls = <MethodCall>[];

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    // The Android platform implementation registers itself only on a real
    // device; register it manually so resolvePlatformSpecificImplementation can
    // route initialize/show to the mocked method channel.
    FlutterLocalNotificationsPlatform.instance =
        AndroidFlutterLocalNotificationsPlugin();
    flnCalls.clear();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(flnChannel, (MethodCall call) async {
      flnCalls.add(call);
      switch (call.method) {
        case "initialize":
          return true;
        case "getNotificationAppLaunchDetails":
          return null;
        case "show":
          return null;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(flnChannel, null);
  });

  group("LocalNotificationService", () {
    test("getInstance initializes and returns a singleton", () async {
      final LocalNotificationService instance1 =
          await LocalNotificationService.getInstance();
      final LocalNotificationService instance2 =
          await LocalNotificationService.getInstance();

      expect(instance1, same(instance2));
      expect(
        flnCalls.map((MethodCall c) => c.method),
        contains("initialize"),
      );
    });

    test("showBigTextNotification shows a notification", () async {
      final LocalNotificationService service =
          await LocalNotificationService.getInstance();
      flnCalls.clear();

      await service.showBigTextNotification(
        id: 1,
        bigText: "big text body",
        title: "Title",
        summaryText: "Summary",
        payload: <String, dynamic>{"key": "value"},
      );

      expect(flnCalls.map((MethodCall c) => c.method), contains("show"));
    });

    test("showBigTextNotification works without a payload or id", () async {
      final LocalNotificationService service =
          await LocalNotificationService.getInstance();
      flnCalls.clear();

      await service.showBigTextNotification(
        bigText: "text",
        title: "Title",
        summaryText: "Summary",
      );

      expect(flnCalls.map((MethodCall c) => c.method), contains("show"));
    });

    test("showBigPictureNotificationHiddenLargeIcon downloads icons and shows",
        () async {
      // Serve the icon/big-picture downloads from a local HTTP server.
      final HttpServer server =
          await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((HttpRequest request) async {
        request.response.add(<int>[1, 2, 3, 4]);
        await request.response.close();
      });
      addTearDown(() async => server.close(force: true));

      PathProviderPlatform.instance = _FakePathProvider();

      final String baseUrl = "http://127.0.0.1:${server.port}";
      final LocalNotificationService service =
          await LocalNotificationService.getInstance();
      flnCalls.clear();

      await service.showBigPictureNotificationHiddenLargeIcon(
        iconURL: "$baseUrl/icon.png",
        largeIconURL: "$baseUrl/big.png",
        title: "Title",
        summaryText: "Summary",
        id: 99,
        payload: <String, dynamic>{"key": "value"},
      );

      expect(flnCalls.map((MethodCall c) => c.method), contains("show"));
    });
  });
}
