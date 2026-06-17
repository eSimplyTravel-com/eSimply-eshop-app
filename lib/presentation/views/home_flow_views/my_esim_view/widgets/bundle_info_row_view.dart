import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/bundle_info_column_view.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class BundleInfoRow extends StatelessWidget {
  const BundleInfoRow({
    required this.validity,
    required this.expiryDate,
    required this.isLoading,
    super.key,
  });

  final String validity;
  final String expiryDate;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        BundleInfoColumn(
          label: LocaleKeys.bundle_validity.tr(),
          value: validity,
        ).applyShimmer(
          params: ShimmerParams(enable: isLoading, context: context),
        ),
        const Spacer(),
        BundleInfoColumn(
          label: LocaleKeys.last_purchase.tr(),
          value: expiryDate,
        ).applyShimmer(
          params: ShimmerParams(enable: isLoading, context: context),
        ),
        const Spacer(),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<String>("validity", validity))
      ..add(DiagnosticsProperty<String>("expiryDate", expiryDate))
      ..add(DiagnosticsProperty<bool>("isLoading", isLoading));
  }
}

@AppPreview(name: "Bundle Info Row")
Widget bundleInfoRowPreview() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: BundleInfoRow(
        validity: "30 days",
        expiryDate: "May 20, 2026",
        isLoading: false,
      ),
    ),
  );
}
