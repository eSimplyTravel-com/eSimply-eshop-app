import "package:esim_open_source/data/data_source/my_esim_entities/esim_bundle_category_entity.dart";
import "package:esim_open_source/data/data_source/my_esim_entities/esim_country_entity.dart";
import "package:esim_open_source/data/data_source/my_esim_entities/transaction_history_entity.dart";
import "package:esim_open_source/data/remote/responses/bundles/purchase_esim_bundle_response_model_dto.dart";
import "package:objectbox/objectbox.dart";

@Entity()
class EsimEntity {
  EsimEntity({
    required this.isTopupAllowed,
    required this.planStarted,
    required this.bundleExpired,
    required this.labelName,
    required this.orderNumber,
    required this.orderStatus,
    required this.qrCodeValue,
    required this.activationCode,
    required this.smdpAddress,
    required this.validityDate,
    required this.iccid,
    required this.paymentDate,
    required this.sharedWith,
    required this.displayTitle,
    required this.displaySubtitle,
    required this.bundleCode,
    required this.bundleMarketingName,
    required this.bundleName,
    required this.countCountries,
    required this.currencyCode,
    required this.gprsLimitDisplay,
    required this.price,
    required this.priceDisplay,
    required this.unlimited,
    required this.validity,
    required this.validityLabel,
    required this.planType,
    required this.activityPolicy,
    required this.icon,
    required this.bundleMessage,
    required this.searchedCountries,
  });

  factory EsimEntity.fromModel(PurchaseEsimBundleResponseModelDto model) {
    return EsimEntity(
      isTopupAllowed: model.isTopupAllowed,
      planStarted: model.planStarted,
      bundleExpired: model.bundleExpired,
      labelName: model.labelName,
      orderNumber: model.orderNumber,
      orderStatus: model.orderStatus,
      qrCodeValue: model.qrCodeValue,
      activationCode: model.activationCode,
      smdpAddress: model.smdpAddress,
      validityDate: model.validityDate,
      iccid: model.iccid,
      paymentDate: model.paymentDate,
      sharedWith: model.sharedWith,
      displayTitle: model.displayTitle,
      displaySubtitle: model.displaySubtitle,
      bundleCode: model.bundleCode,
      bundleMarketingName: model.bundleMarketingName,
      bundleName: model.bundleName,
      countCountries: model.countCountries?.toDouble(),
      currencyCode: model.currencyCode,
      gprsLimitDisplay: model.gprsLimitDisplay,
      price: model.price?.toDouble(),
      priceDisplay: model.priceDisplay,
      unlimited: model.unlimited,
      validity: model.validity?.toDouble(),
      validityLabel: model.validityLabel,
      planType: model.planType,
      activityPolicy: model.activityPolicy,
      icon: model.icon,
      bundleMessage: model.bundleMessage,
      searchedCountries: <String>[],
    );
  }

  @Id()
  int id = 0;

  final bool? isTopupAllowed;
  final bool? planStarted;
  final bool? bundleExpired;
  final String? labelName;
  final String? orderNumber;
  final String? orderStatus;
  final String? qrCodeValue;
  final String? activationCode;
  final String? smdpAddress;
  final String? validityDate;
  final String? iccid;
  final String? paymentDate;
  final String? sharedWith;
  final String? displayTitle;
  final String? displaySubtitle;
  final String? bundleCode;
  final String? bundleMarketingName;
  final String? bundleName;
  final double? countCountries;
  final String? currencyCode;
  final String? gprsLimitDisplay;
  final double? price;
  final String? priceDisplay;
  final bool? unlimited;
  final double? validity;
  final String? validityLabel;
  final String? planType;
  final String? activityPolicy;
  final String? icon;
  final List<String>? bundleMessage;
  final List<String>? searchedCountries;

  final ToMany<EsimCountryEntity> countries = ToMany<EsimCountryEntity>();
  final ToOne<EsimBundleCategoryEntity> bundleCategory =
      ToOne<EsimBundleCategoryEntity>();

  @Backlink("esimData")
  final ToMany<TransactionHistoryEntity> transactionHistory =
      ToMany<TransactionHistoryEntity>();

  PurchaseEsimBundleResponseModelDto toModel() {
    return PurchaseEsimBundleResponseModelDto(
      isTopupAllowed: isTopupAllowed,
      planStarted: planStarted,
      bundleExpired: bundleExpired,
      labelName: labelName,
      orderNumber: orderNumber,
      orderStatus: orderStatus,
      qrCodeValue: qrCodeValue,
      activationCode: activationCode,
      smdpAddress: smdpAddress,
      validityDate: validityDate,
      iccid: iccid,
      paymentDate: paymentDate,
      sharedWith: sharedWith,
      displayTitle: displayTitle,
      displaySubtitle: displaySubtitle,
      bundleCode: bundleCode,
      bundleCategory: bundleCategory.target?.toModel(),
      bundleMarketingName: bundleMarketingName,
      bundleName: bundleName,
      countCountries: countCountries,
      currencyCode: currencyCode,
      gprsLimitDisplay: gprsLimitDisplay,
      price: price,
      priceDisplay: priceDisplay,
      unlimited: unlimited,
      validity: validity,
      validityLabel: validityLabel,
      planType: planType,
      activityPolicy: activityPolicy,
      bundleMessage: bundleMessage,
      countries: countries.map((EsimCountryEntity c) => c.toModel()).toList(),
      icon: icon,
      transactionHistory: transactionHistory
          .map((TransactionHistoryEntity c) => c.toModel())
          .toList(),
    );
  }
}
