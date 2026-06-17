class BannerResponseModel {
  BannerResponseModel({
    String? title,
    String? description,
    String? image,
    String? action,
  }) {
    _title = title;
    _description = description;
    _image = image;
    _action = action;
  }

  String? _title;
  String? _description;
  String? _image;
  String? _action;

  String? get title => _title;

  String? get description => _description;

  String? get image => _image;

  String? get action => _action;
}
