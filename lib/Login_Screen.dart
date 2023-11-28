// Importa os pacotes necessários
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'Agenda.dart';
import 'Login_Screen.dart';
import 'Métricas.dart';
import 'AppBar.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';



class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.symmetric(15),
            child:CircleAvatar(backgroundImage: AssetImage('assets\avatar.png'),),

          )
          
        ],
      ),
    );
  }
}