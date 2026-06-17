import "dart:async";

import "package:esim_open_source/data/remote/apis/api_provider.dart";
import "package:esim_open_source/data/remote/apis/bundles_apis/bundles_apis.dart";
import "package:esim_open_source/data/remote/responses/base_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_consumption_response_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/home_data_response_model_dto.dart";
import "package:esim_open_source/domain/data/api_bundles.dart";

class APIBundlesImpl extends APIService implements APIBundles {
  APIBundlesImpl._privateConstructor() : super.privateConstructor();

  static APIBundlesImpl? _instance;

  static APIBundlesImpl get instance {
    if (_instance == null) {
      _instance = APIBundlesImpl._privateConstructor();
      _instance?._initialise();
    }
    return _instance!;
  }

  void _initialise() {}

  @override
  FutureOr<ResponseMainDto<BundleConsumptionResponseDto>> getBundleConsumption({
    required String iccID,
  }) async {
    ResponseMainDto<BundleConsumptionResponseDto> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: BundlesApis.getBundleConsumption,
        paramIDs: <String>[iccID],
      ),
      fromJson: BundleConsumptionResponseDto.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMainDto<HomeDataResponseModelDto>> getAllData() async {
    ResponseMainDto<HomeDataResponseModelDto> homeDataResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: BundlesApis.getAllData,
      ),
      fromJson: HomeDataResponseModelDto.fromAPIJson,
    );

    return homeDataResponse;
  }

  @override
  FutureOr<ResponseMainDto<List<BundleResponseModelDto>>> getAllBundles() async {
    ResponseMainDto<List<BundleResponseModelDto>> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: BundlesApis.getBundles,
      ),
      fromJson: BundleResponseModelDto.fromJsonList,
    );
    return response;
  }

  @override
  FutureOr<ResponseMainDto<BundleResponseModelDto>> getBundle({
    required String code,
  }) async {
    ResponseMainDto<BundleResponseModelDto> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: BundlesApis.getBundle,
        paramIDs: <String>[code],
      ),
      fromJson: BundleResponseModelDto.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMainDto<List<BundleResponseModelDto>>> getBundlesByRegion({
    required String regionCode,
  }) async {
    ResponseMainDto<List<BundleResponseModelDto>> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: BundlesApis.getBundlesByRegion,
        paramIDs: <String>[regionCode],
      ),
      fromJson: BundleResponseModelDto.fromJsonList,
    );
    return response;
  }

  @override
  FutureOr<ResponseMainDto<List<BundleResponseModelDto>>> getBundlesByCountries({
    required String countryCodes,
  }) async {
    ResponseMainDto<List<BundleResponseModelDto>> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: BundlesApis.getBundlesByCountries,
        queryParameters: <String, String>{"country_codes": countryCodes},
      ),
      fromJson: BundleResponseModelDto.fromJsonList,
    );
    return response;
  }
}
