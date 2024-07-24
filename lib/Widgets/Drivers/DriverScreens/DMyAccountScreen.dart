// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, use_key_in_widget_constructors, must_be_immutable, file_names

import 'dart:async';

import 'package:addis_bus_mgt/Repositories/DriverRepo.dart';
import 'package:addis_bus_mgt/Repositories/ScreenColors.dart';
import 'package:addis_bus_mgt/Widgets/CustomWidgets/CustomeWidgets.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../../../Repositories/Localizations.dart';
import '../../../Repositories/myUtiils.dart';
import 'CustomLocationPicker.dart';

class MyAccountScreen extends StatefulWidget {
  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  TextEditingController fullnameCtr = TextEditingController();
  TextEditingController driverIdCtr = TextEditingController();
  TextEditingController busIdCtr = TextEditingController();
  TextEditingController phoneNoCtr = TextEditingController();
  TextEditingController pinCodeCtr = TextEditingController();

  bool liveTrackingEnabled = true;
  Timer? timer;
  LatLng myLocationData = LatLng(9.00918155121011, 38.7425202484769);

  @override
  void initState() {
    super.initState();
    startRepeatedMethod();
  }

  @override
  void dispose() {
    super.dispose();
    stopRepeatedMethod();
  }

  void toggleSwitch(bool value) {
    setState(() {
      liveTrackingEnabled = value;
    });
    if (liveTrackingEnabled) {
      startRepeatedMethod();
    } else {
      stopRepeatedMethod();
    }
  }

  void startRepeatedMethod() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    timer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      try {
        //get user location
        Location location = Location();

        bool serviceEnabled;
        PermissionStatus permissionGranted;

        serviceEnabled = await location.serviceEnabled();
        if (!serviceEnabled) {
          serviceEnabled = await location.requestService();
          if (!serviceEnabled) {
            throw 'Location not Enabled';
          }
        }

        permissionGranted = await location.hasPermission();
        if (permissionGranted == PermissionStatus.denied) {
          permissionGranted = await location.requestPermission();
          if (permissionGranted != PermissionStatus.granted) {
            throw 'Location Permisson not Granted';
          }
        }

        LocationData locationData = await location.getLocation();

        double deviceLat = locationData.latitude ?? 0;
        double deviceLng = locationData.longitude ?? 0;
        // print(deviceLat.toString() + " " + deviceLng.toString());

        //get routes that pass by that station

        // await Future.delayed(Duration(milliseconds: 300));

        // final random = Random();
        // // Generate random offsets
        // final double latOffset = (random.nextDouble() - 0.5) * 0.00063; // approximately within 70 meters
        // final double longOffset = (random.nextDouble() - 0.5) * 0.00063; // approximately within 70 meters

        // // Apply offsets to original location
        // myLocationData = LatLng(myLocationData.latitude + latOffset, myLocationData.longitude + longOffset);

        myLocationData = LatLng(deviceLat, deviceLng);

        await DriverRepo.updateCurrentLocation(long: myLocationData.longitude, lat: myLocationData.latitude);
      } catch (err) {
        // print(err);
        MyCustomSnackBar(
                duration: Duration(milliseconds: 400),
                context: context,
                bgColor: const Color.fromARGB(255, 189, 20, 7),
                leadingIcon: Icons.location_off_outlined,
                leadingIconColor: Colors.white,
                message: err.toString())
            .show();
      }
      setState(() {});
    });
  }

  void stopRepeatedMethod() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locMgrProv = Provider.of<LocalizationManager>(context, listen: true);
    fullnameCtr.text = DriverRepo.driverModel.name;
    driverIdCtr.text = DriverRepo.driverModel.driverId;
    busIdCtr.text = DriverRepo.driverModel.assignedBusId;
    phoneNoCtr.text = DriverRepo.driverModel.phoneNo;
    pinCodeCtr.text = DriverRepo.driverModel.pin;

    return LayoutBuilder(
      builder: (context, constraints) {
        double cardW = constraints.maxWidth;
        double cardH = constraints.maxHeight;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: cardW * 0.07),
          width: cardW,
          height: cardH,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Row(
                children: [
                  Card(
                    color: Colors.transparent,
                    elevation: 10,
                    child: CircleAvatar(
                      minRadius: 40,
                      backgroundColor: MyColors.btnBgColor,
                      backgroundImage: AssetImage("./assets/person.png"),
                      foregroundImage: NetworkImage("${MyUtils.BASE_URL}/ProfileImages/${DriverRepo.driverModel.driverImg}"),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    locMgrProv.getText('my_account'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              MyCustomTextField(
                backgroundColor: Color.fromARGB(255, 101, 100, 200),
                txtBoxEnabled: false,
                txtColor: const Color.fromARGB(255, 255, 255, 255),
                txtController: fullnameCtr,
                // hintText: locMgrProv.getText('full_name_text'),
                leadingIcon: Icons.person,
              ),
              SizedBox(height: 10),
              MyCustomTextField(
                backgroundColor: Color.fromARGB(255, 101, 100, 200),
                txtBoxEnabled: false,
                txtColor: const Color.fromARGB(255, 255, 255, 255),
                txtController: driverIdCtr,
                // hintText: locMgrProv.getText('driver_id'),
                leadingIcon: Icons.file_copy_rounded,
              ),
              SizedBox(height: 10),
              MyCustomTextField(
                backgroundColor: Color.fromARGB(255, 101, 100, 200),
                txtBoxEnabled: false,
                txtColor: const Color.fromARGB(255, 255, 255, 255),
                txtController: busIdCtr,
                // hintText: locMgrProv.getText('bus_id'),
                leadingIcon: Icons.bus_alert_outlined,
              ),
              SizedBox(height: 10),
              MyCustomTextField(
                backgroundColor: Color.fromARGB(255, 101, 100, 200),
                txtBoxEnabled: false,
                txtColor: const Color.fromARGB(255, 255, 255, 255),
                txtController: phoneNoCtr,
                // hintText: locMgrProv.getText('phone_number_text'),
                leadingIcon: Icons.phone,
              ),
              SizedBox(height: 10),
              SizedBox(height: 10),
              Card(
                child: ListTile(
                  contentPadding: EdgeInsets.all(4),
                  leading: IconButton(
                    icon: Icon(Icons.location_on_outlined),
                    onPressed: () async {
                      dynamic result = [];
                      try {
                        result = await DriverRepo.getAllStations();
                        result = result['stations_list'] ?? [];
                      } catch (err) {
                        //
                      }
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return CustomLocationPicker(stationsList: result);
                        },
                      ));
                    },
                  ),
                  title: Text(
                    "Live Tracking",
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                  ),
                  trailing: SizedBox(
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'OFF',
                          style: TextStyle(
                            fontSize: 12,
                            color: liveTrackingEnabled ? Colors.grey : Colors.blue,
                          ),
                        ),
                        Switch(
                          value: liveTrackingEnabled,
                          onChanged: toggleSwitch,
                          activeColor: Colors.blue,
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey[300],
                        ),
                        Text(
                          'ON',
                          style: TextStyle(
                            fontSize: 12,
                            color: liveTrackingEnabled ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(),
              MyCustomAsyncButton(
                  btnWidth: cardW * 0.9,
                  btnText: locMgrProv.getText('change_pin'),
                  btnOnTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context2) {
                        TextEditingController newPinCtr = TextEditingController();
                        return AlertDialog(
                          icon: Icon(Icons.warning_amber_rounded),
                          title: Text(locMgrProv.getText('confirm_action')),
                          content: MyCustomTextField(
                            fieldWidth: 200,
                            textInputType: TextInputType.number,
                            txtColor: Colors.black,
                            txtController: newPinCtr,
                            hintText: locMgrProv.getText('new_pin_code'),
                            leadingIcon: Icons.key,
                          ),
                          actions: <Widget>[
                            MyCustomAsyncButton(
                                btnText: locMgrProv.getText('confirm'),
                                btnOnTap: () async {
                                  try {
                                    FocusScope.of(context2).unfocus();

                                    String newPin = newPinCtr.text.trim();

                                    MyUtils.validatePin(newPin);

                                    await DriverRepo.changeDriverPin(newPin);

                                    DriverRepo.driverModel.pin = newPin;

                                    MyCustomSnackBar(context: context, message: "Pin Changed", leadingIcon: Icons.check_box, bgColor: Colors.green, leadingIconColor: Colors.white)
                                        .show();
                                  } catch (err) {
                                    MyCustomSnackBar(context: context, message: err.toString(), leadingIcon: Icons.close_rounded).show();
                                  }
                                  Navigator.pop(context2);
                                })
                          ],
                        );
                      },
                    );
                  }),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
