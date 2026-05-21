import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

Widget buildLocalFileSvg({
  required String imagePath,
  required double? width,
  required double? height,
  required BoxFit fit,
  required ColorFilter? colorFilter,
  required WidgetBuilder placeholderBuilder,
  required String semanticsLabel,
}) {
  return SvgPicture.file(
    File(imagePath),
    width: width,
    height: height,
    fit: fit,
    colorFilter: colorFilter,
    placeholderBuilder: placeholderBuilder,
    semanticsLabel: semanticsLabel,
  );
}
