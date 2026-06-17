import "dart:async";

import "package:esim_open_source/domain/data/response/bundles/bundle_consumption_response.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/reactive_service/bundles_data_service.dart";

abstract interface class ApiBundlesRepository {
  FutureOr<Resource<BundleConsumptionResponse?>> getBundleConsumption({
    required String iccID,
  });

  FutureOr<dynamic> getAllBundles();

  FutureOr<dynamic> getBundle({required String code});

  FutureOr<dynamic> getBundlesByRegion({required String regionCode});

  FutureOr<dynamic> getBundlesByCountries({required String countryCodes});

  Stream<BundleServicesStreamModel> get homeDataStream;

  FutureOr<Stream<BundleServicesStreamModel>> getHomeData({
    required Future<HomeDataVersionResult> version,
    bool forceRefresh = false,
    bool isFromRefresh = false,
  });

  Future<void> clearCache();

  Future<void> dispose();
}
