enum AccountsType {
  unknown(""),
  prepaid("PREPAID"), // "PREPAID",
  postpaid("POSTPAID"); // "POSTPAID",

  const AccountsType(this.value);

  final String value;
}

class AccountBalanceParams {
  AccountBalanceParams({
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

class AccountPropertiesParams {
  AccountPropertiesParams({
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

class AccountModelParams {
  AccountModelParams({
    this.balanceInfo,
    this.accountProperties,
  });

  final AccountBalanceParams? balanceInfo;
  final AccountPropertiesParams? accountProperties;
}

class AccountModel {
  AccountModel({
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

  String? _recordGuid;
  String? _accountNumber;
  num? _currentBalance;
  num? _previousBalance;
  num? _lockedBalance;
  num? _previousLockedBalance;
  String? _currencyCode;
  String? _accountTypeTag;
  bool? _isPrimary;

  AccountModel copyWith([AccountModelParams? params]) =>
      AccountModel(
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
}
