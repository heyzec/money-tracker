import 'package:flutter/material.dart';
import 'package:namer_app/utils/dates.dart';

class Sidebar extends StatelessWidget {
  final Period selected;
  final Function(Period, [dynamic dates]) callback;

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

    return Drawer(
      child: ListView(
        children: [
          ListTile(title: createButton("Day", Period.day)),
          ListTile(title: createButton("Week", Period.week)),
          ListTile(title: createButton("Month", Period.month)),
          ListTile(title: createButton("Year", Period.year)),
          ListTile(title: createButton("All", Period.all)),
          ListTile(
            title: SidebarButton(
              text: "Interval",
              isFilled: selected == Period.interval,
              onPressed: () async {
                DateTimeRange? dateRange = await showDateRangePicker(
                  context: context,
                  firstDate: appMinDate,
                  lastDate: appMaxDate,
                );
                callback(Period.interval, dateRange);
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
                callback(Period.day, date);
              },
            ),
          ),
        ],
      ),
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
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
      child: Text(text),
      onPressed: onPressed,
    );
  }
}
