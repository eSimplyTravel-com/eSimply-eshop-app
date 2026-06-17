import "package:esim_open_source/domain/data/response/auth/user_info_response_model.dart";

class AuthResponseModel {
  AuthResponseModel({
    this.accessToken,
    this.refreshToken,
    this.userInfo,
    this.userToken,
    this.isVerified,
  });

  final String? accessToken;
  final String? refreshToken;
  final UserInfoResponseModel? userInfo;
  final String? userToken;
  final bool? isVerified;

  AuthResponseModel copyWith({
    String? accessToken,
    String? refreshToken,
    UserInfoResponseModel? userInfo,
    String? userToken,
    bool? isVerified,
  }) {
    return AuthResponseModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      userInfo: userInfo ?? this.userInfo,
      userToken: userToken ?? this.userToken,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
