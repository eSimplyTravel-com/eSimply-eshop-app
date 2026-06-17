class ConsumptionDataParams {
  ConsumptionDataParams({
    this.dataAllocated,
    this.dataUsed,
    this.dataRemaining,
  });

  final num? dataAllocated;
  final num? dataUsed;
  final num? dataRemaining;
}

class ConsumptionDisplayParams {
  ConsumptionDisplayParams({
    this.dataAllocatedDisplay,
    this.dataUsedDisplay,
    this.dataRemainingDisplay,
  });

  final String? dataAllocatedDisplay;
  final String? dataUsedDisplay;
  final String? dataRemainingDisplay;
}

class ConsumptionPlanParams {
  ConsumptionPlanParams({
    this.planStatus,
    this.expiryDate,
  });

  final String? planStatus;
  final String? expiryDate;
}

class UserBundleConsumptionResponseParams {
  UserBundleConsumptionResponseParams({
    this.consumptionData,
    this.consumptionDisplay,
    this.planInfo,
  });

  final ConsumptionDataParams? consumptionData;
  final ConsumptionDisplayParams? consumptionDisplay;
  final ConsumptionPlanParams? planInfo;
}

class UserBundleConsumptionResponse {
  UserBundleConsumptionResponse({
    num? dataAllocated,
    num? dataUsed,
    num? dataRemaining,
    String? dataAllocatedDisplay,
    String? dataUsedDisplay,
    String? dataRemainingDisplay,
    String? planStatus,
    String? expiryDate,
  }) {
    _dataAllocated = dataAllocated;
    _dataUsed = dataUsed;
    _dataRemaining = dataRemaining;
    _dataAllocatedDisplay = dataAllocatedDisplay;
    _dataUsedDisplay = dataUsedDisplay;
    _dataRemainingDisplay = dataRemainingDisplay;
    _planStatus = planStatus;
    _expiryDate = expiryDate;
  }

  num? _dataAllocated;
  num? _dataUsed;
  num? _dataRemaining;
  String? _dataAllocatedDisplay;
  String? _dataUsedDisplay;
  String? _dataRemainingDisplay;
  String? _planStatus;
  String? _expiryDate;

  UserBundleConsumptionResponse copyWith([
    UserBundleConsumptionResponseParams? params,
  ]) =>
      UserBundleConsumptionResponse(
        dataAllocated:
            params?.consumptionData?.dataAllocated ?? _dataAllocated,
        dataUsed: params?.consumptionData?.dataUsed ?? _dataUsed,
        dataRemaining:
            params?.consumptionData?.dataRemaining ?? _dataRemaining,
        dataAllocatedDisplay:
            params?.consumptionDisplay?.dataAllocatedDisplay ??
                _dataAllocatedDisplay,
        dataUsedDisplay:
            params?.consumptionDisplay?.dataUsedDisplay ?? _dataUsedDisplay,
        dataRemainingDisplay:
            params?.consumptionDisplay?.dataRemainingDisplay ??
                _dataRemainingDisplay,
        planStatus: params?.planInfo?.planStatus ?? _planStatus,
        expiryDate: params?.planInfo?.expiryDate ?? _expiryDate,
      );

  num? get dataAllocated => _dataAllocated;

  num? get dataUsed => _dataUsed;

  num? get dataRemaining => _dataRemaining;

  String? get dataAllocatedDisplay => _dataAllocatedDisplay;

  String? get dataUsedDisplay => _dataUsedDisplay;

  String? get dataRemainingDisplay => _dataRemainingDisplay;

  String? get planStatus => _planStatus;

  String? get expiryDate => _expiryDate;
}
