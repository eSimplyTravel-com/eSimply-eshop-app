import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class BundleInfoColumn extends StatelessWidget {
  const BundleInfoColumn({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: captionTwoBoldTextStyle(
            context: context,
            fontColor: mainDarkTextColor(context: context),
          ),
        ).textSupportsRTL(context),
        Text(
          value,
          //textDirection: TextDirection.ltr,
          style: captionTwoNormalTextStyle(
            context: context,
            fontColor: contentTextColor(context: context),
          ),
        ).textSupportsRTL(context),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty("label", label))
      ..add(StringProperty("value", value));
  }
}

@AppPreview(name: "Bundle Info Column")
Widget bundleInfoColumnPreview() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: BundleInfoColumn(
        label: "Data",
        value: "5 GB",
      ),
    ),
  );
}
