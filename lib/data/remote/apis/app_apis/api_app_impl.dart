import "dart:async";

import "package:esim_open_source/data/remote/apis/api_provider.dart";
import "package:esim_open_source/data/remote/apis/app_apis/app_apis.dart";
import "package:esim_open_source/data/remote/request/app/add_device_params_dto.dart";
import "package:esim_open_source/data/remote/responses/app/banner_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/app/configuration_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/app/currencies_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/app/dynamic_page_response_dto.dart";
import "package:esim_open_source/data/remote/responses/app/faq_response_dto.dart";
import "package:esim_open_source/data/remote/responses/base_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/core/empty_response_dto.dart";
import "package:esim_open_source/data/remote/responses/core/string_response_dto.dart";
import "package:esim_open_source/domain/data/api_app.dart";
import "package:esim_open_source/domain/data/params/add_device_params.dart";

class APIAppImpl extends APIService implements APIApp {
  APIAppImpl._privateConstructor() : super.privateConstructor();

  static APIAppImpl? _instance;

  static APIAppImpl get instance {
    if (_instance == null) {
      _instance = APIAppImpl._privateConstructor();
      _instance?._initialise();
    }
    return _instance!;
  }

  void _initialise() {}

  @override
  FutureOr<dynamic> addDevice(AddDeviceParams params) async {
    ResponseMainDto<EmptyResponseDto?> addDeviceResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AppApis.addDevice,
        parameters: AddDeviceParamsDto.fromDomain(params).toJson(),
      ),
      fromJson: EmptyResponseDto.fromJson,
    );

    return addDeviceResponse;
  }

  @override
  FutureOr<ResponseMainDto<List<FaqResponseDto>?>> getFaq() async {
    ResponseMainDto<List<FaqResponseDto>?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AppApis.faq,
      ),
      fromJson: FaqResponseDto.fromJsonList,
    );

    return response;
  }

  @override
  FutureOr<ResponseMainDto<StringResponseDto?>> contactUs({
    required String email,
    required String message,
  }) async {
    Map<String, dynamic> params = <String, dynamic>{
      "email": email,
      "content": message,
    };

    ResponseMainDto<StringResponseDto?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AppApis.contactUs,
        parameters: params,
      ),
      fromJson: StringResponseDto.fromJson,
    );

    return response;
  }

  @override
  FutureOr<ResponseMainDto<DynamicPageResponseDto?>> getAboutUs() async {
    ResponseMainDto<DynamicPageResponseDto?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AppApis.aboutUS,
      ),
      fromJson: DynamicPageResponseDto.fromJson,
    );

    return response;
  }

  @override
  FutureOr<ResponseMainDto<DynamicPageResponseDto?>> getTermsConditions() async {
    ResponseMainDto<DynamicPageResponseDto?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AppApis.termsConditions,
      ),
      fromJson: DynamicPageResponseDto.fromJson,
    );

    return response;
  }

  @override
  FutureOr<ResponseMainDto<List<ConfigurationResponseModelDto>?>>
      getConfigurations() async {
    ResponseMainDto<List<ConfigurationResponseModelDto>?> response =
        await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AppApis.configurations,
      ),
      fromJson: ConfigurationResponseModelDto.fromJsonList,
    );

    return response;
  }

  @override
  FutureOr<ResponseMainDto<List<CurrenciesResponseModelDto>?>> getCurrencies() async {
    ResponseMainDto<List<CurrenciesResponseModelDto>?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AppApis.getCurrencies,
      ),
      fromJson: CurrenciesResponseModelDto.fromJsonList,
    );

    return response;
  }

  @override
  FutureOr<ResponseMainDto<List<BannerResponseModelDto>?>> getBanner() async {
    Map<String, String> headers = <String, String>{
      "x-platform": "mobile",
    };

    ResponseMainDto<List<BannerResponseModelDto>?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AppApis.getBanner,
        additionalHeaders: headers,
      ),
      fromJson: BannerResponseModelDto.fromJsonList,
    );

    return response;
  }
}
