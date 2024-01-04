package com.example.namer_app.tasker.action

import com.joaomgcd.taskerpluginlibrary.input.TaskerInputField
import com.joaomgcd.taskerpluginlibrary.input.TaskerInputRoot
import com.example.namer_app.R

@TaskerInputRoot
class ActionInput @JvmOverloads constructor(
    @field:TaskerInputField("input", labelResIdName = "config") var config: String = "",
)
