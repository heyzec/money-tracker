// Autogenerated from Pigeon (v15.0.3), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

PlatformException _createConnectionError(String channelName) {
  return PlatformException(
    code: 'channel-error',
    message: 'Unable to establish connection on channel: "$channelName".',
  );
}

class AddTransactionInputMessage {
  AddTransactionInputMessage({
    this.config,
  });

  String? config;

  Object encode() {
    return <Object?>[
      config,
    ];
  }

  static AddTransactionInputMessage decode(Object result) {
    result as List<Object?>;
    return AddTransactionInputMessage(
      config: result[0] as String?,
    );
  }
}

class AddTransactionOutputMessage {
  AddTransactionOutputMessage({
    required this.isError,
    this.err,
    this.errMsg,
  });

  bool isError;

  int? err;

  String? errMsg;

  Object encode() {
    return <Object?>[
      isError,
      err,
      errMsg,
    ];
  }

  static AddTransactionOutputMessage decode(Object result) {
    result as List<Object?>;
    return AddTransactionOutputMessage(
      isError: result[0]! as bool,
      err: result[1] as int?,
      errMsg: result[2] as String?,
    );
  }
}

class _AddTransactionConfigApiCodec extends StandardMessageCodec {
  const _AddTransactionConfigApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is AddTransactionInputMessage) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return AddTransactionInputMessage.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class AddTransactionConfigApi {
  /// Constructor for [AddTransactionConfigApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  AddTransactionConfigApi({BinaryMessenger? binaryMessenger})
      : __pigeon_binaryMessenger = binaryMessenger;
  final BinaryMessenger? __pigeon_binaryMessenger;

  static const MessageCodec<Object?> pigeonChannelCodec = _AddTransactionConfigApiCodec();

  Future<bool> configDone(AddTransactionInputMessage input) async {
    const String __pigeon_channelName = 'dev.flutter.pigeon.money_tracker.AddTransactionConfigApi.configDone';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[input]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else if (__pigeon_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (__pigeon_replyList[0] as bool?)!;
    }
  }
}

class _AddTransactionRunApiCodec extends StandardMessageCodec {
  const _AddTransactionRunApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is AddTransactionOutputMessage) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return AddTransactionOutputMessage.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class AddTransactionRunApi {
  /// Constructor for [AddTransactionRunApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  AddTransactionRunApi({BinaryMessenger? binaryMessenger})
      : __pigeon_binaryMessenger = binaryMessenger;
  final BinaryMessenger? __pigeon_binaryMessenger;

  static const MessageCodec<Object?> pigeonChannelCodec = _AddTransactionRunApiCodec();

  Future<bool> runDone(AddTransactionOutputMessage output) async {
    const String __pigeon_channelName = 'dev.flutter.pigeon.money_tracker.AddTransactionRunApi.runDone';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[output]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else if (__pigeon_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (__pigeon_replyList[0] as bool?)!;
    }
  }
}
