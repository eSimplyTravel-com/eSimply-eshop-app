import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";

class TransactionHistoryResponseModel {
  TransactionHistoryResponseModel({
    this.userOrderId,
    this.iccid,
    this.bundleType,
    this.planStarted,
    this.bundleExpired,
    this.createdAt,
    this.bundle,
  });

  String? userOrderId;
  String? iccid;
  String? bundleType;
  bool? planStarted;
  bool? bundleExpired;
  String? createdAt;
  BundleResponseModel? bundle;
}
