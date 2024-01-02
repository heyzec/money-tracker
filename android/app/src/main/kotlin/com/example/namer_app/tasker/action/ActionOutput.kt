package dev.k9withabone.flutter_tasker_integration_example.tasker.action

import com.joaomgcd.taskerpluginlibrary.output.TaskerOutputObject
import com.joaomgcd.taskerpluginlibrary.output.TaskerOutputVariable
import dev.k9withabone.flutter_tasker_integration_example.R

@TaskerOutputObject()
class ActionOutput(
    @get:TaskerOutputVariable(
        "output",
        R.string.output,
        R.string.output_description
    ) val output: String
)