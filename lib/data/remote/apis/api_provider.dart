import "dart:async";
import "dart:convert";
import "dart:developer";
import "dart:io";

import "package:esim_open_source/data/remote/api_end_point.dart";
import "package:esim_open_source/data/remote/apis/auth_apis/auth_apis.dart";
import "package:esim_open_source/data/remote/apis/http_client_wrapper.dart";
import "package:esim_open_source/data/remote/http_methods.dart";
import "package:esim_open_source/data/remote/http_request.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model_dto.dart";
import "package:esim_open_source/data/remote/responses/base_response_model_dto.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/services/connectivity_service.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/secure_storage_service.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/utils/generation_helper.dart";
import "package:http/http.dart" as http;

/// The KEYS USED in All APIS.
enum ApiParamsKeys {
  languageID("LanguageID"),
  userToken("UserToken"),
  tenant("tenant");

  const ApiParamsKeys(this.value);

  final String value;
}

enum MediaContentType {
  imagePNG("image", "png"),
  imageJPG("image", "jpg");

  const MediaContentType(this.type, this.subType);

  final String type;
  final String subType;

  String get mimeType => "$type/$subType";
}

class APIService {
  APIService.privateConstructor() {
    unawaited(_internal());
  }

  static APIService? _instance;
  static HttpClientWrapper? _client;

  HttpClientWrapper get client => _client!;

  static APIService get instance {
    if (_instance == null) {
      _instance = APIService.privateConstructor();
      _instance?.initialise();
    }
    return _instance!;
  }

  void initialise() {}

  Future<bool> get isLoggedIn async {
    return locator<LocalStorageService>().accessToken.isNotEmpty;
  }

  Future<void> _internal() async {
    _client ??= await _getSSLPinningClient();
  }

  FutureOr<String> get accessToken async {
    return locator<LocalStorageService>().accessToken;
  }

  FutureOr<String> get refreshToken async {
    return locator<LocalStorageService>().refreshToken;
  }

  // Future<void> saveLoginResponse(AuthResponseModel? authResponse) async {
  //   return _localStorage?.saveLoginResponse(authResponse);
  // }

  Future<HttpClientWrapper> _getSSLPinningClient() async {
    final HttpClientWrapper client = HttpClientWrapper(
      securityContext: null, //await _globalContext,
      requestInterceptors: <RequestInterceptor>[
        connectivityInterceptor,
        addAuthHeader,
        addDefaultHeaders,
        logCURLRequest,
      ],
      responseInterceptors: <ResponseInterceptor>[
        logResponse,
      ],
      tokenRefresher: refreshTokenAPI,
    );
    return client;
  }

  //Helper Methods
  Future<ResponseMainDto<T>> sendRequest<T>({
    required APIEndPoint endPoint,
    T Function({dynamic json})? fromJson,
    int? timeoutSeconds,
    List<http.MultipartFile>? files,
  }) async {
    return HttpRequest.sendRequestMain(
      client: _client,
      endPoint: endPoint,
      fromJson: fromJson,
      timeoutSeconds: timeoutSeconds,
      files: files,
    );
  }

  APIEndPoint createAPIEndpoint({
    required URlRequestBuilder endPoint,
    List<String> paramIDs = const <String>[],
    Map<String, dynamic> parameters = const <String, dynamic>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Map<String, String> additionalHeaders = const <String, String>{},
  }) {
    // If there are query parameters, construct the query string
    String updatedPath = endPoint.path;
    if (paramIDs.isNotEmpty) {
      updatedPath += "/${paramIDs.join("/")}";
    }
    Map<String, String> stringQueryParameters = <String, String>{};
    queryParameters.forEach((String key, dynamic value) {
      stringQueryParameters[key] = value.toString();
    });
    if (queryParameters.isNotEmpty) {
      final String queryString =
          Uri(queryParameters: stringQueryParameters).query;
      updatedPath += "?$queryString";
    }
    Map<String, String> headers = <String, String>{};
    if (endPoint.headers.isNotEmpty) {
      headers.addAll(endPoint.headers);
    }
    if (additionalHeaders.isNotEmpty) {
      headers.addAll(additionalHeaders);
    }

    return APIEndPoint(
      enumBaseURL: endPoint.baseURL,
      path: updatedPath,
      method: endPoint.method,
      hasAuthorization: endPoint.hasAuthorization,
      isRefreshToken: endPoint.isRefreshToken,
      headers: headers,
      parameters: parameters,
    );
  }

  void printHeader(String title) {
    log("---------------------------$title---------------------------------");
  }

  // Response Interceptors
  FutureOr<http.BaseResponse> logResponse(
    http.BaseResponse response,
    APIEndPoint endPoint,
  ) {
    log(
      "Response status: ${response.statusCode} url: ${response.request?.url}",
    );
    return response;
  }

  // Request Interceptors
  FutureOr<http.BaseRequest> connectivityInterceptor(
    http.BaseRequest request,
    APIEndPoint endPoint,
  ) async {
    if (await locator<ConnectivityService>().isConnected()) {
      return request;
    } else {
      throw ResponseMainException(
        ResponseMainDto<dynamic>.createError(
          responseCode: 503,
          errorMessage: "No internet connection",
        ),
      );
    }
  }

  FutureOr<http.BaseRequest> addAuthHeader(
    http.BaseRequest request,
    APIEndPoint endPoint,
  ) async {
    if (!endPoint.isRefreshToken && _isRefreshing) {
      await _refreshCompleter!.future;
    }
    if (endPoint.hasAuthorization) {
      String? accessToken = locator<LocalStorageService>().accessToken;
      if (accessToken.isNotEmpty) {
        request.headers["Authorization"] = "Bearer $accessToken";
      }
    }
    return request;
  }

  FutureOr<http.BaseRequest> addDefaultHeaders(
    http.BaseRequest request,
    APIEndPoint endPoint,
  ) async {
    if (endPoint.method == HttpMethod.POST ||
        endPoint.method == HttpMethod.PUT) {
      request.headers[HttpHeaders.contentTypeHeader] = "application/json";
    }

    if (endPoint.isRefreshToken) {
      String refreshToken = locator<LocalStorageService>().refreshToken;

      if (refreshToken.isEmpty) {
        throw ResponseMainException(
          ResponseMainDto<dynamic>.createError(
            responseCode: 401,
            errorMessage: "unauthorized user",
          ),
        );
      }

      request.headers.putIfAbsent(
        "x-refresh-token",
        () => locator<LocalStorageService>().refreshToken,
      );
    }

    String uniqueDeviceID = await getUniqueDeviceID(
      locator<DeviceInfoService>(),
      locator<SecureStorageService>(),
    );

    request.headers.putIfAbsent("x-device-id", () => uniqueDeviceID);

    //currency code
    String currencyCode = getSelectedCurrencyCode();
    request.headers.putIfAbsent(
      "x-currency",
      () => currencyCode,
    );
    request.headers.putIfAbsent(
      "accept-language",
      () => locator<LocalStorageService>().languageCode,
    );

    return request;
  }

  FutureOr<http.BaseRequest> logCURLRequest(
    http.BaseRequest request,
    APIEndPoint endPoint,
  ) {
    printHeader("Request Begin");
    final StringBuffer buffer = StringBuffer()
      ..writeln("curl -X ${request.method} ${request.url}");

    request.headers.forEach((String key, String value) {
      buffer.writeln('-H "$key: $value"');
    });

    if (request is http.Request && request.body.isNotEmpty) {
      String jsonString = json.encode(request.body);
      dynamic decodedJson = json.decode(jsonString);
      buffer.writeln("-d '$decodedJson'");
    }
    log(buffer.toString());
    return request;
  }

  //RefreshToken Api Logic
  static bool _isRefreshing = false;
  static Completer<void>? _refreshCompleter;

  FutureOr<dynamic> refreshTokenAPI() async {
    if (_isRefreshing) {
      await _refreshCompleter!.future;
      return;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<void>();

    try {
      log("Refreshing token...");

      ResponseMainDto<AuthResponseModelDto> authResponse = await sendRequest(
        endPoint: createAPIEndpoint(
          endPoint: AuthApis.refreshToken,
        ),
        fromJson: AuthResponseModelDto.fromAPIJson,
      );

      await locator<UserAuthenticationService>()
          .saveUserResponse(authResponse.dataOfType.toDomain());

      HttpRequest.notifyAuthReloadListeners(authResponse.dataOfType.toDomain());

      _refreshCompleter!.complete();
      _isRefreshing = false;
      _refreshCompleter = null;
      return authResponse;
    } on Error catch (exception) {
      HttpRequest.notifyUnauthorizedAccessCallBackListeners(
        null,
        Exception(exception),
      );
      _refreshCompleter!.complete();
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }
}
