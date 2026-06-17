import "dart:convert";

import "package:esim_open_source/domain/data/response/user/user_bundle_consumption_response.dart";

UserBundleConsumptionResponseDto userBundleConsumptionResponseFromJson(
  String str,
) =>
    UserBundleConsumptionResponseDto.fromJson(json: json.decode(str));

String userBundleConsumptionResponseToJson(
  UserBundleConsumptionResponseDto data,
) =>
    json.encode(data.toJson());

class ConsumptionDataParamsDto {
  ConsumptionDataParamsDto({
    this.dataAllocated,
    this.dataUsed,
    this.dataRemaining,
  });

  final num? dataAllocated;
  final num? dataUsed;
  final num? dataRemaining;
}

class ConsumptionDisplayParamsDto {
  ConsumptionDisplayParamsDto({
    this.dataAllocatedDisplay,
    this.dataUsedDisplay,
    this.dataRemainingDisplay,
  });

  final String? dataAllocatedDisplay;
  final String? dataUsedDisplay;
  final String? dataRemainingDisplay;
}

class ConsumptionPlanParamsDto {
  ConsumptionPlanParamsDto({
    this.planStatus,
    this.expiryDate,
  });

  final String? planStatus;
  final String? expiryDate;
}

class UserBundleConsumptionResponseParamsDto {
  UserBundleConsumptionResponseParamsDto({
    this.consumptionData,
    this.consumptionDisplay,
    this.planInfo,
  });

  final ConsumptionDataParamsDto? consumptionData;
  final ConsumptionDisplayParamsDto? consumptionDisplay;
  final ConsumptionPlanParamsDto? planInfo;
}

class UserBundleConsumptionResponseDto {
  UserBundleConsumptionResponseDto({
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

  UserBundleConsumptionResponseDto.fromJson({dynamic json}) {
    _dataAllocated = json["data_allocated"];
    _dataUsed = json["data_used"];
    _dataRemaining = json["data_remaining"];
    _dataAllocatedDisplay = json["data_allocated_display"];
    _dataUsedDisplay = json["data_used_display"];
    _dataRemainingDisplay = json["data_remaining_display"];
    _planStatus = json["plan_status"];
    _expiryDate = json["expiry_date"];
  }

  num? _dataAllocated;
  num? _dataUsed;
  num? _dataRemaining;
  String? _dataAllocatedDisplay;
  String? _dataUsedDisplay;
  String? _dataRemainingDisplay;
  String? _planStatus;
  String? _expiryDate;

  UserBundleConsumptionResponseDto copyWith([
    UserBundleConsumptionResponseParamsDto? params,
  ]) =>
      UserBundleConsumptionResponseDto(
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["data_allocated"] = _dataAllocated;
    map["data_used"] = _dataUsed;
    map["data_remaining"] = _dataRemaining;
    map["data_allocated_display"] = _dataAllocatedDisplay;
    map["data_used_display"] = _dataUsedDisplay;
    map["data_remaining_display"] = _dataRemainingDisplay;
    map["plan_status"] = _planStatus;
    map["expiry_date"] = _expiryDate;
    return map;
  }

  UserBundleConsumptionResponse toDomain() {
    UserBundleConsumptionResponse response = UserBundleConsumptionResponse(
      dataAllocated: dataAllocated,
      dataUsed: dataUsed,
      dataRemaining: dataRemaining,
      dataAllocatedDisplay: dataAllocatedDisplay,
      dataUsedDisplay: dataUsedDisplay,
      dataRemainingDisplay: dataRemainingDisplay,
      planStatus: planStatus,
      expiryDate: expiryDate,
    );

    return response;
  }
}
