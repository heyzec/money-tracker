package com.example.namer_app.tasker.action

import android.content.Context
import com.joaomgcd.taskerpluginlibrary.action.TaskerPluginRunnerAction
import com.joaomgcd.taskerpluginlibrary.input.TaskerInput
import com.joaomgcd.taskerpluginlibrary.runner.TaskerPluginResult

class ActionRunner : TaskerPluginRunnerAction<ActionInput, ActionOutput>() {
    override fun run(
        context: Context,
        input: TaskerInput<ActionInput>
    ): TaskerPluginResult<ActionOutput> {
        TODO("Not yet implemented")
    }
}