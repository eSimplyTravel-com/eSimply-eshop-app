import "package:esim_open_source/presentation/widgets/lockable_tab_bar.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("LockableTabController Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("animateTo moves when unlocked", (WidgetTester tester) async {
      // Arrange
      late LockableTabController controller;
      await tester.pumpWidget(
        createTestableWidget(
          _TabHost(
            builder: (TickerProvider vsync) {
              controller = LockableTabController(length: 3, vsync: vsync);
              return controller;
            },
          ),
        ),
      );

      // Act
      controller.isLocked = false;
      controller.animateTo(2);
      await tester.pumpAndSettle();

      // Assert
      expect(controller.index, equals(2));
    });

    testWidgets("animateTo is blocked when locked",
        (WidgetTester tester) async {
      // Arrange
      late LockableTabController controller;
      await tester.pumpWidget(
        createTestableWidget(
          _TabHost(
            builder: (TickerProvider vsync) {
              controller = LockableTabController(length: 3, vsync: vsync);
              return controller;
            },
          ),
        ),
      );

      // Act
      controller.isLocked = true;
      controller.animateTo(2);
      await tester.pumpAndSettle();

      // Assert — stays on initial index
      expect(controller.index, equals(0));
    });

    testWidgets("isLocked defaults to false", (WidgetTester tester) async {
      // Arrange
      late LockableTabController controller;
      await tester.pumpWidget(
        createTestableWidget(
          _TabHost(
            builder: (TickerProvider vsync) {
              controller = LockableTabController(length: 2, vsync: vsync);
              return controller;
            },
          ),
        ),
      );

      // Assert
      expect(controller.isLocked, isFalse);
    });
  });
}

/// Hosts a [LockableTabController] inside a [TickerProvider] so it can drive
/// real animations during the test.
class _TabHost extends StatefulWidget {
  const _TabHost({required this.builder});

  final LockableTabController Function(TickerProvider vsync) builder;

  @override
  State<_TabHost> createState() => _TabHostState();
}

class _TabHostState extends State<_TabHost> with TickerProviderStateMixin {
  late final LockableTabController controller = widget.builder(this);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller,
        children: List<Widget>.generate(
          controller.length,
          (int i) => Text("Tab $i"),
        ),
      ),
    );
  }
}
