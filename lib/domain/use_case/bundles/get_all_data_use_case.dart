// import "dart:async";
//
// import "package:esim_open_source/data/remote/responses/bundles/home_data_response_model_dto.dart";
// import "package:esim_open_source/domain/repository/api_bundles_repository.dart";
// import "package:esim_open_source/domain/util/resource.dart";
// import "package:esim_open_source/presentation/reactive_service/bundles_data_service.dart";
//
// class GetAllDataUseCase {
//   GetAllDataUseCase(this.repository);
//   final ApiBundlesRepository repository;
//
//   FutureOr<Stream<Resource<HomeDataResponseModel>>> execute(
//     GetAllDataUseCaseParams params,
//   ) async {
//     return repository.getHomeData(
//       version: Future<HomeDataVersionResult>.value(
//         HomeDataVersionResult(version: params.version),
//       ),
//     );
//   }
// }
//
// class GetAllDataUseCaseParams {
//   GetAllDataUseCaseParams({
//     required this.version,
//   });
//
//   final String version;
// }
