import "dart:developer";

import "package:esim_open_source/domain/data/response/core/empty_response.dart";

class EmptyResponseDto {
  EmptyResponseDto();
  EmptyResponseDto.fromJson({dynamic json}) {
    log(json);
  }

  EmptyResponse toDomain() => EmptyResponse();
}
