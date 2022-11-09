import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
class ConnectBlue {
  String _deviceName = "";
  String _statusConnect = "Connect";
  String _deviceID = "";
  /*Container show(){
    return Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(_deviceName),
                    Text(_deviceID),
                  ],
                ),
              ),
              FlatButton(
                color: Colors.blue,
                child: Text(
                  _statusConnect,
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                    setState(() {
                     _statusConnect = "Connected";
                      print("เชื่อมแล้ว");
                    });
                  try {
                    await device.connect().catchError((error) async {
                      await device.disconnect();
                      await Future.delayed(Duration(seconds: 2));
                      _restartScan();
                    });
                  } catch (e) {
                    if (e != 'already_connected') {
                      throw e;
                    }
                  } finally {
                    _services = await device.discoverServices();
                  }
                },
              ),
            ],
          ),
        );
      
  }
  */
}
