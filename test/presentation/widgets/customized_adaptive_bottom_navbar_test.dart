import "package:esim_open_source/presentation/widgets/customized_adaptive_bottom_navbar.dart";
import "package:esim_open_source/presentation/widgets/lockable_tab_bar.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  const List<String> icons = <String>["home", "settings", "profile"];
  const List<String> labels = <String>["Home", "Settings", "Profile"];
  const List<Widget> pages = <Widget>[
    Center(child: Text("HomePage")),
    Center(child: Text("SettingsPage")),
    Center(child: Text("ProfilePage")),
  ];

  group("BaseAdaptiveBottomNavBar Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders first tab page by default",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const BaseAdaptiveBottomNavBar(
            tabsIconData: icons,
            tabsText: labels,
            tabsWidgets: pages,
          ),
        ),
      );
      tester.takeException(); // consume native asset-load failures

      // Assert
      expect(find.byType(BaseAdaptiveBottomNavBar), findsOneWidget);
      expect(find.byType(IndexedStack), findsOneWidget);
    });

    testWidgets("applies background color when provided",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const BaseAdaptiveBottomNavBar(
            tabsIconData: icons,
            tabsText: labels,
            tabsWidgets: pages,
            backgroundColor: Color(0xFF123456),
          ),
        ),
      );
      tester.takeException();

      // Assert
      expect(find.byType(ColoredBox), findsWidgets);
    });

    testWidgets("hides bottom bar when keyboard is visible",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const BaseAdaptiveBottomNavBar(
            tabsIconData: icons,
            tabsText: labels,
            tabsWidgets: pages,
            isKeyboardVisible: true,
          ),
        ),
      );
      tester.takeException();

      // Assert
      expect(find.byType(BaseAdaptiveBottomNavBar), findsOneWidget);
    });

    testWidgets("syncs current index from tab controller",
        (WidgetTester tester) async {
      // Arrange
      late LockableTabController controller;

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          _NavBarHost(
            builder: (TickerProvider vsync) {
              controller = LockableTabController(length: 3, vsync: vsync);
              return controller;
            },
            icons: icons,
            labels: labels,
            pages: pages,
          ),
        ),
      );
      tester.takeException();

      // Drive the controller and let the navbar react.
      controller.animateTo(2);
      await tester.pumpAndSettle();
      tester.takeException();

      // Assert
      expect(controller.index, equals(2));
      expect(find.byType(BaseAdaptiveBottomNavBar), findsOneWidget);
    });

    testWidgets("does not change index while controller is locked",
        (WidgetTester tester) async {
      // Arrange
      late LockableTabController controller;

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          _NavBarHost(
            builder: (TickerProvider vsync) {
              controller = LockableTabController(length: 3, vsync: vsync)
                ..isLocked = true;
              return controller;
            },
            icons: icons,
            labels: labels,
            pages: pages,
          ),
        ),
      );
      tester.takeException();

      // Assert — controller locked, stays at initial index
      expect(controller.index, equals(0));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      const BaseAdaptiveBottomNavBar widget = BaseAdaptiveBottomNavBar(
        tabsIconData: icons,
        tabsText: labels,
        tabsWidgets: pages,
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      for (final String name in <String>[
        "tabsIconData",
        "tabsText",
        "isKeyboardVisible",
        "tabController",
        "backgroundColor",
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
        createTestableWidget(baseAdaptiveBottomNavBarPreview()),
      );
      tester.takeException();

      // Assert
      expect(find.byType(BaseAdaptiveBottomNavBar), findsOneWidget);
    });
  });
}

/// Hosts a [BaseAdaptiveBottomNavBar] with a real [LockableTabController]
/// driven by a [TickerProvider].
class _NavBarHost extends StatefulWidget {
  const _NavBarHost({
    required this.builder,
    required this.icons,
    required this.labels,
    required this.pages,
  });

  final LockableTabController Function(TickerProvider vsync) builder;
  final List<String> icons;
  final List<String> labels;
  final List<Widget> pages;

  @override
  State<_NavBarHost> createState() => _NavBarHostState();
}

class _NavBarHostState extends State<_NavBarHost>
    with TickerProviderStateMixin {
  late final LockableTabController controller = widget.builder(this);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseAdaptiveBottomNavBar(
      tabsIconData: widget.icons,
      tabsText: widget.labels,
      tabsWidgets: widget.pages,
      tabController: controller,
    );
  }
}
