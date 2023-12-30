import 'package:intl/intl.dart';

final appMinDate = DateTime(2000);
final appMaxDate = DateTime(2050);

class Period {
  final int value;
  final Duration? duration;

  const Period(this.value, this.duration);

  static const day = Period(0, Duration(days: 1));
  static const week = Period(1, Duration(days: 7));
  static const month = Period(2, null);
  static const year = Period(3, null);
  static const all = Period(4, null);

  static const _customPeriodValue = 5;

  @override
  bool operator ==(other) {
    return other is Period && other.value == value;
  }

  @override
  int get hashCode => value + duration.hashCode;

  static Period custom({required int days}) {
    return Period(_customPeriodValue, Duration(days: days));
  }

  bool isCustom() {
    return value == _customPeriodValue;
  }

  @override
  String toString() {
    switch (this) {
      case Period.day:
        return "Period.day";
      case Period.week:
        return "Period.week";
      case Period.month:
        return "Period.month";
      case Period.year:
        return "Period.year";
      case Period.all:
        return "Period.all";
      default:
        assert(isCustom());
        return "Period.custom(days: ${duration!.inDays})";
    }
  }

  DateTime coerceDate(DateTime date) {
    switch (this) {
      case Period.day:
        return coerceToDay(date);
      case Period.week:
        return coerceToWeek(date);
      case Period.month:
        return coerceToMonth(date);
      case Period.year:
        return coerceToYear(date);
      default:
        return coerceToDay(date);
    }
  }

  DateTime incrementDate(DateTime date, [int amount = 1]) {
    if (duration != null) {
      return date.add(duration! * amount);
    }
    switch (this) {
      case Period.month:
        return incrementMonth(date, amount);
      case Period.year:
        return incrementYear(date, amount);
      default:
        assert(false);
        return date;
    }
  }

  int countPeriods(DateTime targetDate, DateTime baseDate) {
    if (this == Period.all) {
      return 0;
    }
    int i = 0;
    DateTime date = coerceDate(baseDate);
    date = incrementDate(date);
    while (true) {
      if (date.isAfter(targetDate)) {
        break;
      }
      date = incrementDate(date);
      i++;
    }
    return i;
  }

  String formatDateRange(DateTime startDate, DateTime endDate) {
    switch (this) {
      case Period.day:
        String output = DateFormat('d MMMM').format(startDate);
        if (shouldShowYear(startDate)) {
          output += " ${DateFormat('y').format(startDate)}";
        }
        return output;

      case Period.year:
        return DateFormat('y').format(startDate);

      case Period.month:
        String output = DateFormat('MMMM').format(startDate);
        if (shouldShowYear(startDate)) {
          output += " ${DateFormat('y').format(startDate)}";
        }
        return output;

      default:
        if (startDate.year != endDate.year) {
          DateFormat fmt = DateFormat('d MMM y');
          return "${fmt.format(startDate)} - ${fmt.format(endDate)}";
        }

        String output = "";
        if (startDate.month == endDate.month) {
          DateFormat day = DateFormat('d');
          output +=
              "${day.format(startDate)} - ${day.format(endDate)} ${DateFormat('MMM').format(startDate)}";
        } else if (startDate.year == endDate.year) {
          DateFormat fmt = DateFormat('d MMM');
          output += "${fmt.format(startDate)} - ${fmt.format(endDate)}";
        }
        if (shouldShowYear(startDate)) {
          output += " ${DateFormat('y').format(startDate)}";
        }
        return output;
    }
  }
}

DateTime coerceToYear(DateTime date) {
  return coerceToDay(date.copyWith(day: 1, month: 1));
}

DateTime coerceToMonth(DateTime date) {
  return coerceToDay(date.copyWith(day: 1));
}

DateTime coerceToWeek(DateTime date) {
  int newDay = date.day ~/ 7 * 7;
  return coerceToDay(date.copyWith(day: newDay));
}

DateTime coerceToDay(DateTime date) {
  return date.copyWith(
    microsecond: 0,
    millisecond: 0,
    second: 0,
    minute: 0,
    hour: 0,
  );
}

DateTime incrementYear(DateTime date, [int amount = 1]) {
  int newYear = date.year + amount;
  return date.copyWith(year: newYear);
}

DateTime incrementMonth(DateTime date, [int amount = 1]) {
  int nMonths = date.month + amount;
  var nYearsOverflow = (nMonths - 1) ~/ 12;
  var newMonth = (nMonths - 1) % 12 + 1;
  return incrementYear(date.copyWith(month: newMonth), nYearsOverflow);
}

DateTime incrementWeek(DateTime date, [int amount = 1]) {
  return date.add(Duration(days: 7 * amount));
}

DateTime incrementDay(DateTime date, [int amount = 1]) {
  return date.add(Duration(days: amount));
}

DateTime maxForDates(DateTime date1, DateTime date2) {
  return date1.isAfter(date2) ? date1 : date2;
}

bool shouldShowYear(date) {
  if (date.year > DateTime.now().year) {
    return true;
  }
  return !date.add(Duration(days: 365)).isAfter(DateTime.now());
}

String dateTimeToStringShort(DateTime dt) {
  return DateFormat('d MMM').format(dt);
}

String dateTimeToStringLong(DateTime dt) {
  return DateFormat('E, d MMM y').format(dt);
}

String formatDate(DateTime date) {
  String output = DateFormat('d MMMM').format(date);
  if (shouldShowYear(date)) {
    output += " ${DateFormat('y').format(date)}";
  }
  return output;
}
