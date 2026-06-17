import "package:esim_open_source/domain/data/params/update_user_info_params.dart";

class UpdateUserInfoRequestDto {
  UpdateUserInfoRequestDto({
    this.email,
    this.msisdn,
    this.firstName,
    this.lastName,
    this.bearerToken,
    this.currencyCode,
    this.languageCode,
  });

  factory UpdateUserInfoRequestDto.fromDomain(UpdateUserInfoRequest request) {
    return UpdateUserInfoRequestDto(
      email: request.email,
      msisdn: request.msisdn,
      firstName: request.firstName,
      lastName: request.lastName,
      bearerToken: request.bearerToken,
      currencyCode: request.currencyCode,
      languageCode: request.languageCode,
    );
  }

  final String? email;
  final String? msisdn;
  final String? firstName;
  final String? lastName;
  final String? bearerToken;
  final String? currencyCode;
  final String? languageCode;

  // Body only — bearerToken is sent as the Authorization header, not the body.
  Map<String, dynamic> toJson() => <String, dynamic>{
        if (email != null) "email": email,
        if (msisdn != null) "msisdn": msisdn,
        if (firstName != null) "first_name": firstName,
        if (lastName != null) "last_name": lastName,
        if (currencyCode != null) "currency": currencyCode,
        if (languageCode != null) "language": languageCode,
      };
}
