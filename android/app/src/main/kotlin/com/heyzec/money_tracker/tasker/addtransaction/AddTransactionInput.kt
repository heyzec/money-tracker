package com.heyzec.money_tracker.tasker.addtransaction

import com.joaomgcd.taskerpluginlibrary.input.TaskerInputField
import com.joaomgcd.taskerpluginlibrary.input.TaskerInputRoot
import com.heyzec.money_tracker.R

@TaskerInputRoot
class AddTransactionInput @JvmOverloads constructor(
    @field:TaskerInputField("date", labelResIdName = "config") var date: String = "%date",
    @field:TaskerInputField("amount", labelResIdName = "config") var amount: String = "%amount",
    @field:TaskerInputField("remarks", labelResIdName = "config") var remarks: String = "%remarks",
    @field:TaskerInputField("categoryName", labelResIdName = "config") var categoryName: String = "%category",
)
