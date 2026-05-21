import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class SubInfoSection extends StatelessWidget {
  const SubInfoSection({
    super.key,
    this.title,
    this.subTitle,
    this.showInfoIcon = true,
    this.onPressed,
    this.infoIcon,
    this.subTitleColor,
    this.subTitleLeadingIcon,
  });
  final String? title;
  final String? subTitle;
  final Color? subTitleColor;
  final bool showInfoIcon;
  final Icon? subTitleLeadingIcon;
  final void Function()? onPressed;
  final Icon? infoIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed?.call();
      },
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              title != null
                  ? Text(
                      title ?? "",
                      style: captionTwoNormalTextStyle(
                        context: context,
                        fontColor: secondaryTextColor(context: context),
                      ),
                    )
                  : Container(),
              showInfoIcon
                  ? infoIcon ??
                      const Icon(
                        Icons.info_outline,
                        size: 12,
                      )
                  : Container(),
            ],
          ),
          Row(
            children: <Widget>[
              subTitleLeadingIcon ?? Container(),
              subTitle != null
                  ? Text(
                      subTitle ?? "",
                      style: captionOneMediumTextStyle(
                        context: context,
                        fontColor: contentTextColor(context: context),
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty("title", title))
      ..add(StringProperty("subTitle", subTitle))
      ..add(ColorProperty("subTitleColor", subTitleColor))
      ..add(DiagnosticsProperty<bool>("showInfoIcon", showInfoIcon))
      ..add(ObjectFlagProperty<void Function()?>.has("onPressed", onPressed));
  }
}

@AppPreview(name: "Sub Info Section")
Widget subInfoSectionPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: SubInfoSection(
        title: "Information",
        subTitle: "Sample subtitle text",
        showInfoIcon: true,
        onPressed: () {},
      ),
    ),
  );
}
