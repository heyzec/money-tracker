// ignore: non_constant_identifier_names
final MIN_DATE = DateTime(2000);
// ignore: non_constant_identifier_names
final MAX_DATE = DateTime(2050);

enum Period {
  day(0),
  week(1),
  month(2),
  year(3),
  all(4),
  interval(-1);

  const Period(this.value);

  final int value;

  bool isSmallerThan(Period other) {
    assert(this != Period.interval && other != Period.interval);
    return value < other.value;
  }
}

var dayOfWeekLookup = {
  1: "Mon",
  2: "Tue",
  3: "Wed",
  4: "Thu",
  5: "Fri",
  6: "Sat",
  7: "Sun",
};

var monthLookup = {
  1: "Jan",
  2: "Feb",
  3: "Mar",
  4: "Apr",
  5: "May",
  6: "June",
  7: "Jul",
  8: "Aug",
  9: "Sep",
  10: "Oct",
  11: "Nov",
  12: "Dec",
};

String dateTimeToStringShort(DateTime dt) {
  return "${dt.day.toString().padLeft(2, '0')} ${monthLookup[dt.month]}";
}

String dateTimeToStringLong(DateTime dt) {
  return "${dayOfWeekLookup[dt.weekday]}, ${dt.day.toString().padLeft(2, '0')} ${monthLookup[dt.month]} ${dt.year.toString()}";
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

DateTime coerceByPeriod(DateTime date, Period period) {
  switch (period) {
    case Period.week:
      return coerceToWeek(date);
    case Period.month:
      return coerceToMonth(date);
    case Period.year:
      return coerceToYear(date);
    default:
      return date;
  }
}

DateTime incrementYear(DateTime date) {
  int newYear = date.year + 1;
  return date.copyWith(year: newYear);
}

DateTime decrementYear(DateTime date) {
  int newYear = date.year - 1;
  return date.copyWith(year: newYear);
}

DateTime incrementMonth(DateTime date) {
  int newMonth = date.month + 1;
  if (newMonth > 12) {
    date = incrementYear(date);
    newMonth %= 12;
  }
  return date.copyWith(month: newMonth);
}

DateTime decrementMonth(DateTime date) {
  int newMonth = date.month - 1;
  if (newMonth < 1) {
    date = decrementYear(date);
    newMonth %= 12;
  }
  return date.copyWith(month: newMonth);
}

DateTime incrementWeek(DateTime date) {
  return date.add(Duration(days: 7));
}

DateTime decrementWeek(DateTime date) {
  return date.subtract(Duration(days: 7));
}

DateTime incrementDay(DateTime date) {
  return date.add(Duration(days: 1));
}

DateTime decrementDay(DateTime date) {
  return date.subtract(Duration(days: 1));
}

DateTime incrementByPeriod(DateTime date, Period period) {
  assert(period != Period.all && period != Period.interval);
  switch (period) {
    case Period.day:
      return incrementDay(date);
    case Period.week:
      return incrementWeek(date);
    case Period.month:
      return incrementMonth(date);
    case Period.year:
      return incrementYear(date);
    default:
      return date;
  }
}

DateTime decrementByPeriod(DateTime date, Period period) {
  assert(period != Period.all && period != Period.interval);
  switch (period) {
    case Period.day:
      return decrementDay(date);
    case Period.week:
      return decrementWeek(date);
    case Period.month:
      return decrementMonth(date);
    case Period.year:
      return decrementYear(date);
    default:
      return date;
  }
}
