import "package:esim_open_source/domain/data/response/bundles/bundle_category_response_model.dart";

class BundleCategoryResponseModelDto {
  BundleCategoryResponseModelDto({
    this.type,
    this.code,
    this.title,
  });

  factory BundleCategoryResponseModelDto.fromJson(Map<String, dynamic> json) {
    return BundleCategoryResponseModelDto(
      type: json["type"],
      title: json["title"],
      code: json["code"],
    );
  }

  bool get isCruise => type == "CRUISE";

  final String? type;
  final String? code;
  final String? title;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "type": type,
      "title": title,
      "code": code,
    };
  }

  BundleCategoryResponseModel toDomain() {
    BundleCategoryResponseModel response = BundleCategoryResponseModel(
      type: type,
      code: code,
      title: title,
    );
    return response;
  }

  BundleCategoryResponseModelDto fromDomain(BundleCategoryResponseModel? model) {
    BundleCategoryResponseModelDto response = BundleCategoryResponseModelDto(
      type: model?.type,
      code: model?.code,
      title: model?.title,
    );
    return response;
  }
}
