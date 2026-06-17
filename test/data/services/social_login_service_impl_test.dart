import "package:esim_open_source/data/services/social_login_service_impl.dart";
import "package:esim_open_source/domain/repository/services/social_login_service.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart";
import "package:plugin_platform_interface/plugin_platform_interface.dart";

import "../../helpers/test_environment_setup.dart";
import "../../helpers/view_helper.dart";

/// Behaviour modes for the fake Google Sign-In platform.
enum _GoogleMode { success, canceled, unknownError, missingAuthorization }

/// A configurable fake [GoogleSignInPlatform] used to drive the success and
/// error branches of [SocialLoginServiceImpl.signInWithGoogle] and to make
/// [SocialLoginServiceImpl.logOut] safe to call.
class _FakeGoogleSignInPlatform extends GoogleSignInPlatform
    with MockPlatformInterfaceMixin {
  _GoogleMode mode = _GoogleMode.success;

  @override
  Future<void> init(InitParameters params) async {}

  @override
  Future<AuthenticationResults?>? attemptLightweightAuthentication(
    AttemptLightweightAuthenticationParameters params,
  ) async =>
      null;

  @override
  bool supportsAuthenticate() => true;

  @override
  bool authorizationRequiresUserInteraction() => false;

  @override
  Future<AuthenticationResults> authenticate(
    AuthenticateParameters params,
  ) async {
    switch (mode) {
      case _GoogleMode.canceled:
        throw const GoogleSignInException(
          code: GoogleSignInExceptionCode.canceled,
        );
      case _GoogleMode.unknownError:
        throw const GoogleSignInException(
          code: GoogleSignInExceptionCode.unknownError,
          description: "boom",
        );
      case _GoogleMode.success:
      case _GoogleMode.missingAuthorization:
        return const AuthenticationResults(
          user: GoogleSignInUserData(email: "test@example.com", id: "user-id"),
          authenticationTokens: AuthenticationTokenData(idToken: "id-token"),
        );
    }
  }

  @override
  Future<ClientAuthorizationTokenData?> clientAuthorizationTokensForScopes(
    ClientAuthorizationTokensForScopesParameters params,
  ) async {
    if (mode == _GoogleMode.missingAuthorization) {
      return null;
    }
    return const ClientAuthorizationTokenData(accessToken: "access-token");
  }

  @override
  Future<ServerAuthorizationTokenData?> serverAuthorizationTokensForScopes(
    ServerAuthorizationTokensForScopesParameters params,
  ) async =>
      null;

  @override
  Future<void> signOut(SignOutParams params) async {}

  @override
  Future<void> disconnect(DisconnectParams params) async {}
}

/// Unit tests for SocialLoginServiceImpl.
///
/// Supabase is initialized once for the suite. The Google SDK is replaced with
/// a configurable fake platform so the success and error branches of the Google
/// flow are exercised. Apple and Facebook hit unmocked platform channels and so
/// drive the error branches of their respective methods.
///
/// Not covered (require integration tests): the Supabase `onAuthStateChange`
/// listener body, which only runs when a real auth session event is delivered.
Future<void> main() async {
  await prepareTest();

  final _FakeGoogleSignInPlatform fakeGoogle = _FakeGoogleSignInPlatform();
  GoogleSignInPlatform.instance = fakeGoogle;

  const MethodChannel facebookAuthChannel =
      MethodChannel("app.meedu/flutter_facebook_auth");

  bool supabaseInitialised = false;

  Future<void> ensureInitialised(SocialLoginServiceImpl service) async {
    if (!supabaseInitialised) {
      await service.initialise(
        url: "https://test.supabase.co",
        anonKey: "test-anon-key",
      );
      supabaseInitialised = true;
    }
  }

  setUp(() async {
    await setupTest();
    await TestEnvironmentSetup.initializeTestEnvironment();
    fakeGoogle.mode = _GoogleMode.success;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      facebookAuthChannel,
      (MethodCall call) async => <String, dynamic>{},
    );
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(facebookAuthChannel, null);
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("SocialLoginServiceImpl Tests", () {
    test("singleton instance is created and reused", () {
      final SocialLoginServiceImpl instance1 = SocialLoginServiceImpl.instance;
      final SocialLoginServiceImpl instance2 = SocialLoginServiceImpl.instance;

      expect(instance1, isNotNull);
      expect(instance1, same(instance2));
    });

    test("instance implements SocialLoginService interface", () {
      expect(SocialLoginServiceImpl.instance, isA<SocialLoginService>());
    });

    test("socialLoginResultStream is accessible", () {
      final SocialLoginServiceImpl service = SocialLoginServiceImpl.instance;

      expect(service.socialLoginResultStream, isNotNull);
      expect(service.socialLoginResultStream, isA<Stream<SocialLoginResult>>());
    });

    test("initialise sets up Supabase and returns the result stream", () async {
      final SocialLoginServiceImpl service = SocialLoginServiceImpl.instance;
      await ensureInitialised(service);

      final Stream<SocialLoginResult> stream = service.socialLoginResultStream;
      expect(stream, isA<Stream<SocialLoginResult>>());
    });

    test("signInWithApple returns stream and reports error on failure",
        () async {
      final SocialLoginServiceImpl service = SocialLoginServiceImpl.instance;
      await ensureInitialised(service);

      final Stream<SocialLoginResult> stream = await service.signInWithApple();

      expect(stream, isA<Stream<SocialLoginResult>>());
    });

    test("signInWithGoogle drives the success path", () async {
      final SocialLoginServiceImpl service = SocialLoginServiceImpl.instance;
      await ensureInitialised(service);
      fakeGoogle.mode = _GoogleMode.success;

      final Stream<SocialLoginResult> stream = await service.signInWithGoogle();

      expect(stream, isA<Stream<SocialLoginResult>>());
    });

    test("signInWithGoogle handles missing authorization", () async {
      final SocialLoginServiceImpl service = SocialLoginServiceImpl.instance;
      await ensureInitialised(service);
      fakeGoogle.mode = _GoogleMode.missingAuthorization;

      final Stream<SocialLoginResult> stream = await service.signInWithGoogle();

      expect(stream, isA<Stream<SocialLoginResult>>());
    });

    test("signInWithGoogle handles user cancellation", () async {
      final SocialLoginServiceImpl service = SocialLoginServiceImpl.instance;
      await ensureInitialised(service);
      fakeGoogle.mode = _GoogleMode.canceled;

      final Stream<SocialLoginResult> stream = await service.signInWithGoogle();

      expect(stream, isA<Stream<SocialLoginResult>>());
    });

    test("signInWithGoogle handles a non-cancel Google exception", () async {
      final SocialLoginServiceImpl service = SocialLoginServiceImpl.instance;
      await ensureInitialised(service);
      fakeGoogle.mode = _GoogleMode.unknownError;

      final Stream<SocialLoginResult> stream = await service.signInWithGoogle();

      expect(stream, isA<Stream<SocialLoginResult>>());
    });

    test("signInWithFaceBook returns stream and reports error on failure",
        () async {
      final SocialLoginServiceImpl service = SocialLoginServiceImpl.instance;
      await ensureInitialised(service);

      final Stream<SocialLoginResult> stream =
          await service.signInWithFaceBook();

      expect(stream, isA<Stream<SocialLoginResult>>());
    });

    test("logOut completes without throwing", () async {
      final SocialLoginServiceImpl service = SocialLoginServiceImpl.instance;
      await ensureInitialised(service);

      await expectLater(service.logOut(), completes);
    });

    // Keep this last: onDispose closes the shared singleton's stream
    // controller, after which other tests could no longer add results.
    test("onDispose cancels the subscription and closes the stream", () async {
      final SocialLoginServiceImpl service = SocialLoginServiceImpl.instance;
      await ensureInitialised(service);

      await expectLater(service.onDispose(), completes);
    });
  });

  group("SocialLoginResult Tests", () {
    test("equals returns true for identical results", () {
      final SocialLoginResult a = SocialLoginResult(
        socialType: SocialMediaLoginType.google,
        accessToken: "token",
        refreshToken: "refresh",
      );
      final SocialLoginResult b = SocialLoginResult(
        socialType: SocialMediaLoginType.google,
        accessToken: "token",
        refreshToken: "refresh",
      );

      expect(a.equals(b), isTrue);
    });

    test("equals returns false for different results", () {
      final SocialLoginResult a = SocialLoginResult(
        socialType: SocialMediaLoginType.google,
        accessToken: "token",
      );
      final SocialLoginResult b = SocialLoginResult(
        socialType: SocialMediaLoginType.apple,
        accessToken: "other",
      );

      expect(a.equals(b), isFalse);
    });

    test("getSocialMediaLoginType maps known and unknown providers", () {
      expect(
        SocialMediaLoginType.getSocialMediaLoginType(name: "apple"),
        SocialMediaLoginType.apple,
      );
      expect(
        SocialMediaLoginType.getSocialMediaLoginType(name: "google"),
        SocialMediaLoginType.google,
      );
      expect(
        SocialMediaLoginType.getSocialMediaLoginType(name: "facebook"),
        SocialMediaLoginType.facebook,
      );
      expect(
        SocialMediaLoginType.getSocialMediaLoginType(name: "unknown"),
        SocialMediaLoginType.google,
      );
    });
  });
}
