import "dart:convert";

import "package:esim_open_source/data/remote/json_convert.dart";
import "package:esim_open_source/domain/util/network_constants.dart";

//Response Main Base Request Model
class ResponseMainDto<T> {
  ResponseMainDto.createError({
    required int responseCode,
    required String errorMessage,
  }) {
    _message = errorMessage;
    _responseCode = responseCode;
  }

  ResponseMainDto.createErrorWithData({
    dynamic data,
    String? title,
    String? status,
    String? message,
    int? totalCount,
    int? statusCode,
    int? responseCode,
    String? developerMessage,
  }) {
    _data = data;
    _title = title;
    _status = status;
    _message = message;
    _totalCount = totalCount;
    _statusCode = statusCode;
    _responseCode = responseCode;
    _developerMessage = developerMessage;
  }

  ResponseMainDto.fromJson({
    required int statusCode,
    required String response,
    required T Function({dynamic json})? fromJson,
  }) {
    _statusCode = statusCode;

    Map<String, dynamic> json = jsonDecode(response);
    _title = jsonConvert.convert<String?>(json["title"]);
    _status = jsonConvert.convert<String?>(json["status"]);
    _message = jsonConvert.convert<String?>(json["message"]);
    _totalCount = jsonConvert.convert<int?>(json["totalCount"]);
    _responseCode = jsonConvert.convert<int?>(json["responseCode"]);
    _developerMessage = jsonConvert.convert<String?>(json["developerMessage"]);

    if (json["data"] != null) {
      if (fromJson != null) {
        _data = fromJson(json: json["data"]);
      } else {
        _data = json["data"];
      }
    }
  }

  dynamic _data;
  String? _title;
  String? _status;
  String? _message;
  int? _totalCount;
  int? _statusCode;
  int? _responseCode;
  String? _developerMessage;

  T get dataOfType {
    return data as T;
  }

  dynamic get data => _data;

  String? get title => _title;

  String? get status => _status;

  String? get message => _message;

  int? get totalCount => _totalCount;

  int? get statusCode => _statusCode;

  int? get responseCode => _responseCode;

  String? get developerMessage => _developerMessage;
}

//Response Main Base Request Model Exception
class ResponseMainException implements Exception {
  ResponseMainException(this._errorReply) : super();
  final ResponseMainDto<dynamic> _errorReply;

  dynamic get data => _errorReply.data;

  String? get message => _errorReply.message;

  int? get errorCode => _errorReply.responseCode;

  @override
  String toString() {
    return message ?? "General Error";
  }
}

// Main Timeout Exception
class MainTimeoutException extends ResponseMainException {
  MainTimeoutException({
    String message = "Request timeout",
    dynamic data,
  }) : super(
          ResponseMainDto<dynamic>.createErrorWithData(
            data: data,
            message: message,
            responseCode: timeoutErrorCode,
            statusCode: timeoutErrorCode,
            title: "Timeout",
            status: "timeout",
            developerMessage: "The request took too long to respond",
          ),
        ); // or any code you prefer
}
