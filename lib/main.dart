// Importa os pacotes necessários
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// Ponto de entrada do aplicativo
void main() {
  runApp(const MyApp());
}

bool _isSwitched = false;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Método para construir o widget principal do aplicativo
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoneApp',
      theme: ThemeData(
        fontFamily: 'RedHatDisplay', // Define a fonte padrão do aplicativo
        iconTheme: IconThemeData(color: Colors.white), // Define o tema do ícone
      ),
      home:
          const MyHomePage(title: ''), // Define a página inicial do aplicativo
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final TabController _tabController;

  final CalendarController _controller = CalendarController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  // Limpa os recursos quando o widget é descartado
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Constrói o layout da página principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(tabController: _tabController),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          TabViewItem(controller: _controller),
          const Center(child: Text("Tarefas vem aqui")),
          const Center(child: Text("Métricas vem aqui")),
          const Center(child: Text("Compartilhar vem aqui")),
        ],
      ),
      endDrawer: CustomDrawer(),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  CustomAppBar({required this.tabController});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 30);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: TabBar(
        controller: tabController,
        tabs: const <Widget>[
          Tab(icon: Icon(Icons.calendar_month_outlined)),
          Tab(icon: Icon(Icons.task_alt_rounded)),
          Tab(icon: Icon(Icons.bar_chart)),
          Tab(icon: Icon(Icons.share)),
        ],
      ),
      backgroundColor: Color.fromRGBO(1, 169, 94, 1),
      leading: Image.asset('assets/avatar.png'),
      toolbarHeight: 70,
      title: Center(
        child: Text(_getTitleBasedOnTab(tabController.index)),
      ),
      iconTheme: IconThemeData(color: Colors.white, size: 40),
    );
  }

  String _getTitleBasedOnTab(int index) {
    switch (index) {
      case 0:
        return 'Agenda';
      case 1:
        return 'Tarefas';
      case 2:
        return 'Métricas';
      case 3:
        return 'Compartilhar';
      default:
        return '';
    }
  }
}

class TabViewItem extends StatelessWidget {
  final CalendarController controller;

  TabViewItem({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.week,
      allowedViews: const [
        CalendarView.day,
        CalendarView.week,
        CalendarView.month,
      ],
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

class CustomSwitch extends StatefulWidget {
  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Switch(
            value: _isSwitched,
            onChanged: (value) {
              setState(() {
                _isSwitched = value;
              });
            },
          ),
          Positioned(
            top: -10, // Adjust this value to move the icon up or down
            left: 18,
            child: Icon(
                _isSwitched
                    ? Icons.nightlight_outlined
                    : Icons.wb_sunny_outlined,
                size: 20,
                color: Colors.white // Adjust this value to change the icon size
                ),
          ),
        ],
      ),
      leading: Icon(
        Icons.format_size,
        color: Colors.white,
        size: 50,
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Color.fromRGBO(1, 169, 94, 1),
        child: Column(children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(10, 45, 10, 0),
              leading: Icon(Icons.menu, size: 40),
              onTap: () {
                Navigator.of(context).pop();
              },
              trailing: SizedBox(
                  width: 120.0,
                  height: 120.0,
                  child: Image.asset("assets/done_logo_white.png")),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Column(children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text("Agenda",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontSize: 20)),
              ),
              ListTile(
                leading: Icon(Icons.task_alt, color: Colors.white, size: 30),
                title: Text("Tarefas",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontSize: 20)),
              ),
              ListTile(
                leading: Icon(Icons.bar_chart_outlined,
                    color: Colors.white, size: 30),
                title: Text("Métricas",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontSize: 20)),
              ),
              ListTile(
                leading: Icon(Icons.share, color: Colors.white, size: 30),
                title: Text("Compartilhar",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontSize: 20)),
              ),
            ]),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                0, MediaQuery.of(context).size.height * .45, 0, 10),
            child: CustomSwitch(),
          ),
        ]));
  }
}

class CalendarDataSourceUtility {
  static _DataSource getCalendarDataSource() {
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

    return _DataSource(appointments);
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(this.source);

  List<Appointment> source;

  @override
  List<dynamic> get appointments => source;
}
