import "package:esim_open_source/domain/data/response/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/presentation/helpers/route_wrapper.dart";
import "package:esim_open_source/presentation/helpers/view_state_utils.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/app_clip_start/app_clip_selection/app_clip_selection_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/bundles_list_screen.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/navigation/esim_arguments.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/purchase_loading_view/purchase_loading_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/purchase_order_success/purchase_order_success_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/verify_purchase_view/verify_purchase_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager.dart";
import "package:esim_open_source/presentation/views/home_flow_views/notifications_view/notifications_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/account_information_view/account_information_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/contact_us_view/contact_us_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_data_view/dynamic_data_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_data_view/dynamic_data_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_selection_view/dynamic_selection_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_selection_view/dynamic_selection_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/faq_view/faq_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/my_wallet_view/my_wallet_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/order_history_view/order_history_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/rewards_history_view/rewards_history_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/android_user_guide_view/android_gallery_user_guide_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_data_source/android_user_guide_enum.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_detailed_view/user_guide_detailed_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/continue_with_email_view/continue_with_email_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/device_compability_check_view/device_compability_check_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/login_view/login_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/verify_login_view/verify_login_view.dart";
import "package:esim_open_source/presentation/views/start_up_view/startup_view.dart";
import "package:esim_open_source/presentation/widgets/qr_scanner/qr_scanner_view.dart";
import "package:esim_open_source/presentation/widgets/stories_view/story_item.dart";
import "package:esim_open_source/presentation/widgets/stories_view/story_viewer.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:stacked/stacked.dart";
import "package:stacked_services/stacked_services.dart";

Route<dynamic> generateRoute(RouteSettings settings) {
  String settingsName = settings.name ?? "";

  switch (settingsName) {
    //Pre sign in
    case StartUpView.routeName:
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: const StartUpView(),
      );

    case AppClipSelectionView.routeName:
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: const AppClipSelectionView(),
      );

    case LoginView.routeName:
      final Object? args = settings.arguments;
      InAppRedirection? redirection;

      if (args is InAppRedirection) {
        redirection = args;
      } else {
        redirection = null;
      }

      return _getPageRoute(
        routeName: settingsName,
        viewToShow: LoginView(
          redirection: redirection,
        ),
        transitionsBuilder: TransitionsBuilders.slideBottom,
      );

    case ContinueWithEmailView.routeName:
      Object? args = settings.arguments;

      RouteTransitionsBuilder? transitionsBuilder;

      if (args is RouteWrapper) {
        transitionsBuilder = args.transitionsBuilder;
        args = args.instance;
      }

      ContinueWithEmailViewArgs? continueWithEmailViewArgs;

      if (args is ContinueWithEmailViewArgs) {
        continueWithEmailViewArgs = args;
      } else {
        continueWithEmailViewArgs = null;
      }
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: ContinueWithEmailView(
          redirection: continueWithEmailViewArgs?.redirection,
          localLoginType: continueWithEmailViewArgs?.localLoginType,
        ),
        transitionsBuilder: transitionsBuilder,
      );

    case VerifyLoginView.routeName:
      VerifyLoginViewArgs args = settings.arguments! as VerifyLoginViewArgs;
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: VerifyLoginView(
          redirection: args.redirection,
          email: args.email,
          phoneNumber: args.phoneNumber,
          localLoginType: args.localLoginType,
          otpChannel: args.otpChannel,
        ),
      );

    case VerifyPurchaseView.routeName:
      VerifyPurchaseViewArgs args =
          settings.arguments! as VerifyPurchaseViewArgs;
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: VerifyPurchaseView(
          args: args,
        ),
      );

    case DeviceCompabilityCheckView.routeName:
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: const DeviceCompabilityCheckView(),
      );

    // home tab bar
    case HomePager.routeName:
      final Object? args = settings.arguments;
      InAppRedirection? redirection;

      if (args is InAppRedirection) {
        redirection = args;
      } else {
        redirection = null;
      }

      return _getPageRoute(
        routeName: settingsName,
        viewToShow: HomePager(redirection: redirection),
        transitionsBuilder: TransitionsBuilders.noTransition,
      );

    case StoryViewer.routeName:
      StoryViewerArgs storyViewerArgs = settings.arguments! as StoryViewerArgs;
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: StoryViewer(storyViewerArgs: storyViewerArgs),
        transitionsBuilder: TransitionsBuilders.slideBottom,
      );

    case NotificationsView.routeName:
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: const NotificationsView(),
      );

    case PurchaseLoadingView.routeName:
      PurchaseLoadingViewData purchaseLoadingViewData =
          settings.arguments! as PurchaseLoadingViewData;
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: PurchaseLoadingView(
          orderID: purchaseLoadingViewData.orderID,
          bearerToken: purchaseLoadingViewData.bearerToken,
        ),
        transitionsBuilder: TransitionsBuilders.slideBottom,
      );

    case PurchaseOrderSuccessView.routeName:
      PurchaseEsimBundleResponseModel? model =
          settings.arguments as PurchaseEsimBundleResponseModel?;
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: PurchaseOrderSuccessView(purchaseESimBundle: model),
        transitionsBuilder: TransitionsBuilders.slideBottom,
      );

    //Profile View Sections
    case AccountInformationView.routeName:
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: const AccountInformationView(),
      );

    case MyWalletView.routeName:
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: const MyWalletView(),
      );

    case FaqView.routeName:
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: const FaqView(),
      );

    case ContactUsView.routeName:
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: const ContactUsView(),
      );

    case OrderHistoryView.routeName:
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: const OrderHistoryView(),
      );

    case DynamicDataView.routeName:
      DynamicDataViewType viewType = settings.arguments! as DynamicDataViewType;
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: DynamicDataView(viewType: viewType),
      );

    case DynamicSelectionView.routeName:
      DynamicSelectionViewDataSource data =
          settings.arguments! as DynamicSelectionViewDataSource;
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: DynamicSelectionView(dataSource: data),
      );

    case RewardsHistoryView.routeName:
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: const RewardsHistoryView(),
      );

    case QrScannerView.routeName:
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: const QrScannerView(),
      );

    case UserGuideView.routeName:
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: const UserGuideView(),
      );

    case UserGuideDetailedView.routeName:
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: const UserGuideDetailedView(
          userGuideViewDataSource: AndroidUserGuideEnum.step1,
        ),
      );

    case AndroidGalleryUserGuideView.routeName:
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: const AndroidGalleryUserGuideView(),
      );

    case BundlesListScreen.routeName:
      final Map<String, dynamic> args =
          settings.arguments! as Map<String, dynamic>;
      final EsimArguments esimItem = args["key"] as EsimArguments;
      return _getPageRoute(
        routeName: settingsName,
        viewToShow: BundlesListScreen(esimItem: esimItem),
      );

    //WebView Display Page
    // case TermsAndConditionsPage.routeName:
    //   return _getPageRoute(
    //     routeName: settingsName,
    //     viewToShow: const TermsAndConditionsPage(),
    //   );

    default:
      return MaterialPageRoute<dynamic>(
        builder: (_) => Scaffold(
          body: Center(
            child: SizedBox(
              width: 35,
              height: 35,
              child: getNativeIndicator(
                StackedService.navigatorKey!.currentContext!,
              ),
            ),
            //Text("No route  test defined for ${settings.name}"),
          ),
        ),
      );
  }
}

PageRoute<dynamic> _getPageRoute({
  required String routeName,
  required Widget viewToShow,
  RouteTransitionsBuilder? transitionsBuilder,
}) {
  // if (Platform.isIOS) {

  if (transitionsBuilder != null) {
    return PageRouteBuilder<dynamic>(
      settings: RouteSettings(
        name: routeName,
      ),
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return viewToShow;
      },
      transitionsBuilder: transitionsBuilder,
    );
  }

  // if (Platform.isIOS) {
  return CupertinoPageRoute<dynamic>(
    settings: RouteSettings(
      name: routeName,
    ),
    builder: (_) => viewToShow,
  );
  // }
  // return MaterialPageRoute(
  //     settings: RouteSettings(
  //       name: routeName,
  //     ),
  //     builder: (_) => viewToShow);
}
