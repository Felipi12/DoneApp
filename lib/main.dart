// Importa os pacotes necessários
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doneapp/Share.dart';
import 'package:doneapp/toDo.dart';
import 'package:doneapp/clients/controllers/appointments_controller.dart';
import 'package:doneapp/clients/entities/appointment_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'Agenda.dart';
import 'LoginScreen.dart';
import 'Profile_Screen.dart';
import 'Métricas.dart';
import 'AppBar.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.green[1000],
  scaffoldBackgroundColor: Colors.black,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.green[900]),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.green),
  ),
  iconTheme: IconThemeData(
    color: Colors.green[1000],
  ),
);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color.fromRGBO(1, 169, 94, 1),
  scaffoldBackgroundColor: Colors.white,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.green[900]),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.green),
  ),
  iconTheme: IconThemeData(
    color: Color.fromRGBO(1, 169, 94, 1),
  ),
);

class SplashScreenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      title: 'Splash Screen',
      home: HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}




class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 2),
        () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => LoginScreen(),
                transitionDuration: Duration(seconds: 1),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(1, 169, 94, 1),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(children: <Widget>[
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Opacity(
                    opacity: 0.25,
                    child: Image.asset("assets/check.png", height: 200),
                  )),
              Column(children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(
                        bottom: 50, left: 50, right: 50, top: 300),
                    child: Image.asset("assets/done_logo_white.png")),
                Padding(
                    padding: const EdgeInsets.only(
                        bottom: 50, left: 10, right: 10, top: 30),
                    child: Text(
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'RedHatDisplay'),
                        "New Tasks, Job #Done")),
              ])
            ])));
  }
}

class OtherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyApp();
  }
}

// Ponto de entrada do aplicativo
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(SplashScreenApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Método para construir o widget principal do aplicativo
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoneApp',
      theme: lightTheme,
      darkTheme: darkTheme,
      home:
          const MyHomePage(title: ''), // Define a página inicial do aplicativo
      supportedLocales: [Locale('pt', 'BR')], // Include Portuguese (Brazil)
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations
            .delegate, // Important for iOS style widgets
      ],
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
      bottomNavigationBar: TabBar(
        indicatorColor: Color.fromRGBO(1, 169, 94, 1),
        labelColor: Color.fromRGBO(1, 169, 94, 1),
        labelStyle:
            TextStyle(fontFamily: 'Roboto', color: Colors.white, fontSize: 12),
        physics: BouncingScrollPhysics(),
        unselectedLabelColor: Colors.grey[400],
        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(20), // Creates border
            color: Colors.grey[100]),
        controller: _tabController,
        tabs: const <Widget>[
          Tab(
              text: "Agenda",
              icon: Icon(Icons.calendar_month_outlined,
                  color: Color.fromRGBO(1, 169, 94, 1))),
          Tab(
              text: "Tarefas",
              icon: Icon(Icons.task_alt_rounded,
                  color: Color.fromRGBO(1, 169, 94, 1))),
          Tab(
              text: "Métricas",
              icon:
                  Icon(Icons.bar_chart, color: Color.fromRGBO(1, 169, 94, 1))),
          Tab(
              text: "Share",
              icon: Icon(Icons.share, color: Color.fromRGBO(1, 169, 94, 1))),
        ],
      ),
      appBar: CustomAppBar(
          tabController: _tabController, selectedIndex: _selectedIndex),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          TabViewItem_1(controller: _controller),
          ToDoList(),
          MetricsTab(),
          ShareScreen(),
        ],
      ),
      endDrawer: CustomDrawer(tabController: _tabController),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 92.0),
        child: Align(
            alignment: Alignment.bottomCenter,
            child: _tabController.index == 0
                ? AnimatedOpacity(
                    // If the widget is visible, animate to 0.0 (invisible).
                    // If the widget is hidden, animate to 1.0 (fully visible).
                    opacity: _tabController.index < 1 ? 1.0 : 0.0,
                    duration: Duration(seconds: 1),
                    // The green box must be a child of the AnimatedOpacity widget.
                    child: FloatingActionButton(
                      elevation: 0.5,
                      tooltip: "Adicionar",
                      onPressed: _showAddAppointmentDialog,
                      backgroundColor: Color.fromRGBO(1, 169, 94, 1),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  )
                : null),
      ),
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
    Color selectedColor = Color.fromRGBO(255, 234, 142, 1.0);

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
        barrierColor: Color.fromRGBO(0, 0, 0, 0.25),
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
          title: const Text('Novo Compromisso',
              style: TextStyle(fontFamily: 'Roboto', fontSize: 18)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  style: TextStyle(fontFamily: 'Roboto'),
                  controller: subjectController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.subject),
                    labelText: 'Assunto',
                    labelStyle: TextStyle(fontFamily: 'Roboto'),
                  ),
                ),
                TextFormField(
                  style: TextStyle(fontFamily: 'Roboto'),
                  controller: dateController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: 'Data',
                    labelStyle: TextStyle(fontFamily: 'Roboto'),
                  ),
                  onTap: () => _selectDate(context),
                  readOnly: true,
                ),
                TextFormField(
                  style: TextStyle(fontFamily: 'Roboto'),
                  controller: timeController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.access_time),
                    labelText: 'Hora',
                    labelStyle: TextStyle(fontFamily: 'Roboto'),
                  ),
                  onTap: () => _selectTime(context),
                  readOnly: true,
                ),
                // TODO: Aqui você adicionaria widgets para seleção de dias de repetição
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: TextField(
                    style: TextStyle(fontFamily: 'Roboto'),
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      labelStyle: TextStyle(fontFamily: 'Roboto'),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ),
                // TODO: Aqui você adicionaria o seletor de cor
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'CANCELAR',
                style: TextStyle(color: Colors.red, fontFamily: 'Roboto'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // TODO: Aqui, você coletaria todas as informações dos campos
                AppointmentsController().create(AppointmentEntity(startTime: _updateDateField, endTime: endTime, color: color, description: subjectController.text))
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

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({super.key});

  @override
  CustomSwitchState createState() => CustomSwitchState();
}

class CustomSwitchState extends State<CustomSwitch> {
  bool _isSwitched = false;
  int actualTheme = 0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Switch(
            trackOutlineColor: MaterialStateProperty.resolveWith(
              (final Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return null;
                }

                return Colors.transparent;
              },
            ),
            activeTrackColor: Colors.grey,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
            activeColor: Colors.white,
            value: _isSwitched,
            onChanged: (value) {
              actualTheme=1;
              setState(() {
                _isSwitched = value;
              });
            },
          ),
          Positioned(
            top: -20,
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
        size: 40,
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
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(10, 34, 10, 0),
              leading: const Icon(Icons.menu, size: 45),
              onTap: () {
                Navigator.of(context).pop();
              },
              trailing: SizedBox(
                width: 110.0,
                height: 120.0,
                child: Image.asset("assets/done_logo_white.png"),
              ),
            ),
          ),
          SizedBox(height: 60), // Added SizedBox for padding
          ListTile(
            leading: const Icon(
              Icons.calendar_month_outlined,
              color: Colors.white,
              size: 32,
            ),
            title: const Text("Agenda",
                style: TextStyle(
                    fontFamily: 'Roboto', color: Colors.white, fontSize: 16)),
            onTap: () {
              Navigator.of(context).pop();
              tabController.animateTo(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.task_alt, color: Colors.white, size: 32),
            title: const Text("Tarefas",
                style: TextStyle(
                    fontFamily: 'Roboto', color: Colors.white, fontSize: 16)),
            onTap: () {
              Navigator.of(context).pop();
              tabController.animateTo(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart_outlined,
                color: Colors.white, size: 32),
            title: const Text("Métricas",
                style: TextStyle(
                    fontFamily: 'Roboto', color: Colors.white, fontSize: 16)),
            onTap: () {
              Navigator.of(context).pop();
              tabController.animateTo(2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.share, color: Colors.white, size: 32),
            title: const Text("Compartilhar",
                style: TextStyle(
                    fontFamily: 'Roboto', color: Colors.white, fontSize: 16)),
            onTap: () {
              Navigator.of(context).pop();
              tabController.animateTo(3);
            },
          ),
          // Use another flexible space below the menu items to keep them centered.
          Spacer(),
          // This will be pushed to the bottom by the Spacers.
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 15,
              ),
              child: const CustomSwitch(),
            ),
          ),
        ],
      ),
    );
  }
}
