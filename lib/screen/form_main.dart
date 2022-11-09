import 'package:efuse/classs/data.dart';
import 'package:flutter/material.dart';
import 'package:efuse/battery.dart';
import 'package:efuse/screen/Fuse_form.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:efuse/screen/gps_form.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:bluetooth_enable/bluetooth_enable.dart';

//import 'package:bluetooth_enable/bluetooth_enable.dart';
class form_main extends StatefulWidget {
  form_main({Key? key}) : super(key: key);
  //final FlutterBlue flutterBlue = FlutterBlue.instance;
  @override
  State<form_main> createState() => _form_mainState();
}

class _form_mainState extends State<form_main> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  bool check_blue = true;
  Getdata data_main = Getdata();
  double battery = 0;
  Timer? timer;
  Timer? timer_checkblue;
  StreamController<Getdata> streamController = StreamController<Getdata>();
  @override
  void cal_battery() {
    battery = ((data_main.battery / 12) * 100);
  }

  Future<bool> _checkDeviceBluetoothIsOn() async {
    return await flutterBlue.isOn;
  }

  void initState() {
    streamController.add(data_main);
    timer_checkblue = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (await _checkDeviceBluetoothIsOn()) {
        check_blue = false;
        timer_checkblue?.cancel();
      }
    });
    cal_battery();
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Container(
              child: Text(
            "eFuse",
            style: TextStyle(fontSize: 30, color: Colors.white),
          )),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: streamController.stream,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return form_main_show();
            }
            return SpinKitRing(
              size: 50,
              color: Colors.blue,
            );
          }),
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Column form_main_show() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                devicebox(),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed('/fuse', arguments: data_main);
                  },
                  child: fusebox(),
                ),
                const SizedBox(
                  height: 20,
                ),
                batterybox(),
                const SizedBox(
                  height: 20,
                ),
                /*   InkWell(
                  onTap: () {
                    Get.toNamed('/gpsmap');
                  },
                  child: gpsbox(),
                ),*/
                const SizedBox(
                  height: 20,
                ),

                ///next function
              ],
            ),
          ))
        ]);
  }

  Container devicebox() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white10, borderRadius: BorderRadius.circular(20)),
      height: 160,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        // ignore: prefer_const_literals_to_create_immutables
        children: [
          SizedBox(
            width: 10,
          ),
          const Text("Device",
              style: TextStyle(fontSize: 20, color: Colors.black)),
          SizedBox(
            width: 5,
          ),
          Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("",
                      style: TextStyle(fontSize: 15, color: Colors.black)),
                  SizedBox(
                    height: 3,
                  ),
                  Image.asset(
                    "images/devicelogo.png",
                    scale: 2,
                  ),
                ]),
          ),
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text("eFuse SMART",
                      style: TextStyle(fontSize: 15, color: Colors.black)),
                  Text("Device ID : " + data_main.name.toString(),
                      style: TextStyle(fontSize: 15, color: Colors.black)),
                  Text("STATUS : " + data_main.connected.toString(),
                      style: TextStyle(fontSize: 15, color: Colors.black)),
                  checkConnect()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void readData_formblue() async {
    data_main.connectedDevice.connect();
    data_main.services = await data_main.connectedDevice.discoverServices();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        data_main.ReadData_blue();
        check_fuse_showWidget();
        cal_battery();
      });
    });
  }

  OutlinedButton checkConnect() {
    if (data_main.connected.compareTo("disconnect") == 0) {
      return button_connect();
    } else {
      return button_disconnect();
    }
  }

  OutlinedButton button_connect() {
    return OutlinedButton.icon(
      onPressed: (() async {
        if (check_blue) {
          BluetoothEnable.enableBluetooth.then((value) {
            if (value == "false") {
              AppSettings.openBluetoothSettings();
            }
          });
        }
        if (!check_blue) {
          try {
            data_main =
                await Get.toNamed('/bluetooth_connect', arguments: data_main);
            readData_formblue();
          } catch (e) {
            if (e == null) {
              throw e;
            }
          }
        }

        //print(data_main.connected);
      }),
      icon: Icon(Icons.add),
      label: Text('Connecting'),
    );
  }

  OutlinedButton button_disconnect() {
    return OutlinedButton.icon(
      onPressed: (() {
        Getdata redata = Getdata();
        timer?.cancel();

        if (mounted) {
          setState(() {
            data_main.connected = "disconnect";
            // data_main.services.clear();
            // data_main.connectedDevice.disconnect();
            data_main = redata;
            cal_battery();
          });
        }
      }),
      icon: Icon(Icons.clear),
      label: Text('disconnect'),
    );
  }

  Container fusebox() {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 120, 252, 252),
          borderRadius: BorderRadius.circular(20)),
      height: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(children: [
              check_fuse_showWidget(),
              SizedBox(
                width: 20,
              ),
              Image.asset(
                'images/fuse.png',
                scale: 2,
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Container check_fuse_showWidget() {
    if (data_main.connected.compareTo("connected") == 0) {
      for (int i = 0; i < data_main.fuse.length; i++) {
        if (data_main.fuse[i] == 0) {
          return Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BorderedText(
                    strokeWidth: 5.0,
                    strokeColor: Colors.blue,
                    child: Text(
                      'Fuse Status',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  BorderedText(
                    strokeWidth: 5.0,
                    strokeColor: Colors.red,
                    child: Text(
                      'Please check!!',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]),
          );
        }
      }
    }
    return Container(
      child: BorderedText(
        strokeWidth: 5.0,
        strokeColor: Colors.blue,
        child: Text(
          'Fuse Status',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Container batterybox() {
    return Container(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [],
              ),
              Battery(
                value: battery,
                size: 200,
              ),
              SizedBox(
                width: 30,
              ),
              Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Battery",
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                      Text(data_main.battery.toStringAsFixed(2) + "V",
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                      Text(battery.toStringAsFixed(2) + "/100 %",
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                    ]),
              )
            ]),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 120, 252, 252),
            borderRadius: BorderRadius.circular(20)),
        height: 180);
  }

  Container gpsbox() {
    return Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/gps.png',
              scale: 2.5,
            ),
            SizedBox(
              width: 20,
            ),
            BorderedText(
              strokeWidth: 5.0,
              strokeColor: Colors.blue,
              child: Text(
                'google tracking',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 120, 252, 252),
            borderRadius: BorderRadius.circular(20)),
        height: 140);
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
