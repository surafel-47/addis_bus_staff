// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_collection_literals, must_be_immutable, use_key_in_widget_constructors, file_names

import 'package:addis_bus_mgt/Repositories/DriverRepo.dart';
import 'package:addis_bus_mgt/Widgets/CustomWidgets/CustomeWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../Repositories/Localizations.dart';
import '../../../Repositories/ScreenColors.dart';

class CustomLocationPicker extends StatefulWidget {
  dynamic stationsList;
  CustomLocationPicker({this.stationsList = const []});
  @override
  State<CustomLocationPicker> createState() => _CustomLocationPickerState();
}

class _CustomLocationPickerState extends State<CustomLocationPicker> {
  LatLng? pickedLocation = LatLng(9.0192, 38.7525);

  List<Marker> stationsMarkersList = [];
  @override
  void initState() {
    super.initState();
    stationsMarkersList = widget.stationsList.map<Marker>((station) {
      double latitude = station['location']['lat'];
      double longitude = station['location']['long'];
      String name = station['station_name'];

      return Marker(
        width: 70,
        height: 50,
        point: LatLng(latitude, longitude),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(223, 162, 174, 224),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(Icons.bus_alert_outlined),
              Text(
                name,
                style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }).toList();
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
          locMgrProv.getText('Demo Location Test'),
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
            width: cardW,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg2.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Spacer(),
                Card(
                  elevation: 4,
                  child: SizedBox(
                    height: cardH * 0.8,
                    width: cardW * 0.9,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(9.0192, 38.7525),
                        initialZoom: 13,
                        onTap: (tapPosition, point) {
                          pickedLocation = point;
                          setState(() {});
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          markers: [
                            ...stationsMarkersList,
                            ...[
                              Marker(
                                width: 80.0,
                                height: 80.0,
                                point: pickedLocation!,
                                child: SizedBox(
                                  child: Icon(
                                    Icons.location_on,
                                    color: Color.fromARGB(255, 244, 67, 54),
                                    size: 40.0,
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                MyCustomAsyncButton(
                  btnText: "Change To Here",
                  btnWidth: cardW * 0.9,
                  btnOnTap: () async {
                    try {
                      await DriverRepo.updateCurrentLocation(lat: pickedLocation!.latitude, long: pickedLocation!.longitude);

                      MyCustomSnackBar(
                              duration: Duration(milliseconds: 700),
                              // ignore: use_build_context_synchronously
                              context: context,
                              bgColor: Colors.green,
                              leadingIcon: Icons.check_box,
                              leadingIconColor: Colors.white,
                              message: 'Location Changed')
                          .show();
                    } catch (err) {
                      MyCustomSnackBar(
                              duration: Duration(milliseconds: 700),
                              // ignore: use_build_context_synchronously
                              context: context,
                              bgColor: const Color.fromARGB(255, 189, 20, 7),
                              leadingIcon: Icons.error,
                              leadingIconColor: Colors.white,
                              message: err.toString())
                          .show();
                    }
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
