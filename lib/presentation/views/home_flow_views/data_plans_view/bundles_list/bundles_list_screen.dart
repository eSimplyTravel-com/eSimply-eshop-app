// bundles_list_screen.dart

import "dart:math";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/bundles_by_countries_view/bundles_by_countries_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/bundles_list_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/bundles_list/navigation/esim_arguments.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/country_flag_image.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";

class BundlesListScreen extends StatelessWidget {
  const BundlesListScreen({
    required this.esimItem,
    super.key,
  });

  static const String routeName = "BundlesListScreen";
  final EsimArguments esimItem;

  @override
  Widget build(BuildContext context) {
    return BaseView<BundlesListViewModel>(
      routeName: routeName,
      viewModel: locator<BundlesListViewModel>()..esimArguments = esimItem,
      hideLoader: true,
      statusBarColor: Colors.transparent,
      hideAppBar: true,
      disableInteractionWhileBusy: false,
      builder: (
        BuildContext context,
        BundlesListViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          Stack(
        children: <Widget>[
          KeyboardDismissOnTap(
            dismissOnCapturedTaps: true,
            child: Column(
              children: <Widget>[
                CommonNavigationTitle(
                  navigationTitle: esimItem.name,
                  textStyle: headerTwoMediumTextStyle(
                    context: context,
                    fontColor: mainDarkTextColor(context: context),
                  ),
                ),
                esimItem.type == EsimArgumentType.country
                    ? PaddingWidget.applySymmetricPadding(
                        horizontal: 15,
                        vertical: 10,
                        child: MainInputField.searchField(
                          controller: viewModel.searchTextFieldController,
                          themeColor: themeColor,
                          textConfig: MainInputFieldTextConfig(
                            hintText:
                                LocaleKeys.dataPlans_SearchPlaceHolderText.tr(),
                          ),
                          appearanceConfig: MainInputFieldAppearanceConfig(
                            backgroundColor: context.appColors.baseWhite,
                            labelStyle: captionOneNormalTextStyle(
                              context: context,
                              fontColor: secondaryTextColor(context: context),
                            ),
                          ),
                          behaviorConfig: const MainInputFieldBehaviorConfig(
                            clearSearchEnabled: true,
                          ),
                          interactionConfig: MainInputFieldInteractionConfig(
                            enterPressed: () => <dynamic, dynamic>{},
                            onTap: () =>
                                viewModel.setSearchFocused(focused: true),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                if (esimItem.type == EsimArgumentType.country)
                  FlagChipsRow(
                    selectedCountries: viewModel.selectedCountryChips,
                    onChipRemoved: (CountryResponseModel country) async =>
                        viewModel.removeCountry(country),
                  ),
                Expanded(
                  child: PaddingWidget.applyPadding(
                    top: viewModel.esimArguments.type == EsimArgumentType.region
                        ? 20
                        : 0,
                    child: viewModel.childViewModel != null
                        ? BundlesByCountriesView(
                            horizontalPadding: 10,
                            viewModel: viewModel.childViewModel!,
                            onBundleSelected:
                                (BundleResponseModel bundle) async =>
                                    viewModel.navigateToEsimDetail(bundle),
                          )
                        : Container(),
                  ),
                ),
              ],
            ),
          ),
          esimItem.type == EsimArgumentType.country
              ? _buildSearchList(context, viewModel)
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EsimArguments>("esimItem", esimItem));
  }
}

Widget _buildSearchList(BuildContext context, BundlesListViewModel model) {
  return ValueListenableBuilder<bool>(
    valueListenable: model.isSearchFocused,
    builder: (BuildContext context, bool isSearchFocused, _) {
      if (!isSearchFocused || model.filteredCountries.isEmpty) {
        return const SizedBox.shrink();
      }
      return Stack(
        children: <Widget>[
          Positioned.fill(
            child: GestureDetector(
              onTap: () => model.setSearchFocused(focused: false),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            top: 110,
            left: 15,
            right: 15,
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: getContainerHeight(
                    context,
                    model.filteredCountries.length,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: mainBorderColor(context: context),
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withAlpha(20),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CountrySearchList(
                  countries: model.filteredCountries,
                  onCountrySelected: (CountryResponseModel country) async {
                    model
                      ..addCountry(country)
                      ..setSearchFocused(focused: false);
                  },
                  searchQuery: model.searchTextFieldController.text,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

double getContainerHeight(BuildContext context, int count) {
  double maxHeight = MediaQuery.of(context).size.height * 0.25;
  double height = count * 80;
  return min(maxHeight, height);
}

class CountrySearchList extends StatelessWidget {
  const CountrySearchList({
    required this.countries,
    required this.onCountrySelected,
    required this.searchQuery,
    super.key,
  });

  final List<CountryResponseModel> countries;
  final Function(CountryResponseModel) onCountrySelected;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: countries.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CountryFlagImage(
              icon: countries[index].icon ?? "",
            ),
            title: Text(countries[index].country ?? ""),
            onTap: () {
              onCountrySelected(countries[index]);
            },
          );
        },
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<CountryResponseModel>("countries", countries))
      ..add(
        ObjectFlagProperty<Function(CountryResponseModel p1)>.has(
          "onCountrySelected",
          onCountrySelected,
        ),
      )
      ..add(StringProperty("searchQuery", searchQuery));
  }
}

class FlagChip extends StatelessWidget {
  const FlagChip({
    required this.icon,
    required this.countryName,
    required this.onRemove,
    super.key,
  });

  final String icon;
  final String countryName;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: CountryFlagImage(
        icon: icon,
      ),
      label: Text(
        countryName,
        style: captionTwoMediumTextStyle(
          context: context,
          fontColor: bubbleCountryTextColor(
            context: context,
          ),
        ),
      ),
      deleteIcon: const Icon(Icons.close, size: 12),
      onDeleted: onRemove,
      backgroundColor: greyBackGroundColor(context: context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty("icon", icon))
      ..add(StringProperty("countryName", countryName))
      ..add(ObjectFlagProperty<VoidCallback>.has("onRemove", onRemove));
  }
}

class FlagChipsRow extends StatefulWidget {
  const FlagChipsRow({
    required this.selectedCountries,
    required this.onChipRemoved,
    super.key,
  });

  final List<CountryResponseModel> selectedCountries;
  final Function(CountryResponseModel) onChipRemoved;

  @override
  State<FlagChipsRow> createState() => _FlagChipsRowState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        IterableProperty<CountryResponseModel>(
          "selectedCountries",
          selectedCountries,
        ),
      )
      ..add(
        ObjectFlagProperty<Function(CountryResponseModel p1)>.has(
          "onChipRemoved",
          onChipRemoved,
        ),
      );
  }
}

class _FlagChipsRowState extends State<FlagChipsRow> {
  @override
  Widget build(BuildContext context) {
    return PaddingWidget.applySymmetricPadding(
      horizontal: 15,
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          spacing: 10,
          children:
              widget.selectedCountries.map((CountryResponseModel country) {
            return FlagChip(
              icon: country.icon ?? "",
              countryName: country.country ?? "",
              onRemove: () => widget.onChipRemoved(country),
            );
          }).toList(),
        ),
      ),
    );
  }
}
