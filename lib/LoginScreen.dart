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

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(1, 169, 94, 1),
          toolbarHeight: 70,
          centerTitle: true,
          title: Padding(
              padding: EdgeInsets.only(left: 95),
              child: Text('Login',
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
            Column(children: [
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 220,
                    child: Column(
                      children: [Image.asset('assets/gen_avatar.png')],
                    )),
              )
            ]),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 40, right: 40),
                  child: Text(
                    'Bem-vindo!',
                    style: TextStyle(
                        fontSize: 24,
                        fontFamily: "RedHatDisplay",
                        color: Color.fromRGBO(1, 169, 94, 1)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 40, right: 40),
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                    child: TextField(
                      style: TextStyle(fontFamily: 'Roboto'),
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(1, 169, 94, 1), width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(1, 169, 94, 1), width: 1.0),
                        ),
                        labelText: 'Username',
                        labelStyle: TextStyle(fontFamily: 'Roboto'),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 25, left: 30, bottom: 15, right: 30),
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                    child: TextField(
                      style: TextStyle(fontFamily: 'Roboto'),
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(1, 169, 94, 1), width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(1, 169, 94, 1), width: 1.0),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(fontFamily: 'Roboto'),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 30),
                  width: 150,
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => OtherScreen(),
                        transitionDuration: Duration(milliseconds: 50),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                      ),
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: Color.fromRGBO(1, 169, 94, 1)),
                    child: Text(
                      'LOGIN',
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
        ));
  }
}
