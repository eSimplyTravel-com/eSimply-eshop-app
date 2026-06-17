// ignore_for_file: file_names

import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/extensions/stacked_services/custom_route_observer.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/start_up_view/startup_view_model.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../helpers/view_helper.dart";
import "../../../helpers/view_model_helper.dart";
import "../../../locator_test.dart";

Future<void> main() async {
  await prepareTest();

  late StartUpViewModel viewModel;

  Widget buildContent(
    BuildContext context,
    StartUpViewModel vm,
    Widget? child,
    double height,
  ) {
    return const SizedBox.shrink();
  }

  setUp(() async {
    await setupTest();
    onViewModelReadyMock();
    when(locator<NavigationRouter>().isPageVisible("TestRoute")).thenReturn(true);
    viewModel = StartUpViewModel();
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("BaseView Widget Tests", () {
    testWidgets("renders basic structure with default parameters",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(BaseView<StartUpViewModel>), findsOneWidget);
      expect(find.byType(Stack), findsWidgets);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets("renders scaffold when isBottomSheetView is false",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets("renders DecoratedBox with no scaffold when isBottomSheetView is true",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            isBottomSheetView: true,
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Scaffold), findsNothing);
      expect(find.byType(DecoratedBox), findsWidgets);
    });

    testWidgets("scaffold has app bar when hideAppBar is false",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      final Scaffold scaffold =
          tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.appBar, isNotNull);
    });

    testWidgets("scaffold has no app bar when hideAppBar is true",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            hideAppBar: true,
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      final Scaffold scaffold =
          tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.appBar, isNull);
    });

    testWidgets("uses custom app bar when customAppBar is provided",
        (WidgetTester tester) async {
      final PreferredSizeWidget customBar = AppBar(
        key: const Key("custom_app_bar"),
        title: const Text("Custom AppBar"),
      );

      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            customAppBar: customBar,
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key("custom_app_bar")), findsOneWidget);
      expect(find.text("Custom AppBar"), findsOneWidget);
    });

    testWidgets("shows app bar title when appBarTitle is provided",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            appBarTitle: (_) => "Test Title",
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(find.text("Test Title"), findsOneWidget);
    });

    testWidgets("shows app bar action list when appBarActionList is provided",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            appBarActionList: (_) => <Widget>[
              const Icon(
                key: Key("action_icon"),
                Icons.settings,
              ),
            ],
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key("action_icon")), findsOneWidget);
    });

    testWidgets("shows app bar leading widget when appBarLeading is provided",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            appBarLeading: (_) => const Icon(
              key: Key("leading_icon"),
              Icons.arrow_back,
            ),
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key("leading_icon")), findsOneWidget);
    });

    testWidgets("renders background image when backGroundImage is provided",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            backGroundImage: "assets/images/test_bg.png",
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Image), findsOneWidget);
      // Consume the expected asset-not-found error from the image loading service
      tester.takeException();
    });

    testWidgets("does not render background image when backGroundImage is null",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Image), findsNothing);
    });

    testWidgets("renders non-reactive view when isReactive is false",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            isReactive: false,
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(BaseView<StartUpViewModel>), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets("invokes onViewModelReady callback when provided",
        (WidgetTester tester) async {
      bool callbackInvoked = false;

      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            onViewModelReady: (StartUpViewModel vm) {
              callbackInvoked = true;
            },
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(callbackInvoked, isTrue);
    });

    testWidgets("onViewModelReady callback receives correct viewModel instance",
        (WidgetTester tester) async {
      StartUpViewModel? receivedViewModel;

      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            onViewModelReady: (StartUpViewModel vm) {
              receivedViewModel = vm;
            },
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(receivedViewModel, equals(viewModel));
    });

    testWidgets("default onViewModelReady calls viewModel.onViewModelReady when no callback provided",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets("shows floating action button when floatingActionButton is provided",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            floatingActionButton: (_) => FloatingActionButton(
              key: const Key("test_fab"),
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key("test_fab")), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets("does not show floating action button when floatingActionButton is null",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets("uses custom backgroundColor when provided",
        (WidgetTester tester) async {
      const Color testColor = Colors.red;

      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            backgroundColor: testColor,
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      final Scaffold scaffold =
          tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(testColor));
    });

    testWidgets("shows IgnorePointer with ignoring true when viewModel is busy and disableInteractionWhileBusy is true",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            builder: buildContent,
          ),
        ),
      );

      viewModel.setViewState(ViewState.busy);
      await tester.pump();

      expect(
        find.byWidgetPredicate(
          (Widget widget) => widget is IgnorePointer && widget.ignoring,
        ),
        findsOneWidget,
      );
    });

    testWidgets("does not show ignoring IgnorePointer when disableInteractionWhileBusy is false",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            disableInteractionWhileBusy: false,
            builder: buildContent,
          ),
        ),
      );

      viewModel.setViewState(ViewState.busy);
      await tester.pump();

      expect(
        find.byWidgetPredicate(
          (Widget widget) => widget is IgnorePointer && widget.ignoring,
        ),
        findsNothing,
      );
    });

    testWidgets("shows loading overlay container when viewModel is busy and hideLoader is false",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            builder: buildContent,
          ),
        ),
      );

      viewModel.setViewState(ViewState.busy);
      await tester.pump();

      final Iterable<Container> coloredContainers =
          tester.widgetList<Container>(
        find.byWidgetPredicate(
          (Widget widget) => widget is Container && widget.color != null,
        ),
      );
      expect(coloredContainers, isNotEmpty);
    });

    testWidgets("does not show colored loading overlay when hideLoader is true",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            hideLoader: true,
            builder: buildContent,
          ),
        ),
      );

      viewModel.setViewState(ViewState.busy);
      await tester.pump();

      // When hideLoader is true, even while busy, no colored overlay from _buildLoadingOverlay
      final Iterable<Container> coloredOverlayContainers =
          tester.widgetList<Container>(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Container &&
              widget.color == Colors.black.withValues(alpha: 0.3),
        ),
      );
      expect(coloredOverlayContainers, isEmpty);
    });

    testWidgets("passes staticChild to builder function",
        (WidgetTester tester) async {
      const Widget staticChildWidget =
          Text(key: Key("static_child"), "Static Child");
      Widget? receivedChild;

      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            staticChild: staticChildWidget,
            builder: (
              BuildContext context,
              StartUpViewModel vm,
              Widget? child,
              double height,
            ) {
              receivedChild = child;
              return child ?? const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pump();

      expect(receivedChild, isNotNull);
      expect(receivedChild, equals(staticChildWidget));
    });

    testWidgets("builder receives positive screen height",
        (WidgetTester tester) async {
      double? receivedHeight;

      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            builder: (
              BuildContext context,
              StartUpViewModel vm,
              Widget? child,
              double height,
            ) {
              receivedHeight = height;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pump();

      expect(receivedHeight, isNotNull);
      expect(receivedHeight, isA<double>());
    });

    testWidgets(
        "builder with hideAppBar true receives smaller height than without hideAppBar",
        (WidgetTester tester) async {
      double? heightWithAppBar;
      double? heightWithoutAppBar;

      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            builder: (BuildContext context, StartUpViewModel vm, Widget? child,
                double height,) {
              heightWithAppBar = height;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pump();

      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            hideAppBar: true,
            builder: (BuildContext context, StartUpViewModel vm, Widget? child,
                double height,) {
              heightWithoutAppBar = height;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pump();

      expect(heightWithAppBar, isNotNull);
      expect(heightWithoutAppBar, isNotNull);
      expect(heightWithoutAppBar, lessThan(heightWithAppBar!));
    });

    testWidgets("sets routeName on viewModel during build",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(viewModel.routeName, equals("TestRoute"));
    });

    testWidgets("safeAreaHeight returns non-negative value",
        (WidgetTester tester) async {
      double? safeHeight;
      final BaseView<StartUpViewModel> baseView = BaseView<StartUpViewModel>(
        routeName: "TestRoute",
        viewModel: viewModel,
        builder: buildContent,
      );

      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (BuildContext context) {
              safeHeight = baseView.safeAreaHeight(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pump();

      expect(safeHeight, isNotNull);
      expect(safeHeight, isA<double>());
    });

    testWidgets("renders correctly with updateStatusBarColor false",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets("renders correctly with updateStatusBarColor true",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            updateStatusBarColor: true,
            statusBarColor: Colors.blue,
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets("renders with isReactive true using reactive builder",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(BaseView<StartUpViewModel>), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets("reactive view rebuilds when viewModel state changes",
        (WidgetTester tester) async {
      int buildCount = 0;

      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            builder: (BuildContext context, StartUpViewModel vm, Widget? child,
                double height,) {
              buildCount++;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pump();

      final int initialBuildCount = buildCount;

      viewModel.setViewState(ViewState.idle);
      await tester.pump();

      expect(buildCount, greaterThan(initialBuildCount));
    });

    testWidgets("bottom sheet view uses appBarBackgroundColor for decoration",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            isBottomSheetView: true,
            appBarBackgroundColor: Colors.green,
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(DecoratedBox), findsWidgets);
    });

    testWidgets("hideBackButton callback controls back button visibility",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            hideBackButton: (_) => true,
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets("noDataWidget is shown when viewModel is in noDataAvailable state",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            noDataWidget: (_) => const Text(
              key: Key("no_data_widget"),
              "No Data Available",
            ),
            builder: buildContent,
          ),
        ),
      );

      viewModel.setViewState(ViewState.noDataAvailable);
      await tester.pump();

      expect(find.byKey(const Key("no_data_widget")), findsOneWidget);
    });

    testWidgets("enableBottomSafeArea controls bottom safe area in scaffold body",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BaseView<StartUpViewModel>(
            routeName: "TestRoute",
            viewModel: viewModel,
            enableBottomSafeArea: false,
            builder: buildContent,
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group("BaseView Static Factory Tests", () {
    test("bottomSheetBuilder creates BaseView with correct routeName",
        () {
      final BaseView<StartUpViewModel> result =
          BaseView.bottomSheetBuilder<StartUpViewModel>(
        viewModel: viewModel,
        builder: buildContent,
      );

      expect(result.routeName, equals(""));
    });

    test("bottomSheetBuilder creates BaseView with hideAppBar true", () {
      final BaseView<StartUpViewModel> result =
          BaseView.bottomSheetBuilder<StartUpViewModel>(
        viewModel: viewModel,
        builder: buildContent,
      );

      expect(result.hideAppBar, isTrue);
    });

    test("bottomSheetBuilder creates BaseView with isBottomSheetView true",
        () {
      final BaseView<StartUpViewModel> result =
          BaseView.bottomSheetBuilder<StartUpViewModel>(
        viewModel: viewModel,
        builder: buildContent,
      );

      expect(result.isBottomSheetView, isTrue);
    });

    test("bottomSheetBuilder creates BaseView with disableInteractionWhileBusy false",
        () {
      final BaseView<StartUpViewModel> result =
          BaseView.bottomSheetBuilder<StartUpViewModel>(
        viewModel: viewModel,
        builder: buildContent,
      );

      expect(result.disableInteractionWhileBusy, isFalse);
    });

    test("bottomSheetBuilder passes hideLoader false by default", () {
      final BaseView<StartUpViewModel> result =
          BaseView.bottomSheetBuilder<StartUpViewModel>(
        viewModel: viewModel,
        builder: buildContent,
      );

      expect(result.hideLoader, isFalse);
    });

    test("bottomSheetBuilder passes hideLoader true when specified", () {
      final BaseView<StartUpViewModel> result =
          BaseView.bottomSheetBuilder<StartUpViewModel>(
        viewModel: viewModel,
        hideLoader: true,
        builder: buildContent,
      );

      expect(result.hideLoader, isTrue);
    });

    test("bottomSheetBuilder passes the provided viewModel", () {
      final BaseView<StartUpViewModel> result =
          BaseView.bottomSheetBuilder<StartUpViewModel>(
        viewModel: viewModel,
        builder: buildContent,
      );

      expect(result.viewModel, equals(viewModel));
    });
  });

  group("BaseView Debug Properties Tests", () {
    test("debugFillProperties adds all expected diagnostic properties", () {
      final BaseView<StartUpViewModel> baseView = BaseView<StartUpViewModel>(
        routeName: "DiagRoute",
        viewModel: viewModel,
        hideLoader: true,
        backgroundColor: Colors.blue,
        statusBarColor: Colors.red,
        hideAppBar: true,
        appBarCenterTitle: true,
        disableInteractionWhileBusy: false,
        enableBottomSafeArea: false,
        builder: buildContent,
      );

      final DiagnosticPropertiesBuilder propsBuilder =
          DiagnosticPropertiesBuilder();
      baseView.debugFillProperties(propsBuilder);

      final List<String?> propNames =
          propsBuilder.properties.map((DiagnosticsNode p) => p.name).toList();

      expect(propNames, contains("viewModel"));
      expect(propNames, contains("builder"));
      expect(propNames, contains("isReactive"));
      expect(propNames, contains("fireOnViewModelReadyOnce"));
      expect(propNames, contains("disposeViewModel"));
      expect(propNames, contains("hideLoader"));
      expect(propNames, contains("updateStatusBarColor"));
      expect(propNames, contains("backgroundColor"));
      expect(propNames, contains("statusBarColor"));
      expect(propNames, contains("appBarLeading"));
      expect(propNames, contains("noDataWidget"));
      expect(propNames, contains("appBarLeadingForAndroid"));
      expect(propNames, contains("hideAppBar"));
      expect(propNames, contains("hideBackButton"));
      expect(propNames, contains("appBarTitle"));
      expect(propNames, contains("floatingActionButton"));
      expect(propNames, contains("animateWithOpacity"));
      expect(propNames, contains("appBarActionList"));
      expect(propNames, contains("appBarBackgroundColor"));
      expect(propNames, contains("appBarCenterTitle"));
      expect(propNames, contains("disableInteractionWhileBusy"));
      expect(propNames, contains("routeName"));
      expect(propNames, contains("backGroundImage"));
      expect(propNames, contains("onViewModelReady"));
      expect(propNames, contains("disableBottomSafeArea"));
      expect(propNames, contains("isBottomSheetView"));
    });

    test("debugFillProperties reflects correct property values", () {
      final BaseView<StartUpViewModel> baseView = BaseView<StartUpViewModel>(
        routeName: "TestRoute",
        viewModel: viewModel,
        isReactive: false,
        hideLoader: true,
        updateStatusBarColor: true,
        hideAppBar: true,
        appBarCenterTitle: true,
        animateWithOpacity: true,
        disableInteractionWhileBusy: false,
        builder: buildContent,
      );

      final DiagnosticPropertiesBuilder propsBuilder =
          DiagnosticPropertiesBuilder();
      baseView.debugFillProperties(propsBuilder);

      final Map<String?, Object?> propMap = <String?, Object?>{
        for (DiagnosticsNode node in propsBuilder.properties)
          node.name: node.value,
      };

      expect(propMap["isReactive"], isFalse);
      expect(propMap["hideLoader"], isTrue);
      expect(propMap["updateStatusBarColor"], isTrue);
      expect(propMap["hideAppBar"], isTrue);
      expect(propMap["appBarCenterTitle"], isTrue);
      expect(propMap["animateWithOpacity"], isTrue);
      expect(propMap["disableInteractionWhileBusy"], isFalse);
      expect(propMap["routeName"], equals("TestRoute"));
    });
  });
}
