import "dart:convert";

import "package:esim_open_source/data/remote/responses/auth/user_info_response_model_dto.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";

class AuthResponseModelDto {
  AuthResponseModelDto({
    this.accessToken,
    this.refreshToken,
    this.userInfo,
    this.userToken,
    this.isVerified,
  });

  // Factory constructor for JSON decoding
  factory AuthResponseModelDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseModelDto(
      accessToken: json["access_token"],
      refreshToken: json["refresh_token"],
      userInfo: json["user_info"] != null
          ? UserInfoResponseModelDto.fromJson(json["user_info"])
          : null,
      userToken: json["user_token"],
      isVerified: json["is_verified"],
    );
  }

  factory AuthResponseModelDto.fromDomain(AuthResponseModel domain) {
    return AuthResponseModelDto(
      accessToken: domain.accessToken,
      refreshToken: domain.refreshToken,
      userInfo: domain.userInfo == null
          ? null
          : UserInfoResponseModelDto.fromDomain(domain.userInfo!),
      userToken: domain.userToken,
      isVerified: domain.isVerified,
    );
  }

  // Factory constructor for JSON decoding
  factory AuthResponseModelDto.fromAPIJson({dynamic json}) {
    return AuthResponseModelDto(
      accessToken: json["access_token"],
      refreshToken: json["refresh_token"],
      userInfo: json["user_info"] != null
          ? UserInfoResponseModelDto.fromJson(json["user_info"])
          : null,
      userToken: json["user_token"],
      isVerified: json["is_verified"],
    );
  }

  final String? accessToken;
  final String? refreshToken;
  final UserInfoResponseModelDto? userInfo;
  final String? userToken;
  final bool? isVerified;

  // Method for JSON encoding
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "access_token": accessToken,
      "refresh_token": refreshToken,
      "user_info": userInfo?.toJson(),
      "user_token": userToken,
      "is_verified": isVerified,
    };
  }

  AuthResponseModelDto copyWith({
    String? accessToken,
    String? refreshToken,
    UserInfoResponseModelDto? userInfo,
    String? userToken,
    bool? isVerified,
  }) {
    return AuthResponseModelDto(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      userInfo: userInfo ?? this.userInfo,
      userToken: userToken ?? this.userToken,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  // Convert JSON string to AuthModel
  static AuthResponseModelDto fromJsonString(String jsonString) {
    return AuthResponseModelDto.fromJson(jsonDecode(jsonString));
  }

  // Convert AuthModel to JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }

  AuthResponseModel toDomain() {
      AuthResponseModel response = AuthResponseModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userInfo: userInfo?.toDomain(),
        userToken: userToken,
        isVerified: isVerified,
      );
      return response;
  }
}
