import "package:esim_open_source/domain/data/response/bundles/bundle_exists_response.dart";

class BundleExistsResponseDto {
  BundleExistsResponseDto({this.exists});

  factory BundleExistsResponseDto.fromJson({dynamic json}) {
    return BundleExistsResponseDto(exists: json as bool?);
  }

  final bool? exists;

  BundleExistsResponse toDomain() => BundleExistsResponse(exists: exists);
}
