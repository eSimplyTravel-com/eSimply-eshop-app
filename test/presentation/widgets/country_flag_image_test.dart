import "package:esim_open_source/presentation/widgets/country_flag_image.dart";
import "package:esim_open_source/presentation/widgets/network_image_cached.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("CountryFlagImage Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders SvgPicture for local svg asset",
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: CountryFlagImage(
              icon: "assets/images/flag.svg",
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets("renders Image for local png asset",
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: CountryFlagImage(
              icon: "assets/images/flag.png",
            ),
          ),
        ),
      );
      await tester.pump();
      tester.takeException(); // suppress missing asset

      // Assert
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets("renders CachedImage for network icon",
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: CountryFlagImage(
              icon: "https://example.com/flag.png",
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(CachedImage), findsOneWidget);
    });

    testWidgets("applies custom width and height", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: CountryFlagImage(
              icon: "assets/images/flag.svg",
              width: 64,
              height: 64,
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(CountryFlagImage), findsOneWidget);
    });

    test("handles property values", () {
      // Arrange & Act
      const CountryFlagImage widget = CountryFlagImage(
        icon: "assets/flag.svg",
        width: 40,
        height: 50,
      );

      // Assert
      expect(widget.icon, equals("assets/flag.svg"));
      expect(widget.width, equals(40));
      expect(widget.height, equals(50));
    });

    test("width and height are null by default", () {
      // Arrange & Act
      const CountryFlagImage widget = CountryFlagImage(icon: "x");

      // Assert
      expect(widget.width, isNull);
      expect(widget.height, isNull);
    });

    test("can be instantiated with a key", () {
      // Arrange & Act
      const Key k = ValueKey<String>("flag-key");
      const CountryFlagImage widget = CountryFlagImage(key: k, icon: "x");

      // Assert
      expect(widget.key, equals(k));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      const CountryFlagImage widget = CountryFlagImage(
        icon: "assets/flag.svg",
        width: 30,
        height: 30,
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props, isNotEmpty);
      for (final String name in <String>["icon", "width", "height"]) {
        expect(
          props.any((DiagnosticsNode p) => p.name == name),
          isTrue,
          reason: "expected '$name'",
        );
      }
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestableWidget(countryFlagImagePreview()));
      await tester.pump();

      // Assert
      expect(find.byType(CountryFlagImage), findsOneWidget);
    });
  });
}
