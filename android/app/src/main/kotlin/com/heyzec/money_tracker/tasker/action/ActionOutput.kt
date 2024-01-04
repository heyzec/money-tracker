package com.heyzec.money_tracker.tasker.action

import com.joaomgcd.taskerpluginlibrary.output.TaskerOutputObject
import com.joaomgcd.taskerpluginlibrary.output.TaskerOutputVariable
import com.heyzec.money_tracker.R

@TaskerOutputObject()
class ActionOutput(
    @get:TaskerOutputVariable(
        "output",
        labelResIdName = "output",
        htmlLabelResIdName = "output_description"
    ) val output: String
)
