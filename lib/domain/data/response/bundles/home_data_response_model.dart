import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/regions_response_model.dart";

class HomeDataResponseModel {
  HomeDataResponseModel({
    this.regions,
    this.countries,
    this.globalBundles,
    this.cruiseBundles,
    this.version,
  });

  final List<RegionsResponseModel>? regions;
  final List<CountryResponseModel>? countries;
  final List<BundleResponseModel>? globalBundles;
  final List<BundleResponseModel>? cruiseBundles;
  String? version;
}
