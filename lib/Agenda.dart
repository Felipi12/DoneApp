// Importa os pacotes necessários
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'AppBar.dart';

// Constrói o calendário da tela de Agenda
class TabViewItem_1 extends StatelessWidget {
  final CalendarController controller;

  const TabViewItem_1({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      viewHeaderStyle:
          ViewHeaderStyle(dateTextStyle: TextStyle(fontFamily: 'Roboto')),
      todayTextStyle: TextStyle(fontFamily: 'RedHatDisplay'),
      appointmentTextStyle:
          TextStyle(color: Colors.white, fontFamily: 'Roboto'),
      showNavigationArrow: true,
      showCurrentTimeIndicator: true,
      headerStyle:
          CalendarHeaderStyle(textStyle: TextStyle(fontFamily: 'Roboto')),
      view: CalendarView.week,
      showWeekNumber: true,
      weekNumberStyle: const WeekNumberStyle(
        backgroundColor: Colors.grey,
        textStyle: TextStyle(color: Colors.black, fontSize: 13),
      ),
      allowedViews: const [
        CalendarView.day,
        CalendarView.week,
        CalendarView.month,
      ],
      cellEndPadding: 0,
      controller: controller,
      initialDisplayDate: DateTime.now(),
      dataSource: CalendarDataSourceUtility.getCalendarDataSource(),
      onTap: calendarTapped,
      monthViewSettings: const MonthViewSettings(
          navigationDirection: MonthNavigationDirection.vertical),
    );
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (controller.view == CalendarView.month &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      controller.view = CalendarView.day;
    } else if ((controller.view == CalendarView.week ||
            controller.view == CalendarView.workWeek) &&
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      controller.view = CalendarView.day;
    }
  }
}

class CalendarDataSourceUtility {
  static DataSource getCalendarDataSource() {
    final List<Appointment> appointments = <Appointment>[];
    appointments.add(Appointment(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 1)),
      subject: 'Meeting',
      color: Colors.pink,
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 4)),
      endTime: DateTime.now().add(const Duration(hours: 5)),
      subject: 'Release Meeting',
      color: Colors.lightBlueAccent,
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 6)),
      endTime: DateTime.now().add(const Duration(hours: 7)),
      subject: 'Performance check',
      color: Colors.amber,
    ));
    appointments.add(Appointment(
      startTime: DateTime(2023, 11, 22, 1, 0, 0),
      endTime: DateTime(2023, 11, 22, 3, 0, 0),
      subject: 'Support',
      color: Colors.green,
    ));
    appointments.add(Appointment(
      startTime: DateTime(2023, 11, 24, 3, 0, 0),
      endTime: DateTime(2023, 11, 24, 4, 0, 0),
      subject: 'Retrospective',
      color: Colors.purple,
    ));

    return DataSource(appointments);
  }
}

class DataSource extends CalendarDataSource {
  DataSource(this.source);

  List<Appointment> source;

  @override
  List<dynamic> get appointments => source;
}
