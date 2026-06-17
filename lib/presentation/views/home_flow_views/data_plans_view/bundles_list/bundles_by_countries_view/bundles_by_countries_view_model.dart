import "dart:developer";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/domain/use_case/bundles/get_bundles_by_countries_use_case.dart";
import "package:esim_open_source/domain/use_case/bundles/get_bundles_by_region_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/navigation/esim_arguments.dart";

class BundlesByCountriesViewModel extends BaseModel {
  BundlesByCountriesViewModel(this.esimArguments);
  final EsimArguments esimArguments;

  final GetBundlesByRegionUseCase getBundlesByRegionUseCase =
      GetBundlesByRegionUseCase(locator());

  final GetBundlesByCountriesUseCase getBundlesByCountriesUseCase =
      GetBundlesByCountriesUseCase(locator());

  List<BundleResponseModel> _bundles = <BundleResponseModel>[];

  List<BundleResponseModel> get bundles => _bundles;

  List<CountryResponseModel> availableCountries = <CountryResponseModel>[];

  Future<void> onModelReady() async {
    if (esimArguments.type == EsimArgumentType.country) {
      getInitialAvailableCountries();
    }
    fetchBundles(esimArguments.id);
  }

  void getInitialAvailableCountries() {
    try {
      List<String> countryIDs = esimArguments.id.split(",");
      for (String countryID in countryIDs) {
        CountryResponseModel? country = countries?.firstWhere(
          (CountryResponseModel fetchedCountry) =>
              fetchedCountry.id == countryID,
        );
        if (country != null) {
          availableCountries.add(country);
          notifyListeners();
        }
      }
    } on Object catch (ex) {
      log(ex.toString());
      availableCountries = <CountryResponseModel>[];
    }
  }

  Future<void> fetchBundles(String countryCodes) async {
    _bundles = BundleResponseModel.getMockGlobalBundles();
    if (esimArguments.type == EsimArgumentType.region) {
      await _fetchRegionBundles();
    } else if (esimArguments.type == EsimArgumentType.country) {
      await _fetchCountryBundles(countryCodes);
    }
  }

  Future<void> _fetchRegionBundles() async {
    setViewState(ViewState.busy);

    Resource<List<BundleResponseModel>> response =
        await getBundlesByRegionUseCase
            .execute(BundleRegionParams(regionCode: esimArguments.id));

    await handleResponse(
      response,
      onSuccess: (Resource<List<BundleResponseModel>> response) async {
        _bundles = response.data ?? <BundleResponseModel>[];
      },
      onFailure: (Resource<List<BundleResponseModel>> response) async {
        handleError(response);
        _bundles = <BundleResponseModel>[];
      },
    );

    setViewState(ViewState.idle);
  }

  void addAvailableCountries(CountryResponseModel country) {
    availableCountries.add(country);
    notifyListeners();
  }

  void removeAvailableCountries(CountryResponseModel country) {
    availableCountries.remove(country);
    notifyListeners();
  }

  Future<void> _fetchCountryBundles(String countryCodes) async {
    setViewState(ViewState.busy);

    Resource<List<BundleResponseModel>> response =
        await getBundlesByCountriesUseCase
            .execute(GetBundlesByCountriesParams(countryCodes: countryCodes));

    await handleResponse(
      response,
      onSuccess: (Resource<List<BundleResponseModel>> response) async {
        _bundles = response.data ?? <BundleResponseModel>[];
      },
      onFailure: (Resource<List<BundleResponseModel>> response) async {
        handleError(response);
        _bundles = <BundleResponseModel>[];
      },
    );

    setViewState(ViewState.idle);
  }
}
