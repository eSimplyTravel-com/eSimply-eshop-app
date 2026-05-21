import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class InfoRow extends StatelessWidget {
  const InfoRow({
    required this.title,
    this.message,
    super.key,
  });

  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return PaddingWidget.applyPadding(
      start: 16,
      end: 16,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            message != null
                ? Text(
                    message ?? "",
                    style: captionTwoNormalTextStyle(
                      context: context,
                      fontColor: contentTextColor(context: context),
                    ),
                  )
                : Container(),
            Text(
              title,
              style: captionTwoNormalTextStyle(
                context: context,
                fontColor: mainDarkTextColor(context: context),
              ),
            ),
            verticalSpaceSmall,
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty("title", title))
      ..add(StringProperty("message", message));
  }
}

@AppPreview(name: "Info Row")
Widget infoRowPreview() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: InfoRow(
        title: "Sample title",
        message: "Sample message",
      ),
    ),
  );
}
