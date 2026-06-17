import "dart:convert";

import "package:esim_open_source/domain/data/response/account/account_model.dart";
import "package:esim_open_source/utils/parsing_helper.dart";

AccountModelDto accountModelFromJson(String str) =>
    AccountModelDto.fromJson(json: json.decode(str));
String accountModelToJson(AccountModelDto data) => json.encode(data.toJson());

class AccountBalanceParamsDto {
  AccountBalanceParamsDto({
    this.currentBalance,
    this.previousBalance,
    this.lockedBalance,
    this.previousLockedBalance,
  });

  final num? currentBalance;
  final num? previousBalance;
  final num? lockedBalance;
  final num? previousLockedBalance;
}

class AccountPropertiesParamsDto {
  AccountPropertiesParamsDto({
    this.recordGuid,
    this.accountNumber,
    this.currencyCode,
    this.accountTypeTag,
    this.isPrimary,
  });

  final String? recordGuid;
  final String? accountNumber;
  final String? currencyCode;
  final String? accountTypeTag;
  final bool? isPrimary;
}

class AccountModelParamsDto {
  AccountModelParamsDto({
    this.balanceInfo,
    this.accountProperties,
  });

  final AccountBalanceParamsDto? balanceInfo;
  final AccountPropertiesParamsDto? accountProperties;
}

class AccountModelDto {
  AccountModelDto({
    String? recordGuid,
    String? accountNumber,
    num? currentBalance,
    num? previousBalance,
    num? lockedBalance,
    num? previousLockedBalance,
    String? currencyCode,
    String? accountTypeTag,
    bool? isPrimary,
  }) {
    _recordGuid = recordGuid;
    _accountNumber = accountNumber;
    _currentBalance = currentBalance;
    _previousBalance = previousBalance;
    _lockedBalance = lockedBalance;
    _previousLockedBalance = previousLockedBalance;
    _currencyCode = currencyCode;
    _accountTypeTag = accountTypeTag;
    _isPrimary = isPrimary;
  }

  AccountModelDto.fromJson({dynamic json}) {
    _recordGuid = json["recordGuid"];
    _accountNumber = json["accountNumber"];
    _currentBalance = json["currentBalance"];
    _previousBalance = json["previousBalance"];
    _lockedBalance = json["lockedBalance"];
    _previousLockedBalance = json["previousLockedBalance"];
    _currencyCode = json["currencyCode"];
    _accountTypeTag = json["accountTypeTag"];
    _isPrimary = json["isPrimary"];
  }
  String? _recordGuid;
  String? _accountNumber;
  num? _currentBalance;
  num? _previousBalance;
  num? _lockedBalance;
  num? _previousLockedBalance;
  String? _currencyCode;
  String? _accountTypeTag;
  bool? _isPrimary;
  AccountModelDto copyWith([AccountModelParamsDto? params]) =>
      AccountModelDto(
        recordGuid: params?.accountProperties?.recordGuid ?? _recordGuid,
        accountNumber:
            params?.accountProperties?.accountNumber ?? _accountNumber,
        currentBalance: params?.balanceInfo?.currentBalance ?? _currentBalance,
        previousBalance:
            params?.balanceInfo?.previousBalance ?? _previousBalance,
        lockedBalance: params?.balanceInfo?.lockedBalance ?? _lockedBalance,
        previousLockedBalance:
            params?.balanceInfo?.previousLockedBalance ?? _previousLockedBalance,
        currencyCode: params?.accountProperties?.currencyCode ?? _currencyCode,
        accountTypeTag:
            params?.accountProperties?.accountTypeTag ?? _accountTypeTag,
        isPrimary: params?.accountProperties?.isPrimary ?? _isPrimary,
      );
  String? get recordGuid => _recordGuid;
  String? get accountNumber => _accountNumber;
  num? get currentBalance => _currentBalance;
  num? get previousBalance => _previousBalance;
  num? get lockedBalance => _lockedBalance;
  num? get previousLockedBalance => _previousLockedBalance;
  String? get currencyCode => _currencyCode;
  String? get accountTypeTag => _accountTypeTag;
  bool? get isPrimary => _isPrimary;

  AccountsType get accountType {
    if (AccountsType.prepaid.value == accountTypeTag?.toUpperCase()) {
      return AccountsType.prepaid;
    }
    if (AccountsType.postpaid.value == accountTypeTag?.toUpperCase()) {
      return AccountsType.postpaid;
    }
    return AccountsType.unknown;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["recordGuid"] = _recordGuid;
    map["accountNumber"] = _accountNumber;
    map["currentBalance"] = _currentBalance;
    map["previousBalance"] = _previousBalance;
    map["lockedBalance"] = _lockedBalance;
    map["previousLockedBalance"] = _previousLockedBalance;
    map["currencyCode"] = _currencyCode;
    map["accountTypeTag"] = _accountTypeTag;
    map["isPrimary"] = _isPrimary;
    return map;
  }

  static List<AccountModelDto> fromJsonList({dynamic json}) {
    return fromJsonListTyped(parser: AccountModelDto.fromJson, json: json);
  }

  AccountModel toDomain() {
    AccountModel response = AccountModel(
      recordGuid: recordGuid,
      accountNumber: accountNumber,
      currentBalance: currentBalance,
      previousBalance: previousBalance,
      lockedBalance: lockedBalance,
      previousLockedBalance: previousLockedBalance,
      currencyCode: currencyCode,
      accountTypeTag: accountTypeTag,
      isPrimary: isPrimary,
    );
    return response;
  }
}
