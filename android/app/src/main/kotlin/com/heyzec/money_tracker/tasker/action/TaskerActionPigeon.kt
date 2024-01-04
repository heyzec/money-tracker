// Autogenerated from Pigeon (v15.0.3), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package com.heyzec.money_tracker.tasker.action

import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  if (exception is FlutterError) {
    return listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    return listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

/** Generated class from Pigeon that represents data sent in messages. */
data class TaskerActionInput (
  val config: String? = null

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): TaskerActionInput {
      val config = list[0] as String?
      return TaskerActionInput(config)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      config,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class TaskerActionOutput (
  val config: String? = null

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): TaskerActionOutput {
      val config = list[0] as String?
      return TaskerActionOutput(config)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      config,
    )
  }
}

@Suppress("UNCHECKED_CAST")
private object TaskerActionConfigApiCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          TaskerActionInput.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is TaskerActionInput -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface TaskerActionConfigApi {
  fun configDone(input: TaskerActionInput, callback: (Result<Boolean>) -> Unit)

  companion object {
    /** The codec used by TaskerActionConfigApi. */
    val codec: MessageCodec<Any?> by lazy {
      TaskerActionConfigApiCodec
    }
    /** Sets up an instance of `TaskerActionConfigApi` to handle messages through the `binaryMessenger`. */
    @Suppress("UNCHECKED_CAST")
    fun setUp(binaryMessenger: BinaryMessenger, api: TaskerActionConfigApi?) {
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.money_tracker.TaskerActionConfigApi.configDone", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val inputArg = args[0] as TaskerActionInput
            api.configDone(inputArg) { result: Result<Boolean> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
@Suppress("UNCHECKED_CAST")
private object TaskerActionRunApiCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          TaskerActionOutput.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is TaskerActionOutput -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface TaskerActionRunApi {
  fun runDone(output: TaskerActionOutput, callback: (Result<Boolean>) -> Unit)

  companion object {
    /** The codec used by TaskerActionRunApi. */
    val codec: MessageCodec<Any?> by lazy {
      TaskerActionRunApiCodec
    }
    /** Sets up an instance of `TaskerActionRunApi` to handle messages through the `binaryMessenger`. */
    @Suppress("UNCHECKED_CAST")
    fun setUp(binaryMessenger: BinaryMessenger, api: TaskerActionRunApi?) {
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.money_tracker.TaskerActionRunApi.runDone", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val outputArg = args[0] as TaskerActionOutput
            api.runDone(outputArg) { result: Result<Boolean> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
