import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/regions_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/bundles/home_data_response_model.dart";

class HomeDataResponseModelDto {
  HomeDataResponseModelDto({
    this.regions,
    this.countries,
    this.globalBundles,
    this.cruiseBundles,
    this.version,
  });

  // Factory method to create an instance from JSON
  factory HomeDataResponseModelDto.fromJson(Map<String, dynamic> json) {
    return HomeDataResponseModelDto(
      regions: json["regions"] != null
          ? List<RegionsResponseModelDto>.from(
              (json["regions"] as List<dynamic>)
                  .map((dynamic item) => RegionsResponseModelDto.fromJson(item)),
            )
          : null,
      countries: json["countries"] != null
          ? List<CountryResponseModelDto>.from(
              (json["countries"] as List<dynamic>)
                  .map((dynamic item) => CountryResponseModelDto.fromJson(item)),
            )
          : null,
      globalBundles: json["global_bundles"] != null
          ? List<BundleResponseModelDto>.from(
              (json["global_bundles"] as List<dynamic>)
                  .map((dynamic item) => BundleResponseModelDto.fromJson(json: item)),
            )
          : null,
      cruiseBundles: json["cruise_bundles"] != null
          ? List<BundleResponseModelDto>.from(
              (json["cruise_bundles"] as List<dynamic>)
                  .map((dynamic item) => BundleResponseModelDto.fromJson(json: item)),
            )
          : null,
    );
  }

  factory HomeDataResponseModelDto.fromAPIJson({dynamic json}) {
    return HomeDataResponseModelDto(
      regions: json["regions"] != null
          ? List<RegionsResponseModelDto>.from(
              json["regions"]
                  .map((dynamic item) => RegionsResponseModelDto.fromJson(item)),
            )
          : null,
      countries: json["countries"] != null
          ? List<CountryResponseModelDto>.from(
              json["countries"]
                  .map((dynamic item) => CountryResponseModelDto.fromJson(item)),
            )
          : null,
      globalBundles: json["global_bundles"] != null
          ? List<BundleResponseModelDto>.from(
              json["global_bundles"].map(
                (dynamic item) => BundleResponseModelDto.fromJson(json: item),
              ),
            )
          : null,
      cruiseBundles: json["cruise_bundles"] != null
          ? List<BundleResponseModelDto>.from(
              json["cruise_bundles"].map(
                (dynamic item) => BundleResponseModelDto.fromJson(json: item),
              ),
            )
          : null,
    );
  }

  HomeDataResponseModel toDomain() {
    HomeDataResponseModel response = HomeDataResponseModel(
      regions: regions?.map((RegionsResponseModelDto dto) => dto.toDomain()).toList(),
      countries: countries?.map((CountryResponseModelDto dto) =>dto.toDomain()).toList(),
      globalBundles: globalBundles?.map((BundleResponseModelDto dto) =>dto.toDomain()).toList(),
      cruiseBundles: cruiseBundles?.map((BundleResponseModelDto dto) =>dto.toDomain()).toList(),
      version: version,
    );

    return response;
  }

  final List<RegionsResponseModelDto>? regions;
  final List<CountryResponseModelDto>? countries;
  final List<BundleResponseModelDto>? globalBundles;
  final List<BundleResponseModelDto>? cruiseBundles;
  String? version;

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "version": version,
      "regions":
          regions?.map((RegionsResponseModelDto item) => item.toJson()).toList(),
      "countries":
          countries?.map((CountryResponseModelDto item) => item.toJson()).toList(),
      "global_bundles": globalBundles
          ?.map((BundleResponseModelDto item) => item.toJson())
          .toList(),
      "cruise_bundles": cruiseBundles
          ?.map((BundleResponseModelDto item) => item.toJson())
          .toList(),
    };
  }
}
