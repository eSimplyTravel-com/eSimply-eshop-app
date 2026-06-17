import "package:esim_open_source/data/remote/responses/bundles/bundle_category_response_model_dto.dart";
import "package:objectbox/objectbox.dart";

@Entity()
class BundleCategoryEntity {
  BundleCategoryEntity({
    required this.type,
    required this.code,
    required this.title,
  });

  factory BundleCategoryEntity.fromModel(BundleCategoryResponseModelDto model) {
    return BundleCategoryEntity(
      type: model.type,
      code: model.code,
      title: model.title,
    );
  }
  @Id()
  int id = 0;

  final String? type;
  final String? code;
  final String? title;

  BundleCategoryResponseModelDto toModel() {
    return BundleCategoryResponseModelDto(
      type: type,
      code: code,
      title: title,
    );
  }
}
