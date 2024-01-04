#!/bin/sh
# build-and-install.sh
# Builds a debug APK and installs it via adb

flutter build apk --debug
adb install build/app/outputs/flutter-apk/app-debug.apk
adb shell cmd notification post money_tracker "Installed app on $(date)"
