import "package:esim_open_source/data/services/remote_config_service_impl.dart";
import "package:esim_open_source/domain/repository/services/remote_config_service.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_core_platform_interface/test.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/test_environment_setup.dart";
import "../../helpers/view_helper.dart";

/// Unit tests for RemoteConfigServiceImpl.
///
/// RemoteConfigServiceImpl uses Firebase Remote Config, whose platform
/// interface is pigeon-based. The pigeon host-API channels are mocked here so
/// the service can initialize and read flags without a real Firebase backend.
Future<void> main() async {
  await prepareTest();

  const String base =
      "dev.flutter.pigeon.firebase_remote_config_platform_interface."
      "FirebaseRemoteConfigHostApi.";

  void mockPigeonReply(String method, Object? value) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(
      "$base$method",
      (ByteData? message) async =>
          const StandardMessageCodec().encodeMessage(<Object?>[value]),
    );
  }

  void clearPigeonReply(String method) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler("$base$method", null);
  }

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();

    mockPigeonReply("ensureInitialized", null);
    mockPigeonReply("setConfigSettings", null);
    mockPigeonReply("fetchAndActivate", true);
    mockPigeonReply("getAll", <String, Object?>{});
    mockPigeonReply("getProperties", <String, Object?>{
      "fetchTimeout": 10,
      "minimumFetchInterval": 0,
      "lastFetchTime": 0,
      "lastFetchStatus": "success",
    });
  });

  tearDown(() async {
    for (final String method in <String>[
      "ensureInitialized",
      "setConfigSettings",
      "fetchAndActivate",
      "getAll",
      "getProperties",
    ]) {
      clearPigeonReply(method);
    }
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("RemoteConfigServiceImpl Tests", () {
    test("singleton instance is created and reused", () {
      final RemoteConfigServiceImpl instance1 =
          RemoteConfigServiceImpl.instance;
      final RemoteConfigServiceImpl instance2 =
          RemoteConfigServiceImpl.instance;

      expect(instance1, isNotNull);
      expect(instance1, same(instance2));
    });

    test("instance implements RemoteConfigService interface", () {
      expect(RemoteConfigServiceImpl.instance, isA<RemoteConfigService>());
    });

    test("initializeRemoteConfig completes and assigns remoteConfig", () async {
      final RemoteConfigServiceImpl service = RemoteConfigServiceImpl.instance;

      await service.initializeRemoteConfig();

      expect(service.remoteConfig, isNotNull);
    });

    test("isPromoCodeFieldVisible returns false when flag is absent", () async {
      final RemoteConfigServiceImpl service = RemoteConfigServiceImpl.instance;
      await service.initializeRemoteConfig();

      final bool visible = await service.isPromoCodeFieldVisible;

      expect(visible, isFalse);
    });

    test("isPromoCodeFieldVisible is consistent across calls", () async {
      final RemoteConfigServiceImpl service = RemoteConfigServiceImpl.instance;
      await service.initializeRemoteConfig();

      final bool first = await service.isPromoCodeFieldVisible;
      final bool second = await service.isPromoCodeFieldVisible;

      expect(first, second);
    });
  });
}
