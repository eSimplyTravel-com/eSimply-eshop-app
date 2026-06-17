import "package:esim_open_source/data/data_source/home_data_entities/bundle_category_entity.dart";
import "package:esim_open_source/data/data_source/home_data_entities/bundle_type.dart";
import "package:esim_open_source/data/data_source/home_data_entities/country_entity.dart";
import "package:esim_open_source/data/data_source/home_data_entities/home_data_entity.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model_dto.dart";
import "package:objectbox/objectbox.dart";

@Entity()
class BundleEntity {
  // enum for global/cruise bundles

  BundleEntity({
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
    required this.bundleTypeValue,
    required this.icon,
  });

  factory BundleEntity.fromModel(BundleResponseModelDto model, BundleType type) {
    return BundleEntity(
      icon: model.icon,
      displayTitle: model.displayTitle,
      displaySubtitle: model.displaySubtitle,
      bundleCode: model.bundleCode,
      bundleMarketingName: model.bundleMarketingName,
      bundleName: model.bundleName,
      countCountries: model.countCountries,
      currencyCode: model.currencyCode,
      gprsLimitDisplay: model.gprsLimitDisplay,
      price: model.price,
      priceDisplay: model.priceDisplay,
      unlimited: model.unlimited,
      validity: model.validity,
      validityLabel: model.validityLabel,
      bundleTypeValue: type.index,
    );
  }

  @Id()
  int id = 0;

  final String? displayTitle;
  final String? displaySubtitle;
  final String? bundleCode;
  final String? bundleMarketingName;
  final String? bundleName;
  final int? countCountries;
  final String? currencyCode;
  final String? gprsLimitDisplay;
  final double? price;
  final String? priceDisplay;
  final bool? unlimited;
  final int? validity;
  final String? validityLabel;
  final String? icon;

  final ToOne<BundleCategoryEntity> bundleCategory =
      ToOne<BundleCategoryEntity>();
  final ToMany<CountryEntity> countries = ToMany<CountryEntity>();

  final ToOne<HomeDataEntity> homeData =
      ToOne<HomeDataEntity>(); // Add this relationship

  @Property(type: PropertyType.byte)
  int bundleTypeValue = 0; // Default to global (0)

  // Getter and setter for BundleType
  BundleType get bundleType => BundleType.values[bundleTypeValue];

  set bundleType(BundleType type) => bundleTypeValue = type.index;

  BundleResponseModelDto toModel() {
    return BundleResponseModelDto(
      icon: icon,
      displayTitle: displayTitle,
      displaySubtitle: displaySubtitle,
      bundleCode: bundleCode,
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
      bundleCategory: bundleCategory.target?.toModel(),
      countries: countries.map((CountryEntity c) => c.toModel()).toList(),
    );
  }
}
