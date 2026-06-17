import "package:esim_open_source/presentation/widgets/sub_info_section.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("SubInfoSection Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders title and subtitle", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: SubInfoSection(
              title: "My Title",
              subTitle: "My Subtitle",
            ),
          ),
        ),
      );

      // Assert
      expect(find.text("My Title"), findsOneWidget);
      expect(find.text("My Subtitle"), findsOneWidget);
    });

    testWidgets("shows default info icon when showInfoIcon is true",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: SubInfoSection(title: "T"),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets("hides info icon when showInfoIcon is false",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: SubInfoSection(title: "T", showInfoIcon: false),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.info_outline), findsNothing);
    });

    testWidgets("uses custom info icon when provided",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: SubInfoSection(
              title: "T",
              infoIcon: Icon(Icons.star),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsNothing);
    });

    testWidgets("renders subtitle leading icon when provided",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: SubInfoSection(
              subTitle: "S",
              subTitleLeadingIcon: Icon(Icons.bolt),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.bolt), findsOneWidget);
    });

    testWidgets("invokes onPressed when tapped", (WidgetTester tester) async {
      // Arrange
      bool tapped = false;

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: SubInfoSection(
              title: "Tap me",
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.tap(find.text("Tap me"));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets("handles null title and subtitle", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(body: SubInfoSection()),
        ),
      );

      // Assert
      expect(find.byType(SubInfoSection), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    test("debug properties coverage", () {
      // Arrange & Act
      final SubInfoSection widget = SubInfoSection(
        title: "t",
        subTitle: "s",
        subTitleColor: const Color(0xFF000000),
        onPressed: () {},
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props.any((DiagnosticsNode p) => p.name == "title"), isTrue);
      expect(props.any((DiagnosticsNode p) => p.name == "subTitle"), isTrue);
      expect(
        props.any((DiagnosticsNode p) => p.name == "subTitleColor"),
        isTrue,
      );
      expect(
        props.any((DiagnosticsNode p) => p.name == "showInfoIcon"),
        isTrue,
      );
      expect(props.any((DiagnosticsNode p) => p.name == "onPressed"), isTrue);
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(subInfoSectionPreview()),
      );

      // Assert
      expect(find.byType(SubInfoSection), findsOneWidget);
      expect(find.text("Information"), findsOneWidget);
    });
  });
}
