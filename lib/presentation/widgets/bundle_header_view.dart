import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/widgets/country_flag_image.dart";
import "package:esim_open_source/presentation/widgets/unlimited_data_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class BundleHeaderView extends StatelessWidget {
  const BundleHeaderView({
    required this.title,
    required this.subTitle,
    required this.dataValue,
    required this.isLoading,
    required this.showUnlimitedData,
    this.countryPrice,
    this.imagePath,
    this.hasNavArrow = true,
    this.titleStyle,
    this.contentStyle,
    this.dataValueStyle,
    this.priceStyle,
    super.key,
  });

  final String? imagePath;
  final String title;
  final String subTitle;
  final String dataValue;
  final String? countryPrice;
  final bool hasNavArrow;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final TextStyle? dataValueStyle;
  final TextStyle? priceStyle;
  final bool isLoading;
  final bool showUnlimitedData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CountryFlagImage(
          icon: imagePath ?? "",
          width: 30,
          height: 30,
        ).applyShimmer(
          params: ShimmerParams(enable: isLoading, context: context),
        ),
        horizontalSpaceSmall,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                textDirection: TextDirection.ltr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: titleStyle ??
                    captionOneMediumTextStyle(
                      context: context,
                      fontColor: regionCountryBundleTitleTextColor(
                        context: context,
                      ),
                    ),
              ).applyShimmer(
                params: ShimmerParams(
                  enable: isLoading,
                  context: context,
                  height: 10,
                ),
              ),
              isLoading ? verticalSpaceSmall : Container(),
              Text(
                subTitle,
                textDirection: TextDirection.ltr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: contentStyle ??
                    captionOneNormalTextStyle(
                      context: context,
                      fontColor: contentTextColor(context: context),
                    ),
              ).applyShimmer(
                params: ShimmerParams(
                  enable: isLoading,
                  context: context,
                  height: 10,
                ),
              ),
            ],
          ),
        ),
        horizontalSpaceSmall,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    showUnlimitedData
                        ? UnlimitedDataWidget(
                            isLoading: isLoading,
                          )
                        : Text(
                            dataValue,
                            textDirection: TextDirection.ltr,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: dataValueStyle ??
                                headerOneBoldTextStyle(
                                  context: context,
                                  fontColor: bundleDataPriceTextColor(
                                    context: context,
                                  ),
                                ),
                          ).applyShimmer(
                            params: ShimmerParams(
                              enable: isLoading,
                              context: context,
                              height: 20,
                            ),
                          ),
                    hasNavArrow && !isLoading
                        ? horizontalSpaceSmall
                        : Container(),
                    hasNavArrow && !isLoading
                        ? Image.asset(
                            EnvironmentImages.darkArrowRight.fullImagePath,
                            width: 15,
                            height: 15,
                          ).imageSupportsRTL(context)
                        : const SizedBox(width: 5),
                  ],
                ),
                // Text(
                //   countryPrice,
                //   style: priceStyle ??
                //       bodyNormalTextStyle(
                //         context: context,
                //         fontColor: mainDarkTextColor(context: context),
                //       ),
                // ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty("countryTitle", title))
      ..add(StringProperty("countryContent", subTitle))
      ..add(StringProperty("countryDataValue", dataValue))
      ..add(StringProperty("countryPrice", countryPrice))
      ..add(DiagnosticsProperty<bool>("hasNavArrow", hasNavArrow))
      ..add(DiagnosticsProperty<TextStyle?>("titleStyle", titleStyle))
      ..add(DiagnosticsProperty<TextStyle?>("contentStyle", contentStyle))
      ..add(DiagnosticsProperty<TextStyle?>("dataValueStyle", dataValueStyle))
      ..add(DiagnosticsProperty<TextStyle?>("priceStyle", priceStyle))
      ..add(StringProperty("imagePath", imagePath))
      ..add(DiagnosticsProperty<bool>("isLoading", isLoading))
      ..add(DiagnosticsProperty<bool>("showUnlimitedData", showUnlimitedData));
  }
}

@AppPreview(name: "Bundle Header View")
Widget bundleHeaderViewPreview() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: BundleHeaderView(
        title: "United States",
        subTitle: "30 Days",
        dataValue: "5 GB",
        isLoading: false,
        showUnlimitedData: false,
      ),
    ),
  );
}
