// Importa os pacotes necessários
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doneapp/clients/controllers/appointments_controller.dart';
import 'package:doneapp/clients/entities/appointment_entity.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

// Ponto de entrada do aplicativo
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Método para construir o widget principal do aplicativo
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoneApp',
      theme: ThemeData(
        fontFamily: 'RedHatDisplay', // Define a fonte padrão do aplicativo
        iconTheme:
            const IconThemeData(color: Colors.white), // Define o tema do ícone
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
  int _selectedIndex = 0; // Variável para rastrear o índice da aba selecionada

  final CalendarController _controller = CalendarController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_selectedIndex != _tabController.index) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
  }

  // Limpa os recursos quando o widget é descartado
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Constrói o layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          tabController: _tabController, selectedIndex: _selectedIndex),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          TabViewItem(controller: _controller),
          const Center(child: Text("Tarefas vem aqui")),
          const Center(child: Text("Métricas vem aqui")),
          const Center(child: Text("Compartilhar vem aqui")),
        ],
      ),
      endDrawer: CustomDrawer(tabController: _tabController),
      floatingActionButton:
          _tabController.index == 0 || _tabController.index == 1
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton(
                      onPressed: _showAddAppointmentDialog,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.add),
                    ),
                  ),
                )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _showAddAppointmentDialog() {
    TextEditingController subjectController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    DateTime? selectedDate = DateTime.now();
    TimeOfDay? selectedTime = TimeOfDay.now();
    List<String> repeatDays = [];
    Color selectedColor = Colors.blue;

    // Atualiza o controlador de data
    void _updateDateField(DateTime selectedDate) {
      dateController.text =
          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
    }

    // Atualiza o controlador de hora
    void _updateTimeField(TimeOfDay selectedTime) {
      timeController.text = selectedTime.format(context);
    }

    // Função para escolher e atualizar a data
    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate!,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null && picked != selectedDate) {
        selectedDate = picked;
        _updateDateField(picked);
      }
    }

    // Função para escolher e atualizar a hora
    Future<void> _selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime!,
      );
      if (picked != null && picked != selectedTime) {
        selectedTime = picked;
        _updateTimeField(picked);
      }
    }

    // Exibe o diálogo para adicionar um novo compromisso
    showDialog(
      context: context,
      barrierDismissible: false, // Usuário deve tocar no botão para fechar
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Novo Compromisso'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: subjectController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.subject),
                    labelText: 'Assunto',
                  ),
                ),
                TextFormField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: 'Data',
                  ),
                  onTap: () => _selectDate(context),
                  readOnly: true,
                ),
                TextFormField(
                  controller: timeController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.access_time),
                    labelText: 'Hora',
                  ),
                  onTap: () => _selectTime(context),
                  readOnly: true,
                ),
                // TODO: Aqui você adicionaria widgets para seleção de dias de repetição
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                // TODO: Aqui você adicionaria o seletor de cor
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCELAR'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // TODO: Aqui, você coletaria todas as informações dos campos
                // e as adicionaria à fonte de dados do seu calendário.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Constrói o Appbar/Navbar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  final int selectedIndex;

  const CustomAppBar(
      {super.key, required this.tabController, required this.selectedIndex});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 30);

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
      backgroundColor: const Color.fromRGBO(1, 169, 94, 1),
      leading: Image.asset('assets/avatar.png'),
      toolbarHeight: 70,
      title: Center(
        child: Text(_getTitleBasedOnTab(selectedIndex)),
      ),
      iconTheme: const IconThemeData(color: Colors.white, size: 40),
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

// Constrói o calendário da tela de Agenda
class TabViewItem extends StatelessWidget {
  final CalendarController controller;

  const TabViewItem({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.day,
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
  const CustomSwitch({super.key});

  @override
  CustomSwitchState createState() => CustomSwitchState();
}

class CustomSwitchState extends State<CustomSwitch> {
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
            top: -10,
            left: 18,
            child: Icon(
                _isSwitched
                    ? Icons.nightlight_outlined
                    : Icons.wb_sunny_outlined,
                size: 20,
                color: Colors.white),
          ),
        ],
      ),
      leading: const Icon(
        Icons.format_size,
        color: Colors.white,
        size: 50,
      ),
    );
  }
}

// Constrói o Drawer/Sidebar
class CustomDrawer extends StatelessWidget {
  final TabController tabController;

  const CustomDrawer({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromRGBO(1, 169, 94, 1),
      child: Column(children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: ListTile(
            contentPadding: const EdgeInsets.fromLTRB(10, 34, 10, 0),
            leading: const Icon(Icons.menu, size: 40),
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
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Column(children: <Widget>[
            ListTile(
              leading: const Icon(
                Icons.calendar_month_outlined,
                color: Colors.white,
                size: 30,
              ),
              title: const Text("Agenda",
                  style: TextStyle(
                      fontFamily: 'Roboto', color: Colors.white, fontSize: 20)),
              onTap: () {
                Navigator.of(context).pop();
                tabController.animateTo(0);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.task_alt, color: Colors.white, size: 30),
              title: const Text("Tarefas",
                  style: TextStyle(
                      fontFamily: 'Roboto', color: Colors.white, fontSize: 20)),
              onTap: () {
                Navigator.of(context).pop();
                tabController.animateTo(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart_outlined,
                  color: Colors.white, size: 30),
              title: const Text("Métricas",
                  style: TextStyle(
                      fontFamily: 'Roboto', color: Colors.white, fontSize: 20)),
              onTap: () {
                Navigator.of(context).pop();
                tabController.animateTo(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.white, size: 30),
              title: const Text("Compartilhar",
                  style: TextStyle(
                      fontFamily: 'Roboto', color: Colors.white, fontSize: 20)),
              onTap: () {
                Navigator.of(context).pop();
                tabController.animateTo(3);
              },
            ),
          ]),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              0, MediaQuery.of(context).size.height * .45, 0, 10),
          child: const CustomSwitch(),
        ),
      ]),
    );
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
