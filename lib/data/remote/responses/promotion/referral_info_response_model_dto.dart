import "dart:convert";

import "package:esim_open_source/domain/data/response/promotion/referral_info_response_model.dart";

class ReferralInfoResponseModelDto {
  ReferralInfoResponseModelDto({
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

  ReferralInfoResponseModelDto.fromJson({dynamic json}) {
    _amount = json["amount"];
    _currency = json["currency"];
    _type = json["type"];
    _message = json["message"];
  }

  factory ReferralInfoResponseModelDto.fromDomain(
    ReferralInfoResponseModel model,
  ) =>
      ReferralInfoResponseModelDto(
        amount: model.amount,
        currency: model.currency,
        type: model.type,
        message: model.message,
      );

  num? _amount;
  String? _currency;
  String? _type;
  String? _message;

  ReferralInfoResponseModelDto copyWith({
    num? amount,
    String? currency,
    String? type,
    String? message,
  }) =>
      ReferralInfoResponseModelDto(
        amount: amount ?? _amount,
        currency: currency ?? _currency,
        type: type ?? _type,
        message: message ?? _message,
      );

  num? get amount => _amount;

  String? get currency => _currency;

  String? get type => _type;

  String? get message => _message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["amount"] = _amount;
    map["currency"] = _currency;
    map["type"] = _type;
    map["message"] = _message;
    return map;
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  // Function to decode JSON string to ReferralInfoResponseModel
  static ReferralInfoResponseModelDto referralInfoFromJsonString(
      String jsonString,) {
    try {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return ReferralInfoResponseModelDto.fromJson(json: jsonMap);
    } catch (e) {
      throw FormatException(
          "Invalid JSON string for ReferralInfoResponseModel: $e",);
    }
  }

  ReferralInfoResponseModel toDomain() {
    ReferralInfoResponseModel response = ReferralInfoResponseModel(
      amount: amount,
      currency: currency,
      type: type,
      message: message,
    );
    return response;
  }
}
