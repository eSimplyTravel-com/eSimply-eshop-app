// page_title : "About Us"
// page_content : "Welcome to our eSIM platform! We provide seamless digital SIM solutions, allowing you to connect globally without the need for a physical SIM card. Our goal is to make mobile connectivity more flexible, secure, and hassle-free."
// page_intro : "Empowering Connectivity with eSIM Technology"

import "package:esim_open_source/domain/data/response/app/dynamic_page_response.dart";

class DynamicPageResponseDto {
  DynamicPageResponseDto({
    String? pageTitle,
    String? pageContent,
    String? pageIntro,
  }) {
    _pageTitle = pageTitle;
    _pageContent = pageContent;
    _pageIntro = pageIntro;
  }

  DynamicPageResponseDto.fromJson({dynamic json}) {
    _pageTitle = json["page_title"];
    _pageContent = json["page_content"];
    _pageIntro = json["page_intro"];
  }
  String? _pageTitle;
  String? _pageContent;
  String? _pageIntro;
  DynamicPageResponseDto copyWith({
    String? pageTitle,
    String? pageContent,
    String? pageIntro,
  }) =>
      DynamicPageResponseDto(
        pageTitle: pageTitle ?? _pageTitle,
        pageContent: pageContent ?? _pageContent,
        pageIntro: pageIntro ?? _pageIntro,
      );
  String? get pageTitle => _pageTitle;
  String? get pageContent => _pageContent;
  String? get pageIntro => _pageIntro;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["page_title"] = _pageTitle;
    map["page_content"] = _pageContent;
    map["page_intro"] = _pageIntro;
    return map;
  }

  DynamicPageResponse toDomain() {
    DynamicPageResponse response = DynamicPageResponse(
      pageTitle: pageTitle,
      pageContent: pageContent,
      pageIntro: pageIntro,
    );
    return response;
  }
}
