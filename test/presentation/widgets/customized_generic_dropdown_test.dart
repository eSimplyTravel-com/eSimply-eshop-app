import "package:esim_open_source/presentation/widgets/customized_generic_dropdown.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("MyGenericDropDown Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders dropdown with items", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: MyGenericDropDown<String>(
              valueList: const <String>["A", "B", "C"],
              selectedValueIndex: 0,
              onChanged: (int index, String? value) {},
              buildItem: (BuildContext context, String? value) =>
                  Text(value ?? ""),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(DropdownButton<String>), findsOneWidget);
      expect(find.text("A"), findsOneWidget);
    });

    testWidgets("shows null value when selectedValueIndex is out of range",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: MyGenericDropDown<String>(
              valueList: const <String>["A", "B"],
              emptyWidget: const Text("Pick one"),
              onChanged: (int index, String? value) {},
              buildItem: (BuildContext context, String? value) =>
                  Text(value ?? ""),
            ),
          ),
        ),
      );

      // Assert — hint shown because no value selected
      expect(find.text("Pick one"), findsOneWidget);
    });

    testWidgets("invokes onChanged when a new item is selected",
        (WidgetTester tester) async {
      // Arrange
      int selectedIndex = -1;
      String? selectedValue;

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: MyGenericDropDown<String>(
              valueList: const <String>["A", "B", "C"],
              selectedValueIndex: 0,
              isExpanded: true,
              onChanged: (int index, String? value) {
                selectedIndex = index;
                selectedValue = value;
              },
              buildItem: (BuildContext context, String? value) =>
                  Text(value ?? ""),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      // Tap the last "C" entry in the opened menu.
      await tester.tap(find.text("C").last);
      await tester.pumpAndSettle();

      // Assert
      expect(selectedIndex, equals(2));
      expect(selectedValue, equals("C"));
    });

    testWidgets("uses custom underline when provided",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: MyGenericDropDown<String>(
              valueList: const <String>["A"],
              selectedValueIndex: 0,
              underline: const SizedBox(key: Key("underline")),
              onChanged: (int index, String? value) {},
              buildItem: (BuildContext context, String? value) =>
                  Text(value ?? ""),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byKey(const Key("underline")), findsOneWidget);
    });

    test("debug properties coverage", () {
      // Arrange & Act
      final MyGenericDropDown<String> widget = MyGenericDropDown<String>(
        valueList: const <String>["A"],
        onChanged: (int index, String? value) {},
        buildItem: (BuildContext context, String? value) => const SizedBox(),
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      for (final String name in <String>[
        "valueList",
        "selectedValueIndex",
        "isExpanded",
        "dropdownColor",
        "itemHeight",
        "onChanged",
        "buildItem",
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
        createTestableWidget(myGenericDropDownPreview()),
      );

      // Assert
      expect(find.byType(MyGenericDropDown<String>), findsOneWidget);
      expect(find.text("Apple"), findsOneWidget);
    });
  });
}
