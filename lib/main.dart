import "dart:async";
import "dart:developer";
import "dart:io";
import "dart:ui";

import "package:chucker_flutter/chucker_flutter.dart";
import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/domain/repository/services/dynamic_linking_service.dart";
import "package:esim_open_source/firebase_options_open_source_dev.dart"
    as open_source_dev;
import "package:esim_open_source/firebase_options_open_source_prod.dart"
    as open_source_prod;
import "package:esim_open_source/firebase_options_open_source_stg.dart"
    as open_source_stg;
import "package:esim_open_source/presentation/extensions/stacked_services/custom_route_observer.dart";
import "package:esim_open_source/presentation/helpers/view_state_utils.dart";
import "package:esim_open_source/presentation/router.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/setup_dialog_ui.dart";
import "package:esim_open_source/presentation/setup_snackbar_ui.dart";
import "package:esim_open_source/presentation/shared/deep_link_helper.dart";
import "package:esim_open_source/presentation/theme/my_theme_builder.dart";
import "package:esim_open_source/presentation/theme/theme_setup.dart";
import "package:esim_open_source/presentation/view_models/main_model.dart";
import "package:esim_open_source/presentation/views/start_up_view/startup_view.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:esim_open_source/utils/my_http_overrides.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:phone_input/l10n/generated/phone_field_localization.dart";
import "package:stacked/stacked.dart";
import "package:stacked_services/stacked_services.dart";
import "package:stacked_themes/stacked_themes.dart";

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // if(kDebugMode){
  HttpOverrides.global = MyHttpOverrides();
  // }
  initializeChucker();

  await EasyLocalization.ensureInitialized();
  await setupBaseFlutterLocator();
  await ThemeManager.initialise();
  setupDialogUi();
  setupSnackbarUi();
  setupBottomSheetUi();
  FlutterNativeSplash.remove();
  await AppEnvironment.setupEnvironment();
  await initializeFirebaseApp();
  await locator<AnalyticsService>().configure();
  await DeepLinkHandler.shared.init(({
    required Uri uri,
    required bool isInitial,
  }) {
    DeepLinkHandler.shared.handleDeepLink(uri: uri, isInitial: isInitial);
  });

  await locator<DynamicLinkingService>().initialize(
    onDeepLink: ({
      required Uri uri,
      required bool isInitial,
    }) {
      DeepLinkHandler.shared.handleDeepLink(uri: uri, isInitial: isInitial);
    },
  );
  // Branch's ATT request used to fire here, before the user had been asked
  // anything. There is only one system ATT prompt, so whichever SDK asks first
  // owns the moment — and it was this one. It now runs from
  // AnalyticsServiceImpl, after analytics consent has been granted.

  runApp(const MyFlutterActivity(StartUpView()));
  FlutterNativeSplash.remove();
}

void initializeChucker() {
  switch (Environment.currentEnvironment) {
    // case Environment.openSourceProd:
    //   ChuckerFlutter.showOnRelease = true;
    default:
      ChuckerFlutter.showOnRelease = false;
  }
}

Future<void> initializeFirebaseApp() async {
  // Determine which Firebase options to use based on the flavor
  FirebaseOptions firebaseOptions =
      open_source_prod.DefaultFirebaseOptions.currentPlatform;

  switch (Environment.currentEnvironment) {
    case Environment.openSourceDev:
      firebaseOptions = open_source_dev.DefaultFirebaseOptions.currentPlatform;
    case Environment.openSourceStaging:
      firebaseOptions = open_source_stg.DefaultFirebaseOptions.currentPlatform;
    case Environment.openSourceProd:
      firebaseOptions = open_source_prod.DefaultFirebaseOptions.currentPlatform;
  }

  await Firebase.initializeApp(options: firebaseOptions);

  FlutterError.onError = (FlutterErrorDetails errorDetails) {
    unawaited(
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails),
    );
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    unawaited(
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
    );
    return true;
  };
}

class MyFlutterActivity extends StatefulWidget {
  const MyFlutterActivity(this.defaultWidget, {super.key});

  final Widget defaultWidget;

  @override
  State<MyFlutterActivity> createState() => _MyFlutterActivityState();
}

class _MyFlutterActivityState extends State<MyFlutterActivity>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    setDefaultStatusBarColor();

    unawaited(
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    unawaited(
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]),
    );
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // App is in background
      log("App moved to background");
    } else if (state == AppLifecycleState.resumed) {
      // App is in foreground
      log("App moved to foreground");
      //locator<BundlesDataService>().refreshData();
    } else if (state == AppLifecycleState.inactive) {
      // App is in inactive state (e.g., phone call, home screen)
      log("App is inactive");
    } else if (state == AppLifecycleState.detached) {
      // App is terminated
      log("App is detached (terminated)");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      onViewModelReady: (MainViewModel model) async => model.onModelReady(),
      builder: (BuildContext context, MainViewModel model, Widget? child) {
        return EasyLocalization(
          useOnlyLangCode: true,
          startLocale: model.getDefaultLocale(),
          supportedLocales: model.getLocaleList(),
          path:
              "assets/translations/${AppEnvironment.appEnvironmentHelper.environmentTheme.directoryName}",
          child: MyThemeBuilder(
            // statusBarColorBuilder: (theme) => model.getColor(),
            // defaultThemeMode: ThemeMode.light,
            themes: getThemes(),
            builder: (
              BuildContext context,
              ThemeData? regularTheme,
              ThemeData? darkTheme,
              ThemeMode? themeMode,
            ) =>
                KeyboardVisibilityProvider(
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: LocaleKeys.appName,
                theme: regularTheme,
                // ThemeData(
                //   primarySwatch: Colors.lightGreen,
                //   textTheme: Theme.of(context).textTheme.apply(
                //         fontFamily: 'Open Sans',
                //       ),
                // ),
                darkTheme: darkTheme,
                themeMode: themeMode,
                navigatorKey: StackedService.navigatorKey,
                navigatorObservers: <NavigatorObserver>[
                  StackedService.routeObserver,
                  locator<CustomRouteObserver>(),
                  ChuckerFlutter.navigatorObserver,
                ],
                // navigatorObservers: [locator<AnalyticsService>().getAnalyticsObserver()],
                home: widget.defaultWidget,
                onGenerateRoute: generateRoute,
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                  ...context.localizationDelegates, // but only if context is safe
                  PhoneFieldLocalization.delegate,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
