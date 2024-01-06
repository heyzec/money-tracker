#!/bin/sh
# build-and-install.sh
# Builds a debug APK and installs it via adb

set -e option errexit


flutter build apk --debug
adb install build/app/outputs/flutter-apk/app-debug.apk
adb shell -- cmd notification post -S bigtext -t "'Installed debug app'" 'tag' "'Installed on $(date)'"
