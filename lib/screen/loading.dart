import 'package:efuse/classs/data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'dart:async';

class loadingwidget extends StatefulWidget {
  const loadingwidget({Key? key}) : super(key: key);

  @override
  State<loadingwidget> createState() => _loadingwidgetState();
}

class _loadingwidgetState extends State<loadingwidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
              child: Text(
            "loading",
            style: TextStyle(fontSize: 30, color: Colors.white),
          )),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: SpinKitRing(
            size: 100,
            color: Colors.blue,
          ),
        ));
  }
}
