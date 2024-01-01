import 'package:flutter/material.dart';
import 'package:namer_app/utils/dates.dart';

class Sidebar extends StatelessWidget {
  final Period selected;
  final Function(Period, [DateTime? dates]) callback;

  Sidebar(this.selected, this.callback);

  @override
  Widget build(BuildContext context) {
    Widget createButton(String text, Period period) {
      return SidebarButton(
        text: text,
        isFilled: (selected == period),
        onPressed: () {
          callback(period);
        },
      );
    }

    return ListView(
      children: [
        ListTile(title: createButton("Day", Period.day)),
        ListTile(title: createButton("Week", Period.week)),
        ListTile(title: createButton("Month", Period.month)),
        ListTile(title: createButton("Year", Period.year)),
        ListTile(title: createButton("All", Period.all)),
        ListTile(
          title: SidebarButton(
            text: "Interval",
            isFilled: selected.isCustom(),
            onPressed: () async {
              DateTimeRange? dateRange = await showDateRangePicker(
                context: context,
                firstDate: appMinDate,
                lastDate: appMaxDate,
              );
              if (dateRange == null) {
                return;
              }
              callback(
                Period.custom(days: dateRange.duration.inDays),
                dateRange.start,
              );
            },
          ),
        ),
        ListTile(
          title: SidebarButton(
            text: "Choose date",
            isFilled: false,
            onPressed: () async {
              DateTime? date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: appMinDate,
                lastDate: appMaxDate,
              );
              if (date == null) {
                return;
              }
              callback(Period.day, date);
            },
          ),
        ),
      ],
    );
  }
}

class SidebarButton extends StatelessWidget {
  final String text;
  final bool isFilled;
  final VoidCallback onPressed;

  SidebarButton({
    required this.text,
    required this.isFilled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    Function ButtonType = (isFilled) ? FilledButton.new : OutlinedButton.new;
    return ButtonType(
      // style: appRoundedButtonStyle,
      child: Text(text),
      onPressed: onPressed,
    );
  }
}
