package com.heyzec.money_tracker.tasker.addtransaction

import android.content.Context
import android.os.Looper
import androidx.core.os.HandlerCompat
import com.joaomgcd.taskerpluginlibrary.action.TaskerPluginRunnerAction
import com.joaomgcd.taskerpluginlibrary.input.TaskerInput
import com.joaomgcd.taskerpluginlibrary.runner.TaskerPluginResult
import com.joaomgcd.taskerpluginlibrary.runner.TaskerPluginResultSucess
import com.joaomgcd.taskerpluginlibrary.runner.TaskerPluginResultErrorWithOutput
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch


class AddTransactionRunner : TaskerPluginRunnerAction<AddTransactionInput, AddTransactionOutput>() {
    private class RunApi : AddTransactionRunApi {
        val flutterDoneCompletable = CompletableDeferred<AddTransactionOutputMessage>()

        override fun runDone(output: AddTransactionOutputMessage, callback: (Result<Boolean>) -> Unit) {
            callback(Result.success(true))
            flutterDoneCompletable.complete(output)
        }
    }

    private var result : AddTransactionOutputMessage? = null

    private var dartEntrypointFunctionName = "taskerAddTransactionRunMain"

    private fun getDartEntrypointArgs(input: TaskerInput<AddTransactionInput>) : List<String>{
        return listOf(
            input.regular.date,
            input.regular.amount,
            input.regular.remarks,
            input.regular.categoryName,
        )
    }

    override fun run(
        context: Context,
        input: TaskerInput<AddTransactionInput>
    ): TaskerPluginResult<AddTransactionOutput> {
        Looper.prepare()
        val runnerHandler = HandlerCompat.createAsync(Looper.myLooper()!!)

        HandlerCompat.createAsync(Looper.getMainLooper()).post {
            val api = RunApi()
            val engine = FlutterEngine(context)
            val dartBundlePath = FlutterInjector.instance().flutterLoader().findAppBundlePath()
            val entrypoint = DartExecutor.DartEntrypoint(dartBundlePath, dartEntrypointFunctionName)

            AddTransactionRunApi.setUp(engine.dartExecutor.binaryMessenger, api)
            engine.dartExecutor.executeDartEntrypoint(entrypoint, getDartEntrypointArgs(input))

            var runResult : AddTransactionOutputMessage? = null
            MainScope().launch {
                runResult = api.flutterDoneCompletable.await()
            }.invokeOnCompletion {
                engine.destroy()
                runnerHandler.post {
                    result = runResult
                    runnerHandler.looper.quit()
                }
            }
        }

        Looper.loop()

        if (result!!.isError) {
            return TaskerPluginResultErrorWithOutput(result?.err?.toInt() ?: 0, result?.errMsg ?: "")
        } else {
            return TaskerPluginResultSucess(AddTransactionOutput("success"))
        }
    }
}
