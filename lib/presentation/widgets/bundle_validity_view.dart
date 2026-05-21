import "package:easy_localization/easy_localization.dart"
    show StringTranslateExtension;
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class BundleValidityView extends StatelessWidget {
  const BundleValidityView({
    required this.bundleValidity,
    required this.bundleExpiryDate,
    super.key,
  });

  final String bundleValidity;
  final String bundleExpiryDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "${LocaleKeys.orderHistory_bundleValidityText.tr()} $bundleValidity",
          textDirection: TextDirection.ltr,
          style: captionTwoNormalTextStyle(
            context: context,
            fontColor: secondaryTextColor(context: context),
          ),
        ),
        Text(
          bundleExpiryDate,
          style: captionTwoNormalTextStyle(
            context: context,
            fontColor: secondaryTextColor(context: context),
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty("bundleValidity", bundleValidity))
      ..add(StringProperty("bundleExpiryDate", bundleExpiryDate));
  }
}

@AppPreview(name: "Bundle Validity View")
Widget bundleValidityViewPreview() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: BundleValidityView(
        bundleValidity: "30 Days",
        bundleExpiryDate: "2026-06-19",
      ),
    ),
  );
}
