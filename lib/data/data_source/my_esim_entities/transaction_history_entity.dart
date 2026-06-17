import "package:esim_open_source/data/data_source/my_esim_entities/esim_bundle_entity.dart";
import "package:esim_open_source/data/data_source/my_esim_entities/esim_entity.dart";
import "package:esim_open_source/data/remote/responses/bundles/transaction_history_response_model_dto.dart";
import "package:objectbox/objectbox.dart";

@Entity()
class TransactionHistoryEntity {
  TransactionHistoryEntity({
    required this.userOrderId,
    required this.iccid,
    required this.bundleType,
    required this.planStarted,
    required this.bundleExpired,
    required this.createdAt,
  });

  factory TransactionHistoryEntity.fromModel(
    TransactionHistoryResponseModelDto model,
  ) {
    return TransactionHistoryEntity(
      userOrderId: model.userOrderId,
      iccid: model.iccid,
      bundleType: model.bundleType,
      planStarted: model.planStarted,
      bundleExpired: model.bundleExpired,
      createdAt: model.createdAt,
    );
  }

  @Id()
  int id = 0;

  String? userOrderId;
  String? iccid;
  String? bundleType;
  bool? planStarted;
  bool? bundleExpired;
  String? createdAt;

  final ToOne<EsimBundleEntity> bundle = ToOne<EsimBundleEntity>();

  final ToOne<EsimEntity> esimData = ToOne<EsimEntity>();

  TransactionHistoryResponseModelDto toModel() {
    return TransactionHistoryResponseModelDto(
      userOrderId: userOrderId,
      iccid: iccid,
      bundleType: bundleType,
      planStarted: planStarted,
      bundleExpired: bundleExpired,
      createdAt: createdAt,
      bundle: bundle.target?.toModel(),
    );
  }
}
