import "package:easy_localization/easy_localization.dart"
    show StringTranslateExtension;
import "package:esim_open_source/domain/data/response/bundles/bundle_category_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart"
    show LocaleKeys;

class BundleResponseModel {
  BundleResponseModel({
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

  final String? displayTitle;
  final String? displaySubtitle;
  final String? bundleCode;
  final BundleCategoryResponseModel? bundleCategory;
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
  final List<CountryResponseModel>? countries;
  final String? label;

  bool get isCruise => bundleCategory?.isCruise ?? false;

  String? getValidityDisplay() {
    if (validityLabel != null) {
      ValidityLabelEnum? val =
      ValidityLabelEnum.fromString(validityLabel ?? "");
      return val?.getValidityDisplay(validity);
    }
    return null;
  }

  static List<BundleResponseModel> getMockGlobalBundles() {
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

    final List<BundleResponseModel> mockBundles = <BundleResponseModel>[
      BundleResponseModel(
        icon: placeholderIcon,
        bundleCategory: BundleCategoryResponseModel(
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
        countries: <CountryResponseModel>[
          CountryResponseModel(
            country: "Albania",
            countryCode: "Unknown",
            iso3Code: "ALB",
            icon: flagApiIcon,
            zoneName: "Unknown",
            alternativeCountry: "Albania",
          ),
        ],
      ),
      BundleResponseModel(
        icon: placeholderIcon,
        bundleCategory: BundleCategoryResponseModel(
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
        countries: <CountryResponseModel>[],
      ),
      BundleResponseModel(
        icon: placeholderIcon,
        bundleCategory: BundleCategoryResponseModel(
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
        countries: <CountryResponseModel>[],
      ),
      BundleResponseModel(
        icon: placeholderIcon,
        bundleCategory: BundleCategoryResponseModel(
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
        countries: <CountryResponseModel>[
          CountryResponseModel(
            country: "France",
            countryCode: "Unknown",
            iso3Code: "FRA",
            icon: flagApiIcon,
            zoneName: "Unknown",
            alternativeCountry: "France",
          ),
          CountryResponseModel(
            country: "Turkey",
            countryCode: "Unknown",
            iso3Code: "TUR",
            icon: flagApiIcon,
            zoneName: "Unknown",
            alternativeCountry: "Türkiye",
          ),
        ],
      ),
      BundleResponseModel(
        icon: placeholderIcon,
        bundleCategory: BundleCategoryResponseModel(
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
        countries: <CountryResponseModel>[],
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
