class BundleCategoryResponseModel {
  BundleCategoryResponseModel({
    this.type,
    this.code,
    this.title,
  });

  bool get isCruise => type == "CRUISE";

  final String? type;
  final String? code;
  final String? title;
}
