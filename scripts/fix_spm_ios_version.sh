#!/bin/bash
# Fixes FlutterGeneratedPluginSwiftPackage iOS deployment target.
# Flutter hardcodes iOS 13.0 in Package.swift during `flutter pub get`.
# This script patches it to match the project's iOS 15.0 minimum.

PACKAGE_SWIFT="ios/Flutter/ephemeral/Packages/FlutterGeneratedPluginSwiftPackage/Package.swift"

if [ -f "$PACKAGE_SWIFT" ]; then
  sed -i '' 's/\.iOS("13\.0")/\.iOS("15.0")/' "$PACKAGE_SWIFT"
  echo "Patched $PACKAGE_SWIFT to iOS 15.0"
else
  echo "Package.swift not found (run flutter pub get first)"
fi
