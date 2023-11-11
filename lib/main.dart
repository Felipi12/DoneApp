import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

bool _isSwitched = false;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoneApp',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.

          // useMaterial3: true,
          fontFamily: 'RedHatDisplay',
          // canvasColor: Color.fromRGBO(1, 169, 94, 1),
          iconTheme: IconThemeData(color: Colors.white)),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.calendar_month_outlined),
            ),
            Tab(
              icon: Icon(Icons.task_alt_rounded),
            ),
            Tab(
              icon: Icon(Icons.bar_chart),
            ),
            Tab(
              icon: Icon(Icons.share),
            ),
          ],
        ),

        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Color.fromRGBO(1, 169, 94, 1),
        leading: Image.asset('assets/avatar.png'),

        toolbarHeight: 70,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(
          child: Text(_getTitleBasedOnTab(_tabController.index)),
        ),
        //widget.title
        iconTheme: IconThemeData(color: Colors.white, size: 40),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          Center(
            child: Text("Eventos vem aqui"),
          ),
          Center(
            child: Text("Tarefas vem aqui"),
          ),
          Center(
            child: Text("Métricas vem aqui"),
          ),
          Center(
            child: Text("Compartilhar vem aqui"),
          ),
        ],
      ),

      endDrawer: Drawer(
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
                    width: 120.0, // Set this width
                    height: 120.0, // Set this height
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
              child: ListTile(
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
                          color: Colors
                              .white // Adjust this value to change the icon size
                          ),
                    ),
                  ],
                ),
                leading: Icon(
                  Icons.format_size,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ])),
      // This trailing comma makes auto-formatting nicer for build methods.
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
