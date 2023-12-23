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
