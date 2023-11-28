// Importa os pacotes necessários
// ignore_for_file: unused_import

import 'LoginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doneapp/main.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'Agenda.dart';
import 'Profile_Screen.dart';
import 'Métricas.dart';
import 'AppBar.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

class ProfileScreen extends StatelessWidget {
  final NUM_TAREFAS = 0;

  @override
  Widget build(BuildContext context) {
    var currentTheme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: currentTheme.primaryColor,
          toolbarHeight: 70,
          title: Padding(
              padding: EdgeInsets.only(left: 95),
              child: Text('Perfil',
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'RedHatDisplay'))),
          iconTheme: const IconThemeData(color: Colors.white, size: 40),
        ),
        body: Stack(
          children: [
            Positioned(
                bottom: 0,
                right: -50,
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset("assets/check_green.png", height: 200),
                )),
            Column(
              children: [
                Stack(
                  children: [
                    Positioned(
                      top: -50,
                      left: -50,
                      height: 200,
                      width: 500,
                      child: Container(
                          height: 200,
                          width: 900,
                          decoration: BoxDecoration(
                            color: currentTheme.primaryColor,
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
                          height: 220,
                          child: Column(
                            children: [Image.asset('assets/avatar.png')],
                          )),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 40, right: 40),
                      child: Text(
                        '_USERNAME',
                        style: TextStyle(
                            fontSize: 24, color: currentTheme.primaryColor),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 40, right: 40),
                      child: Divider(
                        color: currentTheme.primaryColor,
                        thickness: 1.5,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 25, left: 30, bottom: 15, right: 30),
                      child: Text(
                        '_NOME_COMPLETO',
                        style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    CircleAvatar(
                      radius: 2,
                      backgroundColor: currentTheme.primaryColor,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 25, left: 30, bottom: 15, right: 30),
                      child: Text(
                        '_IDADE',
                        style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    CircleAvatar(
                      radius: 2,
                      backgroundColor: currentTheme.primaryColor,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 25, left: 30, bottom: 15, right: 30),
                      child: Text(
                        NUM_TAREFAS.toString() + ' tarefas cumpridas',
                        style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    CircleAvatar(
                      radius: 2,
                      backgroundColor: currentTheme.primaryColor,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 25, left: 30, bottom: 15, right: 30),
                      child: Text(
                        'Deletar todos os dados',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 30),
                      width: 150,
                      child: TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => LoginScreen(),
                            transitionDuration: Duration(milliseconds: 50),
                            transitionsBuilder: (_, animation, __, child) {
                              return FadeTransition(
                                  opacity: animation, child: child);
                            },
                          ),
                        ),
                        style: TextButton.styleFrom(
                            backgroundColor: currentTheme.primaryColor),
                        child: Text(
                          'LOGOUT',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: "RedHatDisplay",
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ));
  }
}
