import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/bundles/transaction_history_response_model.dart";

class TransactionHistoryResponseModelDto {
  TransactionHistoryResponseModelDto({
    this.userOrderId,
    this.iccid,
    this.bundleType,
    this.planStarted,
    this.bundleExpired,
    this.createdAt,
    this.bundle,
  });

  factory TransactionHistoryResponseModelDto.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryResponseModelDto(
      userOrderId: json["user_order_id"],
      iccid: json["iccid"],
      bundleType: json["bundle_type"],
      planStarted: json["plan_started"],
      bundleExpired: json["bundle_expired"],
      createdAt: json["created_at"],
      bundle: json["bundle"] != null
          ? BundleResponseModelDto.fromJson(json: json["bundle"])
          : null,
    );
  }

  String? userOrderId;
  String? iccid;
  String? bundleType;
  bool? planStarted;
  bool? bundleExpired;
  String? createdAt;
  BundleResponseModelDto? bundle;

  TransactionHistoryResponseModel toDomain() {
    TransactionHistoryResponseModel response = TransactionHistoryResponseModel(
        userOrderId: userOrderId,
        iccid: iccid,
        bundleType: bundleType,
        planStarted: planStarted,
        bundleExpired: bundleExpired,
        createdAt: createdAt,
        bundle: bundle?.toDomain(),
    );

    return response;
  }

  TransactionHistoryResponseModelDto fromDomain(TransactionHistoryResponseModel model) {
    TransactionHistoryResponseModelDto response = TransactionHistoryResponseModelDto(
      userOrderId: model.userOrderId,
      iccid: model.iccid,
      bundleType: model.bundleType,
      planStarted: model.planStarted,
      bundleExpired: model.bundleExpired,
      createdAt: model.createdAt,
      bundle: BundleResponseModelDto().fromDomain(model.bundle),
    );

    return response;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "user_order_id": userOrderId,
      "iccid": iccid,
      "bundle_type": bundleType,
      "plan_started": planStarted,
      "bundle_expired": bundleExpired,
      "created_at": createdAt,
      "bundle": bundle?.toJson(),
    };
  }
}
