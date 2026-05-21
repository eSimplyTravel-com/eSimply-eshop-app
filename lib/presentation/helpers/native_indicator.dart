import "dart:io";

import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

Widget getNativeIndicator(BuildContext context) {
  if (Platform.isIOS) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        context.appColors.primary_900!,
        BlendMode.srcATop,
      ),
      child: const CupertinoActivityIndicator(
        radius: 15,
      ),
    );
  }
  return CircularProgressIndicator(
    strokeWidth: 3,
    color: context.appColors.primary_900,
  );
}
