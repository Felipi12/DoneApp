import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doneapp/clients/controllers/tasks_controller.dart';
import 'package:doneapp/clients/entities/tasks_entity.dart';
import 'package:flutter/cupertino.dart';
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
  List<DateTime> currentMonthList = List.empty();
  DateTime currentDateTime =
  DateTime.now
    ();
  late ScrollController scrollController;
  final size = 2;

  //List<List<int>> grid = List<List<int>>.generate(
  //  this.size, (i) => List<int>.generate(this.size, (j) => i * this.size + j));

  List<TaskEntity> _toDoList = [];
  late TaskEntity _lastRemoved;

  @override
  void initState() {
    DateTime firstDayOfMonth =
    DateTime(currentDateTime.year, currentDateTime.month);
    DateTime firstDayOfNextMonth =
    DateTime(currentDateTime.year, currentDateTime.month + 1);

    int daysInMonth = firstDayOfNextMonth.difference(firstDayOfMonth).inDays;
    List<DateTime> dates = List.generate(
        daysInMonth, (i) => firstDayOfMonth.add(Duration(days: i)));
    currentMonthList = dates;
    currentMonthList.sort((a, b) => a.day.compareTo(
        b.day
    ));
    currentMonthList = currentMonthList.toSet().toList();
    scrollController =
        ScrollController(initialScrollOffset: 1.0 *
            currentDateTime.day
        );
    refreshData();
    super.initState();
  }

  void refreshData() {
    TasksController().getAll().then((tasks) {
      print(tasks);
      setState(() {
        _toDoList = tasks;
      });
    });
  }

  void _addToDo() {
    TasksController()
        .create(TaskEntity(
        done: false,
        desc: _toDoController.text,
        date: Timestamp.fromDate(
            DateTime.now
              ()),
        array: ""))
        .then((task) {
      setState(() {
        _toDoController.text = "";
        refreshData();
      });
    });
  }

  Future<Null> _refresh() async {
    /*
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _toDoList.sort((a, b) {
        if (a.done && !b.done)
          return 1;
        else if (!a.done && b.done)
          return -1;
        else
          return 0;
      });

      _saveData();
    });*/

    setState(() {
      refreshData();
    });
  }

  String getTime() {
    final DateTime now =
    DateTime.now
      ();
    final DateFormat formatter = DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br');
    final String formatted = formatter.format(now);
    return formatted;
  }

  Widget capsuleView(int index) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              currentDateTime = currentMonthList[index];
            });
          },
          child: Container(
            width: 40,
            height: 50,
            child: Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center
                ,
                children: <Widget>[
                  Text(
                    currentMonthList[index].day.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        color:
                        (currentMonthList[index].day !=
                            currentDateTime.day
                        )
                            ? Colors.grey
                            : Color.fromRGBO(1, 169, 94, 1)),
                  ),
                  Text(
                    DateFormat('EEE', 'pt_BR')
                        .format(currentMonthList[index])[0]
                        .toUpperCase(),
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color:
                        (currentMonthList[index].day !=
                            currentDateTime.day
                        )
                            ? Colors.grey
                            : Color.fromRGBO(1, 169, 94, 1)),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget hrizontalCapsuleListView() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: currentMonthList.length,
        itemBuilder: (BuildContext context, int index) {
          return capsuleView(index);
        },
      ),
    );
  }

  Widget titleView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Text(
        DateFormat('MMMM', 'pt_BR').format(
            DateTime.now
              ())[0].toUpperCase() +
            DateFormat('MMMM', 'pt_BR').format(
                DateTime.now
                  ()).substring(1) +
            ' ' +
            currentDateTime.year.toString(),
        style: const TextStyle(color: Colors.grey, fontSize: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 85,
          title: Column(children: <Widget>[
            titleView(),
            Container(
              height: 200 * 0.35,
              width: 600,
              child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center
                  ,
                  children: <Widget>[
                    hrizontalCapsuleListView(),
                  ]),
            )
          ]),
          centerTitle: true,
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(left: 30),
            child: FloatingActionButton(
              elevation: 1,
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: currentTheme.primaryColor,
              tooltip: "Adicionar tarefa",
              onPressed: () {
                _ModalBottomSheet(context);
              },
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return Dismissible(
                          key:
                          Key(
                              DateTime.now
                                ().millisecondsSinceEpoch.toString()),
                          background: Container(
                              color: Colors.grey,
                              child: Align(
                                  alignment: Alignment(-0.9, 0),
                                  child: Icon(Icons.delete, color: Colors.white))),
                          direction: DismissDirection.startToEnd,
                          child: Card(
                            elevation: 0,
                            child: ClipPath(
                              child: Container(
                                child: ListTile(
                                  leading: Checkbox(
                                    checkColor: Colors.white,
                                    fillColor: MaterialStateProperty.resolveWith(
                                            (Set<MaterialState> states) {
                                          if (states.contains(MaterialState.selected)) {
                                            return
                                              Colors.green
                                            ;
                                          }
                                          return null;
                                        }),
                                    value: _toDoList[index].done,
                                    shape: CircleBorder(),
                                    onChanged: (bool? value) {
                                      _toDoList[index].done = value!;
                                      TasksController()
                                          .update(_toDoList[index])
                                          .then((value) => refreshData());
                                    },
                                  ),
                                  title: _toDoList[index].done
                                      ? Text(
                                    _toDoList[index].desc,
                                    style: TextStyle(color: Colors.grey),
                                  )
                                      : Text(
                                    _toDoList[index].desc,
                                    style: TextStyle(
                                        color: Color.fromRGBO(1, 169, 94, 1)),
                                  ),
                                  trailing: _toDoList[index].done
                                      ? Icon(
                                    Icons.done,
                                    color: CupertinoColors.white,
                                  )
                                      : null,
                                ),
                                height: 50,
                                decoration: BoxDecoration(
                                    color: currentTheme.scaffoldBackgroundColor,
                                    border: Border(
                                        right: BorderSide(
                                            color: _toDoList[index].done
                                                ? Colors.grey
                                                : Color.fromRGBO(1, 169, 94, 1),
                                            width: 5))),
                              ),
                              clipper: ShapeBorderClipper(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7))),
                            ),
                          ),
                          onDismissed: (direction) {
                            _lastRemoved = _toDoList[index];
                            TaskEntity task = _toDoList.elementAt(index);
                            TasksController()
                                .delete(
                                task.id
                            )
                                .then((value) => {refreshData()})
                                .then((value) {
                              final snack = SnackBar(
                                backgroundColor: Colors.white,
                                content: Text(
                                    "Tarefa \"${_lastRemoved.desc}\" removida com sucesso",
                                    style: TextStyle(color: Colors.grey)),
                                action: SnackBarAction(
                                    label: "Desfazer",
                                    textColor: Color.fromRGBO(1, 169, 94, 1),
                                    onPressed: () {
                                      TasksController()
                                          .create(_lastRemoved)
                                          .then((value) => {refreshData()});
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
            ],
          ),
        ),
      ],
    );
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
                            labelStyle:
                            TextStyle(color: Color.fromRGBO(1, 169, 94, 1)),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _addToDo,
                        child: Text("Add"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                          Color.fromRGBO(1, 169, 94, 1), // text color
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