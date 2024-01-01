import 'dart:async';

const validCalculatorActions = [
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "0",
  "+",
  "-",
  "x",
  "/",
  ".",
  "=",
  "B",
];

class NumpadLogic {
  String _buffer = "0";
  int? _register;
  String? _operation;
  StreamController<String> _streamController = StreamController();

  NumpadLogic([int? initialValue]) {
    if (initialValue == null) {
      _buffer = "0";
      _register;
    } else {
      _buffer = _formatFromCents(initialValue);
      _register = initialValue;
    }
  }

  Stream<String> get stream => _streamController.stream;

  static int _parseToCents(String s) {
    if (s.isEmpty) {
      return 0;
    }

    List<String> arr = s.split(".");
    int dollars = int.parse(arr[0]);
    int cents;

    if (arr.length == 1) {
      cents = 0;
    } else if (arr[1].length == 1) {
      cents = int.parse(arr[1]) * 10;
    } else {
      cents = int.parse(arr[1]);
    }
    return dollars * 100 + cents;
  }

  static String _formatFromCents(int n) {
    int dollars = n ~/ 100;
    int cents = n % 100;
    return cents > 0 ? "$dollars.$cents" : "$dollars";
  }

  String getBuffer() {
    return _buffer;
  }

  int getValue() {
    return _parseToCents(_buffer);
  }

  // TODO: Split into separate handlers
  void handle(String action) {
    if (!validCalculatorActions.contains(action)) {
      throw 'Invalid action $action';
    }
    int? number = int.tryParse(action);
    if (action == "." || number != null) {
      if (_buffer.length >= 6) {
        return;
      }
      if (_buffer == '0' && action != '.') {
        _buffer = action;
        _streamController.add(_buffer);
        return;
      }
      _buffer += action;
    } else if (action == '+' ||
        action == '-' ||
        action == 'x' ||
        action == '/') {
      _register = _parseToCents(_buffer);
      _buffer = "";
      _operation = action;
    } else if (action == '=') {
      if (_operation == null) {
        return;
      }

      int num1 = _register!;
      int num2 = _parseToCents(_buffer);
      int result;

      if (_operation == '+') {
        result = num1 + num2;
      } else if (_operation == '-') {
        result = num1 - num2;
      } else if (_operation == 'x') {
        result = num1 * num2 ~/ 100;
      } else if (_operation == '/') {
        if (num2 != 0) {
          result = num1 * 100 ~/ num2;
        } else {
          result = 0;
        }
      } else {
        result = 999;
      }

      _buffer = _formatFromCents(result);
    } else if (action == 'B') {
      if (_buffer.length == 1) {
        _buffer = "0";
        _streamController.add(_buffer);
        return;
      }
      _buffer = _buffer.substring(0, _buffer.length - 1);
    }
    _streamController.add(_buffer);
  }
}
