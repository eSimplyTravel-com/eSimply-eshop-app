import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_container.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("BottomSheetContainer Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders child and close button", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: BottomSheetContainer(
              onCloseTap: () {},
              child: const Text("Content"),
            ),
          ),
        ),
      );
      tester.takeException(); // consume any asset-load failure from close icon

      // Assert
      expect(find.byType(BottomSheetContainer), findsOneWidget);
      expect(find.byType(BottomSheetCloseButton), findsOneWidget);
      expect(find.text("Content"), findsOneWidget);
    });

    testWidgets("invokes onCloseTap when close button tapped",
        (WidgetTester tester) async {
      // Arrange
      bool closed = false;

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: BottomSheetContainer(
              onCloseTap: () => closed = true,
              child: const Text("Content"),
            ),
          ),
        ),
      );
      tester.takeException();
      await tester.tap(find.byType(InkWell), warnIfMissed: false);
      // MyCardWrap close button fires onTap after a 300ms withDelay.
      await tester.pump(const Duration(milliseconds: 350));

      // Assert
      expect(closed, isTrue);
    });

    testWidgets("uses custom close icon when provided",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: BottomSheetContainer(
              onCloseTap: () {},
              closeIcon: const Icon(Icons.close),
              child: const Text("Content"),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    test("debug properties coverage", () {
      // Arrange & Act
      final BottomSheetContainer widget = BottomSheetContainer(
        onCloseTap: () {},
        child: const SizedBox(),
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props.any((DiagnosticsNode p) => p.name == "onCloseTap"), isTrue);
      expect(
        props.any((DiagnosticsNode p) => p.name == "backgroundColor"),
        isTrue,
      );
      expect(
        props.any((DiagnosticsNode p) => p.name == "cornerRadius"),
        isTrue,
      );
      expect(
        props.any((DiagnosticsNode p) => p.name == "verticalPadding"),
        isTrue,
      );
      expect(
        props.any((DiagnosticsNode p) => p.name == "horizontalPadding"),
        isTrue,
      );
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(bottomSheetContainerPreview()),
      );
      tester.takeException();

      // Assert
      expect(find.byType(BottomSheetContainer), findsOneWidget);
      expect(find.text("Sample bottom sheet content"), findsOneWidget);
    });
  });
}
