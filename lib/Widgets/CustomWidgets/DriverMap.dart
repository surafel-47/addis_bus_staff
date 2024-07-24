// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, use_build_context_synchronously, unnecessary_string_interpolations, file_names

import 'dart:async';

import 'package:addis_bus_mgt/Repositories/DriverRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../Repositories/Localizations.dart';
import '../../../Repositories/ScreenColors.dart';

class DriverMap extends StatefulWidget {
  String title;
  String subTitle;
  IconData leadingIcon;

  List<Marker> stationsMarkersList = [];
  dynamic stationsList;
  List<Polyline> polylines = [];
  bool drawPolylines;

  DriverMap({this.title = "", this.subTitle = "", this.leadingIcon = Icons.route, this.stationsList = const [], this.drawPolylines = false}) {
    stationsMarkersList = stationsList.map<Marker>((station) {
      double latitude = station['location']['lat'];
      double longitude = station['location']['long'];
      String name = station['station_name'];

      return Marker(
        width: 100,
        height: 80,
        point: LatLng(latitude, longitude),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(223, 162, 174, 224),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                name,
                style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Icon(Icons.bus_alert_outlined),
                  Icon(Icons.arrow_back),
                  Icon(Icons.person),
                  Text(
                    station['in'].toString(),
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.bus_alert_outlined),
                  Icon(Icons.arrow_forward),
                  Icon(Icons.person),
                  Text(
                    station['out'].toString(),
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }).toList();

    if (drawPolylines) {
      List<LatLng> polylinePoints = stationsMarkersList.map((marker) => marker.point).toList();

      // Create polylines from the polyline points
      polylines = [
        Polyline(
          points: polylinePoints,
          strokeWidth: 4.0,
          color: Colors.blue,
        ),
      ];
    }
  }

  @override
  State<DriverMap> createState() => _DriverMapState();
}

class _DriverMapState extends State<DriverMap> {
  List<Marker> driversMarkerList = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startRepeatedMethod();
  }

  @override
  void dispose() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    super.dispose();
  }

  void startRepeatedMethod() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }

    timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        // print("Runningg");

        driversMarkerList = [];
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 100));

        var jsonResult = await DriverRepo.getCurrentLocation();

        driversMarkerList = [
          Marker(
            width: 60,
            height: 60,
            point: LatLng(jsonResult['location']['lat'], jsonResult['location']['long']),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  Icon(Icons.bus_alert),
                  Text(
                    "MyBus",
                    style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 12, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          )
        ];

        setState(() {});
      } catch (err) {
        // print(err);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locMgrProv = Provider.of<LocalizationManager>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.png'), // Path to your image
              fit: BoxFit.cover, // Cover the entire app bar
            ),
          ),
        ),
        leading: Icon(
          Icons.bus_alert,
          color: Colors.white,
        ),
        title: Text(
          locMgrProv.getText('Map'),
          style: TextStyle(color: MyColors.lightBlueText),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double cardW = constraints.maxWidth;
          double cardH = constraints.maxHeight;
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg2.png"),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.all(20),
            width: cardW,
            height: cardH,
            child: Column(
              children: [
                Card(
                  elevation: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: cardH * 0.75,
                      width: cardW,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(9.0192, 38.7525),
                          initialZoom: 13,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app',
                          ),
                          MarkerLayer(
                            markers: [...widget.stationsMarkersList, ...driversMarkerList],
                          ),
                          PolylineLayer(polylines: widget.polylines),
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Card(
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(widget.leadingIcon),
                    title: Text(
                      widget.title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle: Text(
                      widget.subTitle,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
