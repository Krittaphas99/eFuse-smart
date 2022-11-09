import 'package:efuse/battery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert';
import 'dart:async';

class Getdata {
  String connected = "disconnect";
  String name = "No device";
  String uuid = " ";
  String device_id = " ";
  List<int> fuse = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  double battery = 0;
  late BluetoothDevice connectedDevice;
  late List<BluetoothService> services;

  String data = "";
  void ReadData_blue() async {
    try {
      for (BluetoothService service1 in services) {
        for (BluetoothCharacteristic characteristic
            in service1.characteristics) {
          if (characteristic.properties.notify) {
            List<int> value = await characteristic.read();
            const asciiDecoder = AsciiDecoder();
            final result = asciiDecoder.convert(value);
            data = result;
          }
        }
      }
    } catch (e) {
      connectedDevice.disconnect();
      services.clear();
    }
    splite();
  }

  void splite() {
    if (data == null) {
      return null;
    } else {
      try {
        final result = data.split(":");
        for (int i = 0; i < result.length; i++) {}
        name = result[0];
        for (int i = 0; i < 10; i++) {
          //fuse[i] = int.parse(result[i + 1]);
          fuse[i] = int.parse(result[i + 1]);
        }
        battery = double.parse(result[11]);
      } on Exception catch (e) {
        throw e;
      }
    }
  }
}
