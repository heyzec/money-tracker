package com.heyzec.money_tracker.tasker.addtransaction

import com.joaomgcd.taskerpluginlibrary.output.TaskerOutputObject
import com.joaomgcd.taskerpluginlibrary.output.TaskerOutputVariable
import com.heyzec.money_tracker.R

@TaskerOutputObject()
class AddTransactionOutput(
    @get:TaskerOutputVariable(
        "output",
        labelResIdName = "output",
        htmlLabelResIdName = "output_description"
    ) val output: String
)
