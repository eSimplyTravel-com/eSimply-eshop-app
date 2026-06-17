class OtpResponseModel {
  OtpResponseModel({
    this.otpExpiration,
  });

  final int? otpExpiration;


  OtpResponseModel copyWith({
    int? otpExpiration,
  }) {
    return OtpResponseModel(
      otpExpiration: otpExpiration ?? this.otpExpiration,
    );
  }
}
