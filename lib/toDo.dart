import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
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
        floatingActionButton: Align(alignment: Alignment.bottomCenter, child: FloatingActionButton(

            child: Icon(Icons.add, color: Colors.white),
            backgroundColor: Color.fromRGBO(1, 169, 94, 1),
            tooltip: "Adicionar tarefa",
            onPressed: () {
              _ModalBottomSheet(context);
            },
          ),),

        body: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            slivers: <Widget>[
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
                              style: TextStyle(color: Color.fromRGBO(1, 169, 94, 1)),
                            ),
                            trailing: _toDoList[index]["ok"]
                                ? CircleAvatar(
                                    child: Icon(Icons.done),
                                    backgroundColor: Color.fromRGBO(1, 169, 94, 1),
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
                    labelStyle: TextStyle(color: Color.fromRGBO(1, 169, 94, 1)),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _addToDo,
                child: Text("Add"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromRGBO(1, 169, 94, 1),
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
                            labelStyle: TextStyle(color: Color.fromRGBO(1, 169, 94, 1)),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _addToDo,
                        child: Text("Add"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromRGBO(1, 169, 94, 1), // text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
