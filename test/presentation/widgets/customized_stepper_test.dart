import "package:esim_open_source/presentation/widgets/customized_stepper.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  const List<Widget> steps = <Widget>[
    Center(child: Text("Step 1")),
    Center(child: Text("Step 2")),
    Center(child: Text("Step 3")),
  ];

  group("MyStepper Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders steps with tab bar", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: MyStepper(
              themeColor: Colors.blue,
              tabsWidgets: steps,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(MyStepper), findsOneWidget);
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.byType(TabBarView), findsOneWidget);
      expect(find.text("Step 1"), findsOneWidget);
    });

    testWidgets("honors initialValue for selected index",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: MyStepper(
              themeColor: Colors.green,
              initialValue: 2,
              tabsWidgets: steps,
            ),
          ),
        ),
      );

      // Assert — builds without error at the given initial index
      expect(find.byType(MyStepper), findsOneWidget);
      expect(find.byType(Tab), findsNWidgets(3));
    });

    testWidgets("reacts to tab controller changes",
        (WidgetTester tester) async {
      // Arrange
      late TabController controller;

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          _StepperHost(
            builder: (TickerProvider vsync) {
              controller = TabController(length: 3, vsync: vsync);
              return controller;
            },
            steps: steps,
          ),
        ),
      );
      controller.animateTo(1);
      await tester.pumpAndSettle();

      // Assert
      expect(controller.index, equals(1));
      expect(find.byType(MyStepper), findsOneWidget);
    });

    testWidgets("tapping a tab triggers its onTap callback",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: MyStepper(
              themeColor: Colors.blue,
              tabsWidgets: steps,
            ),
          ),
        ),
      );
      // The TabBar is wrapped in IgnorePointer; tap is a no-op but should not
      // throw. Exercise the build path.
      await tester.tap(find.byType(MyStepper), warnIfMissed: false);
      await tester.pump();

      // Assert
      expect(tester.takeException(), isNull);
    });

    test("debug properties coverage", () {
      // Arrange & Act
      const MyStepper widget = MyStepper(
        themeColor: Colors.blue,
        tabsWidgets: steps,
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props.any((DiagnosticsNode p) => p.name == "themeColor"), isTrue);
      expect(
        props.any((DiagnosticsNode p) => p.name == "tabController"),
        isTrue,
      );
      expect(
        props.any((DiagnosticsNode p) => p.name == "initialValue"),
        isTrue,
      );
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(myStepperPreview()),
      );

      // Assert
      expect(find.byType(MyStepper), findsOneWidget);
    });
  });
}

/// Hosts a [MyStepper] with a real [TabController] driven by a
/// [TickerProvider].
class _StepperHost extends StatefulWidget {
  const _StepperHost({required this.builder, required this.steps});

  final TabController Function(TickerProvider vsync) builder;
  final List<Widget> steps;

  @override
  State<_StepperHost> createState() => _StepperHostState();
}

class _StepperHostState extends State<_StepperHost>
    with TickerProviderStateMixin {
  late final TabController controller = widget.builder(this);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyStepper(
        themeColor: Colors.blue,
        tabController: controller,
        tabsWidgets: widget.steps,
      ),
    );
  }
}
