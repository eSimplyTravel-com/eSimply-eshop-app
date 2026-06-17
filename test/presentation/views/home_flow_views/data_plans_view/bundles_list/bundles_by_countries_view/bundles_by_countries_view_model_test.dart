import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/bundles_by_countries_view/bundles_by_countries_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/navigation/esim_arguments.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../../helpers/view_helper.dart";
import "../../../../../../helpers/view_model_helper.dart";

Future<void> main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "BundlesByCountriesView");
  });

  test("basic coverage", () async {
    final EsimArguments args =
        const EsimArguments(id: "1", name: "test", type: "region");
    final BundlesByCountriesViewModel vm = BundlesByCountriesViewModel(args);
    

    await vm.onModelReady();
    vm.getInitialAvailableCountries();
    await vm.fetchBundles("codes");
    vm..addAvailableCountries(CountryResponseModel(id: "1", country: "Test"))
    ..removeAvailableCountries(CountryResponseModel(id: "1", country: "Test"));
  });

  // Future<void> tearDown() async {
  //   await tearDownTest();
  // }
}
