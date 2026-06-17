import "package:esim_open_source/presentation/widgets/customized_dropdown.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("MyDropDown Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
      debugDefaultTargetPlatformOverride = null;
    });

    tearDown(() async {
      await tearDownTest();
    });

    group("Android", () {
      testWidgets("renders DropdownButton with selected value",
          (WidgetTester tester) async {
        // Arrange
        debugDefaultTargetPlatformOverride = TargetPlatform.android;

        // Act
        await tester.pumpWidget(
          createTestableWidget(
            Scaffold(
              body: MyDropDown(
                valueList: const <String>["A", "B", "C"],
                selectedValueIndex: 0,
                onChanged: (int index, String? value) {},
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(DropdownButton<String>), findsOneWidget);
        expect(find.text("A"), findsOneWidget);

        // Reset before invariants run.
        debugDefaultTargetPlatformOverride = null;
      });

      testWidgets("invokes onChanged when item selected",
          (WidgetTester tester) async {
        // Arrange
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        int idx = -1;
        String? val;

        // Act
        await tester.pumpWidget(
          createTestableWidget(
            Scaffold(
              body: MyDropDown(
                valueList: const <String>["A", "B", "C"],
                selectedValueIndex: 0,
                isExpanded: true,
                onChanged: (int index, String? value) {
                  idx = index;
                  val = value;
                },
              ),
            ),
          ),
        );
        await tester.tap(find.byType(DropdownButton<String>));
        await tester.pumpAndSettle();
        await tester.tap(find.text("C").last);
        await tester.pumpAndSettle();

        // Assert
        expect(idx, equals(2));
        expect(val, equals("C"));

        debugDefaultTargetPlatformOverride = null;
      });

      testWidgets("shows empty hint when no selection",
          (WidgetTester tester) async {
        // Arrange
        debugDefaultTargetPlatformOverride = TargetPlatform.android;

        // Act
        await tester.pumpWidget(
          createTestableWidget(
            Scaffold(
              body: MyDropDown(
                valueList: const <String>["A", "B"],
                emptyWidget: const Text("Choose"),
                onChanged: (int index, String? value) {},
              ),
            ),
          ),
        );

        // Assert
        expect(find.text("Choose"), findsOneWidget);

        debugDefaultTargetPlatformOverride = null;
      });
    });

    group("iOS", () {
      testWidgets("renders selected value row", (WidgetTester tester) async {
        // Arrange
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

        // Act
        await tester.pumpWidget(
          createTestableWidget(
            Scaffold(
              body: MyDropDown(
                valueList: const <String>["A", "B", "C"],
                selectedValueIndex: 1,
                onChanged: (int index, String? value) {},
              ),
            ),
          ),
        );
        await tester.pump();

        // Assert
        expect(find.text("B"), findsOneWidget);
        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);

        debugDefaultTargetPlatformOverride = null;
      });

      testWidgets("renders empty row when no selection",
          (WidgetTester tester) async {
        // Arrange
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

        // Act
        await tester.pumpWidget(
          createTestableWidget(
            Scaffold(
              body: MyDropDown(
                valueList: const <String>["A", "B"],
                emptyWidget: const Text("Pick one"),
                onChanged: (int index, String? value) {},
              ),
            ),
          ),
        );
        await tester.pump();

        // Assert
        expect(find.text("Pick one"), findsOneWidget);

        debugDefaultTargetPlatformOverride = null;
      });

      testWidgets("tapping opens action sheet and selecting invokes onChanged",
          (WidgetTester tester) async {
        // Arrange
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        int idx = -1;
        String? val;

        // Act
        await tester.pumpWidget(
          createTestableWidget(
            Scaffold(
              body: MyDropDown(
                valueList: const <String>["A", "B", "C"],
                selectedValueIndex: 0,
                cupertinoSheetTitle: "Choose option",
                onChanged: (int index, String? value) {
                  idx = index;
                  val = value;
                },
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.tap(find.byType(GestureDetector).first);
        await tester.pumpAndSettle();

        // The action sheet is shown with the title and options.
        expect(find.text("Choose option"), findsOneWidget);
        expect(find.byType(CupertinoActionSheetAction), findsWidgets);

        // Select option "B".
        await tester.tap(find.widgetWithText(CupertinoActionSheetAction, "B"));
        await tester.pumpAndSettle();

        // Assert
        expect(idx, equals(1));
        expect(val, equals("B"));

        debugDefaultTargetPlatformOverride = null;
      });

      testWidgets("triggerActionSheet opens sheet automatically",
          (WidgetTester tester) async {
        // Arrange
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

        // Act
        await tester.pumpWidget(
          createTestableWidget(
            Scaffold(
              body: MyDropDown(
                valueList: const <String>["A", "B"],
                selectedValueIndex: 0,
                triggerActionSheet: true,
                onChanged: (int index, String? value) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert — sheet is shown automatically via post-frame callback.
        expect(find.byType(CupertinoActionSheet), findsOneWidget);

        // Dismiss via cancel to clean up the route.
        await tester.tap(find.byType(CupertinoActionSheetAction).last);
        await tester.pumpAndSettle();

        debugDefaultTargetPlatformOverride = null;
      });
    });

    test("debug properties coverage", () {
      // Arrange & Act
      final MyDropDown widget = MyDropDown(
        valueList: const <String>["A"],
        onChanged: (int index, String? value) {},
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      for (final String name in <String>[
        "valueList",
        "selectedValueIndex",
        "cupertinoSheetTitle",
        "isExpanded",
        "onChanged",
        "triggerActionSheet",
      ]) {
        expect(
          props.any((DiagnosticsNode p) => p.name == name),
          isTrue,
          reason: "missing $name",
        );
      }
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(myDropDownPreview()),
      );
      await tester.pump();

      // Assert
      expect(find.byType(MyDropDown), findsOneWidget);
    });
  });
}
