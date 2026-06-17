import "dart:async";

import "package:esim_open_source/data/remote/responses/base_response_model_dto.dart";

class Resource<T> {
  Resource({required this.resourceType, this.data, this.message, this.error});

  factory Resource.success(T data, {required String? message}) => Resource<T>(
        data: data,
        resourceType: ResourceType.success,
        message: message,
      );

  factory Resource.error(String message, {T? data, GeneralError? error}) =>
      Resource<T>(
        data: data,
        message: message,
        error: error,
        resourceType: ResourceType.error,
      );

  factory Resource.loading({T? data}) =>
      Resource<T>(data: data, resourceType: ResourceType.loading);
  final ResourceType resourceType;
  final T? data;
  final String? message;
  final GeneralError? error;
}

class GeneralError {
  GeneralError({
    required this.message,
    this.errorCode,
    this.exception,
  });

  final int? errorCode;
  final String message;
  final Exception? exception;
}

enum ResourceType { success, error, loading }

FutureOr<Resource<T>> responseToResource<TDto, T>(
  FutureOr<dynamic> request,
  T Function(TDto dto) mapper,
) async {
  try {
    ResponseMainDto<dynamic> response = await request;
    if (response.statusCode == 200) {
      TDto? dto = response.data as TDto?;
      return Resource<T>.success(
        dto == null ? null as T : mapper(dto),
        message: response.message,
      );
    }
    return Resource<T>.error(
      response.message ?? response.title ?? "",
      error: GeneralError(
        message: response.message ?? response.title ?? "",
        errorCode: response.responseCode,
      ),
    );
  } on MainTimeoutException catch (ex) {
    return Resource<T>.error(
      ex.message ?? "",
      error: GeneralError(
        message: ex.message ?? "",
        errorCode: ex.errorCode,
        exception: ex,
      ),
    );
  } on ResponseMainException catch (ex) {
    return Resource<T>.error(
      ex.message ?? "",
      error: GeneralError(
        message: ex.message ?? "",
        errorCode: ex.errorCode,
        exception: ex,
      ),
    );
  } on Exception catch (e) {
    return Resource<T>.error(
      e.toString(),
      error: GeneralError(
        message: e.toString(),
        errorCode: -1,
        exception: e,
      ),
    );
  } on Object catch (e) {
    return Resource<T>.error(
      e.toString(),
      error: GeneralError(
        message: e.toString(),
        errorCode: -1,
        exception: Exception(e),
      ),
    );
  }
}
