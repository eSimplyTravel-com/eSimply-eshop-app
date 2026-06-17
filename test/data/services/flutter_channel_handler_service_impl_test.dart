import "package:esim_open_source/data/services/flutter_channel_handler_service_impl.dart";
import "package:esim_open_source/domain/repository/services/flutter_channel_handler_service.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";

/// Unit tests for FlutterChannelHandlerServiceImpl.
///
/// The service talks to native code over the "com.luxe.esim/flutter_to_native"
/// method channel. The channel is mocked to drive the success and error
/// branches of each method.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel =
      MethodChannel("com.luxe.esim/flutter_to_native");

  // Per-test control over what the native side returns / throws.
  Object? Function(MethodCall call)? handler;

  setUp(() {
    handler = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      return handler?.call(call);
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group("FlutterChannelHandlerServiceImpl Tests", () {
    test("getInstance creates and reuses a single instance", () {
      final FlutterChannelHandlerServiceImpl instance1 =
          FlutterChannelHandlerServiceImpl.getInstance();
      final FlutterChannelHandlerServiceImpl instance2 =
          FlutterChannelHandlerServiceImpl.getInstance();

      expect(instance1, isNotNull);
      expect(instance1, same(instance2));
      expect(instance1, isA<FlutterChannelHandlerService>());
    });

    test("errorMessage property has a default value", () {
      final FlutterChannelHandlerServiceImpl service =
          FlutterChannelHandlerServiceImpl.getInstance();

      expect(service.errorMessage, isNotEmpty);
      expect(service.errorMessage, contains("Auto eSIM installation"));
    });

    group("openSimProfilesSettings", () {
      test("completes when the native call succeeds", () async {
        handler = (MethodCall call) => null;
        final FlutterChannelHandlerServiceImpl service =
            FlutterChannelHandlerServiceImpl.getInstance();

        await expectLater(service.openSimProfilesSettings(), completes);
      });

      test("throws when the native side raises a PlatformException", () async {
        handler = (MethodCall call) =>
            throw PlatformException(code: "ERR", message: "boom");
        final FlutterChannelHandlerServiceImpl service =
            FlutterChannelHandlerServiceImpl.getInstance();

        await expectLater(
          service.openSimProfilesSettings(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group("openEsimSetupForIOS", () {
      test("completes when the native call succeeds", () async {
        handler = (MethodCall call) => null;
        final FlutterChannelHandlerServiceImpl service =
            FlutterChannelHandlerServiceImpl.getInstance();

        await expectLater(
          service.openEsimSetupForIOS(
            smdpAddress: "smdp.example.com",
            activationCode: "ABC123",
          ),
          completes,
        );
      });

      test("throws when the native side raises a PlatformException", () async {
        handler = (MethodCall call) =>
            throw PlatformException(code: "ERR", message: "boom");
        final FlutterChannelHandlerServiceImpl service =
            FlutterChannelHandlerServiceImpl.getInstance();

        await expectLater(
          service.openEsimSetupForIOS(
            smdpAddress: "smdp.example.com",
            activationCode: "ABC123",
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group("openEsimSetupForAndroid", () {
      test("returns true when installation is supported", () async {
        handler = (MethodCall call) => true;
        final FlutterChannelHandlerServiceImpl service =
            FlutterChannelHandlerServiceImpl.getInstance();

        final bool result = await service.openEsimSetupForAndroid(
          smdpAddress: "smdp.example.com",
          activationCode: "ABC123",
        );

        expect(result, isTrue);
      });

      test("throws when installation is not supported", () async {
        handler = (MethodCall call) => false;
        final FlutterChannelHandlerServiceImpl service =
            FlutterChannelHandlerServiceImpl.getInstance();

        await expectLater(
          service.openEsimSetupForAndroid(
            smdpAddress: "smdp.example.com",
            activationCode: "ABC123",
          ),
          throwsA(isA<Exception>()),
        );
      });

      test("throws when the native side raises a PlatformException", () async {
        handler = (MethodCall call) =>
            throw PlatformException(code: "ERR", message: "boom");
        final FlutterChannelHandlerServiceImpl service =
            FlutterChannelHandlerServiceImpl.getInstance();

        await expectLater(
          service.openEsimSetupForAndroid(
            smdpAddress: "smdp.example.com",
            activationCode: "ABC123",
          ),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
