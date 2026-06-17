class ResendOtpResponseModel {
  ResendOtpResponseModel({
    this.status,
    this.totalCount,
    this.data,
    this.title,
    this.message,
    this.developerMessage,
    this.responseCode,
  });

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

  ResendOtpResponseModel copyWith({
    String? status,
    int? totalCount,
    String? data,
    String? title,
    String? message,
    String? developerMessage,
    int? responseCode,
  }) {
    return ResendOtpResponseModel(
      status: status ?? this.status,
      totalCount: totalCount ?? this.totalCount,
      data: data ?? this.data,
      title: title ?? this.title,
      message: message ?? this.message,
      developerMessage: developerMessage ?? this.developerMessage,
      responseCode: responseCode ?? this.responseCode,
    );
  }
}
