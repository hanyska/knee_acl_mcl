import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/helpers/date_time_helper.dart';
import 'package:knee_acl_mcl/main/app_bar.dart';
import 'package:knee_acl_mcl/utils/utils.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  static const routeName = '/progress';

  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final ValueNotifier<List<Event>> _selectedEvents = ValueNotifier([]);

  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  DateTime _focusedDay = DateTime.now();

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForDays(Set<DateTime> days) {
    // Implementation example
    // Note that days are in selection order (same applies to events)
    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      // Update values in a Set
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }
    });

    _selectedEvents.value = _getEventsForDays(_selectedDays);
  }

  Widget _progressDayWidget(DateTime date, [dynamic event] ) {
    return Container(
      color: Colors.white,
      child: CircularPercentIndicator(
        radius: 50.0,
        lineWidth: 5.0,
        animation: true,
        percent: event/100,
        center: Text(
          date.day.toString(),
          style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: DateTimeHelper.isTheSameDateWithoutHours(date, DateTime.now()) ? kPrimaryColor : Colors.black
          ),
        ),
        backgroundColor: Colors.grey,
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double percent = 20.0;

    return Scaffold(
      appBar: myAppBar(title: 'Progress'),
      body: Column(
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(8.0),
            child: TableCalendar<Event>(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,

               headerStyle: HeaderStyle(
                 formatButtonVisible: false,
                 titleCentered: true,
                 decoration: BoxDecoration(color: kPrimaryColor,),
                 titleTextStyle: TextStyle(color: kWhite, fontSize: 18.0),
                 leftChevronIcon: Icon(Icons.chevron_left, color: kWhite,),
                 rightChevronIcon: Icon(Icons.chevron_right, color: kWhite,),
                 headerMargin: EdgeInsets.only(bottom: 10.0)
               ),
              calendarStyle: CalendarStyle(outsideDaysVisible: false),
              rowHeight: 60.0,
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, events) => _progressDayWidget(date, 50),
                // selectedBuilder: (context, date, events) => _progressDayWidget(date, 10),
                todayBuilder: (context, date, events) => _progressDayWidget(date, 100),
                markerBuilder: (context, date, events) => SizedBox()
              ),

              selectedDayPredicate: (day) {
                // Use values from Set to mark multiple days as selected
                return _selectedDays.contains(day);
              },
              onDaySelected: _onDaySelected,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),
          ElevatedButton(
            child: Text('Clear selection'),
            onPressed: () {
              setState(() {
                _selectedDays.clear();
                _selectedEvents.value = [];
              });
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}


class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
  ..addAll({
    kToday: [
      Event('Today\'s Event 1'),
      Event('Today\'s Event 2'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
