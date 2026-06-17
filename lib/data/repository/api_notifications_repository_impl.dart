import "dart:async";

import "package:esim_open_source/data/remote/responses/core/empty_response_dto.dart";
import "package:esim_open_source/domain/data/api_notifications.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_notifications_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";

class ApiNotificationsRepositoryImpl implements ApiNotificationsRepository {
  ApiNotificationsRepositoryImpl(this.apiNotifications);
  final APINotifications apiNotifications;

  @override
  FutureOr<Resource<EmptyResponse?>> getConsumptionLimit() {
    return responseToResource<EmptyResponseDto, EmptyResponse?>(
      apiNotifications.getConsumptionLimit(),
      (EmptyResponseDto dto) => dto.toDomain(),
    );
  }
}
