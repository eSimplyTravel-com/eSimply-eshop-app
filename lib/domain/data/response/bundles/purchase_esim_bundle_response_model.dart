import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_category_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/transaction_history_response_model.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";

enum BundleStatus { active, inactive, expired }

class PurchaseOrderInfoParams {
  PurchaseOrderInfoParams({
    this.labelName,
    this.orderNumber,
    this.orderStatus,
    this.iccid,
    this.paymentDate,
    this.sharedWith,
    this.transactionHistory,
  });

  final String? labelName;
  final String? orderNumber;
  final String? orderStatus;
  final String? iccid;
  final String? paymentDate;
  final String? sharedWith;
  final List<TransactionHistoryResponseModel>? transactionHistory;
}

class EsimActivationParams {
  EsimActivationParams({
    this.qrCodeValue,
    this.activationCode,
    this.smdpAddress,
    this.validityDate,
  });

  final String? qrCodeValue;
  final String? activationCode;
  final String? smdpAddress;
  final String? validityDate;
}

class BundlePlanStatusParams {
  BundlePlanStatusParams({
    this.isTopupAllowed,
    this.planStarted,
    this.bundleExpired,
  });

  final bool? isTopupAllowed;
  final bool? planStarted;
  final bool? bundleExpired;
}

class BundleDisplayParams {
  BundleDisplayParams({
    this.displayTitle,
    this.displaySubtitle,
    this.icon,
  });

  final String? displayTitle;
  final String? displaySubtitle;
  final String? icon;
}

class BundleInfoParams {
  BundleInfoParams({
    this.bundleCode,
    this.bundleCategory,
    this.bundleMarketingName,
    this.bundleName,
    this.planType,
    this.activityPolicy,
    this.bundleMessage,
  });

  final String? bundleCode;
  final BundleCategoryResponseModel? bundleCategory;
  final String? bundleMarketingName;
  final String? bundleName;
  final String? planType;
  final String? activityPolicy;
  final List<String>? bundleMessage;
}

class BundlePricingParams {
  BundlePricingParams({
    this.currencyCode,
    this.price,
    this.priceDisplay,
  });

  final String? currencyCode;
  final num? price;
  final String? priceDisplay;
}

class BundleCoverageParams {
  BundleCoverageParams({
    this.countCountries,
    this.gprsLimitDisplay,
    this.unlimited,
    this.validity,
    this.validityLabel,
    this.countries,
  });

  final num? countCountries;
  final String? gprsLimitDisplay;
  final bool? unlimited;
  final num? validity;
  final String? validityLabel;
  final List<CountryResponseModel>? countries;
}

class PurchaseEsimBundleResponseModelParams {
  PurchaseEsimBundleResponseModelParams({
    this.orderInfo,
    this.activation,
    this.status,
    this.display,
    this.bundleInfo,
    this.pricing,
    this.coverage,
  });

  final PurchaseOrderInfoParams? orderInfo;
  final EsimActivationParams? activation;
  final BundlePlanStatusParams? status;
  final BundleDisplayParams? display;
  final BundleInfoParams? bundleInfo;
  final BundlePricingParams? pricing;
  final BundleCoverageParams? coverage;
}

class PurchaseEsimBundleResponseModel {
  PurchaseEsimBundleResponseModel({
    bool? isTopupAllowed,
    bool? planStarted,
    bool? bundleExpired,
    String? labelName,
    String? orderNumber,
    String? orderStatus,
    String? qrCodeValue,
    String? activationCode,
    String? smdpAddress,
    String? validityDate,
    String? iccid,
    String? paymentDate,
    String? sharedWith,
    String? displayTitle,
    String? displaySubtitle,
    String? bundleCode,
    BundleCategoryResponseModel? bundleCategory,
    String? bundleMarketingName,
    String? bundleName,
    num? countCountries,
    String? currencyCode,
    String? gprsLimitDisplay,
    num? price,
    String? priceDisplay,
    bool? unlimited,
    num? validity,
    String? validityLabel,
    String? planType,
    String? activityPolicy,
    List<String>? bundleMessage,
    List<CountryResponseModel>? countries,
    String? icon,
    List<TransactionHistoryResponseModel>? transactionHistory,
  }) {
    _isTopupAllowed = isTopupAllowed;
    _planStarted = planStarted;
    _bundleExpired = bundleExpired;
    _labelName = labelName;
    _orderNumber = orderNumber;
    _orderStatus = orderStatus;
    _qrCodeValue = qrCodeValue;
    _activationCode = activationCode;
    _smdpAddress = smdpAddress;
    _validityDate = validityDate;
    _iccid = iccid;
    _paymentDate = paymentDate;
    _sharedWith = sharedWith;
    _displayTitle = displayTitle;
    _displaySubtitle = displaySubtitle;
    _bundleCode = bundleCode;
    _bundleCategory = bundleCategory;
    _bundleMarketingName = bundleMarketingName;
    _bundleName = bundleName;
    _countCountries = countCountries;
    _currencyCode = currencyCode;
    _gprsLimitDisplay = gprsLimitDisplay;
    _price = price;
    _priceDisplay = priceDisplay;
    _unlimited = unlimited;
    _validity = validity;
    _validityLabel = validityLabel;
    _planType = planType;
    _activityPolicy = activityPolicy;
    _bundleMessage = bundleMessage;
    _countries = countries;
    _icon = icon;
    _transactionHistory = transactionHistory;
  }

  bool? _isTopupAllowed;
  bool? _planStarted;
  bool? _bundleExpired;
  String? _labelName;
  String? _orderNumber;
  String? _orderStatus;
  String? _qrCodeValue;
  String? _activationCode;
  String? _smdpAddress;
  String? _validityDate;
  String? _iccid;
  String? _paymentDate;
  String? _sharedWith;
  String? _displayTitle;
  String? _displaySubtitle;
  String? _bundleCode;
  BundleCategoryResponseModel? _bundleCategory;
  String? _bundleMarketingName;
  String? _bundleName;
  num? _countCountries;
  String? _currencyCode;
  String? _gprsLimitDisplay;
  num? _price;
  String? _priceDisplay;
  bool? _unlimited;
  num? _validity;
  String? _validityLabel;
  String? _planType;
  String? _activityPolicy;
  List<String>? _bundleMessage;
  List<CountryResponseModel>? _countries;
  String? _icon;
  List<TransactionHistoryResponseModel>? _transactionHistory;

  PurchaseEsimBundleResponseModel copyWith([
    PurchaseEsimBundleResponseModelParams? params,
  ]) =>
      PurchaseEsimBundleResponseModel(
        isTopupAllowed: params?.status?.isTopupAllowed ?? _isTopupAllowed,
        planStarted: params?.status?.planStarted ?? _planStarted,
        bundleExpired: params?.status?.bundleExpired ?? _bundleExpired,
        labelName: params?.orderInfo?.labelName ?? _labelName,
        orderNumber: params?.orderInfo?.orderNumber ?? _orderNumber,
        orderStatus: params?.orderInfo?.orderStatus ?? _orderStatus,
        qrCodeValue: params?.activation?.qrCodeValue ?? _qrCodeValue,
        activationCode: params?.activation?.activationCode ?? _activationCode,
        smdpAddress: params?.activation?.smdpAddress ?? _smdpAddress,
        validityDate: params?.activation?.validityDate ?? _validityDate,
        iccid: params?.orderInfo?.iccid ?? _iccid,
        paymentDate: params?.orderInfo?.paymentDate ?? _paymentDate,
        sharedWith: params?.orderInfo?.sharedWith ?? _sharedWith,
        displayTitle: params?.display?.displayTitle ?? _displayTitle,
        displaySubtitle: params?.display?.displaySubtitle ?? _displaySubtitle,
        bundleCode: params?.bundleInfo?.bundleCode ?? _bundleCode,
        bundleCategory: params?.bundleInfo?.bundleCategory ?? _bundleCategory,
        bundleMarketingName:
            params?.bundleInfo?.bundleMarketingName ?? _bundleMarketingName,
        bundleName: params?.bundleInfo?.bundleName ?? _bundleName,
        countCountries: params?.coverage?.countCountries ?? _countCountries,
        currencyCode: params?.pricing?.currencyCode ?? _currencyCode,
        gprsLimitDisplay:
            params?.coverage?.gprsLimitDisplay ?? _gprsLimitDisplay,
        price: params?.pricing?.price ?? _price,
        priceDisplay: params?.pricing?.priceDisplay ?? _priceDisplay,
        unlimited: params?.coverage?.unlimited ?? _unlimited,
        validity: params?.coverage?.validity ?? _validity,
        validityLabel: params?.coverage?.validityLabel ?? _validityLabel,
        planType: params?.bundleInfo?.planType ?? _planType,
        activityPolicy: params?.bundleInfo?.activityPolicy ?? _activityPolicy,
        bundleMessage: params?.bundleInfo?.bundleMessage ?? _bundleMessage,
        countries: params?.coverage?.countries ?? _countries,
        icon: params?.display?.icon ?? _icon,
        transactionHistory:
            params?.orderInfo?.transactionHistory ?? _transactionHistory,
      );

  bool? get isTopupAllowed => _isTopupAllowed;

  bool? get planStarted => _planStarted;

  bool? get bundleExpired => _bundleExpired;

  String? get labelName => _labelName;

  String? get orderNumber => _orderNumber;

  String? get orderStatus => _orderStatus;

  String? get qrCodeValue => _qrCodeValue;

  String? get activationCode => _activationCode;

  String? get smdpAddress => _smdpAddress;

  String? get validityDate => _validityDate;

  String? get iccid => _iccid;

  String? get paymentDate => _paymentDate;

  dynamic get sharedWith => _sharedWith;

  String? get displayTitle => _displayTitle;

  String? get displaySubtitle => _displaySubtitle;

  String? get bundleCode => _bundleCode;

  BundleCategoryResponseModel? get bundleCategory => _bundleCategory;

  String? get bundleMarketingName => _bundleMarketingName;

  String? get bundleName => _bundleName;

  num? get countCountries => _countCountries;

  String? get currencyCode => _currencyCode;

  String? get gprsLimitDisplay => _gprsLimitDisplay;

  num? get price => _price;

  String? get priceDisplay => _priceDisplay;

  bool? get unlimited => _unlimited;

  num? get validity => _validity;

  String? get validityLabel => _validityLabel;

  String? get planType => _planType;

  String? get activityPolicy => _activityPolicy;

  List<String>? get bundleMessage => _bundleMessage;

  List<CountryResponseModel>? get countries => _countries;

  String? get icon => _icon;

  List<TransactionHistoryResponseModel>? get transactionHistory =>
      _transactionHistory;

  String? getValidityDisplay() {
    if (validityLabel != null) {
      ValidityLabelEnum? val =
      ValidityLabelEnum.fromString(validityLabel ?? "");
      return val?.getValidityDisplay(validity?.toInt());
    }
    return null;
  }

  static BundleStatus? _mapStringToBundleStatus(String? status) {
    switch ((status ?? "").toLowerCase()) {
      case "active":
        return BundleStatus.active;
      case "inactive":
        return BundleStatus.inactive;
      case "expired":
        return BundleStatus.expired;
      default:
        return null;
    }
  }

  Color getStatusBgColor(BuildContext context) {
    switch (_mapStringToBundleStatus(orderStatus ?? "")) {
      case BundleStatus.active:
        return context.appColors.success_50 ??
            context.appColors.baseWhite ??
            Colors.transparent;
      case BundleStatus.inactive:
        return context.appColors.warning_50 ??
            context.appColors.baseWhite ??
            Colors.transparent;
      case BundleStatus.expired:
        return context.appColors.error_50 ??
            context.appColors.baseWhite ??
            Colors.transparent;
      default:
        return context.appColors.baseWhite ?? Colors.transparent;
    }
  }

  Color getStatusTextColor(BuildContext context) {
    switch (_mapStringToBundleStatus(orderStatus ?? "")) {
      case BundleStatus.active:
        return context.appColors.success_700 ??
            context.appColors.baseWhite ??
            Colors.transparent;
      case BundleStatus.inactive:
        return context.appColors.warning_700 ??
            context.appColors.baseWhite ??
            Colors.transparent;
      case BundleStatus.expired:
        return context.appColors.error_500 ??
            context.appColors.baseWhite ??
            Colors.transparent;
      default:
        return context.appColors.baseWhite ?? Colors.transparent;
    }
  }

  String getStatusText() {
    switch (_mapStringToBundleStatus(orderStatus ?? "")) {
      case BundleStatus.active:
        return LocaleKeys.status_active.tr();
      case BundleStatus.inactive:
        return LocaleKeys.status_inactive.tr();
      case BundleStatus.expired:
        return LocaleKeys.status_expired.tr();
      default:
        return "";
    }
  }

  String? getDisplayName() {
    if (transactionHistory != null) {
      if ((transactionHistory?.length ?? 0) > 0) {
        if (transactionHistory?.first.bundle?.label?.isNotEmpty ?? false) {
          return transactionHistory?.first.bundle?.label;
        }
      }
    }
    return bundleName;
  }

  static List<PurchaseEsimBundleResponseModel> mockItems() {
    String mockBundleName = "Bundle name";
    String mockIccid = "123123";
    String mockOrderStatus = "active";
    String mockPaymentDate = "1740667696";
    String mockDisplayTitle = "Europe5GB10Days";
    String mockDisplaySubtitle = "USD";
    String mockValidityLabel = "Day";
    String mockGprsLimitDisplay = "5 GB";

    return <PurchaseEsimBundleResponseModel>[
      PurchaseEsimBundleResponseModel(
        iccid: mockIccid,
        orderStatus: mockOrderStatus,
        validity: 1740667696,
        paymentDate: mockPaymentDate,
        bundleExpired: false,
        bundleName: mockBundleName,
        displayTitle: mockDisplayTitle,
        displaySubtitle: mockDisplaySubtitle,
        validityLabel: mockValidityLabel,
        gprsLimitDisplay: mockGprsLimitDisplay,
        // icon: "https://placehold.co/600x400?bundle=None",
        countries: CountryResponseModel.getMockCountries(),
      ),
      PurchaseEsimBundleResponseModel(
        iccid: mockIccid,
        orderStatus: mockOrderStatus,
        validity: 1740667696,
        paymentDate: mockPaymentDate,
        bundleExpired: false,
        bundleName: mockBundleName,
        displayTitle: mockDisplayTitle,
        displaySubtitle: mockDisplaySubtitle,
        validityLabel: mockValidityLabel,
        gprsLimitDisplay: mockGprsLimitDisplay,
        // icon: "https://placehold.co/600x400?bundle=None",
        countries: CountryResponseModel.getMockCountries(),
      ),
      PurchaseEsimBundleResponseModel(
        iccid: mockIccid,
        orderStatus: mockOrderStatus,
        validity: 1740667696,
        paymentDate: mockPaymentDate,
        bundleExpired: false,
        bundleName: mockBundleName,
        displayTitle: mockDisplayTitle,
        displaySubtitle: mockDisplaySubtitle,
        validityLabel: mockValidityLabel,
        gprsLimitDisplay: mockGprsLimitDisplay,
        // icon: "https://placehold.co/600x400?bundle=None",
        countries: CountryResponseModel.getMockCountries(),
      ),
    ];
  }
}
