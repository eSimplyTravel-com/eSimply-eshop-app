import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_category_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/bundles/transaction_history_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/transaction_history_response_model.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:esim_open_source/utils/parsing_helper.dart";
import "package:flutter/material.dart";

enum BundleStatus { active, inactive, expired }

class PurchaseOrderInfoParamsDto {
  PurchaseOrderInfoParamsDto({
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
  final List<TransactionHistoryResponseModelDto>? transactionHistory;
}

class EsimActivationParamsDto {
  EsimActivationParamsDto({
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

class BundlePlanStatusParamsDto {
  BundlePlanStatusParamsDto({
    this.isTopupAllowed,
    this.planStarted,
    this.bundleExpired,
  });

  final bool? isTopupAllowed;
  final bool? planStarted;
  final bool? bundleExpired;
}

class BundleDisplayParamsDto {
  BundleDisplayParamsDto({
    this.displayTitle,
    this.displaySubtitle,
    this.icon,
  });

  final String? displayTitle;
  final String? displaySubtitle;
  final String? icon;
}

class BundleInfoParamsDto {
  BundleInfoParamsDto({
    this.bundleCode,
    this.bundleCategory,
    this.bundleMarketingName,
    this.bundleName,
    this.planType,
    this.activityPolicy,
    this.bundleMessage,
  });

  final String? bundleCode;
  final BundleCategoryResponseModelDto? bundleCategory;
  final String? bundleMarketingName;
  final String? bundleName;
  final String? planType;
  final String? activityPolicy;
  final List<String>? bundleMessage;
}

class BundlePricingParamsDto {
  BundlePricingParamsDto({
    this.currencyCode,
    this.price,
    this.priceDisplay,
  });

  final String? currencyCode;
  final num? price;
  final String? priceDisplay;
}

class BundleCoverageParamsDto {
  BundleCoverageParamsDto({
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
  final List<CountryResponseModelDto>? countries;
}

class PurchaseEsimBundleResponseModelParamsDto {
  PurchaseEsimBundleResponseModelParamsDto({
    this.orderInfo,
    this.activation,
    this.status,
    this.display,
    this.bundleInfo,
    this.pricing,
    this.coverage,
  });

  final PurchaseOrderInfoParamsDto? orderInfo;
  final EsimActivationParamsDto? activation;
  final BundlePlanStatusParamsDto? status;
  final BundleDisplayParamsDto? display;
  final BundleInfoParamsDto? bundleInfo;
  final BundlePricingParamsDto? pricing;
  final BundleCoverageParamsDto? coverage;
}

class PurchaseEsimBundleResponseModelDto {
  PurchaseEsimBundleResponseModelDto({
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
    BundleCategoryResponseModelDto? bundleCategory,
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
    List<CountryResponseModelDto>? countries,
    String? icon,
    List<TransactionHistoryResponseModelDto>? transactionHistory,
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

  PurchaseEsimBundleResponseModelDto.fromJson({dynamic json}) {
    _isTopupAllowed = json["is_topup_allowed"];
    _planStarted = json["plan_started"];
    _bundleExpired = json["bundle_expired"];
    _labelName = json["label_name"];
    _orderNumber = json["order_number"];
    _orderStatus = json["order_status"];
    _qrCodeValue = json["qr_code_value"];
    _activationCode = json["activation_code"];
    _smdpAddress = json["smdp_address"];
    _validityDate = json["validity_date"];
    _iccid = json["iccid"];
    _paymentDate = json["payment_date"];
    _sharedWith = json["shared_with"];
    _displayTitle = json["display_title"];
    _displaySubtitle = json["display_subtitle"];
    _bundleCode = json["bundle_code"];
    _bundleCategory = json["bundle_category"] != null
        ? BundleCategoryResponseModelDto.fromJson(json["bundle_category"])
        : null;
    _bundleMarketingName = json["bundle_marketing_name"];
    _bundleName = json["bundle_name"];
    _countCountries = json["count_countries"];
    _currencyCode = json["currency_code"];
    _gprsLimitDisplay = json["gprs_limit_display"];
    _price = json["price"];
    _priceDisplay = json["price_display"];
    _unlimited = json["unlimited"];
    _validity = json["validity"];
    _validityLabel = json["validity_label"];
    _planType = json["plan_type"];
    _activityPolicy = json["activity_policy"];

    _bundleMessage = json["bundle_message"] != null
        ? List<String>.from(json["bundle_message"])
        : <String>[];

    if (json["countries"] != null) {
      _countries = <CountryResponseModelDto>[];
      json["countries"].forEach((dynamic v) {
        _countries?.add(CountryResponseModelDto.fromJson(v));
      });
    }

    _icon = json["icon"];
    if (json["transaction_history"] != null) {
      _transactionHistory = <TransactionHistoryResponseModelDto>[];
      json["transaction_history"].forEach((dynamic v) {
        _transactionHistory?.add(
            TransactionHistoryResponseModelDto.fromJson(v),);
      });
    }
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
  BundleCategoryResponseModelDto? _bundleCategory;
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
  List<CountryResponseModelDto>? _countries;
  String? _icon;
  List<TransactionHistoryResponseModelDto>? _transactionHistory;

  PurchaseEsimBundleResponseModel toDomain() {
    PurchaseEsimBundleResponseModel response = PurchaseEsimBundleResponseModel(
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
      planType: planType,
      activityPolicy: activityPolicy,
      bundleMessage: bundleMessage,
      countries: countries
          ?.map((CountryResponseModelDto dto) => dto.toDomain())
          .toList(),
      icon: icon,
      transactionHistory: transactionHistory?.map((
          TransactionHistoryResponseModelDto dto,) => dto.toDomain(),).toList(),
    );

    return response;
  }

  PurchaseEsimBundleResponseModelDto fromDomain(
      PurchaseEsimBundleResponseModel model,) {
    PurchaseEsimBundleResponseModelDto response = PurchaseEsimBundleResponseModelDto(
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
        bundleCategory: BundleCategoryResponseModelDto().fromDomain(
            model.bundleCategory,),
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
        planType: model.planType,
        activityPolicy: model.activityPolicy,
        bundleMessage: model.bundleMessage,
        countries: model.countries
            ?.map((CountryResponseModel country) =>
                CountryResponseModelDto().fromDomain(country),)
            .toList(),
        icon: model.icon,
        transactionHistory: model.transactionHistory
            ?.map((TransactionHistoryResponseModel history) =>
                TransactionHistoryResponseModelDto().fromDomain(history),)
            .toList(),
    );

    return response;
  }

  PurchaseEsimBundleResponseModelDto copyWith([
    PurchaseEsimBundleResponseModelParamsDto? params,
  ]) =>
      PurchaseEsimBundleResponseModelDto(
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

  BundleCategoryResponseModelDto? get bundleCategory => _bundleCategory;

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

  List<CountryResponseModelDto>? get countries => _countries;

  String? get icon => _icon;

  List<TransactionHistoryResponseModelDto>? get transactionHistory =>
      _transactionHistory;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["is_topup_allowed"] = _isTopupAllowed;
    map["plan_started"] = _planStarted;
    map["bundle_expired"] = _bundleExpired;
    map["label_name"] = _labelName;
    map["order_number"] = _orderNumber;
    map["order_status"] = _orderStatus;
    map["qr_code_value"] = _qrCodeValue;
    map["activation_code"] = _activationCode;
    map["smdp_address"] = _smdpAddress;
    map["validity_date"] = _validityDate;
    map["iccid"] = _iccid;
    map["payment_date"] = _paymentDate;
    map["shared_with"] = _sharedWith;
    map["display_title"] = _displayTitle;
    map["display_subtitle"] = _displaySubtitle;
    map["bundle_code"] = _bundleCode;
    if (_bundleCategory != null) {
      map["bundle_category"] = _bundleCategory?.toJson();
    }
    map["bundle_marketing_name"] = _bundleMarketingName;
    map["bundle_name"] = _bundleName;
    map["count_countries"] = _countCountries;
    map["currency_code"] = _currencyCode;
    map["gprs_limit_display"] = _gprsLimitDisplay;
    map["price"] = _price;
    map["price_display"] = _priceDisplay;
    map["unlimited"] = _unlimited;
    map["validity"] = _validity;
    map["validity_label"] = validityLabel;
    map["plan_type"] = _planType;
    map["activity_policy"] = _activityPolicy;
    map["bundle_message"] = _bundleMessage;
    map["countries"] =
        _countries?.map((CountryResponseModelDto v) => v.toJson()).toList();
    map["icon"] = _icon;
    if (_transactionHistory != null) {
      map["transaction_history"] = _transactionHistory
          ?.map((TransactionHistoryResponseModelDto v) => v.toJson())
          .toList();
    }
    return map;
  }

  String? getValidityDisplay() {
    if (validityLabel != null) {
      ValidityLabelEnum? val =
      ValidityLabelEnum.fromString(validityLabel ?? "");
      return val?.getValidityDisplay(validity?.toInt());
    }
    return null;
  }

  static List<PurchaseEsimBundleResponseModelDto> fromJsonList({dynamic json}) {
    return fromJsonListTyped(
      parser: PurchaseEsimBundleResponseModelDto.fromJson,
      json: json,
    );
  }

  // static String? _mapBundleStatusToString(BundleStatus? status) {
  //   switch (status) {
  //     case BundleStatus.active:
  //       return "active";
  //     case BundleStatus.inactive:
  //       return "inactive";
  //     case BundleStatus.expired:
  //       return "expired";
  //     default:
  //       return null;
  //   }
  // }

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

  static List<PurchaseEsimBundleResponseModelDto> mockItems() {
    String mockBundleName = "Bundle name";
    String mockIccid = "123123";
    String mockOrderStatus = "active";
    String mockPaymentDate = "1740667696";
    String mockDisplayTitle = "Europe5GB10Days";
    String mockDisplaySubtitle = "USD";
    String mockValidityLabel = "Day";
    String mockGprsLimitDisplay = "5 GB";

    return <PurchaseEsimBundleResponseModelDto>[
      PurchaseEsimBundleResponseModelDto(
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
        countries: CountryResponseModelDto.getMockCountries(),
      ),
      PurchaseEsimBundleResponseModelDto(
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
        countries: CountryResponseModelDto.getMockCountries(),
      ),
      PurchaseEsimBundleResponseModelDto(
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
        countries: CountryResponseModelDto.getMockCountries(),
      ),
    ];
  }
}
