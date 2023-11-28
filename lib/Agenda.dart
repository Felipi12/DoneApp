// Importa os pacotes necessários
import 'package:doneapp/clients/controllers/appointments_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'clients/entities/appointment_entity.dart';

// Constrói o calendário da tela de Agenda
class TabViewItem_1 extends StatelessWidget {
  final CalendarController controller;

  const TabViewItem_1({super.key, required this.controller});

  Widget build(context) {
    return FutureBuilder<DataSource>(
        future: CalendarDataSourceUtility.getCalendarDataSource(),
        builder: (context, AsyncSnapshot<DataSource> snapshot) {
          if (snapshot.hasData) {
            return SfCalendar(
              selectionDecoration: BoxDecoration(color: Colors.grey[100]),
              todayHighlightColor: Color.fromRGBO(1, 169, 94, 1),
              viewHeaderStyle: ViewHeaderStyle(
                  dateTextStyle: TextStyle(fontFamily: 'Roboto')),
              todayTextStyle: TextStyle(fontFamily: 'Roboto'),
              appointmentTextStyle:
                  TextStyle(color: Colors.white, fontFamily: 'Roboto'),
              showNavigationArrow: true,
              showCurrentTimeIndicator: true,
              headerStyle: CalendarHeaderStyle(
                  textStyle: TextStyle(fontFamily: 'Roboto')),
              view: CalendarView.week,
              allowedViews: const [
                CalendarView.day,
                CalendarView.week,
                CalendarView.month,
              ],
              cellEndPadding: 0,
              controller: controller,
              initialDisplayDate: DateTime.now(),
              dataSource: snapshot.data,
              onTap: calendarTapped,
              monthViewSettings: const MonthViewSettings(
                  navigationDirection: MonthNavigationDirection.vertical),
            );
            ;
          } else {
            return CircularProgressIndicator();
          }
        });
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
    final List<Appointment> appointments = <Appointment>[];

    AppointmentsController appCtrl = new AppointmentsController();

    List<AppointmentEntity> appEnt = await appCtrl.getAll();

    appEnt.map((e) => {
          appointments.add(Appointment(
            startTime: e.startTime.toDate(),
            endTime: e.endTime.toDate(),
            subject: e.description,
          ))
        });

    return DataSource(appointments);
  }
}

class DataSource extends CalendarDataSource {
  DataSource(this.source);

  List<Appointment> source;

  @override
  List<dynamic> get appointments => source;
}
