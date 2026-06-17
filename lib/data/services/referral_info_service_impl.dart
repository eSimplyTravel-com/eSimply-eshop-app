import "dart:async";
import "dart:developer";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/data/remote/responses/promotion/referral_info_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/promotion/referral_info_response_model.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/referral_info_service.dart";
import "package:esim_open_source/domain/use_case/app/get_referral_info_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class ReferralInfoServiceImpl extends ReferralInfoService {
  ReferralInfoServiceImpl._privateConstructor();

  static ReferralInfoServiceImpl? _instance;

  static ReferralInfoServiceImpl get instance {
    if (_instance == null) {
      _instance = ReferralInfoServiceImpl._privateConstructor();
      log("Initialize Referral info Service");
      unawaited(_instance?.getReferralInfo());
    }
    return _instance!;
  }

  Completer<void>? _referralInfoCompleter;
  ReferralInfoResponseModel? _referralInfoData;

  Future<void> getReferralInfo() async {
    _referralInfoCompleter = Completer<void>();

    String? config = locator<LocalStorageService>().getString(
      LocalStorageKeys.referralInfo,
    );

    if (config != null) {
      try {
        _referralInfoData =
            ReferralInfoResponseModelDto.referralInfoFromJsonString(config)
                .toDomain();
      } on Object catch (e) {
        log(e.toString());
      }
    }
    // if (_referralInfoData?.amount != null) {
    //   _referralInfoCompleter?.complete();
    // }

    Resource<ReferralInfoResponseModel?> response =
        await GetReferralInfoUseCase(locator()).execute(NoParams());

    if (response.resourceType == ResourceType.success) {
      _referralInfoData = response.data;

      locator<LocalStorageService>().setString(
        LocalStorageKeys.referralInfo,
        _referralInfoData == null
            ? ""
            : ReferralInfoResponseModelDto.fromDomain(_referralInfoData!)
                .toJsonString(),
      );

      if (!(_referralInfoCompleter?.isCompleted ?? true)) {
        _referralInfoCompleter?.complete();
      }
    }
  }

  @override
  String get getReferralAmount {
    return _referralInfoData?.amount.toString() ?? "";
  }

  @override
  String get getReferralAmountAndCurrency {
    return "${_referralInfoData?.amount ?? ""} ${_referralInfoData?.currency ?? ""}";
  }

  @override
  String get getReferralCurrency {
    return _referralInfoData?.currency ?? "";
  }

  @override
  String get getReferralMessage {
    return _referralInfoData?.message ?? "";
  }

  @override
  Future<void> refreshReferralInfo() async {
    return getReferralInfo();
  }
}
