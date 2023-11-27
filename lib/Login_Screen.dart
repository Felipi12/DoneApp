// Importa os pacotes necessários
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doneapp/main.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'Agenda.dart';
import 'Login_Screen.dart';
import 'Métricas.dart';
import 'AppBar.dart';
import 'main.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(1, 169, 94, 1),
        toolbarHeight: 70,
        title: Padding(padding: EdgeInsets.only(left:95), child:Text('Perfil', style: TextStyle(color: Colors.white))),
        iconTheme: const IconThemeData(color: Colors.white, size: 40),
      ),
      body: Stack(children: [
        Positioned(top: 0,
        left: 0,
        height: 200,
        width: 400,
        child:
        Container(
        height: 200,
      width: 900,
      decoration: const BoxDecoration(
      color: Color.fromRGBO(1, 169, 94, 1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(300),
          bottomRight: Radius.circular(300),
        ),)),),

        Padding(padding: EdgeInsets.only(top: 40) ,
        child:Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Image.asset('assets/avatar.png')
              ],
            )
        ),
      )],),
    );
  }
}
