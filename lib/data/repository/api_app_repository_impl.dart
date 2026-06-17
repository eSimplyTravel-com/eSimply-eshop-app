import "dart:async";
import "dart:developer";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/data/remote/responses/app/banner_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/app/configuration_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/app/currencies_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/app/dynamic_page_response_dto.dart";
import "package:esim_open_source/data/remote/responses/app/faq_response_dto.dart";
import "package:esim_open_source/data/remote/responses/core/empty_response_dto.dart";
import "package:esim_open_source/data/remote/responses/core/string_response_dto.dart";
import "package:esim_open_source/domain/data/api_app.dart";
import "package:esim_open_source/domain/data/params/add_device_params.dart";
import "package:esim_open_source/domain/data/response/app/banner_response_model.dart";
import "package:esim_open_source/domain/data/response/app/configuration_response_model.dart";
import "package:esim_open_source/domain/data/response/app/currencies_response_model.dart";
import "package:esim_open_source/domain/data/response/app/dynamic_page_response.dart";
import "package:esim_open_source/domain/data/response/app/faq_response.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/data/response/core/string_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/utils/value_stream.dart";

class ApiAppRepositoryImpl implements ApiAppRepository {
  ApiAppRepositoryImpl(this.apiApp);

  final APIApp apiApp;

  final ValueStream<Resource<List<BannerResponseModel>?>> _bannersStream =
      ValueStream<Resource<List<BannerResponseModel>?>>();

  @override
  FutureOr<Resource<EmptyResponse?>> addDevice(AddDeviceParams params) async {
    return responseToResource<EmptyResponseDto, EmptyResponse?>(
      apiApp.addDevice(params),
      (EmptyResponseDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<List<FaqResponse>?>> getFaq() async {
    return responseToResource<List<FaqResponseDto>, List<FaqResponse>?>(
      apiApp.getFaq(),
          (List<FaqResponseDto> dtos) => dtos
          .map((FaqResponseDto dto) => dto.toDomain())
          .toList(),
    );
  }

  @override
  FutureOr<Resource<StringResponse?>> contactUs({
    required String email,
    required String message,
  }) async {
    return responseToResource<StringResponseDto, StringResponse?>(
      apiApp.contactUs(email: email, message: message),
      (StringResponseDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<DynamicPageResponse?>> getAboutUs() async {
    return responseToResource<DynamicPageResponseDto, DynamicPageResponse?>(
      apiApp.getAboutUs(),
      (DynamicPageResponseDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<DynamicPageResponse?>> getTermsConditions() async {
    return responseToResource<DynamicPageResponseDto, DynamicPageResponse?>(
      apiApp.getTermsConditions(),
      (DynamicPageResponseDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<List<ConfigurationResponseModel>?>>
      getConfigurations() async {
    return responseToResource<List<ConfigurationResponseModelDto>,
        List<ConfigurationResponseModel>?>(
      apiApp.getConfigurations(),
      (List<ConfigurationResponseModelDto> dtos) => dtos
          .map((ConfigurationResponseModelDto dto) => dto.toDomain())
          .toList(),
    );
  }

  @override
  FutureOr<Resource<List<CurrenciesResponseModel>?>> getCurrencies() async {
    return responseToResource<List<CurrenciesResponseModelDto>,
        List<CurrenciesResponseModel>?>(
      apiApp.getCurrencies(),
      (List<CurrenciesResponseModelDto> dtos) =>
          dtos.map((CurrenciesResponseModelDto dto) => dto.toDomain()).toList(),
    );
  }

  @override
  FutureOr<Resource<List<BannerResponseModel>?>> getBanner() async {
    return responseToResource<List<BannerResponseModelDto>,
        List<BannerResponseModel>?>(
      apiApp.getBanner(),
      (List<BannerResponseModelDto> dtos) =>
          dtos.map((BannerResponseModelDto dto) => dto.toDomain()).toList(),
    );
  }

  @override
  ValueStream<Resource<List<BannerResponseModel>?>> getBannerStream() {
    unawaited(_triggerBannerStream());
    return _bannersStream;
  }

  Future<void> _triggerBannerStream({bool forceReload = false}) async {
    if (!forceReload) {
      if (_bannersStream.currentValue != null &&
          _bannersStream.currentValue?.resourceType == ResourceType.success) {
        return;
      }
    }

    _bannersStream.add(Resource<List<BannerResponseModel>?>.loading());
    // _bannersStream.add(Resource<List<BannerResponseModel>?>.error(""));
    // return;
    if (forceReload) {
      locator<LocalStorageService>().remove(LocalStorageKeys.appBanner);
    } else {
      String? config = locator<LocalStorageService>().getString(
        LocalStorageKeys.appBanner,
      );

      List<BannerResponseModel>? configData;

      if (config != null) {
        try {
          configData = BannerResponseModelDto.fromJsonListString(config)
              .map((BannerResponseModelDto dto) => dto.toDomain())
              .toList();
          _bannersStream.add(
            Resource<List<BannerResponseModel>?>.success(
              configData,
              message: "",
            ),
          );
          return;
        } on Object catch (e) {
          log(e.toString());
        }
      }
    }

    Resource<List<BannerResponseModel>?> response =
        await responseToResource<List<BannerResponseModelDto>,
            List<BannerResponseModel>?>(
      apiApp.getBanner(),
      (List<BannerResponseModelDto> dtos) =>
          dtos.map((BannerResponseModelDto dto) => dto.toDomain()).toList(),
    );

    if (response.resourceType == ResourceType.success) {
      List<BannerResponseModel>? bannerData = response.data;

      locator<LocalStorageService>().setString(
        LocalStorageKeys.appBanner,
        BannerResponseModelDto.toJsonListString(
          (bannerData ?? <BannerResponseModel>[])
              .map(BannerResponseModelDto.fromDomain)
              .toList(),
        ),
      );
    }
    _bannersStream.add(response);
  }

  @override
  Future<void> resetBannerStream() {
    return _triggerBannerStream(forceReload: true);
  }
}
