class ReferralInfoResponseModel {
  ReferralInfoResponseModel({
    num? amount,
    String? currency,
    String? type,
    String? message,
  }) {
    _amount = amount;
    _currency = currency;
    _type = type;
    _message = message;
  }

  num? _amount;
  String? _currency;
  String? _type;
  String? _message;

  ReferralInfoResponseModel copyWith({
    num? amount,
    String? currency,
    String? type,
    String? message,
  }) =>
      ReferralInfoResponseModel(
        amount: amount ?? _amount,
        currency: currency ?? _currency,
        type: type ?? _type,
        message: message ?? _message,
      );

  num? get amount => _amount;

  String? get currency => _currency;

  String? get type => _type;

  String? get message => _message;
}
