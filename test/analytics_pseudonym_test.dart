import "package:esim_open_source/core/analytics_pseudonym.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("an email never appears in the analytics id", () {
    final String id = analyticsUserIdOf("Thomas@Example.com");
    expect(id.contains("@"), isFalse);
    expect(id.contains("thomas"), isFalse);
    expect(id.length, 64);
  });

  test("the same person gets the same id regardless of case or spacing", () {
    expect(
      analyticsUserIdOf(" thomas@example.com "),
      analyticsUserIdOf("Thomas@Example.com"),
    );
  });

  test("different people get different ids", () {
    expect(
      analyticsUserIdOf("a@example.com") == analyticsUserIdOf("b@example.com"),
      isFalse,
    );
  });

  test("a signed-out user sends nothing", () {
    expect(analyticsUserIdOf(""), "");
    expect(analyticsUserIdOf("   "), "");
  });
}
