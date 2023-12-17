class NumpadLogic {
  String _buffer = "0";
  int? _register;
  String? _operation;

  int _parseToCents(String s) {
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

  String _formatFromCents(int n) {
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

  void handle(String ch) {
    int? number = int.tryParse(ch);
    if (ch == "." || number != null) {
      if (_buffer.length >= 6) {
        return;
      }
      if (_buffer == '0' && ch != '.') {
        _buffer = ch;
        return;
      }
      _buffer += ch;
    } else if (ch == '+' || ch == '-' || ch == 'x' || ch == '/') {
      _register = _parseToCents(_buffer);
      _buffer = "";
      _operation = ch;
    } else if (ch == '=') {
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
    } else if (ch == 'BS') {
      if (_buffer.length == 1) {
        _buffer = "0";
        return;
      }
      _buffer = _buffer.substring(0, _buffer.length - 1);
    }
  }
}
