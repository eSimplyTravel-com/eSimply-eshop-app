// empty_content.dart
import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class EmptyContentUI extends StatelessWidget {
  const EmptyContentUI({
    required this.title,
    required this.description,
    this.imagePath,
    super.key,
    this.content,
  });

  final String title;
  final String description;
  final String? imagePath;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Spacer(flex: 10),
        if (imagePath != null)
          Image.asset(
            imagePath!,
            width: 80,
            height: 80,
          ),
        const Spacer(),
        Center(
          child: Text(
            title,
            style: headerThreeMediumTextStyle(
              context: context,
              fontColor: emptyStateTextColor(context: context),
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            description,
            style: bodyNormalTextStyle(
              context: context,
              fontColor: contentTextColor(context: context),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(flex: 2),
        if (content != null) content!,
        const Spacer(flex: 10),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty("title", title))
      ..add(StringProperty("description", description))
      ..add(StringProperty("imagePath", imagePath));
  }
}

class EmptyCurrentPlansContent extends StatelessWidget {
  const EmptyCurrentPlansContent({
    required this.onCheckOurPlansClick,
    super.key,
  });

  final VoidCallback onCheckOurPlansClick;

  @override
  Widget build(BuildContext context) {
    return EmptyContentUI(
      title: LocaleKeys.no_active_eSim.tr(),
      description: LocaleKeys.no_active_eSim_description.tr(),
      imagePath: EnvironmentImages.emptyEsims.fullImagePath,
      content: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: MainButton.bannerButton(
          params: BannerButtonParams(
            height: 50,
            action: onCheckOurPlansClick,
            themeColor: themeColor,
            titleHorizontalPadding: 30,
            title: LocaleKeys.check_plans_text.tr(),
            textColor: mainWhiteTextColor(context: context),
            buttonColor: emptyStateButtonColor(context: context),
            titleTextStyle: captionOneMediumTextStyle(context: context),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<VoidCallback>.has(
        "onCheckOurPlansClick",
        onCheckOurPlansClick,
      ),
    );
  }
}

class EmptyExpiredPlansContent extends StatelessWidget {
  const EmptyExpiredPlansContent({
    required this.onCheckOurPlansClick,
    super.key,
  });

  final VoidCallback onCheckOurPlansClick;

  @override
  Widget build(BuildContext context) {
    return EmptyContentUI(
      title: LocaleKeys.no_expired_eSim.tr(),
      description: LocaleKeys.no_expired_eSim_description.tr(),
      imagePath: EnvironmentImages.emptyEsims.fullImagePath,
      content: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: MainButton.bannerButton(
          params: BannerButtonParams(
            height: 50,
            action: onCheckOurPlansClick,
            themeColor: themeColor,
            titleHorizontalPadding: 30,
            title: LocaleKeys.check_plans_text.tr(),
            textColor: mainWhiteTextColor(context: context),
            buttonColor: emptyStateButtonColor(context: context),
            titleTextStyle: captionOneMediumTextStyle(context: context),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<VoidCallback>.has(
        "onCheckOurPlansClick",
        onCheckOurPlansClick,
      ),
    );
  }
}

@AppPreview(name: "Empty Content UI")
Widget emptyContentUIPreview() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: EmptyContentUI(
        title: "Nothing here yet",
        description: "Once you have items, they'll appear in this area.",
      ),
    ),
  );
}
