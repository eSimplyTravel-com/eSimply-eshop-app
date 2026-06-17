import "dart:async";
import "dart:developer";

import "package:esim_open_source/data/data_source/home_local_data_source.dart";
import "package:esim_open_source/data/remote/responses/base_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_consumption_response_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/home_data_response_model_dto.dart";
import "package:esim_open_source/domain/data/api_bundles.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_consumption_response.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/home_data_response_model.dart";
import "package:esim_open_source/domain/repository/api_bundles_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/extensions/string_extensions.dart";
import "package:esim_open_source/presentation/reactive_service/bundles_data_service.dart";

class ApiBundlesRepositoryImpl implements ApiBundlesRepository {
  ApiBundlesRepositoryImpl({
    required HomeLocalDataSource repository,
    required APIBundles apiBundles,
  })  : _repository = repository,
        _apiBundles = apiBundles;

  final HomeLocalDataSource _repository;
  final APIBundles _apiBundles;

  // Stream controller to emit updates
  final StreamController<BundleServicesStreamModel> _homeDataController =
      StreamController<BundleServicesStreamModel>.broadcast();

  @override
  Stream<BundleServicesStreamModel> get homeDataStream =>
      _homeDataController.stream;

  @override
  FutureOr<Resource<BundleConsumptionResponse?>> getBundleConsumption({
    required String iccID,
  }) {
    return responseToResource<BundleConsumptionResponseDto, BundleConsumptionResponse?>(
      _apiBundles.getBundleConsumption(iccID: iccID),
        (BundleConsumptionResponseDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Stream<BundleServicesStreamModel>> getHomeData({
    required Future<HomeDataVersionResult> version,
    bool forceRefresh = false,
    bool isFromRefresh = false,
  }) async {
    triggerHomeData(
      version: version,
      forceRefresh: forceRefresh,
      isFromRefresh: isFromRefresh,
    );
    return _homeDataController.stream;
  }

  FutureOr<Stream<BundleServicesStreamModel>> triggerHomeData({
    required Future<HomeDataVersionResult> version,
    bool forceRefresh = false,
    bool isFromRefresh = false,
  }) async {
    // First, try to get cached data
    final HomeDataResponseModel? cachedData = _repository.getHomeData()?.toDomain();
    if (cachedData != null && !isFromRefresh) {
      _homeDataController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.success(
            cachedData,
            message: null,
          ),
        ),
      );
    }

    String strVersion = "";
    HomeDataVersionResult versionResult = await version;
    if (versionResult.isSuccess) {
      strVersion = versionResult.version;
    }

    // If cache is valid and not forcing refresh, don't fetch new data
    String versionToCheck = strVersion.appendAppCurrency.appendAppLanguage;

    if ((cachedData != null &&
            cachedData.version == versionToCheck &&
            strVersion.isNotEmpty) &&
        !forceRefresh) {
      return _homeDataController.stream;
    }

    // Fetch new data in the background
    _homeDataController.add(
      BundleServicesStreamModel(
        shouldRenderShimmer: true,
        homeData: cachedData == null
            ? Resource<HomeDataResponseModel>.error("No data")
            : Resource<HomeDataResponseModel>.success(
                cachedData,
                message: null,
              ),
      ),
    );
    String newVersion = strVersion.appendAppCurrency.appendAppLanguage;
    _fetchAndUpdateHomeData(_homeDataController, newVersion);

    return _homeDataController.stream;
  }

  Future<void> _fetchAndUpdateHomeData(
    StreamController<BundleServicesStreamModel> controller,
    String version,
  ) async {
    try {
      final ResponseMainDto<HomeDataResponseModelDto> response =
          await _apiBundles.getAllData();
      final HomeDataResponseModelDto newData = response.data..version = version;

      await _repository.saveHomeData(newData);

      // Emit new data as success resource
      _homeDataController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData:
              Resource<HomeDataResponseModel>.success(newData.toDomain(), message: null),
        ),
      );
    } on Error catch (e) {
      // Emit error resource
      _homeDataController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.error(e.toString()),
        ),
      );
      log("Error fetching new home data: $e");
    }
  }

  @override
  Future<void> clearCache() async {
    await _repository.clearCache();
  }

  @override
  Future<void> dispose() async {
    await _homeDataController.close();
  }

  @override
  FutureOr<Resource<List<BundleResponseModel>?>> getAllBundles() async {
    return responseToResource<List<BundleResponseModelDto>, List<BundleResponseModel>?>(
      _apiBundles.getAllBundles(),
          (List<BundleResponseModelDto>? dtos) => dtos
          ?.map((BundleResponseModelDto dto) => dto.toDomain())
          .toList(),
    );
  }

  @override
  FutureOr<Resource<BundleResponseModel?>> getBundle({
    required String code,
  }) async {
    return responseToResource<BundleResponseModelDto, BundleResponseModel?>(
      _apiBundles.getBundle(code: code),
      (BundleResponseModelDto dto) => dto.toDomain(),
    );
  }

  @override
  FutureOr<Resource<List<BundleResponseModel>>> getBundlesByRegion({
    required String regionCode,
  }) async {
    return responseToResource<List<BundleResponseModelDto>,
        List<BundleResponseModel>>(
      _apiBundles.getBundlesByRegion(regionCode: regionCode),
      (List<BundleResponseModelDto> dtos) =>
          dtos.map((BundleResponseModelDto dto) => dto.toDomain()).toList(),
    );
  }

  @override
  FutureOr<Resource<List<BundleResponseModel>>> getBundlesByCountries({
    required String countryCodes,
  }) async {
    return responseToResource<List<BundleResponseModelDto>,
        List<BundleResponseModel>>(
      _apiBundles.getBundlesByCountries(countryCodes: countryCodes),
      (List<BundleResponseModelDto> dtos) =>
          dtos.map((BundleResponseModelDto dto) => dto.toDomain()).toList(),
    );
  }
}
