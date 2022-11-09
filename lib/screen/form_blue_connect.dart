import 'package:efuse/classs/data.dart';
import 'package:efuse/screen/gps_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert';
import 'package:get/get.dart';

class form_blue_connect extends StatefulWidget {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = [];
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();

  @override
  State<form_blue_connect> createState() => _form_blue_connectState();
}

class _form_blue_connectState extends State<form_blue_connect> {
  final _writeController = TextEditingController();
  late BluetoothDevice _connectedDevice;
  late List<BluetoothService> _services;

  // ConnectBlue con = new ConnectBlue();
  String status1_ = "connect";
  String statused = "disconnect";
  String result1 = "";
  Getdata data_fuse = Getdata();

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      if (mounted) {
        setState(() {
          widget.devicesList.add(device);
        });
      }
    }
  }

  @override
  void initState() {
    data_fuse = Get.arguments;
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
      }
    });
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
    widget.flutterBlue.startScan(timeout: Duration(seconds: 10));
    widget.flutterBlue.stopScan();
    //AsyncSnapshot.waiting();
    super.initState();
  }

  @override
  void dispose() {
    print("กดออก");
    widget.flutterBlue.stopScan();

    // TODO: implement dispose
    super.dispose();
  }

  ListView _buildListViewOfDevices() {
    List<Container> containers = [];
    for (BluetoothDevice device in widget.devicesList) {
      if (device.name.compareTo("eFuse") == 0) {
        containers.add(
          Container(
            height: 50,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                          device.name == '' ? '(unknown device)' : device.name),
                      Text(device.id.toString()),
                    ],
                  ),
                ),
                ElevatedButton(
                  child: Text(
                    status1_,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    try {
                      await device.connect();
                    } catch (e) {
                      if (e == 'already_connected') {
                        device.disconnect();
                        print("เคยเชื่อมต่อแล้ว");
                        throw e;
                      }
                    } finally {
                      _services = await device.discoverServices();
                      print("กดแล้ว");
                      data_fuse.connected = "connected";
                      data_fuse.connectedDevice = device;
                      data_fuse.services = _services;
                      device.disconnect();
                    }
                    widget.flutterBlue.stopScan();
                    Get.back(result: data_fuse);
                  },
                ),
              ],
            ),
          ),
        );
      }
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            child: Text(
              "Blue tooth connect",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
          centerTitle: true,
        ),
        body: _buildListViewOfDevices());
  }
}
