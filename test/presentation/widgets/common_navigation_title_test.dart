import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("CommonNavigationTitle Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders title text", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: CommonNavigationTitle(
              navigationTitle: "My Title",
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      );
      await tester.pump();
      tester.takeException(); // suppress missing back-icon asset

      // Assert
      expect(find.text("My Title"), findsOneWidget);
    });

    testWidgets("contains a back GestureDetector", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: CommonNavigationTitle(
              navigationTitle: "Back",
              textStyle: const TextStyle(fontSize: 14),
            ),
          ),
        ),
      );
      await tester.pump();
      tester.takeException();

      // Assert
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    test("handles property values", () {
      // Arrange & Act
      const TextStyle style = TextStyle(fontSize: 20);
      final CommonNavigationTitle widget = CommonNavigationTitle(
        navigationTitle: "Title",
        textStyle: style,
      );

      // Assert
      expect(widget.navigationTitle, equals("Title"));
      expect(widget.textStyle, equals(style));
      expect(widget.navigationService, isNotNull);
    });

    test("can be instantiated with a key", () {
      // Arrange & Act
      const Key k = ValueKey<String>("nav-key");
      final CommonNavigationTitle widget = CommonNavigationTitle(
        key: k,
        navigationTitle: "Title",
        textStyle: const TextStyle(),
      );

      // Assert
      expect(widget.key, equals(k));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      final CommonNavigationTitle widget = CommonNavigationTitle(
        navigationTitle: "Debug",
        textStyle: const TextStyle(fontSize: 16),
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props, isNotEmpty);
      for (final String name in <String>[
        "navigationTitle",
        "textStyle",
        "navigationService",
      ]) {
        expect(
          props.any((DiagnosticsNode p) => p.name == name),
          isTrue,
          reason: "expected '$name'",
        );
      }
    });
  });
}
