import 'package:doneapp/clients/controllers/appointments_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'clients/entities/appointment_entity.dart';

// Constrói o calendário da tela de Agenda

class TabViewItem_1 extends StatefulWidget {
  late final CalendarController controller;

  TabViewItem_1({required this.controller});


  @override
  _TabViewState createState() => _TabViewState(controller:controller);
}

class _TabViewState extends State<TabViewItem_1> {
  final CalendarController controller;

  DataSource appointments = DataSource([]);


  _TabViewState({required this.controller});

  @override
  void initState() {

    CalendarDataSourceUtility.getCalendarDataSource().then((value){
      setState(() {
        print(value);
        appointments = value;
      });
    });

    super.initState();
  }


  Widget build(BuildContext context) {
    return SfCalendar(
      selectionDecoration: BoxDecoration(color: Colors.grey[100]),
      todayHighlightColor: Color.fromRGBO(1, 169, 94, 1),
      viewHeaderStyle:
      ViewHeaderStyle(dateTextStyle: TextStyle(fontFamily: 'Roboto')),
      todayTextStyle: TextStyle(fontFamily: 'Roboto'),
      appointmentTextStyle:
      TextStyle(color: Colors.white, fontFamily: 'Roboto'),
      showNavigationArrow: true,
      showCurrentTimeIndicator: true,
      headerStyle:
      CalendarHeaderStyle(textStyle: TextStyle(fontFamily: 'Roboto')),
      view: CalendarView.week,
      allowedViews: const [
        CalendarView.day,
        CalendarView.week,
        CalendarView.month,
      ],
      cellEndPadding: 0,
      controller: controller,
      initialDisplayDate: DateTime.now(),
      dataSource: appointments,
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

// MOCK DE DADOS
class CalendarDataSourceUtility {
  static Future<DataSource> getCalendarDataSource() async {
    AppointmentsController appCtrl = new AppointmentsController();

    List<AppointmentEntity> appEnt = await appCtrl.getAll();
    print("data utility");
    print(appEnt);

    List<Appointment> mappedAppointments =
    appEnt.map
      ((e) {
      return Appointment(
        startTime: e.startTime.toDate(),
        endTime: e.endTime.toDate(),
        subject: e.description,
      );
    }).toList();

    print(mappedAppointments);

    return DataSource(mappedAppointments);
  }
}

class DataSource extends CalendarDataSource {
  DataSource(this.source);

  List<Appointment> source;

  @override
  List<dynamic> get appointments => source;
}