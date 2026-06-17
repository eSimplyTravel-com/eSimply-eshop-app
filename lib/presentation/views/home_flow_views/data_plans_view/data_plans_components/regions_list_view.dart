import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/core/presentation/util/flag_util.dart";
import "package:esim_open_source/domain/data/response/bundles/regions_response_model.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/data_plans_components/country_region_view.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class RegionsList extends StatelessWidget {
  const RegionsList({
    required this.regions,
    required this.showShimmer,
    required this.onRegionTap,
    this.lastItemBottomPadding = 0,
    super.key,
  });

  final bool showShimmer;
  final List<RegionsResponseModel> regions;
  final void Function(RegionsResponseModel selectedregion) onRegionTap;
  final int lastItemBottomPadding;

  @override
  Widget build(BuildContext context) {
    return regions.isEmpty
        ? Center(
            child: Text(
              LocaleKeys.bundleDetails_emptyText.tr(),
              style: captionOneNormalTextStyle(
                context: context,
                fontColor: emptyStateTextColor(context: context),
              ),
            ),
          )
        : () {
            final int itemCount = regions.length + (lastItemBottomPadding > 0 ? 1 : 0);
            return ListView.separated(
              itemCount: itemCount,
              separatorBuilder: (BuildContext context, int index) =>
                  verticalSpaceSmallMedium,
            itemBuilder: (BuildContext context, int index) {
              if (index == regions.length) {
                //reach the end
                return const SizedBox(height: 90);
              }
              return PaddingWidget.applyPadding(
                top: index == 0 ? 15 : 0,
                child: CountryRegionView(
                  title: regions[index].regionName ?? "",
                  type: BundleType.regional,
                  code: regions[index].regionCode ?? "",
                  icon: regions[index].icon ?? "",
                  onTap: () => onRegionTap.call(regions[index]),
                  showShimmer: showShimmer,
                ),
              );
            },
          );
          }();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>("showShimmer", showShimmer))
      ..add(IterableProperty<RegionsResponseModel>("regions", regions))
      ..add(
        ObjectFlagProperty<
            void Function(RegionsResponseModel selectedregion)>.has(
          "onRegionTap",
          onRegionTap,
        ),
      )
      ..add(IntProperty("lastItemBottomPadding", lastItemBottomPadding));
  }
}
