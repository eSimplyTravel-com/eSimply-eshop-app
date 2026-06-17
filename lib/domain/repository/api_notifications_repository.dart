import "dart:async";

import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/util/resource.dart";

abstract interface class ApiNotificationsRepository {
  FutureOr<Resource<EmptyResponse?>> getConsumptionLimit();
}
