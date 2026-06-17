import "dart:convert";

import "package:esim_open_source/domain/data/response/auth/otp_response_model.dart";

class OtpResponseModelDto {
  OtpResponseModelDto({
    this.otpExpiration,
  });

  // Factory constructor for JSON decoding
  factory OtpResponseModelDto.fromJson({dynamic json}) {
    return OtpResponseModelDto(
      otpExpiration: json["otp_expiration"],
    );
  }

  // Factory constructor for JSON decoding
  factory OtpResponseModelDto.fromAPIJson({dynamic json}) {
    return OtpResponseModelDto(
      otpExpiration: json["otp_expiration"],
    );
  }

  final int? otpExpiration;

  // Method for JSON encoding
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "otp_expiration": otpExpiration,
    };
  }

  OtpResponseModelDto copyWith({
    int? otpExpiration,
  }) {
    return OtpResponseModelDto(
      otpExpiration: otpExpiration ?? this.otpExpiration,
    );
  }

  // Convert JSON string to AuthModel
  static OtpResponseModelDto fromJsonString(String jsonString) {
    return OtpResponseModelDto.fromJson(json: jsonDecode(jsonString));
  }

  // Convert AuthModel to JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }

  OtpResponseModel toDomain() {
    OtpResponseModel response = OtpResponseModel(
      otpExpiration: otpExpiration,
    );
    return response;
  }
}
