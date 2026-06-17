import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("BottomSheetCloseButton Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders default close icon", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: BottomSheetCloseButton(onTap: () {}),
          ),
        ),
      );
      await tester.pump();
      tester.takeException(); // suppress missing asset in test bundle

      // Assert
      expect(find.byType(BottomSheetCloseButton), findsOneWidget);
    });

    testWidgets("renders custom close icon when provided",
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: BottomSheetCloseButton(
              onTap: () {},
              closeIcon: const Icon(Icons.close),
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    test("handles property values", () {
      // Arrange & Act
      final BottomSheetCloseButton widget = BottomSheetCloseButton(
        onTap: () {},
        closeIcon: const Icon(Icons.close),
      );

      // Assert
      expect(widget.onTap, isNotNull);
      expect(widget.closeIcon, isA<Icon>());
    });

    test("closeIcon is null by default", () {
      // Arrange & Act
      final BottomSheetCloseButton widget = BottomSheetCloseButton(
        onTap: () {},
      );

      // Assert
      expect(widget.closeIcon, isNull);
    });

    test("can be instantiated with a key", () {
      // Arrange & Act
      const Key k = ValueKey<String>("close-key");
      final BottomSheetCloseButton widget = BottomSheetCloseButton(
        key: k,
        onTap: () {},
      );

      // Assert
      expect(widget.key, equals(k));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      final BottomSheetCloseButton widget = BottomSheetCloseButton(
        onTap: () {},
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props, isNotEmpty);
      expect(props.any((DiagnosticsNode p) => p.name == "onTap"), isTrue);
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(bottomSheetCloseButtonPreview()),
      );
      await tester.pump();
      tester.takeException();

      // Assert
      expect(find.byType(BottomSheetCloseButton), findsOneWidget);
    });
  });
}
