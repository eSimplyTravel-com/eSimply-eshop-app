class BundleConsumptionResponse {
  BundleConsumptionResponse({
    num? consumption,
    String? unit,
    String? displayConsumption,
  }) {
    _consumption = consumption;
    _unit = unit;
    _displayConsumption = displayConsumption;
  }

  num? _consumption;
  String? _unit;
  String? _displayConsumption;

  BundleConsumptionResponse copyWith({
    num? consumption,
    String? unit,
    String? displayConsumption,
  }) =>
      BundleConsumptionResponse(
        consumption: consumption ?? _consumption,
        unit: unit ?? _unit,
        displayConsumption: displayConsumption ?? _displayConsumption,
      );

  num? get consumption => _consumption;
  String? get unit => _unit;
  String? get displayConsumption => _displayConsumption;
}
