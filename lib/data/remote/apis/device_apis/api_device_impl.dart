import "dart:async";

import "package:esim_open_source/data/remote/apis/api_provider.dart";
import "package:esim_open_source/data/remote/apis/device_apis/device_apis.dart";
import "package:esim_open_source/data/remote/request/device/register_device_params_dto.dart";
import "package:esim_open_source/data/remote/responses/base_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/device/device_info_response_model_dto.dart";
import "package:esim_open_source/domain/data/api_device.dart";
import "package:esim_open_source/domain/data/params/register_device_params.dart";

class ApiDeviceImpl extends APIService implements APIDevice {
  ApiDeviceImpl._privateConstructor() : super.privateConstructor();

  static ApiDeviceImpl? _instance;

  static ApiDeviceImpl get instance {
    if (_instance == null) {
      _instance = ApiDeviceImpl._privateConstructor();
      _instance?._initialise();
    }
    return _instance!;
  }

  void _initialise() {}

  @override
  FutureOr<ResponseMainDto<DeviceInfoResponseModelDto?>> registerDevice({
required RegisterDeviceParams params,
  }) async {
    ResponseMainDto<DeviceInfoResponseModelDto?> registerDeviceResponse =
        await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: DeviceApis.registerDevice,
        parameters: RegisterDeviceParamsDto.fromDomain(params).toJson(),
      ),
      fromJson: DeviceInfoResponseModelDto.fromJson,
    );

    return registerDeviceResponse;
  }
}
