import "dart:async";

import "package:esim_open_source/domain/data/response/core/string_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class ContactUsUseCase
    implements UseCase<Resource<StringResponse?>, ContactUsParams> {
  ContactUsUseCase(this.repository);
  final ApiAppRepository repository;

  @override
  FutureOr<Resource<StringResponse?>> execute(ContactUsParams params) async {
    return await repository.contactUs(
      email: params.email,
      message: params.message,
    );
  }
}

class ContactUsParams {
  ContactUsParams({
    required this.email,
    required this.message,
  });
  final String email;
  final String message;
}
