import "package:esim_open_source/presentation/widgets/custom_tab_view.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  const List<Tab> tabs = <Tab>[
    Tab(text: "Local"),
    Tab(text: "Regional"),
    Tab(text: "Global"),
  ];

  List<Widget> scrollableChildren() => <Widget>[
        ListView(
          children: List<Widget>.generate(
            30,
            (int i) => SizedBox(height: 40, child: Text("L$i")),
          ),
        ),
        const Text("Regional plans"),
        const Text("Global plans"),
      ];

  group("DataPlansTabView Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders tabs and first tab view child",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: Column(
              children: <Widget>[
                DataPlansTabView(
                  tabs: tabs,
                  tabViewsChildren: <Widget>[
                    Text("Local plans"),
                    Text("Regional plans"),
                    Text("Global plans"),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(DataPlansTabView), findsOneWidget);
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.text("Local"), findsOneWidget);
      expect(find.text("Local plans"), findsOneWidget);
    });

    testWidgets("tapping a tab invokes onTabChange",
        (WidgetTester tester) async {
      // Arrange
      int? changedTo;

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: Column(
              children: <Widget>[
                DataPlansTabView(
                  tabs: tabs,
                  onTabChange: (int newIndex) => changedTo = newIndex,
                  tabViewsChildren: const <Widget>[
                    Text("Local plans"),
                    Text("Regional plans"),
                    Text("Global plans"),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text("Regional"));
      await tester.pumpAndSettle();

      // Assert
      expect(changedTo, equals(1));
    });

    testWidgets("renders childWidget when not collapsable",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: Column(
              children: <Widget>[
                DataPlansTabView(
                  tabs: tabs,
                  childWidget: Text("Header child"),
                  tabViewsChildren: <Widget>[
                    Text("Local plans"),
                    Text("Regional plans"),
                    Text("Global plans"),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text("Header child"), findsOneWidget);
    });

    testWidgets("scrollable physics when isScrollable is true",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: Column(
              children: <Widget>[
                DataPlansTabView(
                  tabs: tabs,
                  isScrollable: true,
                  tabViewsChildren: <Widget>[
                    Text("Local plans"),
                    Text("Regional plans"),
                    Text("Global plans"),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert
      final TabBarView view =
          tester.widget<TabBarView>(find.byType(TabBarView));
      expect(view.physics, isNot(isA<NeverScrollableScrollPhysics>()));
    });

    testWidgets("underlined indicator uses null custom indicator",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: Column(
              children: <Widget>[
                DataPlansTabView(
                  tabs: tabs,
                  isIndicatorUnderlined: true,
                  tabViewsChildren: <Widget>[
                    Text("Local plans"),
                    Text("Regional plans"),
                    Text("Global plans"),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(DataPlansTabView), findsOneWidget);
    });

    testWidgets("collapsable child hides on scroll and shows on scroll back",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: Column(
              children: <Widget>[
                DataPlansTabView(
                  tabs: tabs,
                  isChildCollapsable: true,
                  childWidget:
                      const SizedBox(height: 100, child: Text("Child")),
                  tabViewsChildren: scrollableChildren(),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      final _DataPlansTabViewStateAccess access = _DataPlansTabViewStateAccess(
        tester,
      );
      expect(access.state, equals(ChildWidgetTabState.show));

      // Scroll down past the threshold → hide.
      await tester.drag(find.text("L0"), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(access.state, equals(ChildWidgetTabState.hidden));

      // Scroll back up → show with animation.
      await tester.drag(find.byType(ListView), const Offset(0, 500));
      await tester.pumpAndSettle();
      expect(access.state, equals(ChildWidgetTabState.showWithAnimation));
    });

    testWidgets("didUpdateWidget animates to initial index",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: Column(
              children: <Widget>[
                DataPlansTabView(
                  key: ValueKey<String>("tabview"),
                  tabs: tabs,
                  tabViewsChildren: <Widget>[
                    Text("Local plans"),
                    Text("Regional plans"),
                    Text("Global plans"),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      // Rebuild same widget type to trigger didUpdateWidget.
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: Column(
              children: <Widget>[
                DataPlansTabView(
                  key: ValueKey<String>("tabview"),
                  tabs: tabs,
                  initialIndex: 2,
                  tabViewsChildren: <Widget>[
                    Text("Local plans"),
                    Text("Regional plans"),
                    Text("Global plans"),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(DataPlansTabView), findsOneWidget);
    });

    test("widget debug properties coverage", () {
      // Arrange & Act
      const DataPlansTabView widget = DataPlansTabView(
        tabs: tabs,
        tabViewsChildren: <Widget>[Text("a"), Text("b"), Text("c")],
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      for (final String name in <String>[
        "height",
        "borderRadius",
        "backGroundColor",
        "selectedTabColor",
        "unSelectedTabColor",
        "selectedLabelColor",
        "unSelectedLabelColor",
        "isScrollable",
        "horizontalPadding",
        "tabsSpacing",
        "verticalPadding",
        "initialIndex",
        "onTabChange",
        "isIndicatorUnderlined",
        "unSelectedTabTextStyle",
        "selectedTabTextStyle",
        "isChildCollapsable",
      ]) {
        expect(
          props.any((DiagnosticsNode p) => p.name == name),
          isTrue,
          reason: "missing $name",
        );
      }
    });

    testWidgets("state debug properties coverage", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: Column(
              children: <Widget>[
                DataPlansTabView(
                  tabs: tabs,
                  tabViewsChildren: <Widget>[
                    Text("Local plans"),
                    Text("Regional plans"),
                    Text("Global plans"),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      // Act
      final State<DataPlansTabView> state =
          tester.state(find.byType(DataPlansTabView));
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      state.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(
        props.any((DiagnosticsNode p) => p.name == "childWidgetTabState"),
        isTrue,
      );
      expect(
        props.any((DiagnosticsNode p) => p.name == "scrollController"),
        isTrue,
      );
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(dataPlansTabViewPreview()),
      );
      await tester.pump();

      // Assert
      expect(find.byType(DataPlansTabView), findsOneWidget);
    });
  });
}

/// Reads the private state's [ChildWidgetTabState] via its diagnostics.
class _DataPlansTabViewStateAccess {
  _DataPlansTabViewStateAccess(this.tester);

  final WidgetTester tester;

  ChildWidgetTabState get state {
    final State<DataPlansTabView> s =
        tester.state(find.byType(DataPlansTabView));
    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    s.debugFillProperties(builder);
    final DiagnosticsNode node = builder.properties.firstWhere(
      (DiagnosticsNode p) => p.name == "childWidgetTabState",
    );
    final EnumProperty<ChildWidgetTabState> prop =
        node as EnumProperty<ChildWidgetTabState>;
    return prop.value!;
  }
}
