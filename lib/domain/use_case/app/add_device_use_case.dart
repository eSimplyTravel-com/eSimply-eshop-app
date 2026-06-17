import "dart:async";
import "dart:developer";

import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/params/add_device_params.dart";
import "package:esim_open_source/domain/data/params/register_device_params.dart";
import "package:esim_open_source/domain/data/request/device_info_request_model.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/api_device_repository.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/secure_storage_service.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/utils/generation_helper.dart";

class AddDeviceUseCase implements UseCase<Resource<EmptyResponse?>, NoParams> {
  AddDeviceUseCase(
    this.repository,
    this.deviceRepository,
  );

  final ApiAppRepository repository;
  final ApiDeviceRepository deviceRepository;

  @override
  FutureOr<Resource<EmptyResponse?>> execute(NoParams params) async {
    String fcmToken =
        locator<LocalStorageService>().getString(LocalStorageKeys.fcmToken) ??
            "";
    AddDeviceParams deviceParams =
        await locator<DeviceInfoService>().addDeviceParams
          ..fcmToken = fcmToken;

    String uniqueDeviceID = await getUniqueDeviceID(
      locator<DeviceInfoService>(),
      locator<SecureStorageService>(),
    );

    try {
      if (AppEnvironment.appEnvironmentHelper.omniConfigApiKey
              .trim()
              .isNotEmpty &&
          AppEnvironment.appEnvironmentHelper.omniConfigAppGuid
              .trim()
              .isNotEmpty) {
        await deviceRepository.registerDevice(
          params: RegisterDeviceParams(
            fcmToken: fcmToken,
            deviceId: uniqueDeviceID,
            appGuid: AppEnvironment.appEnvironmentHelper.omniConfigAppGuid,
            version: deviceParams.appVersion,
            userGuid: locator<LocalStorageService>()
                    .authResponse
                    ?.userInfo
                    ?.userToken ??
                "",
            deviceInfo: DeviceInfoRequestModel(
              deviceName: deviceParams.deviceModel,
            ),
          ),
        );
      }
    } on Object catch (ex) {
      log(ex.toString());
    }

    return await repository.addDevice(deviceParams);
  }
}
