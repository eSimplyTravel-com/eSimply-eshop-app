import "dart:developer";

import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/helpers/view_state_utils.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/haptic_feedback.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/base/main_base_model.dart";
import "package:esim_open_source/presentation/widgets/lockable_tab_bar.dart";
import "package:flutter/material.dart";

class HomePagerViewModel extends MainBaseModel {
  static bool _analyticsConsentPromptAttempted = false;

  FocusScopeNode? _currentFocus;
  LockableTabController? _tabController;
  InAppRedirection? redirection;
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  @override
  void onViewDidAppear() {
    super.onViewDidAppear();
    setDefaultStatusBarColor();
  }

  @override
  void onViewModelReady() {
    super.onViewModelReady();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future<void>.delayed(
          const Duration(milliseconds: 500),); // Add your desired delay
      if (redirection != null) {
        redirectionsHandlerService.redirectToRoute(redirection: redirection!);
        await Future<void>.delayed(const Duration(milliseconds: 300));
      }
      await _showAnalyticsConsentIfNeeded();
    });
  }

  Future<void> _showAnalyticsConsentIfNeeded() async {
    if (AppEnvironment.isFromAppClip ||
        _analyticsConsentPromptAttempted ||
        _analyticsService.analyticsConsent != null) {
      return;
    }

    _analyticsConsentPromptAttempted = true;

    // HomePager has rendered by this point; wait for any startup sheet before
    // asking so consent never stacks over compatibility or redirection sheets.
    // Bounded: a user who leaves another sheet open for half a minute is doing
    // something else, and an unbounded poll would keep a timer alive for the
    // rest of the session. Giving up here costs nothing — consent stays
    // unanswered, so the next launch asks again.
    const int maxWaits = 100; // 100 × 300ms = 30s
    for (int waited = 0;
        (bottomSheetService.isBottomSheetOpen ?? false) && waited < maxWaits;
        waited++) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }
    if (bottomSheetService.isBottomSheetOpen ?? false) {
      return;
    }

    if (AppEnvironment.isFromAppClip ||
        _analyticsService.analyticsConsent != null) {
      return;
    }

    await bottomSheetService
        .showCustomSheet<EmptyBottomSheetResponse, EmptyBottomSheetResponse>(
      variant: BottomSheetType.analyticsConsent,
      isScrollControlled: true,
    );
  }

  set tabController(LockableTabController controller) {
    _tabController = controller;
  }

  LockableTabController get tabController => _tabController!;

  set lockTabBar(bool lock) {
    _tabController?.isLocked = lock;
  }

  void changeSelectedTabIndex({required int index}) {
    playHapticFeedback(HapticFeedbackType.tabBarSelectionChange);
    _tabController?.animateTo(index);
  }

  int? getSelectedTabIndex() {
    return _tabController?.index;
  }

  void setRelatedListeners({required BuildContext context}) {
    _currentFocus = FocusScope.of(context);
    if (_currentFocus?.hasListeners ?? false) {
      _currentFocus?.removeListener(_onFocusChange);
    }
    _currentFocus?.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    log("Focus: ${_currentFocus?.hasFocus}");
    if (_currentFocus != null) {
      notifyListeners();
    }
  }
}
