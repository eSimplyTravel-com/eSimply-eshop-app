import "dart:async";

import "package:esim_open_source/data/remote/responses/device/device_info_response_model_dto.dart";
import "package:esim_open_source/domain/data/api_device.dart";
import "package:esim_open_source/domain/data/params/register_device_params.dart";
import "package:esim_open_source/domain/data/response/device/device_info_response_model.dart";
import "package:esim_open_source/domain/repository/api_device_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";

class ApiDeviceRepositoryImpl implements ApiDeviceRepository {
  ApiDeviceRepositoryImpl(this.apiDevice);
  final APIDevice apiDevice;

  @override
  FutureOr<Resource<DeviceInfoResponseModel?>> registerDevice({
    required RegisterDeviceParams params,
  }) {
    return responseToResource<DeviceInfoResponseModelDto,
        DeviceInfoResponseModel?>(
      apiDevice.registerDevice(
        params: params,
      ),
      (DeviceInfoResponseModelDto dto) => dto.toDomain(),
    );
  }
}
