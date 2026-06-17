import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class BundleDivider extends StatelessWidget {
  const BundleDivider({
    super.key,
    this.verticalPadding,
  });
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    return PaddingWidget.applySymmetricPadding(
      vertical: verticalPadding ?? 15,
      child: Divider(
        color: greyBackGroundColor(context: context),
        height: 1,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty("verticalPadding", verticalPadding));
  }
}

@AppPreview(name: "Bundle Divider")
Widget bundleDividerPreview() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: BundleDivider(),
    ),
  );
}
