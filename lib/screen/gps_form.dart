import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class gps_page extends StatefulWidget {
  const gps_page({Key? key}) : super(key: key);

  @override
  State<gps_page> createState() => _gps_pageState();
}

class _gps_pageState extends State<gps_page> {
  late GoogleMapController mapController;

  final LatLng _getposition = const LatLng(13.7650836, 100.5379664);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            child: Text(
          "GPS Tracking",
          style: TextStyle(fontSize: 30, color: Colors.white),
        )),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(13.7650836, 100.5379664),
          zoom: 15.0,
        ),
      ),
    );
  }
}
