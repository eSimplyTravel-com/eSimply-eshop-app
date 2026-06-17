import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/bundles_by_countries_view/bundles_by_countries_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/data_plans_components/esim_bundle_item_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked/stacked.dart";

class BundlesByCountriesView extends StatelessWidget {
  const BundlesByCountriesView({
    required this.viewModel,
    required this.onBundleSelected,
    required this.horizontalPadding,
    super.key,
  });

  final double horizontalPadding;
  final BundlesByCountriesViewModel viewModel;
  final Function(BundleResponseModel selectedBundle) onBundleSelected;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BundlesByCountriesViewModel>.reactive(
      viewModelBuilder: () => viewModel,
      disposeViewModel: false,
      fireOnViewModelReadyOnce: true,
      onViewModelReady: (BundlesByCountriesViewModel viewModel) async =>
          viewModel.onModelReady(),
      builder: (
        BuildContext context,
        BundlesByCountriesViewModel viewModel,
        Widget? child,
      ) {
        return viewModel.bundles.isEmpty
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
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                itemCount: viewModel.bundles.length,
                separatorBuilder: (BuildContext context, int index) =>
                    verticalSpaceSmall,
                itemBuilder: (BuildContext context, int index) {
                  final BundleResponseModel bundle = viewModel.bundles[index];
                  return EsimBundleWidget(
                    title: bundle.bundleName ?? "",
                    data: bundle.gprsLimitDisplay ?? "",
                    showUnlimitedData: bundle.unlimited ?? false,
                    validFor: bundle.getValidityDisplay() ?? "",
                    availableCountries: viewModel.availableCountries,
                    supportedCountries:
                        bundle.countries ?? <CountryResponseModel>[],
                    priceButtonText: LocaleKeys.bundleInfo_priceText.tr(
                      namedArgs: <String, String>{
                        "price": "${bundle.priceDisplay}",
                      },
                    ),
                    icon: bundle.icon ?? "",
                    onPriceButtonClick: () async =>
                        onBundleSelected.call(bundle),
                  ).applyShimmer(
                    params: ShimmerParams(
                      context: context,
                      enable: viewModel.isBusy,
                    ),
                  );
                },
              );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<Function(BundleResponseModel selectedBundle)>.has(
          "onBundleSelected",
          onBundleSelected,
        ),
      )
      ..add(
        DiagnosticsProperty<BundlesByCountriesViewModel>(
          "viewModel",
          viewModel,
        ),
      )
      ..add(DoubleProperty("horizontalPadding", horizontalPadding));
  }
}
