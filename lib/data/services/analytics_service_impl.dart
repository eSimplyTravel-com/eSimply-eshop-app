import "dart:developer";

import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:firebase_analytics/firebase_analytics.dart";

class AnalyticsServiceImpl extends AnalyticsService {
  // Stays false until a stored consent says otherwise. The platform defaults
  // (Info.plist / AndroidManifest) keep the SDK itself quiet; this only gates
  // the events we log by hand.
  bool _useFirebaseAnalytics = false;

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
  /// It deliberately does NOT ask for anything. Privacy §3 promises analytics
  /// runs on consent (GDPR Art. 6(1)(a)), and until the user has answered,
  /// everything stays off — which the platform defaults already guarantee at
  /// the SDK level.
  ///
  /// The `firebaseAnalytics` argument is a build-time kill switch, not a
  /// consent signal: passing `false` keeps analytics off even for a user who
  /// consented.
  @override
  Future<void> configure({
    bool firebaseAnalytics = true,
  }) async {
    final bool granted = analyticsConsent ?? false;

    _useFirebaseAnalytics = firebaseAnalytics && granted;

    log(
      "Analytics configured — stored consent: ${analyticsConsent ?? "not asked"}, "
      "Firebase: $_useFirebaseAnalytics",
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
    } on Object catch (ex) {
      log("Failed to apply analytics consent: $ex");
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
}
