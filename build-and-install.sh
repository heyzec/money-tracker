#!/bin/sh
flutter build apk --debug && adb install build/app/outputs/flutter-apk/app-debug.apk && adb shell cmd notification post namer_app Installed
