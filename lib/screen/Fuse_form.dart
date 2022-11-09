import 'package:efuse/classs/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: camel_case_types
class Fuse_form extends StatefulWidget {
  const Fuse_form({Key? key}) : super(key: key);

  @override
  State<Fuse_form> createState() => _Fuse_formState();
}

// ignore: camel_case_types
class _Fuse_formState extends State<Fuse_form> {
  Getdata data_main_fuse = Getdata();
  //Stream<Getdata> check_fuse;
  //List<int> fuse_number = getdata;
  List<String> fuse_check = [];
  StreamController<Getdata> streamController = StreamController<Getdata>();
  Timer? timer;
  void _check_fuse() {
    fuse_check.clear();
    for (var i = 0; i < data_main_fuse.fuse.length; i++) {
      if (data_main_fuse.fuse[i] == 1) {
        fuse_check.add('images/fuse_on.png');
      } else {
        fuse_check.add('images/fuse_off.png');
      }
    }
  }

  @override
  void dispose() {
    fuse_check.clear();
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
    print("กดส่งfuse");
  }

  @override
  void initState() {
    data_main_fuse = Get.arguments;

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //print(Get.arguments);
      print(data_main_fuse.fuse);
      streamController.add(data_main_fuse);
      setState(() {
        _check_fuse();
      });
    });
    // TODO: implement initState
    //print(data_main_fuse.fuse);
    _check_fuse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
              child: Text(
            "Fuse Status",
            style: TextStyle(fontSize: 30, color: Colors.white),
          )),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: streamController.stream,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return Column(children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Text("Fuse ${index + 1}"),
                        trailing: Image.asset(fuse_check[index]),
                      );
                    },
                  ),
                ),
              ]);
            }
            return SpinKitRing(
              size: 50,
              color: Colors.blue,
            );
          }),
        ));
  }
}
