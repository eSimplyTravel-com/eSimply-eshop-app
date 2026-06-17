import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/bundles_by_countries_view/bundles_by_countries_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/bundles_by_countries_view/bundles_by_countries_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/navigation/esim_arguments.dart";
import "package:flutter/foundation.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../../helpers/view_helper.dart";
import "../../../../../../helpers/view_model_helper.dart";

void main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "BundlesByCountriesView");
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  testWidgets("renders basic structure", (WidgetTester tester) async {
    final EsimArguments args =
        const EsimArguments(id: "1", name: "test", type: "region");
    final BundlesByCountriesViewModel vm = BundlesByCountriesViewModel(args);

    final BundlesByCountriesView view = BundlesByCountriesView(
      viewModel: vm,
      onBundleSelected: (BundleResponseModel bundle) {},
      horizontalPadding: 10,
    );

    await tester.pumpWidget(
      createTestableWidget(
        view,
      ),
    );

    await tester.pump();
  });

  testWidgets("renders basic structure with empty bundles",
      (WidgetTester tester) async {
    final EsimArguments args =
        const EsimArguments(id: "1", name: "test", type: "region");
    final BundlesByCountriesViewModel vm = BundlesByCountriesViewModel(args);

    final BundlesByCountriesView view = BundlesByCountriesView(
      viewModel: vm,
      onBundleSelected: (BundleResponseModel bundle) {},
      horizontalPadding: 10,
    );

    await tester.pumpWidget(
      createTestableWidget(
        view,
      ),
    );

    await tester.pump();
  });

  test("debug properties coverage", () {
    final EsimArguments args =
        const EsimArguments(id: "1", name: "test", type: "region");
    final BundlesByCountriesViewModel vm = BundlesByCountriesViewModel(args);

    final BundlesByCountriesView view = BundlesByCountriesView(
      viewModel: vm,
      onBundleSelected: (BundleResponseModel bundle) {},
      horizontalPadding: 10,
    );

    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    view.debugFillProperties(builder);
  });
}
