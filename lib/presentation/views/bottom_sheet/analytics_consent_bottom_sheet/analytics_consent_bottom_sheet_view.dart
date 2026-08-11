import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/analytics_consent_bottom_sheet/analytics_consent_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class AnalyticsConsentBottomSheetView extends StatelessWidget {
  const AnalyticsConsentBottomSheetView({
    required this.completer,
    required this.requestBase,
    super.key,
  });

  final SheetRequest<dynamic> requestBase;
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      viewModel: AnalyticsConsentBottomSheetViewModel(completer),
      builder: (
        BuildContext context,
        AnalyticsConsentBottomSheetViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          SizedBox(
        width: screenWidth(context),
        child: PaddingWidget.applySymmetricPadding(
          vertical: 24,
          horizontal: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                LocaleKeys.analyticsConsent_title.tr(),
                style: headerTwoMediumTextStyle(
                  context: context,
                  fontColor: mainDarkTextColor(context: context),
                ),
              ).textSupportsRTL(context),
              verticalSpaceMedium,
              Text(
                LocaleKeys.analyticsConsent_body.tr(),
                style: bodyNormalTextStyle(
                  context: context,
                  fontColor: contentTextColor(context: context),
                ),
              ).textSupportsRTL(context),
              verticalSpaceMediumLarge,
              MainButton(
                title: LocaleKeys.analyticsConsent_allow.tr(),
                onPressed: () => viewModel.setConsent(granted: true),
                themeColor: themeColor,
                width: double.infinity,
                height: 56,
                hideShadows: true,
                enabledTextColor: mainDarkTextColor(context: context),
                enabledBackgroundColor:
                    analyticsConsentAccentColor(context: context),
                titleTextStyle: captionOneMediumTextStyle(
                  context: context,
                  fontColor: mainDarkTextColor(context: context),
                ),
              ),
              verticalSpaceSmall,
              MainButton(
                title: LocaleKeys.analyticsConsent_deny.tr(),
                onPressed: () => viewModel.setConsent(granted: false),
                themeColor: themeColor,
                width: double.infinity,
                height: 56,
                hideShadows: true,
                borderColor: analyticsConsentBorderColor(context: context),
                enabledTextColor: mainDarkTextColor(context: context),
                enabledBackgroundColor: Colors.transparent,
                titleTextStyle: captionOneMediumTextStyle(
                  context: context,
                  fontColor: mainDarkTextColor(context: context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SheetRequest<dynamic>>("requestBase", requestBase),
      )
      ..add(
        ObjectFlagProperty<
            Function(SheetResponse<EmptyBottomSheetResponse> p1)>.has(
          "completer",
          completer,
        ),
      );
  }
}
