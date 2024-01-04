#!/bin/sh
# pigeon.sh
# Generates files needed for Pigeon.

dart run pigeon \
  --input pigeons/tasker_action_api.dart \
  --dart_out lib/tasker/tasker_action_pigeon.dart \
  --experimental_kotlin_out android/app/src/main/kotlin/com/heyzec/money_tracker/tasker/action/TaskerActionPigeon.kt \
  --experimental_kotlin_package com.heyzec.money_tracker.tasker.action
