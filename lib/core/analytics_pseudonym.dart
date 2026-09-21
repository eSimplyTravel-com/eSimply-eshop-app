import "dart:convert";

import "package:crypto/crypto.dart";

/// Analytics events must never carry a raw email address: Google Analytics bans personal data in
/// event parameters, and the App Store privacy label would have to declare it.
///
/// Returns a stable pseudonym instead, or an empty string when nobody is signed in.
String analyticsUserIdOf(String email) {
  final String normalised = email.trim().toLowerCase();
  if (normalised.isEmpty) {
    return "";
  }
  return sha256.convert(utf8.encode(normalised)).toString();
}
