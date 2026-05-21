import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class WarningWidget extends StatelessWidget {
  const WarningWidget({required this.warningTextContent, super.key});

  final String warningTextContent;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: myEsimSecondaryBackGroundColor(context: context),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              spacing: 12,
              children: <Widget>[
                Icon(
                  size: 18,
                  Icons.info_outline,
                  color: context.appColors.baseWhite,
                ),
                Text(
                  LocaleKeys.warning_title.tr(),
                  style: captionTwoBoldTextStyle(context: context)
                      .copyWith(color: context.appColors.baseWhite),
                ),
              ],
            ),
            Text(
              warningTextContent,
              style: captionTwoBoldTextStyle(context: context)
                  .copyWith(color: context.appColors.baseWhite),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty("warningTextContent", warningTextContent));
  }
}

@AppPreview(name: "Warning Widget")
Widget warningWidgetPreview() => const WarningWidget(
  warningTextContent: "This is a sample warning message.",
);
