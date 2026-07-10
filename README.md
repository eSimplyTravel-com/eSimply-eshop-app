# Open Source eSIM Instructions

## Getting Started

# Add your bundle identifiers on iOS and Android:

1. Open build.gradle in (android/app) navigate to product flavors and add your applicationID field in every flavor
2. Open project in xcode navigate to build settings section make sure Runner is selected as your target navigate to user-defined section and add your bundle identifier in IOS_APP_BUNDLE_ID field
3. Open project in xcode navigate to build settings section make sure Runner is selected as your target navigate to Packaging section and add $(IOS_APP_BUNDLE_ID) in PRODUCT_BUNDLE_IDENTIFIER field
4. Open project in xcode navigate to build settings section make sure NotificationService is selected as your target navigate to user-defined section and add your bundle identifier in IOS_APP_BUNDLE_ID field again
5. Open project in xcode navigate to build settings section make sure NotificationService is selected as your target navigate to Packaging section and add $(IOS_APP_BUNDLE_ID).NotificationService in PRODUCT_BUNDLE_IDENTIFIER field

# Change App Display Name

1. Open build.gradle in (android/app) navigate to product flavors and add your app_name field in every flavor
2. Open project in xcode navigate to build settings section make sure Runner is selected as your target navigate to user-defined section and add your app display name in PRODUCT_DISPLAY_NAME field

# Change App Icons

1. Open icons directory located in (assets/images/open_source/icons) override darkAppIcon.png and whiteAppIcon.png to match your logo
2. Open logo directory located in (assets/images/open_source/logo) override appIcon.png, splashIcon.png and notificationIcon.png to match your logo
3. Open user_guide directory located in (assets/images/open_source/user_guide) override iosStep1.png to match your logo
4. Open terminal in root directory and run (dart run flutter_launcher_icons -f flutter_launcher_icons.yaml) to generate app icon
5. Open terminal in root directory and run (dart run flutter_native_splash:create --path=flutter_native_splash.yaml) to generate app splash screen icon
6. Open terminal in root directory and run (./update_notification_icons.sh) to generate app notification launcher icon

# Add Firebase to your project

1. Make sure to install flutterfire_cli and activate it for reference (https://firebase.flutter.dev/docs/cli/)
2. Open flutterfire-config.sh and add your bundle id in OPEN_SOURCE_APP_BUNDLE_ID field
3. Open flutterfire-config.sh and add your firebase dev project id in FIREBASE_OPEN_SOURCE_DEV_PROJECT_ID field
4. Open flutterfire-config.sh and add your firebase prod project id in FIREBASE_OPEN_SOURCE_PROD_PROJECT_ID field
5. Open terminal in root and run ./flutterfire-config.sh $(your_flavor) ex: (./flutterfire-config.sh openSourceDev) then choose ios and android the build configuration the choose scheme

//Note after flutter upgrade run this command
dart pub global activate flutterfire_cli

# Environment Variables

1. Each flavor has its own instance inside the directory(lib/app/environment/envs)
2. The following environment variables are:
   . baseApiUrl: This is the main API domain where your app makes HTTP requests. (supabase config keys are dynamically provided via these APIs)
   - the solution related to this baseApiUrl is available on this link TODO:// Raed
     . omni is a third party service used to register device for (push notifications, version info ...), where you should create your own app inside this framework and use the given keys:
   - environmentFamilyName
     . Add name of the font family
   - environmentTheme
     . Theme for the app located in an enum in the path (lib/app/environment_theme.dart)
   - environmentCornerRadius
     . Corner radius for the main button
   - omniConfigTenant
   - omniConfigBaseUrl
   - omniConfigApiKey
   - omniConfigAppGuid.
   - isCruiseEnabled: feature flag to add cruise tab in home section
   - for setup refer to (TODO://Raed add links related)
     . supabaseFacebookCallBackScheme: This is a deep link / dynamic link used for Facebook login via Supabase setup.(refer to: "Sign in with Facebook" section)
   - websiteUrl: your website domain for deeplinking to work

# Feature flags

Each flavor can have it's own feature flag where the user can turn on or off from environment variables located in(lib/app/environment/envs)

1. enablePromoCode: user can use promo code to get discount while purchasing esim
2. enableWalletView: Show or hide the wallet section where user can top up his wallet and use it to purchase esim
3. enableBannersView: Show or hide the banners view on the main home page use with enableWalletView turned on
4. enableCurrencySelection: Show the user section where he can select his preferred currency code
5. enableLanguageSelection: Show the user section where he can select his preferred language
6. enableGuestFlowPurchase: When turned of user cannot purchase any esim as guest and has to login before any purchase
7. enableBranchIO: For dynamic linking support, to integrate branch IO please refer to this document(https://pub.dev/packages/flutter_branch_sdk), after integrating make sure to follow the following steps
   - Android: Change the following(branchScheme, branchDomain, branchTestDomain, branchKeyLive, branchKeyTest, branchUseTest) located in (android/app/build.gradle)
   - iOS: Open project with xcode choose your target and navigate to build settings user-defined change the following (BRANCH_DOMAIN, BRANCH_KEY_LIVE, BRANCH_KEY_TEST, BRANCH_SCHEME, BRANCH_USE_TEST_MODE) with your values

# Add Deeplinking

1. Open build.gradle in (android/app) navigate to product flavors and add your link in domain field in manifestPlaceholders in every flavor
2. Open project in xcode navigate to build settings section make sure Runner is selected as your target navigate to user-defined section and add your link in DEEP_LINK_DOMAIN field
3. Finish by adding your website also in your flavor environment variable located in (lib/app/environment/envs)

# Add your texts or Change Translation :

1. Open the translations files ar.json and en.json located in (assets/translations/open_source)
2. Add new texts to these json files or change available texts
3. Run the following command in terminal: dart run easy_localization:generate -S assets/translations -f keys -O lib/translations -o locale_keys.g.dart to generate a file locale_keys.g.dart at(lib/translations)
4. If the linter giving warning on the auto generated file just add (// ignore_for_file: type = lint) at the top of a file
5. You can use the texts like so LocaleKeys.{key of your text}.tr()

Note: In case you need a text with arguments here’s an example

1. “valid": "Valid {date}" add the text like that with date dynamic argument
2. Use it like LocaleKeys.{key of your text}.tr(namedArgs: {“date”: value_of_date})

# Sign in with Apple:

1. Register your app id
2. Enable Sign in with Apple capability
3. To integrate supabase with your Apple login follow this link (https://supabase.com/docs/guides/auth/social-login/auth-apple?queryGroups=environment&environment=client&queryGroups=platform&platform=flutter)

# Sign in With Google:

1. Open Google Cloud Platform(https://console.cloud.google.com/apis/dashboard?inv=1&invt=Absn1w)
2. Navigate to Apis&Services -> credentials and create your key with the bundle id for iOS and android app under OAuth Client IDS
3. iOS only Add the ClientID for the key generated inside BuildSettings (GOOGLE_SIGN_IN_CLIENT_ID)
4. To integrate supabase with your google login follow this link (https://supabase.com/docs/guides/auth/social-login/auth-google?queryGroups=platform&platform=flutter)

# Sign in with Facebook:

1. Create your fb App at (https://developers.facebook.com/apps/?show_reminder=true)
2. In the App Settings -> Basic add your iOS and android apps with your bundle ids
3. Get the Facebook client token from App Settings -> advanced and the Facebook App ID from the top header view
4. Navigate to (android/app/build.gradle) add for every flavor the facebook_app_id value, fb_client_token, fb_login_protocol_scheme note that fb_login_protocol_scheme is the facebook_app_id but with fb in front of key
5. In iOS open the project with Xcode in build settings -> user defined add the values for each flavor in the key FACEBOOK_SIGN_IN_APP_ID
6. To integrate supabase with your Facebook login follow this link (https://supabase.com/docs/guides/auth/social-login/auth-facebook)
