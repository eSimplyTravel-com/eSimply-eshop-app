import "dart:async";

import "package:flutter/services.dart";

enum HapticFeedbackType {
  mainButtonTapped,
  secondaryButtonTapped,
  tabBarSelectionChange,
  pagerSelectionChange,
  validationError,
  apiError,
  apiSuccess,
  majorEvents;
}

void playHapticFeedback(HapticFeedbackType hapticFeedbackType) {
  switch (hapticFeedbackType) {
    case HapticFeedbackType.mainButtonTapped:
    case HapticFeedbackType.secondaryButtonTapped:
    case HapticFeedbackType.apiSuccess:
      unawaited(HapticFeedback.selectionClick());
    case HapticFeedbackType.tabBarSelectionChange:
      unawaited(HapticFeedback.mediumImpact());
    case HapticFeedbackType.pagerSelectionChange:
      unawaited(HapticFeedback.lightImpact());
    case HapticFeedbackType.validationError:
    case HapticFeedbackType.apiError:
    case HapticFeedbackType.majorEvents:
      unawaited(HapticFeedback.heavyImpact());
  }
}
