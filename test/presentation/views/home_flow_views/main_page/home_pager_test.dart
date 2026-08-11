import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/presentation/extensions/stacked_services/custom_route_observer.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager.dart";
import "package:flutter/foundation.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();

  group("HomePager Unit Tests", () {
    setUp(() async {
      await setupTest();
    // The analytics-consent prompt reads this on first appearance. `false`
    // means "already answered", so these tests are not interrupted by it.
    when(
      (locator<AnalyticsService>() as MockAnalyticsService).analyticsConsent,
    ).thenReturn(false);

      onViewModelReadyMock(viewName: "HomePager");
      // onViewModelReadyMock(viewName: "MyEsimView");
      // onViewModelReadyMock(viewName: "ProfileView");
      when(locator<NavigationRouter>().isPageVisible("DataPlansView"))
          .thenReturn(true);
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("ViewModelBuilder creates and configures ViewModel correctly",
        (WidgetTester tester) async {
      final InAppRedirection redirection = InAppRedirection.cashback();

      await tester.pumpWidget(
        createTestableWidget(
          HomePager(redirection: redirection),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1000));
    });

    test("debug properties with redirection", () {
      final InAppRedirection redirection = InAppRedirection.cashback();
      final HomePager widget = HomePager(redirection: redirection);

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> properties = builder.properties;

      final DiagnosticsProperty<InAppRedirection?> redirectionProp =
          properties.firstWhere((DiagnosticsNode p) => p.name == "redirection")
              as DiagnosticsProperty<InAppRedirection?>;

      expect(redirectionProp.value, isNotNull);
      expect(redirectionProp.value, equals(redirection));
    });

    test("debug properties with null redirection", () {
      final HomePager widget = HomePager();

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> properties = builder.properties;

      final DiagnosticsProperty<InAppRedirection?> redirectionProp =
          properties.firstWhere((DiagnosticsNode p) => p.name == "redirection")
              as DiagnosticsProperty<InAppRedirection?>;

      expect(redirectionProp.value, isNull);
    });

    test("route name is correctly defined", () {
      expect(HomePager.routeName, equals("HomePager"));
    });

    test("constructor with no parameters", () {
      final HomePager widget = HomePager();
      expect(widget.redirection, isNull);
      expect(widget.key, isNull);
    });

    test("constructor with redirection parameter", () {
      final InAppRedirection redirection = InAppRedirection.cashback();
      final HomePager widget = HomePager(redirection: redirection);
      expect(widget.redirection, equals(redirection));
      expect(widget.key, isNull);
    });

    test("constructor with key parameter", () {
      const Key key = ValueKey<String>("test_key");
      final HomePager widget = HomePager(key: key);
      expect(widget.key, equals(key));
      expect(widget.redirection, isNull);
    });

    test("constructor with both parameters", () {
      const Key key = ValueKey<String>("test_key");
      final InAppRedirection redirection = InAppRedirection.cashback();
      final HomePager widget = HomePager(key: key, redirection: redirection);
      expect(widget.key, equals(key));
      expect(widget.redirection, equals(redirection));
    });
  });
}
