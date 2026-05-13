import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

class TopUpButton extends StatelessWidget {
  const TopUpButton({
    required this.onClick,
    this.isLoading = false,
    super.key,
    this.backgroundColor,
    this.textColor,
  });

  final bool isLoading;
  final VoidCallback onClick;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return MainButton(
      horizontalPadding: 15,
      hideShadows: true,
      leadingWidget: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: SvgPicture.asset(
          EnvironmentImages.topUpIcon.fullImagePath,
          colorFilter: ColorFilter.mode(
            context.appColors.baseBlack!,
            BlendMode.srcIn,
          ),
        ),
      ),
      title: LocaleKeys.top_up.tr(),
      onPressed: onClick,
      height: 40,
      titleTextStyle: captionOneMediumTextStyle(
        context: context,
      ),
      enabledBackgroundColor: backgroundColor,
      themeColor: backgroundColor ?? enabledMainButtonColor(context: context),
      enabledTextColor:
          textColor ?? enabledMainButtonTextColor(context: context),
    ).applyShimmer(
      params: ShimmerParams(enable: isLoading, context: context, height: 20),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>("isLoading", isLoading))
      ..add(ObjectFlagProperty<VoidCallback>.has("onClick", onClick))
      ..add(ColorProperty("backgroundColor", backgroundColor))
      ..add(ColorProperty("textColor", textColor));
  }
}
