import "package:esim_open_source/domain/data/request/related_search.dart";

class RelatedSearchRequestModelDto {
  RelatedSearchRequestModelDto({
    this.region,
    this.countries,
  });

  factory RelatedSearchRequestModelDto.fromDomain(
    RelatedSearchRequestModel model,
  ) {
    return RelatedSearchRequestModelDto(
      region: model.region == null
          ? null
          : RegionRequestModelDto.fromDomain(model.region!),
      countries: model.countries
          ?.map(CountriesRequestModelDto.fromDomain)
          .toList(),
    );
  }

  RegionRequestModelDto? region;
  List<CountriesRequestModelDto>? countries;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "region": region?.toJson(),
      "countries": countries
          ?.map((CountriesRequestModelDto country) => country.toJson())
          .toList(),
    };
  }
}

class RegionRequestModelDto {
  RegionRequestModelDto({
    this.isoCode,
    this.regionName,
  });

  factory RegionRequestModelDto.fromDomain(RegionRequestModel model) {
    return RegionRequestModelDto(
      isoCode: model.isoCode,
      regionName: model.regionName,
    );
  }

  String? isoCode;
  String? regionName;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "iso_code": isoCode,
      "region_name": regionName,
    };
  }
}

class CountriesRequestModelDto {
  CountriesRequestModelDto({
    this.isoCode,
    this.countryName,
  });

  factory CountriesRequestModelDto.fromDomain(CountriesRequestModel model) {
    return CountriesRequestModelDto(
      isoCode: model.isoCode,
      countryName: model.countryName,
    );
  }

  String? isoCode;
  String? countryName;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "iso3_code": isoCode,
      "country_name": countryName,
    };
  }
}
