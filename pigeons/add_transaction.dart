// run scripts/pigeon.sh after modifying

import 'package:pigeon/pigeon.dart';

class AddTransactionInputMessage {
  String? config;
}

@HostApi()
abstract class AddTransactionConfigApi {
  // call when configuration is complete
  @async
  bool configDone(AddTransactionInputMessage input);
}

class AddTransactionOutputMessage {
  bool isError;
  int? err;
  String? errMsg;

  AddTransactionOutputMessage({this.err, this.errMsg, required this.isError});
}


@HostApi()
abstract class AddTransactionRunApi {
  // call when flutter runner is complete
  @async
  bool runDone(AddTransactionOutputMessage output);
}
