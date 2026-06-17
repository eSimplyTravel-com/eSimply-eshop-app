import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/core/presentation/util/flag_util.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/data_plans_components/country_region_view.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class CountriesList extends StatelessWidget {
  const CountriesList({
    required this.countries,
    required this.showShimmer,
    required this.onCountryTap,
    this.lastItemBottomPadding = 0,
    super.key,
  });

  final bool showShimmer;
  final List<CountryResponseModel> countries;
  final void Function(CountryResponseModel selectedCountry) onCountryTap;
  final int lastItemBottomPadding;

  @override
  Widget build(BuildContext context) {
    int additionalItemCount = 0;
    if (lastItemBottomPadding > 0) {
      additionalItemCount = 1;
    }
    final int totalItemCount = countries.length + additionalItemCount;

    return countries.isEmpty
        ? Center(
            child: Text(
              LocaleKeys.bundleDetails_emptyText.tr(),
              style: captionOneNormalTextStyle(
                context: context,
                fontColor: emptyStateTextColor(context: context),
              ),
            ),
          )
        : ListView.separated(
            itemCount: totalItemCount,
            separatorBuilder: (BuildContext context, int index) =>
                verticalSpaceSmallMedium,
            itemBuilder: (BuildContext context, int index) {
              if (index == countries.length) {
                //reach the end
                return const SizedBox(height: 90);
              }
              return PaddingWidget.applyPadding(
                top: index == 0 ? 15 : 0,
                child: CountryRegionView(
                  title: countries[index].country ?? "",
                  type: BundleType.country,
                  code: countries[index].iso3Code ?? "",
                  icon: countries[index].icon ?? "",
                  onTap: () => onCountryTap.call(countries[index]),
                  showShimmer: showShimmer,
                ),
              );
            },
          );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<
            void Function(CountryResponseModel selectedCountry)>.has(
          "onCountryTap",
          onCountryTap,
        ),
      )
      ..add(DiagnosticsProperty<bool>("showShimmer", showShimmer))
      ..add(IterableProperty<CountryResponseModel>("countries", countries))
      ..add(IntProperty("lastItemBottomPadding", lastItemBottomPadding));
  }
}
