// page_title : "About Us"
// page_content : "Welcome to our eSIM platform! We provide seamless digital SIM solutions, allowing you to connect globally without the need for a physical SIM card. Our goal is to make mobile connectivity more flexible, secure, and hassle-free."
// page_intro : "Empowering Connectivity with eSIM Technology"

class DynamicPageResponse {
  DynamicPageResponse({
    String? pageTitle,
    String? pageContent,
    String? pageIntro,
  }) {
    _pageTitle = pageTitle;
    _pageContent = pageContent;
    _pageIntro = pageIntro;
  }

  String? _pageTitle;
  String? _pageContent;
  String? _pageIntro;

  DynamicPageResponse copyWith({
    String? pageTitle,
    String? pageContent,
    String? pageIntro,
  }) =>
      DynamicPageResponse(
        pageTitle: pageTitle ?? _pageTitle,
        pageContent: pageContent ?? _pageContent,
        pageIntro: pageIntro ?? _pageIntro,
      );

  String? get pageTitle => _pageTitle;
  String? get pageContent => _pageContent;
  String? get pageIntro => _pageIntro;
}
