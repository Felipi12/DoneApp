// Importa os pacotes necessários
// ignore_for_file: unused_import

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doneapp/clients/controllers/authenticator_controller.dart';
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

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  final userController = TextEditingController();

  @override
  void dispose() {
    userController.dispose();
    super.dispose();
  }

  final passwordController = TextEditingController();

  @override
  void disposePass() {
    passwordController.dispose();
    super.dispose();
  }

  void toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentTheme = Theme.of(context);
    return Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: currentTheme.primaryColor,
          toolbarHeight: 70,
          centerTitle: true,
          title: Padding(
              padding: EdgeInsets.only(),
              child: Text('Login',
                  style: TextStyle(
                      color: currentTheme.scaffoldBackgroundColor,
                      fontFamily: 'RedHatDisplay'))),
          iconTheme: IconThemeData(
              color: currentTheme.scaffoldBackgroundColor, size: 40),
        ),
        body: SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(children: [
                  Positioned(
                      bottom: 105,
                      right: -50,
                      child: Opacity(
                        opacity: 0.2,
                        child:
                            Image.asset("assets/check_green.png", height: 200),
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
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: 40, left: 40, right: 40),
                          child: Text(
                            'Bem-vindo!',
                            style: TextStyle(
                                fontSize: 24,
                                fontFamily: "RedHatDisplay",
                                color: currentTheme.primaryColor),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 40, right: 40),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 10, bottom: 0, left: 15, right: 15),
                            child: TextField(
                              controller: userController,
                             style:
                                  TextStyle(fontFamily: 'Roboto', height: 0.1),
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: currentTheme.primaryColor,
                                      width: 0.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: currentTheme.primaryColor,
                                      width: 0.5),
                                ),
                                labelText: 'Username',
                                hintText: 'testandoo',
                                helperText: 'tstststst',
                                labelStyle: TextStyle(fontFamily: 'Roboto'),
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10, left: 50, bottom: 15, right: 50),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 0, bottom: 5, left: 5, right: 5),
                            child: TextField(
                              controller: passwordController,
                              style:
                                  TextStyle(fontFamily: 'Roboto', height: 0.1),
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: currentTheme.primaryColor,
                                      width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: currentTheme.primaryColor,
                                      width: 1.0),
                                ),
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Change this icon based on the _obscureText state
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    // Update the state of _obscureText
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 30),
                          width: 150,
                          child: TextButton(
                            onPressed: () async {
                              try {
                                await AuthenticatorController.signIn(
                                    email: userController.text,
                                    password: passwordController.text);
                              } catch (e) {
                                print('Caught an exception: $e');
                                return;
                              }
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => OtherScreen(),
                                  transitionDuration:
                                      Duration(milliseconds: 50),
                                  transitionsBuilder:
                                      (_, animation, __, child) {
                                    return FadeTransition(
                                        opacity: animation, child: child);
                                  },
                                ),
                              );
                            },                            style: TextButton.styleFrom(
                                backgroundColor: currentTheme.primaryColor),
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
                  ]),
                ]))));
  }
}
