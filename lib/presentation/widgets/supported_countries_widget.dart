import "dart:math";

import "package:esim_open_source/data/remote/responses/bundles/country_response_model.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/widgets/circular_flag_icon.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class SupportedCountriesWidget extends StatelessWidget {
  const SupportedCountriesWidget({
    required this.label,
    required this.countries,
    required this.backgroundColor,
    this.isLoading = false,
    super.key,
    this.maxCountriesToShow = 5,
    this.size = 25.0,
    this.offset = 15.0,
    this.padding = 12,
    this.borderRadius = 6,
    this.labelStyle,
    this.showLabel = true,
    this.showOnlyFlags = false,
  });

  final bool isLoading;
  final List<CountryResponseModel> countries;
  final int maxCountriesToShow;
  final double size;
  final double offset;
  final double padding;
  final double borderRadius;
  final Color backgroundColor;
  final TextStyle? labelStyle;
  final String label;
  final bool showLabel;
  final bool showOnlyFlags;

  @override
  Widget build(BuildContext context) {
    List<Widget> countryWidgets = _buildCountryWidgets(context);
    double stackWidth = _calculateStackWidth();
    return showOnlyFlags
        ? Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: stackWidth - 10,
              height: size + (padding * 2),
              color: Colors.transparent,
              padding: EdgeInsets.only(
                top: padding,
                bottom: padding,
              ),
              child: SizedBox(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: countryWidgets.reversed.toList(),
                ),
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: EdgeInsets.all(padding),
            height: size + (padding * 2),
            child: Row(
              children: <Widget>[
                if (showLabel) ...<Widget>[
                  Text(
                    label,
                    style: labelStyle ??
                        captionTwoMediumTextStyle(
                          context: context,
                          fontColor: contentTextColor(context: context),
                        ),
                  ),
                  const Spacer(),
                ],
                SizedBox(
                  width: stackWidth,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: countryWidgets.reversed.toList(),
                  ),
                ),
              ],
            ),
          ).applyShimmer(
            params: ShimmerParams(
              enable: isLoading,
              context: context,
              height: 20,
            ),
          );
  }

  List<Widget> _buildCountryWidgets(
    BuildContext context,
  ) {
    List<Widget> widgets = <Widget>[];
    int totalCountries = countries.length;
    int countriesToDisplay = min(totalCountries, maxCountriesToShow);

    if (totalCountries > maxCountriesToShow) {
      widgets.add(
        _buildOverflowIndicator(
          totalCountries - maxCountriesToShow,
          context,
        ),
      );
    }

    for (int i = 0; i < countriesToDisplay; i++) {
      widgets.add(_buildFlagWidget(i, totalCountries, context));
    }

    return widgets;
  }

  Widget _buildOverflowIndicator(
    int remainingCount,
    BuildContext context,
  ) {
    return Positioned(
      right: 0,
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: showOnlyFlags
                ? mainBorderColor(context: context)
                : Colors.white,
            width: 2,
          ),
        ),
        child: ClipOval(
          child: Container(
            width: size * 1.15,
            height: size * 1.15,
            color: greyBackGroundColor(context: context),
            child: Center(
              child: Text(
                "+$remainingCount",
                style: TextStyle(
                  color: mainDarkTextColor(context: context),
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlagWidget(
    int index,
    int totalCountries,
    BuildContext context,
  ) {
    return Positioned(
      right:
          (index * offset) + (totalCountries > maxCountriesToShow ? offset : 0),
      child: CircularFlagIcon(
        icon: countries[index].icon ?? "",
        size: size * 1.1,
        borderColor:
            showOnlyFlags ? mainBorderColor(context: context) : Colors.white,
      ),
    );
  }

  double _calculateStackWidth() {
    int totalCountries = countries.length;
    int countriesToDisplay = min(totalCountries, maxCountriesToShow);
    double width = (countriesToDisplay * offset) + size;

    if (totalCountries > maxCountriesToShow) {
      width += offset;
    }

    return width;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>("isLoading", isLoading))
      ..add(IterableProperty<CountryResponseModel>("countries", countries))
      ..add(IntProperty("maxCountriesToShow", maxCountriesToShow))
      ..add(DoubleProperty("size", size))
      ..add(DoubleProperty("offset", offset))
      ..add(DoubleProperty("padding", padding))
      ..add(DoubleProperty("borderRadius", borderRadius))
      ..add(ColorProperty("backgroundColor", backgroundColor))
      ..add(DiagnosticsProperty<TextStyle?>("labelStyle", labelStyle))
      ..add(StringProperty("label", label))
      ..add(DiagnosticsProperty<bool>("showLabel", showLabel))
      ..add(DiagnosticsProperty<bool>("showOnlyFlags", showOnlyFlags));
  }
}

@AppPreview(name: "Supported Countries Widget")
Widget supportedCountriesWidgetPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: SupportedCountriesWidget(
        label: "Supported Countries",
        countries: CountryResponseModel.getMockCountries().take(5).toList(),
        backgroundColor: Colors.grey[200]!,
      ),
    ),
  );
}
