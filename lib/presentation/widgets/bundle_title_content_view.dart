import "package:easy_localization/easy_localization.dart" as localization;
import "package:esim_open_source/presentation/enums/language_enum.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class BundleTitleContentView extends StatelessWidget {
  const BundleTitleContentView({
    required this.titleText,
    required this.contentText,
    this.showShimmer = false,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    super.key,
  });

  final String titleText;
  final String contentText;
  final bool showShimmer;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final String langCode =
        localization.EasyLocalization.of(context)?.locale.languageCode ?? "en";

    final bool isRTL = LanguageEnum.fromCode(langCode).isRTL;

    return Align(
      alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: <Widget>[
          verticalSpaceSmall,
          Text(
            titleText,
            style: captionTwoNormalTextStyle(
              context: context,
              fontColor: mainDarkTextColor(context: context),
            ),
          ),
          verticalSpaceTiny,
          Text(
            contentText,
            style: captionOneMediumTextStyle(
              context: context,
              fontColor: contentTextColor(context: context),
            ),
          ).applyShimmer(
            params: ShimmerParams(
              context: context,
              enable: showShimmer,
            ),
          ),
          verticalSpaceSmall,
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty("titleText", titleText))
      ..add(StringProperty("contentText", contentText))
      ..add(
        EnumProperty<CrossAxisAlignment>(
          "crossAxisAlignment",
          crossAxisAlignment,
        ),
      )
      ..add(DiagnosticsProperty<bool>("showShimmer", showShimmer));
  }
}

@AppPreview(name: "Bundle Title Content View")
Widget bundleTitleContentViewPreview() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: BundleTitleContentView(
        titleText: "Validity",
        contentText: "30 Days",
      ),
    ),
  );
}
