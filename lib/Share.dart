// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import 'package:social_share/social_share.dart';




class ShareScreen extends StatelessWidget {

  final txtController = TextEditingController();

  @override
  void dispose() {
    txtController.dispose();
    dispose();
  }

  void compartilhar() {
    SocialShare.shareOptions(
      txtController.text
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentTheme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(children: <Widget>[
            Positioned(
                bottom: 180,
                right: -50,
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset("assets/check_green.png", height: 200),
                )),
            Container(
                child: Column(children: <Widget>[
              Center(
                  child: Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 45),
                      child: Image.asset(
                        'assets/job_done.png',
                        height: 30,
                      ))),
              Padding(
                padding: EdgeInsets.only(left: 15, bottom: 15, right: 15),
                child: Card(
                  surfaceTintColor: Colors.white,
                  color: currentTheme.scaffoldBackgroundColor,
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                    child: TextField(
                      controller: txtController,
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
                      ),),),
                  elevation: 3,
              ),),
              Padding(
                padding: EdgeInsets.only(left: 30, bottom: 15, right: 30),
                child: Text(
                  'Compartilhe com os seus amigos e mostre que você está #Done!',
                  style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, right: 40),
                child: Divider(
                  color: Color.fromRGBO(1, 169, 94, 1),
                  thickness: 1.5,
                ),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 40, bottom: 20),
                          child: GestureDetector(
                            onTap: () {
                              compartilhar();
                            },
                            child: Image.asset(
                              'assets/x.png',
                              fit: BoxFit.cover,
                              width: 60.0,
                            ),
                          ),),
                      Padding(
                          padding: EdgeInsets.only(top: 40, bottom: 20),
                          child: GestureDetector(
                            onTap: () {
                              compartilhar();
                            },
                            child: Image.asset(
                              'assets/face.png',
                              fit: BoxFit.cover,
                              width: 60.0,
                            ),
                          ))
                    ],
                  )
              ])
            ]))
          ]))),
    );
  }
}
