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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoneApp',
      theme: ThemeData(
          fontFamily: 'RedHatDisplay',
          iconTheme: IconThemeData(color: Colors.white)),
      home: const MyHomePage(title: ''),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          tabController: _tabController, selectedIndex: _selectedIndex),
      bottomNavigationBar:  SizedBox(
    height: 58,
    child:TabBar(
        controller: _tabController,
        tabs: const <Widget>[
          Tab(icon: Icon(Icons.calendar_month_outlined, color: Colors.green,)),
          Tab(icon: Icon(Icons.task_alt_rounded, color: Colors.green)),
          Tab(icon: Icon(Icons.bar_chart, color: Colors.green)),
          Tab(icon: Icon(Icons.share, color: Colors.green)),
        ],
      )),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          TabViewItem(controller: _controller),
          const Center(child: Text("Tarefas vem aqui")),
          const Center(child: Text("Métricas vem aqui")),
          const Center(child: Text("Compartilhar vem aqui")),
        ],
      ),
      endDrawer: Drawer(tabController: _tabController),
      floatingActionButton:
          _tabController.index == 0 || _tabController.index == 1
              ? FloatingActionButton(
            onPressed: _showAddAppointmentDialog,
            backgroundColor: Colors.green,
            child: const Icon(Icons.add),
          )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Color.fromRGBO(1, 169, 94, 1),
        leading: Image.asset('assets/avatar.png'),
        toolbarHeight: 70,
        title: Center(
          child: Text(_getTitleBasedOnTab(_tabController.index)),
        ),
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

      backgroundColor: const Color.fromRGBO(1, 169, 94, 1),
      leading: Image.asset('assets/avatar.png'),
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
