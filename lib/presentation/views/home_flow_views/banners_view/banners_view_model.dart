import "dart:async";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/data/response/app/banner_response_model.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/use_case/app/get_banner_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/extensions/navigation_service_extensions.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/shared/action_helpers.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/banners_view/banners_view_types.dart";
import "package:esim_open_source/presentation/views/home_flow_views/stories_view/cashback_stories_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/stories_view/referal_stories_view.dart";
import "package:esim_open_source/presentation/widgets/stories_view/story_viewer.dart";
import "package:esim_open_source/utils/value_stream.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class BannersViewModel extends BaseModel {
  //#endregion
  Timer? _timer;
  Timer? _buttonTimer;
  int _currentPage = 0;
  PageController bannersPageController = PageController(viewportFraction: 0.9);

  List<BannerState> _bannersList = <BannerState>[];

  List<BannerState> get banners => _bannersList;

  Color? _textColor;
  Color? _buttonColor;

  int get currentPage => _currentPage;

  Color? get textColor => _textColor;

  Color? get buttonColor => _buttonColor;

  //#endregion

  //#region UseCases
  final GetBannerUseCase getBannerUseCase = GetBannerUseCase(locator());

  //#endregion

  //#region Functions
  @override
  void onViewModelReady() {
    super.onViewModelReady();
    ValueStream<Resource<List<BannerResponseModel>?>> bannerStream =
        getBannerUseCase.execute(NoParams());

    processBanners(bannerStream.currentValue);
    bannerStream.stream.listen(processBanners);
  }

  void processBanners(Resource<List<BannerResponseModel>?>? banners) {
    switch (banners?.resourceType) {
      case ResourceType.success:
        _bannersList =
            banners?.data?.map(BannerState.fromBannerMode).toList() ??
                <BannerState>[];
      case ResourceType.error:
        _bannersList = <BannerState>[];
      case ResourceType.loading:
        _bannersList = <BannerState>[];
      case null:
    }
    notifyListeners();
  }

  @override
  void onDispose() {
    super.onDispose();
    _timer?.cancel();
    _buttonTimer?.cancel();
  }

  void startAnimatingView(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setUpBannersAnimation();
      setupButtonColorAnimation(context);
    });
  }

  void setUpBannersAnimation() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) async {
      if (_currentPage < BannersViewTypes.values.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      bannersPageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  void setupButtonColorAnimation(BuildContext context) {
    Color redColor = context.appColors.error_500!;
    Color greyColor = context.appColors.grey_900!;
    Color whiteColor = context.appColors.baseWhite!;

    _textColor = whiteColor;
    _buttonColor = redColor;
    _buttonTimer =
        Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      _textColor = (_textColor == whiteColor) ? greyColor : whiteColor;
      _buttonColor = (_buttonColor == redColor) ? whiteColor : redColor;
      notifyListeners();
    });
  }

  Future<void> onViewTap(BannerState bannerView) async {
    switch (bannerView.bannersViewType) {
      case BannersViewTypes.liveChat:
        openWhatsApp(
          phoneNumber:
              await locator<AppConfigurationService>().getWhatsAppNumber,
          message: "",
        );
      case BannersViewTypes.referAndEarn:
        if (locator<UserAuthenticationService>().isUserLoggedIn) {
          locator<NavigationService>().navigateTo(
            StoryViewer.routeName,
            arguments:
                ReferalStoriesView(StackedService.navigatorKey!.currentContext!)
                    .storyViewerArgs,
          );
          return;
        }
        locator<NavigationService>().navigateToLoginScreen(
          redirection: InAppRedirection.referral(),
        );

      case BannersViewTypes.cashBackRewards:
        if (locator<UserAuthenticationService>().isUserLoggedIn) {
          locator<NavigationService>().navigateTo(
            StoryViewer.routeName,
            arguments: CashbackStoriesView().storyViewerArgs,
          );
          return;
        }
        locator<NavigationService>().navigateToLoginScreen(
          redirection: InAppRedirection.cashback(),
        );
      case BannersViewTypes.none:
        break;
    }
  }

//#endregion
}

//#region BannerState
class BannerState {
  BannerState({
    required BannersViewTypes bannersViewType,
    String? title,
    String? description,
    String? image,
  }) {
    _title = title;
    _description = description;
    _image = image;
    _bannersViewType = bannersViewType;
  }

  BannerState.fromBannerMode(BannerResponseModel model) {
    _title = model.title;
    _description = model.description;
    _image = model.image;
    _bannersViewType = BannersViewTypes.fromString(model.action ?? "");
  }

  String? _title;
  String? _description;
  String? _image;
  late BannersViewTypes _bannersViewType;

  String? get title => _title;

  String? get description => _description;

  String? get image => _image;

  BannersViewTypes get bannersViewType => _bannersViewType;
}
//#endregion
