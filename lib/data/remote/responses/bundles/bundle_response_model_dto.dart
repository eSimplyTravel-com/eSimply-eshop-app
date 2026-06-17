import "package:easy_localization/easy_localization.dart"
    show StringTranslateExtension;
import "package:esim_open_source/data/remote/responses/bundles/bundle_category_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart"
    show LocaleKeys;
import "package:esim_open_source/utils/parsing_helper.dart";

class BundleResponseModelDto {
  BundleResponseModelDto({
    this.displayTitle,
    this.displaySubtitle,
    this.bundleCode,
    this.bundleCategory,
    this.bundleMarketingName,
    this.bundleName,
    this.countCountries,
    this.currencyCode,
    this.gprsLimitDisplay,
    this.price,
    this.priceDisplay,
    this.unlimited,
    this.validity,
    this.validityLabel,
    this.countries,
    this.icon,
    this.label,
  });

  // Factory method to create an instance from JSON
  factory BundleResponseModelDto.fromJson({dynamic json}) {
    return BundleResponseModelDto(
      displayTitle: json["display_title"],
      displaySubtitle: json["display_subtitle"],
      bundleCode: json["bundle_code"],
      bundleCategory: json["bundle_category"] != null
          ? BundleCategoryResponseModelDto.fromJson(json["bundle_category"])
          : null,
      bundleMarketingName: json["bundle_marketing_name"],
      bundleName: json["bundle_name"],
      countCountries: json["count_countries"],
      currencyCode: json["currency_code"],
      gprsLimitDisplay: json["gprs_limit_display"],
      price: (json["price"] as num?)?.toDouble(),
      priceDisplay: json["price_display"],
      unlimited: json["unlimited"],
      validity: json["validity"],
      validityLabel: json["validity_label"],
      icon: json["icon"],
      label: json["label"],
      countries: json["countries"] != null
          ? List<CountryResponseModelDto>.from(
              json["countries"]
                  .map((dynamic item) => CountryResponseModelDto.fromJson(item)),
            )
          : null,
    );
  }

  final String? displayTitle;
  final String? displaySubtitle;
  final String? bundleCode;
  final BundleCategoryResponseModelDto? bundleCategory;
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
  final List<CountryResponseModelDto>? countries;
  final String? label;


  BundleResponseModel toDomain() {
    BundleResponseModel response = BundleResponseModel(
      displayTitle: displayTitle,
      displaySubtitle: displaySubtitle,
      bundleCode: bundleCode,
      bundleCategory: bundleCategory?.toDomain(),
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
      countries: countries?.map((CountryResponseModelDto dto) =>dto.toDomain()).toList(),
      icon: icon,
      label: label,
    );
    return response;
  }

  BundleResponseModelDto fromDomain(BundleResponseModel? model) {
    BundleResponseModelDto response = BundleResponseModelDto(
      displayTitle: model?.displayTitle,
      displaySubtitle: model?.displaySubtitle,
      bundleCode: model?.bundleCode,
      bundleCategory: BundleCategoryResponseModelDto().fromDomain(
        model?.bundleCategory,
      ),
      bundleMarketingName: model?.bundleMarketingName,
      bundleName: model?.bundleName,
      countCountries: model?.countCountries,
      currencyCode: model?.currencyCode,
      gprsLimitDisplay: model?.gprsLimitDisplay,
      price: model?.price,
      priceDisplay: model?.priceDisplay,
      unlimited: model?.unlimited,
      validity: model?.validity,
      validityLabel: model?.validityLabel,
      countries: model?.countries
          ?.map((CountryResponseModel country) =>
              CountryResponseModelDto().fromDomain(country),)
          .toList(),
      icon: model?.icon,
      label: model?.label,
    );
    return response;
  }

  bool get isCruise => bundleCategory?.isCruise ?? false;

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "display_title": displayTitle,
      "display_subtitle": displaySubtitle,
      "bundle_code": bundleCode,
      "bundle_category": bundleCategory?.toJson(),
      "bundle_marketing_name": bundleMarketingName,
      "bundle_name": bundleName,
      "count_countries": countCountries,
      "currency_code": currencyCode,
      "gprs_limit_display": gprsLimitDisplay,
      "price": price,
      "price_display": priceDisplay,
      "unlimited": unlimited,
      "validity": validity,
      "icon": icon,
      "label": label,
      "validity_label": validityLabel,
      "countries":
          countries?.map((CountryResponseModelDto item) => item.toJson()).toList(),
    };
  }

  String? getValidityDisplay() {
    if (validityLabel != null) {
      ValidityLabelEnum? val =
          ValidityLabelEnum.fromString(validityLabel ?? "");
      return val?.getValidityDisplay(validity);
    }
    return null;
  }

  static List<BundleResponseModelDto> fromJsonList({dynamic json}) {
    return fromJsonListTyped(parser: BundleResponseModelDto.fromJson, json: json);
  }

  static List<BundleResponseModelDto> getMockGlobalBundles() {
    String mockCode = "fcb21616-daf2-4159-9457-6b27f15a1985";
    String placeholderIcon = "https://placehold.co/600x400?bundle=None";
    String flagApiIcon = "https://flagsapi.com/None/flat/64.png";
    String mockGlobalBundle1GB7Days = "Global 1GB 7Days";
    String mockPrice = "1.5 USD";
    String uppercaseGlobal = "GLOBAL";
    String normalGlobal = "Global";
    String mockCurrency = "USD";
    String mockValidityLabel = "Day";
    String mockBundleCode = "None";

    final List<BundleResponseModelDto> mockBundles = <BundleResponseModelDto>[
      BundleResponseModelDto(
        icon: placeholderIcon,
        bundleCategory: BundleCategoryResponseModelDto(
          type: uppercaseGlobal,
          code: mockCode,
          title: normalGlobal,
        ),
        displayTitle: "sd",
        displaySubtitle: "sd",
        bundleMarketingName: "sd",
        bundleName: "sd",
        bundleCode: mockBundleCode,
        countCountries: 1,
        currencyCode: "BYR",
        gprsLimitDisplay: "1 GB",
        price: 15,
        priceDisplay: "15 BYR",
        unlimited: false,
        validity: 1,
        validityLabel: mockValidityLabel,
        countries: <CountryResponseModelDto>[
          CountryResponseModelDto(
            country: "Albania",
            countryCode: "Unknown",
            iso3Code: "ALB",
            icon: flagApiIcon,
            zoneName: "Unknown",
            alternativeCountry: "Albania",
          ),
        ],
      ),
      BundleResponseModelDto(
        icon: placeholderIcon,
        bundleCategory: BundleCategoryResponseModelDto(
          type: uppercaseGlobal,
          code: mockCode,
          title: normalGlobal,
        ),
        displayTitle: "$mockGlobalBundle1GB7Days 2026",
        displaySubtitle: mockGlobalBundle1GB7Days,
        bundleMarketingName: "$mockGlobalBundle1GB7Days 2026",
        bundleName: "$mockGlobalBundle1GB7Days 2026",
        bundleCode: mockBundleCode,
        countCountries: 0,
        currencyCode: mockCurrency,
        gprsLimitDisplay: "1 GB",
        price: 1.5,
        priceDisplay: mockPrice,
        unlimited: false,
        validity: 1,
        validityLabel: mockValidityLabel,
        countries: <CountryResponseModelDto>[],
      ),
      BundleResponseModelDto(
        icon: placeholderIcon,
        bundleCategory: BundleCategoryResponseModelDto(
          type: uppercaseGlobal,
          code: mockCode,
          title: normalGlobal,
        ),
        displayTitle: "$mockGlobalBundle1GB7Days 2025",
        displaySubtitle: mockGlobalBundle1GB7Days,
        bundleMarketingName: "$mockGlobalBundle1GB7Days 2025",
        bundleName: "$mockGlobalBundle1GB7Days 2025",
        bundleCode: mockBundleCode,
        countCountries: 0,
        currencyCode: mockCurrency,
        gprsLimitDisplay: "1 GB",
        price: 1.5,
        priceDisplay: mockPrice,
        unlimited: false,
        validity: 1,
        validityLabel: mockValidityLabel,
        countries: <CountryResponseModelDto>[],
      ),
      BundleResponseModelDto(
        icon: placeholderIcon,
        bundleCategory: BundleCategoryResponseModelDto(
          type: uppercaseGlobal,
          code: mockCode,
          title: normalGlobal,
        ),
        displayTitle: mockGlobalBundle1GB7Days,
        displaySubtitle: mockGlobalBundle1GB7Days,
        bundleMarketingName: mockGlobalBundle1GB7Days,
        bundleName: mockGlobalBundle1GB7Days,
        bundleCode: mockBundleCode,
        countCountries: 2,
        currencyCode: mockCurrency,
        gprsLimitDisplay: "1 GB",
        price: 1.5,
        priceDisplay: mockPrice,
        unlimited: false,
        validity: 1,
        validityLabel: mockValidityLabel,
        countries: <CountryResponseModelDto>[
          CountryResponseModelDto(
            country: "France",
            countryCode: "Unknown",
            iso3Code: "FRA",
            icon: flagApiIcon,
            zoneName: "Unknown",
            alternativeCountry: "France",
          ),
          CountryResponseModelDto(
            country: "Turkey",
            countryCode: "Unknown",
            iso3Code: "TUR",
            icon: flagApiIcon,
            zoneName: "Unknown",
            alternativeCountry: "Türkiye",
          ),
        ],
      ),
      BundleResponseModelDto(
        icon: placeholderIcon,
        bundleCategory: BundleCategoryResponseModelDto(
          type: uppercaseGlobal,
          code: mockCode,
          title: normalGlobal,
        ),
        displayTitle: mockGlobalBundle1GB7Days,
        displaySubtitle: mockGlobalBundle1GB7Days,
        bundleMarketingName: mockGlobalBundle1GB7Days,
        bundleName: mockGlobalBundle1GB7Days,
        bundleCode: mockBundleCode,
        countCountries: 0,
        currencyCode: mockCurrency,
        gprsLimitDisplay: "1 GB",
        price: 3,
        priceDisplay: "3 USD",
        unlimited: false,
        validity: 1,
        validityLabel: mockValidityLabel,
        countries: <CountryResponseModelDto>[],
      ),
    ];

    return mockBundles;
  }
}

enum ValidityLabelEnum {
  days("day"),
  weeks("week"),
  months("month"),
  years("year");

  const ValidityLabelEnum(this.type);

  final String type;

  /// Creates a [ValidityLabelEnum] from a string value
  /// Returns null if no matching type is found
  static ValidityLabelEnum? fromString(String value) {
    return ValidityLabelEnum.values.cast<ValidityLabelEnum?>().firstWhere(
          (ValidityLabelEnum? type) =>
              value.toLowerCase().contains(type?.type.toLowerCase() ?? ""),
          orElse: () => null,
        );
  }

  /// Gets the string representation of the bundle type
  @override
  String toString() => type;

  String getValidityDisplay(int? count) {
    bool isPlural = false;
    if (count != null) {
      isPlural = count > 1;
    }

    switch (this) {
      case days:
        if (isPlural) {
          return "$count ${LocaleKeys.validity_day_plural.tr()} ";
        }

        return "$count ${LocaleKeys.validity_day.tr()}";
      case weeks:
        if (isPlural) {
          return "$count ${LocaleKeys.validity_week_plural.tr()}";
        }

        return "$count ${LocaleKeys.validity_week.tr()}";
      case months:
        if (isPlural) {
          return "$count ${LocaleKeys.validity_month_plural.tr()}";
        }

        return "$count ${LocaleKeys.validity_month.tr()}";

      case years:
        if (isPlural) {
          return "$count ${LocaleKeys.validity_year_plural.tr()}";
        }

        return "$count ${LocaleKeys.validity_year.tr()}";
    }
  }
}
