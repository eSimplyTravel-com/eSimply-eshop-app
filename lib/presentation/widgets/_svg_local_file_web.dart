import "package:flutter/material.dart";

Widget buildLocalFileSvg({
  required String imagePath,
  required double? width,
  required double? height,
  required BoxFit fit,
  required ColorFilter? colorFilter,
  required WidgetBuilder placeholderBuilder,
  required String semanticsLabel,
}) {
  return Container(
    width: width,
    height: height,
    color: Colors.grey[200],
    alignment: Alignment.center,
    child: Icon(
      Icons.broken_image,
      color: Colors.grey[400],
    ),
  );
}
