import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'cocogroose'),
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ],
    supportedLocales: [const Locale('pt', 'BR')],
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _toDoController = TextEditingController();

  List _toDoList = [];
  late Map<String, dynamic> _lastRemoved;
  late int _lastRemovedPosition;

  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        _toDoList = json.decode(data!);
      });
    });
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoController.text;
      _toDoController.text = "";
      newToDo["ok"] = false;
      _toDoList.add(newToDo);
      _saveData();
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _toDoList.sort((a, b) {
        if (a["ok"] && !b["ok"])
          return 1;
        else if (!a["ok"] && b["ok"])
          return -1;
        else
          return 0;
      });

      _saveData();
    });
  }

  String getTime() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br');
    final String formatted = formatter.format(now);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
            child: Column(children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(10, 25, 0, 0),
            leading: Icon(Icons.menu, size: 40),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.check,
              color: Colors.redAccent,
              size: 30,
            ),
            title: Text("Cumpridas",
                style: TextStyle(color: Colors.redAccent, fontSize: 25)),
          ),
          ListTile(
            leading: Icon(Icons.panorama_fish_eye,
                color: Colors.redAccent, size: 30),
            title: Text("A cumprir",
                style: TextStyle(color: Colors.redAccent, fontSize: 25)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                30, MediaQuery.of(context).size.height * .60, 0, 10),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Image.asset("images/check_logo.png", scale: 1.2),
            ),
          ),
        ])),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.redAccent,
            tooltip: "Adicionar tarefa",
            onPressed: () {
              _ModalBottomSheet(context);
            },
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.redAccent,
                leading: Builder(
                    builder: (context) => IconButton(
                        icon: Icon(
                          Icons.menu,
                          size: 40,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        })),
                actions: <Widget>[
                  Container(
                      child: Text(
                        getTime(),
                        style: TextStyle(fontSize: 20),
                      ),
                      padding: EdgeInsets.fromLTRB(0, 20, 20, 0)),
                ],
                centerTitle: false,
                floating: false,
                pinned: true,
                expandedHeight: 210.0,
                flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      "Tarefas",
                      style: TextStyle(fontSize: 35),
                    ),
                    titlePadding: EdgeInsets.only(left: 15),
                    background: Image.asset("images/back_check.jpg")),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                    background: Container(
                        color: Colors.grey,
                        child: Align(
                            alignment: Alignment(-0.9, 0),
                            child: Icon(Icons.delete, color: Colors.white))),
                    direction: DismissDirection.startToEnd,
                    child: Card(
                      elevation: 5,
                      child: ClipPath(
                        child: Container(
                          child: ListTile(
                            leading: Checkbox(
                              checkColor: Colors.white,
                              fillColor: MaterialStateProperty.resolveWith(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Colors.grey;
                                }
                                return null;
                              }),
                              value: _toDoList[index]["ok"],
                              shape: CircleBorder(),
                              onChanged: (bool? value) {
                                setState(() {
                                  _toDoList[index]["ok"] = value!;
                                  _saveData();
                                });
                              },
                            ),
                            title: Text(
                              _toDoList[index]["title"],
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            trailing: _toDoList[index]["ok"]
                                ? CircleAvatar(
                                    child: Icon(Icons.done),
                                    backgroundColor: Colors.redAccent,
                                  )
                                : null,
                          ),
                          height: 60,
                          decoration: BoxDecoration(
                              color: _toDoList[index]["ok"]
                                  ? Color.fromRGBO(221, 221, 219, 1)
                                  : Colors.white,
                              border: Border(
                                  right: BorderSide(
                                      color: _toDoList[index]["ok"]
                                          ? Colors.grey
                                          : Colors.redAccent,
                                      width: 5))),
                        ),
                        clipper: ShapeBorderClipper(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3))),
                      ),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        _lastRemoved = Map.from(_toDoList[index]);
                        _lastRemovedPosition = index;
                        _toDoList.removeAt(index);

                        _saveData();

                        final snack = SnackBar(
                          backgroundColor: Colors.white,
                          content: Text(
                              "Tarefa \"${_lastRemoved["title"]}\" removida com sucesso",
                              style: TextStyle(color: Colors.grey)),
                          action: SnackBarAction(
                              label: "Desfazer",
                              textColor: Colors.redAccent,
                              onPressed: () {
                                setState(() {
                                  _toDoList.insert(
                                      _lastRemovedPosition, _lastRemoved);
                                  _saveData();
                                });
                              }),
                          duration: Duration(seconds: 3),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snack);
                      });
                    },
                  );
                },
                childCount: _toDoList.length,
              )),
              //SliverList(delegate: SliverChildListDelegate([aWidget()]))
            ],
          ),
        ));
  }

  Widget aWidget() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _toDoController,
                  decoration: InputDecoration(
                    labelText: "Nova tarefa",
                    labelStyle: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _addToDo,
                child: Text("Add"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String?> _readData() async {
    try {
      final file = await _getFile();

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  void _ModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * .60,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 0, 30),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _toDoController,
                          decoration: InputDecoration(
                            labelText: "Nova tarefa",
                            labelStyle: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _addToDo,
                        child: Text("Add"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.redAccent, // text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: Image.asset("images/check_logo.png", scale: 1.2)),
              ],
            ),
          ),
        );
      },
    );
  }
}
