package com.heyzec.money_tracker.tasker.action

import com.joaomgcd.taskerpluginlibrary.input.TaskerInputField
import com.joaomgcd.taskerpluginlibrary.input.TaskerInputRoot
import com.heyzec.money_tracker.R

@TaskerInputRoot
class ActionInput @JvmOverloads constructor(
    @field:TaskerInputField("input", labelResIdName = "config") var config: String = "",
)
