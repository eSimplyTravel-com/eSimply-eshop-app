class UserInfoResponseModel {
  UserInfoResponseModel({
    this.isVerified,
    this.referralCode,
    this.userToken,
    this.roleName,
    this.balance,
    this.currencyCode,
    this.msisdn,
    this.firstName,
    this.lastName,
    this.language,
    this.country,
    this.countryCode,
    this.email,
  });

  final bool? isVerified;
  final String? referralCode;
  final String? userToken;
  final String? roleName;
  final double? balance;
  final String? currencyCode;
  final String? msisdn;
  final String? firstName;
  final String? lastName;
  final String? language;
  final String? country;
  final String? countryCode;
  final String? email;

}
