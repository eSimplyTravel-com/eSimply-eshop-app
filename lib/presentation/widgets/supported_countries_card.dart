import "dart:math";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/widgets/country_flag_image.dart";
import "package:esim_open_source/presentation/widgets/info_row_view.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class SupportedCountriesCard extends StatefulWidget {
  const SupportedCountriesCard({required this.countries, super.key});

  final List<CountryResponseModel> countries;

  @override
  State<SupportedCountriesCard> createState() => _SupportedCountriesCardState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(IterableProperty<CountryResponseModel>("countries", countries));
  }
}

class _SupportedCountriesCardState extends State<SupportedCountriesCard> {
  bool _isExpanded = false;

  double getHeight() {
    double maxHeight = 180;
    double cellHeight = _isExpanded ? 40 + 40 : 40;
    double allHeight = widget.countries.length * cellHeight;
    return min(maxHeight, allHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: lightGreyBackGroundColor(context: context),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PaddingWidget.applySymmetricPadding(
            vertical: 12,
            horizontal: 12,
            child: Text(
              LocaleKeys.supportedCountries_card_tittleText.tr(
                namedArgs: <String, String>{
                  "countries": "(${widget.countries.length})",
                },
              ),
              style: captionTwoMediumTextStyle(
                context: context,
                fontColor: mainDarkTextColor(context: context),
              ),
            ),
          ),
          //verticalSpaceSmall,
          SizedBox(
            height: getHeight(),
            child: Scrollbar(
              thickness: 4,
              radius: const Radius.circular(2),
              child: ListView.builder(
                itemCount: widget.countries.length,
                itemBuilder: (BuildContext context, int index) {
                  final CountryResponseModel country = widget.countries[index];
                  final bool hasOperators = !(country.operatorList?.isEmpty ?? true);
                  final IconData expansionIcon = _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down;

                  return AbsorbPointer(
                    absorbing: country.operatorList?.isEmpty ?? true,
                    child: ExpansionTile(
                      collapsedIconColor:
                          mainTabBackGroundColor(context: context),
                      iconColor: mainTabBackGroundColor(context: context),
                      minTileHeight: 0,
                      shape: const Border(),
                      onExpansionChanged: (bool isExpanded) {
                        setState(() {
                          _isExpanded = isExpanded;
                        });
                      },
                      trailing: hasOperators
                          ? Icon(expansionIcon, size: 20)
                          : const SizedBox.shrink(),
                      tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                      title: Row(
                        children: <Widget>[
                          CountryFlagImage(
                            icon: widget.countries[index].icon ?? "",
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            country.country ?? "",
                            style: captionTwoMediumTextStyle(
                              context: context,
                              fontColor: titleTextColor(
                                context: context,
                              ),
                            ),
                          ),
                        ],
                      ),
                      children: <Widget>[
                        country.operatorList?.isEmpty ?? true
                            ? Container()
                            : InfoRow(
                                title: country.operatorList?.join(",") ??
                                    LocaleKeys.supportedCountries_noNetworks
                                        .tr(),
                              ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@AppPreview(name: "Supported Countries Card")
Widget supportedCountriesCardPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: SupportedCountriesCard(
        countries: CountryResponseModel.getMockCountries().take(5).toList(),
      ),
    ),
  );
}
