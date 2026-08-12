import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/main_tab_page.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();

  group("MainTabPage Debug Tests", () {
    late HomePagerViewModel viewModel;

    setUp(() async {
      await setupTest();
    // The chat button is only offered when a number is configured; the live
    // config has none, so these tests take the same path a real user does.
    when(
      (locator<AppConfigurationService>() as MockAppConfigurationService)
          .isWhatsAppAvailable,
    ).thenReturn(false);

      onViewModelReadyMock(viewName: "HomePager");
      viewModel = locator<HomePagerViewModel>();
    });

    tearDown(() async {
      await tearDownTest();
    });

    test("debug properties", () {
      final MainTabPage widget = MainTabPage(viewModel: viewModel);

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> properties = builder.properties;

      final DiagnosticsProperty<HomePagerViewModel> viewModelProp =
          properties.firstWhere((DiagnosticsNode p) => p.name == "viewModel")
              as DiagnosticsProperty<HomePagerViewModel>;

      expect(viewModelProp.value, isNotNull);
      expect(viewModelProp.value, equals(viewModel));
    });
  });

  group("MainTabPage State Lifecycle Tests", () {
    late HomePagerViewModel viewModel;

    setUp(() async {
      await setupTest();
      onViewModelReadyMock(viewName: "HomePager");
      viewModel = locator<HomePagerViewModel>();
      when(viewModel.viewState).thenReturn(ViewState.idle);
      when(viewModel.isUserLoggedIn).thenReturn(true);
    });

    tearDown(() async {
      await tearDownTest();
    });
  });

  group("MainTabPage Unit Tests", () {
    late MainTabPage widget;
    late HomePagerViewModel viewModel;

    setUp(() async {
      await setupTest();
      viewModel = locator<HomePagerViewModel>();
      when(viewModel.isUserLoggedIn).thenReturn(true);
      widget = MainTabPage(viewModel: viewModel);
    });

    tearDown(() async {
      await tearDownTest();
    });

    test("constructor accepts key parameter", () {
      const Key testKey = ValueKey<String>("test_key");
      final MainTabPage widget = MainTabPage(
        key: testKey,
        viewModel: viewModel,
      );

      expect(widget.key, equals(testKey));
    });

    test("createState returns correct state type", () {
      final State<MainTabPage> state = widget.createState();
      expect(state.runtimeType.toString(), contains("MainTabPageState"));
    });

    test("widget type verification", () {
      expect(widget, isA<StatefulWidget>());
      expect(widget, isA<MainTabPage>());
    });

    test("viewModel property access", () {
      expect(widget.viewModel, isA<HomePagerViewModel>());
      expect(widget.viewModel, equals(viewModel));
    });
  });
}
