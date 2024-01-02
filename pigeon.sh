#!/bin/sh
# pigeon.sh
# Generates files needed for Pigeon.

flutter pub run pigeon \
  --input pigeons/tasker_action_api.dart \
  --dart_out lib/tasker/tasker_action_pigeon.dart \
  --experimental_kotlin_out android/app/src/main/kotlin/com/example/namer_app/tasker/action/TaskerActionPigeon.kt \
  --experimental_kotlin_package com.example.namer_app.tasker.action