import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class ShareScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Positioned(
          bottom: 0,
          right: 0,
          child: Opacity(
            opacity: 0.25,
            child: Image.asset("assets/check_green.png", height: 200),
          )),
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
              children: <Widget>[
            Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Image.asset(
                      'assets/job_done.png',
                      height: 30,
                    ))),
            Padding(
              padding: EdgeInsets.only(left: 15, bottom: 15, right: 15),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                  child: TextField(
                    style: TextStyle(fontFamily: 'Roboto'),
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      labelStyle: TextStyle(fontFamily: 'Roboto'),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ),
                elevation: 3,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 15, bottom: 15, right: 15),
                child: Align(
                  alignment: Alignment(-1, -1),
                  child: Text(
                    'Compartilhe com os seus amigos e mostre que você está #Done!',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[ Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Image.asset(
                        'assets/x.png',
                        height: 60,
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: Image.asset(
                        'assets/face.png',
                        height: 60,
                      ))
                ],
              )]
            )
          ]))
    ]));
  }
}
