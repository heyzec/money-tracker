#!/bin/sh
# pigeon.sh
# Generates files needed for Pigeon.

set -e option

dart run pigeon \
  --input pigeons/add_transaction.dart \
  --dart_out lib/tasker/add_transaction.g.dart \
  --experimental_kotlin_out android/app/src/main/kotlin/com/heyzec/money_tracker/tasker/addtransaction/AddTransaction.g.kt \
  --experimental_kotlin_package com.heyzec.money_tracker.tasker.addtransaction
