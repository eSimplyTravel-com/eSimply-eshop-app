// ignore_for_file: use_function_type_syntax_for_parameters

import "dart:async";
import "dart:convert";
import "dart:developer";

import "package:esim_open_source/data/remote/api_end_point.dart";
import "package:esim_open_source/data/remote/apis/http_client_wrapper.dart";
import "package:esim_open_source/data/remote/auth_reload_interface.dart";
import "package:esim_open_source/data/remote/http_methods.dart";
import "package:esim_open_source/data/remote/responses/base_response_model_dto.dart";
import "package:esim_open_source/data/remote/unauthorized_access_interface.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/utils/log_helper.dart";
import "package:http/http.dart" as http;

class HttpRequest {
  static int _defaultTimeoutSeconds = 30;

  static final List<WeakReference<UnauthorizedAccessListener>>
      _unauthorizedAccessCallBackListeners =
      <WeakReference<UnauthorizedAccessListener>>[];

  // Add a listener with weak reference
  static void addUnauthorizedAccessCallBackListener(
    UnauthorizedAccessListener listener,
  ) {
    _unauthorizedAccessCallBackListeners
        .add(WeakReference<UnauthorizedAccessListener>(listener));
  }

  // Remove a listener
  static void removeUnauthorizedAccessCallBackListener(
    UnauthorizedAccessListener listener,
  ) {
    _unauthorizedAccessCallBackListeners.removeWhere(
      (WeakReference<UnauthorizedAccessListener> weakRef) =>
          weakRef.target == listener,
    );
  }

  // Notify all listeners
  static void notifyUnauthorizedAccessCallBackListeners(
    http.BaseResponse? base,
    Exception? ex,
  ) {
    _unauthorizedAccessCallBackListeners.removeWhere(
      (WeakReference<UnauthorizedAccessListener> weakRef) =>
          weakRef.target == null,
    );
    for (final WeakReference<UnauthorizedAccessListener> weakRef
        in _unauthorizedAccessCallBackListeners) {
      final UnauthorizedAccessListener? listener = weakRef.target;
      if (listener != null) {
        listener.onUnauthorizedAccessCallBackUseCase(base, ex);
      }
    }
  }

  // auth reloaded
  static final List<WeakReference<AuthReloadListener>> _authReloadListeners =
      <WeakReference<AuthReloadListener>>[];

  // Add a listener with weak reference
  static void addAuthReloadListenerCallBack(
    AuthReloadListener listener,
  ) {
    _authReloadListeners.add(WeakReference<AuthReloadListener>(listener));
  }

  // Remove a listener
  static void removeAuthReloadListenerCallBack(
    AuthReloadListener listener,
  ) {
    _authReloadListeners.removeWhere(
      (WeakReference<AuthReloadListener> weakRef) => weakRef.target == listener,
    );
  }

  // Notify all listeners
  static void notifyAuthReloadListeners(AuthResponseModel? authResponse) {
    _authReloadListeners.removeWhere(
          (WeakReference<AuthReloadListener> weakRef) => weakRef.target == null,
    );
    for (final WeakReference<AuthReloadListener> weakRef
    in _authReloadListeners) {
      final AuthReloadListener? listener = weakRef.target;
      if (listener != null) {
        listener.onAuthReloadListenerCallBackUseCase(authResponse);
      }
    }
  }


  // ignore: unnecessary_getters_setters
  static int get defaultTimeoutSeconds => _defaultTimeoutSeconds;

  static set defaultTimeoutSeconds(int timeout) =>
      _defaultTimeoutSeconds = timeout;

  static Future<ResponseMainDto<T>> sendRequestMain<T>({
    required APIEndPoint endPoint,
    T Function({dynamic json})? fromJson,
    HttpClientWrapper? client,
    int? timeoutSeconds,
    List<http.MultipartFile>? files,
  }) async {
    if (endPoint.method == HttpMethod.MULTIPART) {
      // Assuming multipart handling is unchanged
      return _sendMultipartMain<T>(
        client: client,
        endPoint: endPoint,
        fromJson: fromJson,
        files: files,
      );
    }

    http.Request request = http.Request(
      endPoint.method.name,
      Uri.parse(endPoint.fullURL),
    );

    // Set headers from the endpoint
    request.headers.addAll(
      endPoint.headers,
    );

    // Optionally, set the body if it's a POST or PUT request
    if (endPoint.method == HttpMethod.POST ||
        endPoint.method == HttpMethod.PUT) {
      request.body = jsonEncode(
        endPoint.parameters,
      ); // Make sure the body is set if needed
    }

    try {
      http.StreamedResponse response = client != null
          ? await client.mySend(request, endPoint).timeout(
                Duration(
                  seconds: timeoutSeconds ?? _defaultTimeoutSeconds,
                ),
              )
          : await request.send().timeout(
                Duration(
                  seconds: timeoutSeconds ?? _defaultTimeoutSeconds,
                ),
              );

      // Assuming `_validateMainAndParseResponse` returns a parsed object of type T
      return _validateMainAndParseResponse<T>(
        response,
        fromJson,
        "URL:${endPoint.fullURL} \nRequestType: ${endPoint.method.name} \n",
        endPoint.isRefreshToken,
      );
    } on TimeoutException {
      log("Request timed out after ${timeoutSeconds ?? _defaultTimeoutSeconds} seconds.");
      throw MainTimeoutException(message: "Time out exception");
    }
  }

  static Future<ResponseMainDto<T>> _sendMultipartMain<T>({
    required APIEndPoint endPoint,
    T Function({dynamic json})? fromJson,
    HttpClientWrapper? client,
    int? timeoutSeconds,
    List<http.MultipartFile>? files,
  }) async {
    // Prepare the multipart request
    http.MultipartRequest request = http.MultipartRequest(
      HttpMethod.POST.name,
      Uri.parse(endPoint.fullURL),
    );

    // Add headers
    request.headers.addAll(endPoint.headers);

    // Add fields (parameters) to the request
    request.fields.addAll(
      endPoint.parameters.map(
        (String key, dynamic value) =>
            MapEntry<String, String>(key, value?.toString() ?? ""),
      ),
    );

    // Add files if available
    if (files?.isNotEmpty ?? false) {
      for (int i = 0; i < files!.length; i++) {
        request.files.add(files[i]);
      }
    }

    try {
      // Send the request and get the response
      http.StreamedResponse response = client != null
          ? await client.mySend(request, endPoint).timeout(
                Duration(seconds: timeoutSeconds ?? _defaultTimeoutSeconds),
              )
          : await request.send().timeout(
                Duration(seconds: timeoutSeconds ?? _defaultTimeoutSeconds),
              );

      // Parse and validate the response using the provided `fromJson` function
      return _validateMainAndParseResponse<T>(
        response,
        fromJson,
        "URL:${endPoint.fullURL} \nRequestType: ${endPoint.method.name} \n",
        false,
      );
    } on TimeoutException {
      log("Request timed out after ${timeoutSeconds ?? _defaultTimeoutSeconds} seconds.");
      throw MainTimeoutException(message: "Time out exception");
    }
  }

  static Future<ResponseMainDto<T>> _validateMainAndParseResponse<T>(
    http.StreamedResponse response,
    T Function({dynamic json})? fromJson,
    String debugInfo,
    bool isRefreshTokenApi,
  ) async {
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 400 ||
        response.statusCode == 404 ||
        response.statusCode == 429) {
      ResponseMainDto<T>? responseMain;
      try {
        String result = await response.stream.bytesToString();

        // Debug print the raw response
        log("${debugInfo}Response Raw: $result $printHeader('Request End')");

        // Parse the response using the fromJson function
        responseMain = ResponseMainDto<T>.fromJson(
          response: result,
          fromJson: fromJson,
          statusCode: response.statusCode,
        );

        if (responseMain.responseCode == null ||
            (responseMain.responseCode ?? -2000) > 0) {
          return responseMain; // Return the parsed response as T
        }
      } catch (e) {
        throw ResponseMainException(
          ResponseMainDto<T>.createError(
            responseCode: response.statusCode,
            errorMessage: e.toString(),
          ),
        );
      }

      throw ResponseMainException(
        ResponseMainDto<T>.createErrorWithData(
          title: responseMain.title,
          status: responseMain.status,
          totalCount: responseMain.totalCount,
          statusCode: responseMain.statusCode,
          developerMessage: responseMain.developerMessage,
          responseCode: responseMain.responseCode ?? -2000,
          message: responseMain.message ?? "",
          data: responseMain.data,
        ),
      );
    } else {
      // Handle specific case for unauthorized access
      if (isRefreshTokenApi && response.statusCode == 401) {
        try {
          String result = await response.stream.bytesToString();

          log("${debugInfo}Response Raw: $result $printHeader('Request End')");
        } on Exception catch (e) {
          log("${debugInfo}Response Raw: \n $e $printHeader('Request End')");
        }
        notifyUnauthorizedAccessCallBackListeners(response, null);
      }

      // Throw an error for other status codes
      throw ResponseMainException(
        ResponseMainDto<T>.createError(
          responseCode: response.statusCode,
          errorMessage: response.reasonPhrase ?? "no reason shared",
        ),
      );
    }
  }
}
