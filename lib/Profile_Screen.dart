// Importa os pacotes necessários
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doneapp/main.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'Agenda.dart';
import 'Profile_Screen.dart';
import 'Métricas.dart';
import 'AppBar.dart';
import 'main.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(1, 169, 94, 1),
          toolbarHeight: 70,
          title: Padding(
              padding: EdgeInsets.only(left: 95),
              child: Text('Perfil', style: TextStyle(color: Colors.white))),
          iconTheme: const IconThemeData(color: Colors.white, size: 40),
        ),
        body: Column(
          children: [
            Stack(
              clipBehavior: Clip.,
              children: [
                Positioned(
                  top: -50,
                  left: -50,
                  height: 200,
                  width: 500,
                  child: Container(
                      height: 200,
                      width: 900,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(1, 169, 94, 1),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(300),
                          bottomRight: Radius.circular(300),
                        ),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Column(
                        children: [Image.asset('assets/avatar.png')],
                      )),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('felipe_USERNAME'),
                  ],
                )
              ],
            ),
          ],
        ));
  }
}
