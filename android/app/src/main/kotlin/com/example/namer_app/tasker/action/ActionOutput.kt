package com.example.namer_app.tasker.action

import com.joaomgcd.taskerpluginlibrary.output.TaskerOutputObject
import com.joaomgcd.taskerpluginlibrary.output.TaskerOutputVariable
import com.example.namer_app.R

@TaskerOutputObject()
class ActionOutput(
    @get:TaskerOutputVariable(
        "output",
        labelResIdName = "output",
        htmlLabelResIdName = "output_description"
    ) val output: String
)
