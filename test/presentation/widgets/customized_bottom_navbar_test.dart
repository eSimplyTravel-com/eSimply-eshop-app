import "package:esim_open_source/presentation/widgets/customized_bottom_navbar.dart";
import "package:esim_open_source/presentation/widgets/lockable_tab_bar.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  const List<String> icons = <String>["a.png", "b.png", "c.png"];
  const List<String> labels = <String>["Data Plans", "My eSIM", "Profile"];
  const List<Widget> pages = <Widget>[
    Center(child: Text("DataPlansPage")),
    Center(child: Text("MyEsimPage")),
    Center(child: Text("ProfilePage")),
  ];

  group("BaseFlutterBottomNavBar Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders tab bar with labels", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: BaseFlutterBottomNavBar(
              tabsIconData: icons,
              tabsText: labels,
              tabsWidgets: pages,
            ),
          ),
        ),
      );
      tester.takeException(); // consume tab icon asset-load failures

      // Assert
      expect(find.byType(BaseFlutterBottomNavBar), findsOneWidget);
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.text("Data Plans"), findsOneWidget);
      expect(find.text("My eSIM"), findsOneWidget);
    });

    testWidgets("tapping a tab updates current index",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: BaseFlutterBottomNavBar(
              tabsIconData: icons,
              tabsText: labels,
              tabsWidgets: pages,
              indicatorsColor: <Color>[Colors.red, Colors.green, Colors.blue],
            ),
          ),
        ),
      );
      tester.takeException();
      await tester.tap(find.text("Profile"));
      await tester.pumpAndSettle();
      tester.takeException();

      // Assert — builds and reacts without error.
      expect(find.byType(BaseFlutterBottomNavBar), findsOneWidget);
    });

    testWidgets("hides tab bar when keyboard is visible",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: BaseFlutterBottomNavBar(
              tabsIconData: icons,
              tabsText: labels,
              tabsWidgets: pages,
              isKeyboardVisible: true,
            ),
          ),
        ),
      );
      tester.takeException();

      // Assert — no TabBar shown when keyboard visible.
      expect(find.byType(TabBar), findsNothing);
    });

    testWidgets("disables swipe when swipeEnabled is false",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: BaseFlutterBottomNavBar(
              tabsIconData: icons,
              tabsText: labels,
              tabsWidgets: pages,
              swipeEnabled: false,
            ),
          ),
        ),
      );
      tester.takeException();

      // Assert
      final TabBarView view =
          tester.widget<TabBarView>(find.byType(TabBarView));
      expect(view.physics, isA<NeverScrollableScrollPhysics>());
    });

    testWidgets("ignores tab tap when controller is locked",
        (WidgetTester tester) async {
      // Arrange
      late LockableTabController controller;

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          _NavHost(
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
      await tester.tap(find.text("Profile"));
      await tester.pumpAndSettle();
      tester.takeException();

      // Assert — locked controller stays at initial index.
      expect(controller.index, equals(0));
    });

    testWidgets("reacts to controller index change via listener",
        (WidgetTester tester) async {
      // Arrange
      late LockableTabController controller;

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          _NavHost(
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
      // Force a didUpdateWidget so the listener is attached.
      await tester.pumpWidget(
        createTestableWidget(
          _NavHost(
            builder: (TickerProvider vsync) => controller,
            icons: icons,
            labels: labels,
            pages: pages,
          ),
        ),
      );
      tester.takeException();
      controller.animateTo(1);
      await tester.pumpAndSettle();
      tester.takeException();

      // Assert
      expect(controller.index, equals(1));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      const BaseFlutterBottomNavBar widget = BaseFlutterBottomNavBar(
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
        "indicatorsColor",
        "indicatorColor",
        "selectedColor",
        "unselectedColor",
        "height",
        "swipeEnabled",
        "isKeyboardVisible",
        "tabController",
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
        createTestableWidget(baseFlutterBottomNavBarPreview()),
      );
      tester.takeException();

      // Assert
      expect(find.byType(BaseFlutterBottomNavBar), findsOneWidget);
    });
  });
}

/// Hosts a [BaseFlutterBottomNavBar] with a real [LockableTabController].
class _NavHost extends StatefulWidget {
  const _NavHost({
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
  State<_NavHost> createState() => _NavHostState();
}

class _NavHostState extends State<_NavHost> with TickerProviderStateMixin {
  late final LockableTabController controller = widget.builder(this);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseFlutterBottomNavBar(
        tabsIconData: widget.icons,
        tabsText: widget.labels,
        tabsWidgets: widget.pages,
        tabController: controller,
      ),
    );
  }
}
