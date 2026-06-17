import "package:esim_open_source/presentation/widgets/busy_overlay.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("BusyOverlay Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders child", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const BusyOverlay(
            child: Text("Content"),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(BusyOverlay), findsOneWidget);
      expect(find.text("Content"), findsOneWidget);
    });

    testWidgets("shows loading indicator when show is true",
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const BusyOverlay(
            show: true,
            title: "Loading",
            child: Text("Content"),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text("Loading"), findsOneWidget);
    });

    testWidgets("overlay hidden (opacity 0) when show is false",
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const BusyOverlay(
            child: Text("Content"),
          ),
        ),
      );
      await tester.pump();

      // Assert
      final Opacity opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, equals(0.0));
    });

    testWidgets("overlay visible (opacity 1) when show is true",
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const BusyOverlay(
            show: true,
            child: Text("Content"),
          ),
        ),
      );
      await tester.pump();

      // Assert
      final Opacity opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, equals(1.0));
    });

    test("handles default property values", () {
      // Arrange & Act
      const BusyOverlay widget = BusyOverlay(child: SizedBox());

      // Assert
      expect(widget.title, equals("Please wait..."));
      expect(widget.show, isFalse);
    });

    test("handles custom property values", () {
      // Arrange & Act
      const BusyOverlay widget = BusyOverlay(
        show: true,
        title: "Custom",
        child: SizedBox(),
      );

      // Assert
      expect(widget.title, equals("Custom"));
      expect(widget.show, isTrue);
    });

    test("can be instantiated with a key", () {
      // Arrange & Act
      const Key k = ValueKey<String>("overlay-key");
      const BusyOverlay widget = BusyOverlay(key: k, child: SizedBox());

      // Assert
      expect(widget.key, equals(k));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      const BusyOverlay widget = BusyOverlay(
        show: true,
        title: "Debug",
        child: SizedBox(),
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props, isNotEmpty);
      expect(props.any((DiagnosticsNode p) => p.name == "title"), isTrue);
      expect(props.any((DiagnosticsNode p) => p.name == "show"), isTrue);
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestableWidget(busyOverlayPreview()));
      await tester.pump();

      // Assert
      expect(find.byType(BusyOverlay), findsOneWidget);
    });
  });
}
