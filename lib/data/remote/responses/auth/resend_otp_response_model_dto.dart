import "dart:convert";

import "package:esim_open_source/domain/data/response/auth/resend_otp_response_model.dart";

class ResendOtpResponseModelDto {
  ResendOtpResponseModelDto({
    this.status,
    this.totalCount,
    this.data,
    this.title,
    this.message,
    this.developerMessage,
    this.responseCode,
  });

  factory ResendOtpResponseModelDto.fromJson({dynamic json}) {
    return ResendOtpResponseModelDto(
      status: json["status"],
      totalCount: json["totalCount"],
      data: json["data"],
      title: json["title"],
      message: json["message"],
      developerMessage: json["developerMessage"],
      responseCode: json["responseCode"],
    );
  }

  factory ResendOtpResponseModelDto.fromAPIJson({dynamic json}) {
    return ResendOtpResponseModelDto(
      status: json["status"],
      totalCount: json["totalCount"],
      data: json["data"],
      title: json["title"],
      message: json["message"],
      developerMessage: json["developerMessage"],
      responseCode: json["responseCode"],
    );
  }

  final String? status;
  final int? totalCount;
  final String? data;
  final String? title;
  final String? message;
  final String? developerMessage;
  final int? responseCode;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "status": status,
      "totalCount": totalCount,
      "data": data,
      "title": title,
      "message": message,
      "developerMessage": developerMessage,
      "responseCode": responseCode,
    };
  }

  ResendOtpResponseModelDto copyWith({
    String? status,
    int? totalCount,
    String? data,
    String? title,
    String? message,
    String? developerMessage,
    int? responseCode,
  }) {
    return ResendOtpResponseModelDto(
      status: status ?? this.status,
      totalCount: totalCount ?? this.totalCount,
      data: data ?? this.data,
      title: title ?? this.title,
      message: message ?? this.message,
      developerMessage: developerMessage ?? this.developerMessage,
      responseCode: responseCode ?? this.responseCode,
    );
  }

  static ResendOtpResponseModelDto fromJsonString(String jsonString) {
    return ResendOtpResponseModelDto.fromJson(json: jsonDecode(jsonString));
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  ResendOtpResponseModel toDomain() {
      ResendOtpResponseModel response = ResendOtpResponseModel(
        status: status,
        totalCount: totalCount,
        data: data,
        title: title,
        message: message,
        developerMessage: developerMessage,
        responseCode: responseCode,
      );
      return response;
  }
}
