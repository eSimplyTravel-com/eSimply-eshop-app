import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:stacked_services/stacked_services.dart";

class AnalyticsConsentBottomSheetViewModel extends BaseModel {
  AnalyticsConsentBottomSheetViewModel(this.completer);

  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  Future<void> setConsent({required bool granted}) async {
    await _analyticsService.setAnalyticsConsent(granted: granted);
    completer(
      SheetResponse<EmptyBottomSheetResponse>(confirmed: true),
    );
  }
}
