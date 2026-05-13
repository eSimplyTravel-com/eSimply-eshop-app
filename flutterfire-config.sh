#!/bin/bash
# Script to generate Firebase configuration files for different environments/flavors
# Feel free to reuse and adapt this script for your own projects

if [[ $# -eq 0 ]]; then
  echo "Error: No environment specified. Use 'openSourceDev', 'openSourceStaging', or 'openSourceProd'."
  exit 1
fi


OPEN_SOURCE_APP_BUNDLE_ID="com.esimply.esim"
FIREBASE_OPEN_SOURCE_DEV_PROJECT_ID="esimply-live"
FIREBASE_OPEN_SOURCE_PROD_PROJECT_ID="esimply-live"

case $1 in
  openSourceDev)
    flutterfire config \
      --project="${FIREBASE_OPEN_SOURCE_DEV_PROJECT_ID}" \
      --out=lib/firebase_options_open_source_dev.dart \
      --ios-bundle-id="${OPEN_SOURCE_APP_BUNDLE_ID}.test" \
      --ios-out=ios/flavors/OpenSourceDev/GoogleService-Info.plist \
      --android-package-name="${OPEN_SOURCE_APP_BUNDLE_ID}.test" \
      --android-out=android/app/src/OpenSourceDev/google-services.json
    ;;
  openSourceStaging)
    flutterfire config \
      --project="${FIREBASE_OPEN_SOURCE_PROD_PROJECT_ID}" \
      --out=lib/firebase_options_open_source_stg.dart \
      --ios-bundle-id="${OPEN_SOURCE_APP_BUNDLE_ID}" \
      --ios-out=ios/flavors/OpenSourceStg/GoogleService-Info.plist \
      --android-package-name="${OPEN_SOURCE_APP_BUNDLE_ID}" \
      --android-out=android/app/src/OpenSourceStaging/google-services.json
    ;;
  openSourceProd)
    flutterfire config \
      --project="${FIREBASE_OPEN_SOURCE_PROD_PROJECT_ID}" \
      --out=lib/firebase_options_open_source_prod.dart \
      --ios-bundle-id="${OPEN_SOURCE_APP_BUNDLE_ID}" \
      --ios-out=ios/flavors/OpenSourceProd/GoogleService-Info.plist \
      --android-package-name="${OPEN_SOURCE_APP_BUNDLE_ID}" \
      --android-out=android/app/src/OpenSourceProd/google-services.json
    ;;
  *)
  echo "Error: No environment specified. Use 'openSourceDev', 'openSourceStaging', or 'openSourceProd'."
  exit 1
  ;;
esac