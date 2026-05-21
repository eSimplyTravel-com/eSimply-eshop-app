// HapticFeedback (from flutter/services.dart) routes through the
// `flutter/platform` channel, which Flutter's test framework silently
// handles for unmocked invocations. No setup is required — this helper
// is retained as a no-op so existing test call sites stay valid.
class HapticHelperTest {
  static void implementHaptic() {}

  static void deInitHaptic() {}
}
