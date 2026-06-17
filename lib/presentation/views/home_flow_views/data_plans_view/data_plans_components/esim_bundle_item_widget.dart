import "package:easy_localization/easy_localization.dart" show StringTranslateExtension;
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/domain/data/response/bundles/country_response_model.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/widgets/country_flag_image.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/supported_countries_widget.dart";
import "package:esim_open_source/presentation/widgets/unlimited_data_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class EsimBundleWidget extends StatelessWidget {
  const EsimBundleWidget({
    required this.priceButtonText,
    required this.title,
    required this.data,
    required this.validFor,
    required this.supportedCountries,
    required this.onPriceButtonClick,
    required this.icon,
    required this.showUnlimitedData,
    this.showArrow = true,
    this.availableCountries = const <CountryResponseModel>[],
    super.key,
  });

  final String priceButtonText;
  final String title;
  final String data;
  final String validFor;
  final String icon;
  final List<CountryResponseModel> supportedCountries;
  final bool showArrow;
  final VoidCallback onPriceButtonClick;
  final List<CountryResponseModel> availableCountries;
  final bool showUnlimitedData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPriceButtonClick,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: mainBorderColor(context: context),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CountryFlagImage(
                    icon: icon,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.ltr,
                      style: captionOneNormalTextStyle(
                        context: context,
                        fontColor: regionCountryBundleTitleTextColor(
                          context: context,
                        ),
                      ),
                    ).textSupportsRTL(context),
                  ),
                  const SizedBox(width: 10),
                  showUnlimitedData
                      ? const UnlimitedDataWidget()
                      : Text(
                          data,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.ltr,
                          style: headerTwoMediumTextStyle(
                            context: context,
                            fontColor:
                                bundleDataPriceTextColor(context: context),
                          ),
                        ),
                  const SizedBox(width: 10),
                  Image.asset(
                    EnvironmentImages.darkArrowRight.fullImagePath,
                    height: 15,
                    fit: BoxFit.fitHeight,
                  ).imageSupportsRTL(context),
                ],
              ),

              const SizedBox(height: 15),

              Divider(
                color: greyBackGroundColor(context: context),
                height: 1,
              ),
              // Valid For Row
              //const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "${LocaleKeys.bundleInfo_validityText.tr()} $validFor",
                    textDirection: TextDirection.ltr,
                    style: captionTwoNormalTextStyle(
                      context: context,
                      fontColor: contentTextColor(context: context),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      availableCountries.isEmpty
                          ? const SizedBox.shrink()
                          : Text(
                              LocaleKeys.supportedCountries_availableInText
                                  .tr(),
                              style: captionTwoNormalTextStyle(
                                context: context,
                                fontColor: contentTextColor(context: context),
                              ),
                            ),
                      SupportedCountriesWidget(
                        size: 18,
                        showOnlyFlags: true,
                        countries: availableCountries,
                        label: LocaleKeys.supportedCountries_tittleText.tr(),
                        backgroundColor: greyBackGroundColor(context: context),
                      ),
                    ],
                  ),
                ],
              ),

              //const SizedBox(height: 10),

              // Supported Countries
              if (supportedCountries.isNotEmpty)
                SupportedCountriesWidget(
                  offset: 20,
                  countries: supportedCountries,
                  label: LocaleKeys.supportedCountries_tittleText.tr(),
                  backgroundColor: greyBackGroundColor(context: context),
                ),

              const SizedBox(height: 15),

              // Price Button
              Container(
                alignment: Alignment.centerLeft,
                child: MainButton.bannerButton(
                  params: BannerButtonParams(
                    title: priceButtonText,
                    action: onPriceButtonClick,
                    height: 42,
                    themeColor: themeColor,
                    textColor: enabledMainButtonTextColor(context: context),
                    buttonColor: enabledMainButtonColor(context: context),
                    titleTextStyle: captionOneBoldTextStyle(
                      context: context,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty("priceButtonText", priceButtonText))
      ..add(StringProperty("title", title))
      ..add(StringProperty("data", data))
      ..add(StringProperty("validFor", validFor))
      ..add(
        IterableProperty<CountryResponseModel>(
          "supportedCountries",
          supportedCountries,
        ),
      )
      ..add(DiagnosticsProperty<bool>("showArrow", showArrow))
      ..add(
        ObjectFlagProperty<VoidCallback>.has(
          "onPriceButtonClick",
          onPriceButtonClick,
        ),
      )
      ..add(StringProperty("icon", icon))
      ..add(
        IterableProperty<CountryResponseModel>(
          "availableCountries",
          availableCountries,
        ),
      )
      ..add(DiagnosticsProperty<bool>("showUnlimitedData", showUnlimitedData));
  }
}
