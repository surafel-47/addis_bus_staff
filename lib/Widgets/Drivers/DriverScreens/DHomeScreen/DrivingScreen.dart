// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, use_key_in_widget_constructors, file_names, must_be_immutable

import 'package:addis_bus_mgt/Repositories/DriverRepo.dart';
import 'package:addis_bus_mgt/Repositories/ScreenColors.dart';
import 'package:addis_bus_mgt/Widgets/CustomWidgets/CustomeWidgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../../../../Repositories/Localizations.dart';
import '../../../CustomWidgets/DriverMap.dart';

class DrivingScreen extends StatelessWidget {
  dynamic cardData;
  final void Function() refershHomeScreenPageFunction;

  DrivingScreen({required this.cardData, required this.refershHomeScreenPageFunction});

  @override
  Widget build(BuildContext context) {
    final locMgrProv = Provider.of<LocalizationManager>(context, listen: true);
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardW = constraints.maxWidth;
        double cardH = constraints.maxHeight;
        return Container(
          width: cardW,
          height: cardH,
          color: Color.fromARGB(20, 0, 0, 0),
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                locMgrProv.getText("new_route"),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: cardW * 0.9,
                child: Card(
                  elevation: 6,
                  child: Column(
                    children: [
                      SizedBox(
                        child: ListTile(
                          leading: Icon(Icons.route_outlined),
                          title: Text(
                            cardData['current_route']['route_name'],
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${locMgrProv.getText('route')} -> ${cardData['current_route']['route_id']}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyColors.btnBgColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return DriverMap(
                                    stationsList: cardData['stations_list'],
                                    drawPolylines: true,
                                    title: "${cardData['current_route']['route_name'] ?? ""} ${locMgrProv.getText("Route")}",
                                    subTitle: "Your Current Assigned Route",
                                  );
                                },
                              ));
                            },
                            child: Text(
                              locMgrProv.getText('view_map'),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${locMgrProv.getText('num_of_stations')}: ${cardData['stations_list'].length}   ",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Icon(Icons.bus_alert_outlined),
                          SizedBox(width: 20),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  elevation: 1,
                  color: Color.fromARGB(21, 0, 0, 0),
                  child: SizedBox(
                    width: cardW * 0.75,
                    child: ListView.builder(
                      itemCount: cardData['stations_list'].length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 6,
                          child: Column(
                            children: [
                              SizedBox(
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(4),
                                  leading: Icon(Icons.route_outlined),
                                  title: Text(
                                    cardData['stations_list'][index]['station_name'],
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    locMgrProv.getText('station'),
                                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                                  ),
                                  trailing: SizedBox(
                                    width: cardW * 0.3,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.bus_alert_outlined),
                                            Icon(Icons.arrow_back),
                                            Icon(Icons.person),
                                            Text(
                                              cardData['stations_list'][index]['in'].toString(),
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
                                              cardData['stations_list'][index]['out'].toString(),
                                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: cardW * 0.9,
                child: SlideAction(
                  borderRadius: 15,
                  text: locMgrProv.getText('mark_as_completed'),
                  onSubmit: () async {
                    try {
                      Navigator.push(
                        context,
                        DialogRoute(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return PopScope(
                              canPop: false,
                              child: Material(
                                color: Colors.transparent,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Completing Route",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(height: 10),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );

                      await DriverRepo.completeCurrentRoute();

                      await Future.delayed(Durations.extralong1);

                      Navigator.pop(context);
                    } catch (err) {
                      Navigator.pop(context);
                      MyCustomSnackBar(
                              duration: Duration(milliseconds: 700),
                              context: context,
                              bgColor: const Color.fromARGB(255, 189, 20, 7),
                              leadingIcon: Icons.error,
                              leadingIconColor: Colors.white,
                              message: err.toString())
                          .show();
                    } finally {
                      refershHomeScreenPageFunction();
                    }
                  },
                  innerColor: Colors.white,
                  outerColor: Color.fromARGB(255, 105, 89, 250),
                  sliderRotate: false,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
