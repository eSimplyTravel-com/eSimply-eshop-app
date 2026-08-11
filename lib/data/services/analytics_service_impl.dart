import "dart:developer";

import "package:app_tracking_transparency/app_tracking_transparency.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/domain/repository/services/dynamic_linking_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:facebook_app_events/facebook_app_events.dart";
import "package:firebase_analytics/firebase_analytics.dart";

class AnalyticsServiceImpl extends AnalyticsService {
  // Both stay false until a stored consent says otherwise. The platform
  // defaults (Info.plist / AndroidManifest) keep the SDKs themselves quiet;
  // these two only gate the events we log by hand.
  bool _useFirebaseAnalytics = false;
  bool _useFacebookAnalytics = false;

  final FacebookAppEvents _facebookAppEvents = FacebookAppEvents();
  final FirebaseAnalytics _firebaseAppEvents = FirebaseAnalytics.instance;

  static AnalyticsServiceImpl? _instance;

  static AnalyticsServiceImpl get instance {
    if (_instance == null) {
      _instance = AnalyticsServiceImpl();
      log("Initialize Analytics Logging Service");
    }
    return _instance!;
  }

  LocalStorageService get _localStorage => locator<LocalStorageService>();

  @override
  bool? get analyticsConsent {
    // LocalStorageService is a `registerSingletonAsync` with no `allReady()`
    // await anywhere, and configure() runs before runApp — so this can be the
    // first sync access to a singleton that has not signalled ready, which
    // GetIt answers with a throw. Failing closed keeps analytics off rather
    // than taking the app down before its first frame.
    try {
      return _localStorage.getBool(LocalStorageKeys.analyticsConsent);
    } on Object catch (ex) {
      log("Could not read stored analytics consent, treating as unasked: $ex");
      return null;
    }
  }

  /// Reads any stored choice and applies it. Called at start-up.
  ///
  /// It deliberately does NOT ask for anything: no analytics consent prompt and
  /// no ATT prompt. Privacy §3 promises analytics runs on consent
  /// (GDPR Art. 6(1)(a)), and until the user has answered, everything stays
  /// off — which the platform defaults already guarantee at the SDK level.
  ///
  /// The `firebaseAnalytics` / `facebookAnalytics` arguments are a build-time
  /// kill switch, not a consent signal: passing `false` keeps a provider off
  /// even for a user who consented.
  @override
  Future<void> configure({
    bool firebaseAnalytics = true,
    bool facebookAnalytics = true,
  }) async {
    final bool granted = analyticsConsent ?? false;

    _useFirebaseAnalytics = firebaseAnalytics && granted;
    _useFacebookAnalytics = facebookAnalytics && granted;

    log(
      "Analytics configured — stored consent: ${analyticsConsent ?? "not asked"}, "
      "Firebase: $_useFirebaseAnalytics, Facebook: $_useFacebookAnalytics",
    );

    await _applyToSdks(granted: granted);
  }

  @override
  Future<void> setAnalyticsConsent({required bool granted}) async {
    try {
      await _localStorage.setBool(
        LocalStorageKeys.analyticsConsent,
        value: granted,
      );
    } on Object catch (ex) {
      // A choice we cannot persist must not silently become a permanent one.
      log("Could not store analytics consent: $ex");
      rethrow;
    }

    _useFirebaseAnalytics = granted;
    _useFacebookAnalytics = granted;

    log("Analytics consent set to $granted");

    await _applyToSdks(granted: granted);
  }

  Future<void> _applyToSdks({required bool granted}) async {
    try {
      await _firebaseAppEvents.setAnalyticsCollectionEnabled(granted);
      await _firebaseAppEvents.setConsent(
        analyticsStorageConsentGranted: granted,
        adStorageConsentGranted: granted,
        adUserDataConsentGranted: granted,
        adPersonalizationSignalsConsentGranted: granted,
      );
      await _facebookAppEvents.setAutoLogAppEventsEnabled(granted);
    } on Object catch (ex) {
      log("Failed to apply analytics consent: $ex");
    }

    if (granted) {
      await _requestTrackingAuthorization();
    } else {
      // Withdrawal has to be as easy as consent, so a refusal actively turns
      // advertiser tracking back off rather than merely stopping new events.
      try {
        await _facebookAppEvents.setAdvertiserTracking(enabled: false);
      } on Object catch (ex) {
        log("Failed to disable advertiser tracking: $ex");
      }
    }
  }

  /// ATT is Apple's cross-app tracking permission, not GDPR consent — Apple
  /// treats the two as separate. It is only reached once analytics consent has
  /// been given, so the user is never met by the system prompt first.
  Future<void> _requestTrackingAuthorization() async {
    try {
      final TrackingStatus status =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      log("ATT status: $status");

      TrackingStatus resolved = status;
      if (status == TrackingStatus.notDetermined) {
        resolved = await AppTrackingTransparency.requestTrackingAuthorization();
        log("ATT permission result: $resolved");
      }

      await _facebookAppEvents.setAdvertiserTracking(
        enabled: resolved == TrackingStatus.authorized,
      );
    } on Object catch (ex) {
      log("ATT request failed: $ex");
    }

    // Branch ships its own ATT call, which used to run from main() before the
    // user had been asked anything. iOS only ever shows the dialog once, so
    // this now just hands Branch the status the user already chose.
    try {
      await locator<DynamicLinkingService>().requestTrackingAuthorization();
    } on Object catch (ex) {
      log("Branch tracking authorization failed: $ex");
    }
  }

  @override
  Future<void> logEvent({
    required AnalyticEvent event,
  }) async {
    log("Logging event of type ${event.eventName}");
    if (_useFirebaseAnalytics) {
      logFireBaseEvent(event: event);
    }

    if (_useFacebookAnalytics) {
      logFaceBookEvent(event: event);
    }
  }

  @override
  Future<void> setUserId(String? hashedEmail) async {
    if (_useFirebaseAnalytics) {
      await _firebaseAppEvents.setUserId(id: hashedEmail);
      log("Analytics user ID set");
    }
  }

  Future<void> logFireBaseEvent({
    required AnalyticEvent event,
  }) async {
    await _firebaseAppEvents.logEvent(
      name: event.eventName,
      parameters: event.parameters,
    );
  }

  Future<void> logFaceBookEvent({
    required AnalyticEvent event,
  }) async {
    try {
      await _facebookAppEvents.logEvent(
        name: event.eventName,
        parameters: event.parameters,
      );
    } on Object catch (ex) {
      log("Error exception: $ex");
    }
  }
}
