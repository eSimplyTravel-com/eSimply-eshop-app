import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/presentation/theme/theme_setup.dart";
import "package:flutter/material.dart";
import "package:flutter/widget_previews.dart";

final class AppPreview extends Preview {
  const AppPreview({
    super.name,
    super.group,
    super.size,
    super.textScaleFactor,
    super.brightness,
  }) : super(theme: _previewTheme, wrapper: _previewWrapper);

  static PreviewThemeData _previewTheme() {
    _ensureEnvironment();
    return PreviewThemeData(
      materialLight: ThemeData(
        extensions: <ThemeExtension<AppColors>>[AppColors.lightThemeColors],
      ),
      materialDark: ThemeData(
        brightness: Brightness.dark,
        extensions: <ThemeExtension<AppColors>>[AppColors.darkThemeColors],
      ),
    );
  }

  static Widget _previewWrapper(Widget child) {
    _ensureEnvironment();
    return FutureBuilder<void>(
      future: EasyLocalization.ensureInitialized(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }
        return EasyLocalization(
          useOnlyLangCode: true,
          supportedLocales: const <Locale>[Locale("en")],
          path:
              "assets/translations/${AppEnvironment.appEnvironmentHelper.environmentTheme.directoryName}",
          child: child,
        );
      },
    );
  }

  static void _ensureEnvironment() {
    AppEnvironment.appEnvironmentHelper =
        Environment.getAppEnvironmentHelper();
  }
}
