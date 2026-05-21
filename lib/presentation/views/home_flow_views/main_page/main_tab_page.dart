import "dart:io";

import "package:adaptive_platform_ui/adaptive_platform_ui.dart";
import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/presentation/helpers/view_state_utils.dart";
import "package:esim_open_source/presentation/shared/action_helpers.dart";
import "package:esim_open_source/presentation/shared/haptic_feedback.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/data_plans_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/my_esim_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view.dart";
import "package:esim_open_source/presentation/widgets/customized_adaptive_bottom_navbar.dart";
import "package:esim_open_source/presentation/widgets/customized_bottom_navbar.dart";
import "package:esim_open_source/presentation/widgets/lockable_tab_bar.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";
import "package:lottie/lottie.dart";

class MainTabPage extends StatefulWidget {
  const MainTabPage({
    required this.viewModel,
    super.key,
  });

  final HomePagerViewModel viewModel;

  @override
  State<MainTabPage> createState() => _MainTabPageState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<HomePagerViewModel>("viewModel", viewModel));
  }
}

class _MainTabPageState extends State<MainTabPage>
    with TickerProviderStateMixin {
  late LockableTabController tabController;
  final MyESimView myEsimView = const MyESimView();
  final ProfileView profileView = const ProfileView();
  final DataPlansView dataPlansView = DataPlansView();

  @override
  void initState() {
    super.initState();
    tabController = LockableTabController(
      length: (widget.viewModel.isUserLoggedIn ? 3 : 2),
      vsync: this,
    );
    widget.viewModel.tabController = tabController;
    tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    // Only rebuild when the tab actually changes
    if (tabController.indexIsChanging) {
      setState(() {});
      playHapticFeedback(HapticFeedbackType.tabBarSelectionChange);
    }
  }

  void openDataPlansPage() {
    tabController.index = 0;
  }

  @override
  void didUpdateWidget(covariant MainTabPage oldWidget) {
    int neededLength = (widget.viewModel.isUserLoggedIn ? 3 : 2);
    int currentIndex = tabController.index;
    if (widget.viewModel.isUserLoggedIn && currentIndex == 1) {
      currentIndex++;
    }
    if (tabController.length != neededLength) {
      tabController.dispose();
      tabController = LockableTabController(
        length: neededLength,
        vsync: this,
      );

      tabController.animateTo(
        currentIndex >= neededLength ? neededLength - 1 : currentIndex,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    tabController
      ..removeListener(_handleTabChange)
      ..dispose();
    super.dispose();
  }

  double _getFloatingActionButtonBottomPadding() {
    if (Platform.isIOS) {
      return AppEnvironment.isFromAppClip ? 20 : 60;
    }
    return 80;
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    final Color background = whiteBackGroundColor(context: context);
    final Widget? whatsAppFab = tabController.index > 1
        ? null
        : GestureDetector(
            onTap: () async {
              openWhatsApp(
                phoneNumber:
                    await locator<AppConfigurationService>().getWhatsAppNumber,
                message: "",
              );
            },
            child: Container(
              padding: EdgeInsets.only(
                bottom: _getFloatingActionButtonBottomPadding(),
              ),
              child: Lottie.asset(
                "assets/lottie/whatsappLottie.json",
                width: 90,
                height: 90,
              ),
            ),
          );

    final bool useAdaptiveNav =
        PlatformInfo.isIOS26OrHigher() && !AppEnvironment.isFromAppClip;

    if (useAdaptiveNav) {
      return wrapBodyWithState(
        params: BodyStateWrapParams(
          context: context,
          model: widget.viewModel,
          child: BaseAdaptiveBottomNavBar(
            tabController: tabController,
            isKeyboardVisible: isKeyboardVisible,
            backgroundColor: background,
            floatingActionButton: whatsAppFab,
            tabsWidgets: generateTabWidgets(
              context: context,
              isLoggedIn: widget.viewModel.isUserLoggedIn,
            ),
            tabsIconData: generateTabIcons(
              context: context,
              isLoggedIn: widget.viewModel.isUserLoggedIn,
            ),
            tabsText: generateTabNames(
              context: context,
              isLoggedIn: widget.viewModel.isUserLoggedIn,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      floatingActionButton: whatsAppFab,
      backgroundColor: background,
      body: wrapBodyWithState(
        params: BodyStateWrapParams(
          context: context,
          model: widget.viewModel,
          child: AppEnvironment.isFromAppClip
              ? DataPlansView()
              : buildBottomNavigationBar(
                  context: context,
                  model: widget.viewModel,
                  isKeyboardVisible: isKeyboardVisible,
                  tabController: tabController,
                ),
        ),
      ),
    );
  }

  Widget buildBottomNavigationBar({
    required BuildContext context,
    required HomePagerViewModel model,
    required bool isKeyboardVisible,
    required LockableTabController tabController,
  }) {
    return BaseFlutterBottomNavBar(
      height: 90,
      swipeEnabled: false,
      tabController: tabController,
      isKeyboardVisible: isKeyboardVisible,
      selectedColor: bottomNavbarSelectedBackGroundColor(context: context),
      unselectedColor: bottomNavbarUnselectedBackGroundColor(context: context),
      tabsWidgets: generateTabWidgets(
        context: context,
        isLoggedIn: widget.viewModel.isUserLoggedIn,
      ),
      tabsIconData: generateTabIcons(
        context: context,
        isLoggedIn: widget.viewModel.isUserLoggedIn,
      ),
      tabsText: generateTabNames(
        context: context,
        isLoggedIn: widget.viewModel.isUserLoggedIn,
      ),
    );
  }

  List<String> generateTabIcons({
    required BuildContext context,
    required bool isLoggedIn,
  }) {
    List<String> tabsIcons = <String>[
      EnvironmentImages.tabBarDataPlans.fullImagePath,
    ];

    if (isLoggedIn) {
      tabsIcons.add(
        EnvironmentImages.tabBarMyEsim.fullImagePath,
      );
    }

    tabsIcons.add(
      EnvironmentImages.tabBarProfile.fullImagePath,
    );

    return tabsIcons;
  }

  List<String> generateTabNames({
    required BuildContext context,
    required bool isLoggedIn,
  }) {
    List<String> tabsNames = <String>[
      LocaleKeys.dataPlans_titleText.tr(),
    ];

    if (isLoggedIn) {
      tabsNames.add(LocaleKeys.myEsim_tabName.tr());
    }

    tabsNames.add(
      LocaleKeys.profile_tabName.tr(),
    );

    return tabsNames;
  }

  List<Widget> generateTabWidgets({
    required BuildContext context,
    required bool isLoggedIn,
  }) {
    List<Widget> tabsWidgets = <Widget>[
      dataPlansView,
    ];

    if (isLoggedIn) {
      tabsWidgets.add(myEsimView);
    }

    tabsWidgets.add(profileView);

    return tabsWidgets;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<TabController>("tabController", tabController),
    );
  }
}
