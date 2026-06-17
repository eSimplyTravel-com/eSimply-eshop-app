class RelatedSearchRequestModel {
  RelatedSearchRequestModel({
    this.region,
    this.countries,
  });

  RegionRequestModel? region;
  List<CountriesRequestModel>? countries;
}

class RegionRequestModel {
  RegionRequestModel({
    this.isoCode,
    this.regionName,
  });

  String? isoCode;
  String? regionName;
}

class CountriesRequestModel {
  CountriesRequestModel({
    this.isoCode,
    this.countryName,
  });

  String? isoCode;
  String? countryName;
}
