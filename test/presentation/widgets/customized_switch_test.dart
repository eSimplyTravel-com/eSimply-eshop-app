import "package:esim_open_source/presentation/widgets/customized_switch.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  Widget buildSwitch({
    required bool value,
    required void Function({required bool value}) onChanged,
    Color activeColor = Colors.blue,
    Color trackColor = Colors.grey,
    Color thumbColor = Colors.white,
  }) {
    return createTestableWidget(
      Scaffold(
        body: MySwitch(
          value: value,
          onChanged: onChanged,
          activeColor: activeColor,
          trackColor: trackColor,
          thumbColor: thumbColor,
        ),
      ),
    );
  }

  group("MySwitch Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
      debugDefaultTargetPlatformOverride = null;
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders Material Switch on Android",
        (WidgetTester tester) async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      await tester.pumpWidget(
        buildSwitch(value: false, onChanged: ({required bool value}) {}),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(Switch), findsOneWidget);
      expect(find.byType(CupertinoSwitch), findsNothing);
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets("renders CupertinoSwitch on iOS", (WidgetTester tester) async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      await tester.pumpWidget(
        buildSwitch(value: true, onChanged: ({required bool value}) {}),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(CupertinoSwitch), findsOneWidget);
      expect(find.byType(Switch), findsNothing);
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets("Material Switch reflects value and colors",
        (WidgetTester tester) async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      await tester.pumpWidget(
        buildSwitch(
          value: true,
          onChanged: ({required bool value}) {},
          activeColor: Colors.green,
          trackColor: Colors.red,
          thumbColor: Colors.yellow,
        ),
      );

      // Act
      await tester.pump();

      // Assert
      final Switch materialSwitch = tester.widget<Switch>(find.byType(Switch));
      expect(materialSwitch.value, isTrue);
      expect(materialSwitch.activeTrackColor, equals(Colors.green));
      expect(materialSwitch.inactiveTrackColor, equals(Colors.red));
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets("CupertinoSwitch reflects value state",
        (WidgetTester tester) async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      await tester.pumpWidget(
        buildSwitch(
          value: false,
          onChanged: ({required bool value}) {},
          activeColor: Colors.purple,
          trackColor: Colors.orange,
          thumbColor: Colors.pink,
        ),
      );

      // Act
      await tester.pump();

      // Assert
      final CupertinoSwitch cupertinoSwitch =
          tester.widget<CupertinoSwitch>(find.byType(CupertinoSwitch));
      expect(cupertinoSwitch.value, isFalse);
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets("Material Switch calls onChanged when toggled",
        (WidgetTester tester) async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      bool? changedValue;
      await tester.pumpWidget(
        buildSwitch(
          value: false,
          onChanged: ({required bool value}) => changedValue = value,
        ),
      );

      // Act
      await tester.pump();
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Assert
      expect(changedValue, isTrue);
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets("CupertinoSwitch calls onChanged when toggled",
        (WidgetTester tester) async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      bool? changedValue;
      await tester.pumpWidget(
        buildSwitch(
          value: false,
          onChanged: ({required bool value}) => changedValue = value,
        ),
      );

      // Act
      await tester.pump();
      await tester.tap(find.byType(CupertinoSwitch));
      await tester.pumpAndSettle();

      // Assert
      expect(changedValue, isTrue);
      debugDefaultTargetPlatformOverride = null;
    });

    test("handles property values", () {
      // Arrange & Act
      final MySwitch widget = MySwitch(
        value: true,
        onChanged: ({required bool value}) {},
        activeColor: Colors.blue,
        trackColor: Colors.grey,
        thumbColor: Colors.white,
      );

      // Assert
      expect(widget.value, isTrue);
      expect(widget.activeColor, equals(Colors.blue));
      expect(widget.trackColor, equals(Colors.grey));
      expect(widget.thumbColor, equals(Colors.white));
    });

    test("handles false value", () {
      // Arrange & Act
      final MySwitch widget = MySwitch(
        value: false,
        onChanged: ({required bool value}) {},
        activeColor: Colors.green,
        trackColor: Colors.red,
        thumbColor: Colors.yellow,
      );

      // Assert
      expect(widget.value, isFalse);
      expect(widget.activeColor, equals(Colors.green));
    });

    test("can be instantiated with a key", () {
      // Arrange
      const Key k = ValueKey<String>("test-key");

      // Act
      final MySwitch widget = MySwitch(
        key: k,
        value: false,
        onChanged: ({required bool value}) {},
        activeColor: Colors.blue,
        trackColor: Colors.grey,
        thumbColor: Colors.white,
      );

      // Assert
      expect(widget.key, equals(k));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      final MySwitch widget = MySwitch(
        value: true,
        onChanged: ({required bool value}) {},
        activeColor: Colors.red,
        trackColor: Colors.green,
        thumbColor: Colors.yellow,
      );

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props, isNotEmpty);
      for (final String name in <String>[
        "value",
        "onChanged",
        "activeColor",
        "trackColor",
        "thumbColor",
      ]) {
        expect(
          props.any((DiagnosticsNode prop) => prop.name == name),
          isTrue,
          reason: "expected '$name'",
        );
      }
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestableWidget(mySwitchPreview()));
      await tester.pump();

      // Assert
      expect(find.byType(MySwitch), findsOneWidget);
    });
  });
}
