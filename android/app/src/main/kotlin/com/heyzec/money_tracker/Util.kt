package com.heyzec.money_tracker

import android.app.Activity
import android.app.AlertDialog
import android.content.Context
import android.content.Intent
import android.os.Build.VERSION.SDK_INT
import android.os.Build.VERSION_CODES.M
import android.os.Handler
import android.os.Looper
import android.widget.ArrayAdapter
import android.widget.RadioButton
import android.widget.RadioGroup
import android.widget.Toast


fun String.toToast(context: Context) {
    Handler(Looper.getMainLooper()).post { Toast.makeText(context, this, Toast.LENGTH_LONG).show() }
}


fun Activity.alert(title: String, message: String) {
    val alertDialog = AlertDialog.Builder(this).create()
    alertDialog.setTitle(title)
    alertDialog.setMessage(message)
    alertDialog.setButton(AlertDialog.BUTTON_NEUTRAL, "OK") { dialog, _ -> dialog.dismiss() }
    alertDialog.show()
}

val RadioGroup.checkedRadioButton get() = this.findViewById<RadioButton>(checkedRadioButtonId)

val Context.canDrawOverlays get() = if (SDK_INT < M) true else android.provider.Settings.canDrawOverlays(this)

