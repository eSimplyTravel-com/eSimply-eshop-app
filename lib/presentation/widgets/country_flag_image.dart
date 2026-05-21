import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/widgets/network_image_cached.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

class CountryFlagImage extends StatelessWidget {
  const CountryFlagImage({
    required this.icon,
    super.key,
    this.width,
    this.height,
  });

  final String icon;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    if (icon.startsWith("assets/")) {
      // for local icons
      if (icon.toLowerCase().endsWith(".svg")) {
        return SvgPicture.asset(
          icon,
          width: width ?? 30,
          height: height ?? 30,
          placeholderBuilder: (_) => SizedBox(
            width: width ?? 30,
            height: height ?? 30,
          ).applyShimmer(
            params: ShimmerParams(
              enable: true,
              context: context,
              borderRadius: 30,
            ),
          ),
        );
      } else {
        return Image.asset(
          icon,
          width: width ?? 30,
          height: height ?? 30,
          errorBuilder: (_, __, ___) => Image.asset(
            EnvironmentImages.globalFlag.fullImagePath,
            width: width ?? 30,
            height: height ?? 30,
          ),
        );
      }
    }

    return CachedImage.network(
      imagePath: icon,
      dimensions: ImageDimensions(
        width: width ?? 30,
        height: height ?? 30,
      ),
      widgets: ImageWidgets(
        errorWidget: SvgPicture.asset(
          EnvironmentImages.globalFlag.fullImagePath,
          width: width ?? 30,
          height: height ?? 30,
        ),
        placeholder: SizedBox(
          width: width ?? 30,
          height: height ?? 30,
        ).applyShimmer(
          params: ShimmerParams(
            enable: true,
            context: context,
            borderRadius: 30,
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty("icon", icon))
      ..add(DoubleProperty("width", width))
      ..add(DoubleProperty("height", height));
  }
}

@AppPreview(name: "Country Flag Image")
Widget countryFlagImagePreview() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: CountryFlagImage(
          icon: "assets/images/shared/flags/globalFlag.svg",
          width: 64,
          height: 64,
        ),
      ),
    ),
  );
}
