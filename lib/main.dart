import 'package:efuse/screen/form_blue_connect.dart';
import 'package:efuse/screen/form_main.dart';
import 'package:efuse/screen/Fuse_form.dart';
import 'package:efuse/screen/gps_form.dart';
import 'package:efuse/screen/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'eFuse',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.lightBlue,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () =>form_main()),
        GetPage(name: '/fuse', page: () =>Fuse_form()),
        GetPage(name: '/gpsmap', page: () =>gps_page()),
        GetPage(name: '/bluetooth_connect', page: () =>form_blue_connect()),
        GetPage(name: '/loading', page: () =>loadingwidget()),
      ],
    );
  }
}
