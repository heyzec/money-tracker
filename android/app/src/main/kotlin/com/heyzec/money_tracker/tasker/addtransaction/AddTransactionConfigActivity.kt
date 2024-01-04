package com.heyzec.money_tracker.tasker.addtransaction

import android.app.Activity
import android.content.Context
import android.os.Bundle
import com.joaomgcd.taskerpluginlibrary.config.TaskerPluginConfig
import com.joaomgcd.taskerpluginlibrary.config.TaskerPluginConfigHelper
import com.joaomgcd.taskerpluginlibrary.input.TaskerInput
import io.flutter.embedding.android.FlutterActivity

class AddTransactionHelper(config: TaskerPluginConfig<AddTransactionInput>) :
    TaskerPluginConfigHelper<AddTransactionInput, AddTransactionOutput, AddTransactionRunner>(config) {
    override val runnerClass = AddTransactionRunner::class.java
    override val inputClass = AddTransactionInput::class.java
    override val outputClass = AddTransactionOutput::class.java

    override fun addToStringBlurb(input: TaskerInput<AddTransactionInput>, blurbBuilder: StringBuilder) {
        blurbBuilder.clear()
        blurbBuilder.append("Inputs:\n")
        blurbBuilder.append("%amount\n")
        blurbBuilder.append("%category\n")
        blurbBuilder.append("%date\n")
        blurbBuilder.append("%remarks\n")
    }

}

@Suppress("ACCIDENTAL_OVERRIDE")
class AddTransactionConfigActivity : Activity(), TaskerPluginConfig<AddTransactionInput> {
    override val context get() = applicationContext

    private val helper by lazy { AddTransactionHelper(this) }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        helper.finishForTasker()
    }

    override val inputForTasker: TaskerInput<AddTransactionInput>
        get() = TaskerInput(AddTransactionInput())

    override fun assignFromInput(input: TaskerInput<AddTransactionInput>) { }

}
