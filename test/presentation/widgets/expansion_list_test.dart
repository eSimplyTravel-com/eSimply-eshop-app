import "package:esim_open_source/presentation/widgets/expansion_list.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("ExpansionList Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders title and items", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: ExpansionList<String>(
              title: "Pick",
              items: const <String>["One", "Two"],
              onItemSelected: (_) {},
            ),
          ),
        ),
      );

      // Assert — collapsed list only lays out the header item.
      expect(find.byType(ExpansionList<String>), findsOneWidget);
      expect(find.text("Pick"), findsOneWidget);
      expect(find.byType(ExpansionListItem), findsAtLeastNWidgets(1));
    });

    testWidgets("toggles expansion when header tapped",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: ExpansionList<String>(
              title: "Pick",
              items: const <String>["One", "Two"],
              onItemSelected: (_) {},
            ),
          ),
        ),
      );
      final ExpansionListState state =
          tester.state(find.byType(ExpansionList<String>));
      expect(state.expanded, isFalse);

      await tester.tap(find.text("Pick"));
      await tester.pumpAndSettle();

      // Assert
      expect(state.expanded, isTrue);
    });

    testWidgets("selecting an item invokes onItemSelected",
        (WidgetTester tester) async {
      // Arrange
      dynamic selected;

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: ExpansionList<String>(
              title: "Pick",
              items: const <String>["One", "Two"],
              onItemSelected: (dynamic value) => selected = value,
            ),
          ),
        ),
      );
      // Expand first
      await tester.tap(find.text("Pick"));
      await tester.pumpAndSettle();
      // Tap an option
      await tester.tap(find.text("Two"));
      await tester.pumpAndSettle();

      // Assert
      expect(selected, equals("Two"));
      final ExpansionListState state =
          tester.state(find.byType(ExpansionList<String>));
      expect(state.selectedValue, equals("Two"));
    });

    testWidgets("smallVersion uses reduced heights",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: ExpansionList<String>(
              title: "Pick",
              items: const <String>["One"],
              smallVersion: true,
              onItemSelected: (_) {},
            ),
          ),
        ),
      );

      // Assert
      final ExpansionListState state =
          tester.state(find.byType(ExpansionList<String>));
      expect(state.collapsedHeight, equals(40));
    });

    test("widget debug properties coverage", () {
      // Arrange & Act
      final ExpansionList<String> widget = ExpansionList<String>(
        title: "t",
        items: const <String>["a"],
        onItemSelected: (_) {},
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props.any((DiagnosticsNode p) => p.name == "items"), isTrue);
      expect(props.any((DiagnosticsNode p) => p.name == "title"), isTrue);
      expect(
        props.any((DiagnosticsNode p) => p.name == "onItemSelected"),
        isTrue,
      );
      expect(
        props.any((DiagnosticsNode p) => p.name == "smallVersion"),
        isTrue,
      );
    });

    testWidgets("state debug properties coverage", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: ExpansionList<String>(
              title: "t",
              items: const <String>["a"],
              onItemSelected: (_) {},
            ),
          ),
        ),
      );

      // Act
      final ExpansionListState state =
          tester.state(find.byType(ExpansionList<String>));
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      state.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      for (final String name in <String>[
        "startingHeight",
        "expandedHeight",
        "expanded",
        "selectedValue",
        "collapsedHeight",
      ]) {
        expect(
          props.any((DiagnosticsNode p) => p.name == name),
          isTrue,
          reason: "missing $name",
        );
      }
    });

    group("ExpansionListItem", () {
      testWidgets("shows arrow when showArrow is true",
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestableWidget(
            Scaffold(
              body: ExpansionListItem(
                title: "Item",
                showArrow: true,
                onTap: () {},
              ),
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
        expect(find.text("Item"), findsOneWidget);
      });

      testWidgets("hides arrow when showArrow is false",
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestableWidget(
            Scaffold(
              body: ExpansionListItem(
                title: "Item",
                onTap: () {},
              ),
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.arrow_drop_down), findsNothing);
      });

      testWidgets("invokes onTap when tapped", (WidgetTester tester) async {
        // Arrange
        bool tapped = false;

        // Act
        await tester.pumpWidget(
          createTestableWidget(
            Scaffold(
              body: ExpansionListItem(
                title: "Item",
                onTap: () => tapped = true,
              ),
            ),
          ),
        );
        await tester.tap(find.byType(ExpansionListItem));
        await tester.pump();

        // Assert
        expect(tapped, isTrue);
      });

      test("debug properties coverage", () {
        // Arrange & Act
        final ExpansionListItem widget = ExpansionListItem(
          title: "t",
          showArrow: true,
          onTap: () {},
        );
        final DiagnosticPropertiesBuilder builder =
            DiagnosticPropertiesBuilder();
        widget.debugFillProperties(builder);

        // Assert
        final List<DiagnosticsNode> props = builder.properties;
        expect(props.any((DiagnosticsNode p) => p.name == "onTap"), isTrue);
        expect(props.any((DiagnosticsNode p) => p.name == "title"), isTrue);
        expect(
          props.any((DiagnosticsNode p) => p.name == "showArrow"),
          isTrue,
        );
        expect(
          props.any((DiagnosticsNode p) => p.name == "smallVersion"),
          isTrue,
        );
      });
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(expansionListPreview()),
      );

      // Assert
      expect(find.byType(ExpansionList<String>), findsOneWidget);
      expect(find.text("Select an option"), findsOneWidget);
    });
  });
}
