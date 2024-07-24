// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, file_names

import 'package:addis_bus_mgt/Repositories/DriverRepo.dart';
import 'package:addis_bus_mgt/Repositories/myUtiils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../Repositories/Localizations.dart';

class RouteHistoryScreen extends StatefulWidget {
  @override
  State<RouteHistoryScreen> createState() => _RouteHistoryScreenState();
}

class _RouteHistoryScreenState extends State<RouteHistoryScreen> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final locMgrProv = Provider.of<LocalizationManager>(context, listen: true);

    return LayoutBuilder(
      builder: (context, constraints) {
        double cardW = constraints.maxWidth;
        double cardH = constraints.maxHeight;
        return SizedBox(
          width: cardW,
          height: cardH,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locMgrProv.getText('routes_completed'),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            _selectedDate.toString().substring(0, 10),
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: DriverRepo.getRouteHistory(_selectedDate),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(child: Center(child: CircularProgressIndicator()));
                  } else if (snapshot.hasError) {
                    return SizedBox(
                      width: cardW,
                      child: Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: cardH * 0.3,
                              width: cardH * 0.3,
                              child: Icon(
                                Icons.error_outline_outlined,
                                size: cardH * 0.25,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'Error: Unable To Fetch Data',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    if (snapshot.data!.isEmpty || snapshot.data!['routeHistoryList'].length == 0) {
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: cardH * 0.3,
                              width: cardH * 0.3,
                              child: Lottie.asset(
                                './assets/empty.json',
                              ),
                            ),
                            Text(
                              "Empty",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: cardH * 0.3),
                          ],
                        ),
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!['routeHistoryList'].length,
                          itemBuilder: (context, index) {
                            return RouteHistoryCard(cardData: snapshot.data!['routeHistoryList'][index]);
                          },
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class RouteHistoryCard extends StatelessWidget {
  Map<String, dynamic> cardData;
  RouteHistoryCard({required this.cardData});

  @override
  Widget build(BuildContext context) {
    final locMgrProv = Provider.of<LocalizationManager>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Card(
        elevation: 6,
        child: Column(
          children: [
            SizedBox(
              child: ListTile(
                leading: Icon(Icons.bus_alert_outlined),
                title: Text(
                  locMgrProv.getText('route_name'),
                  style: TextStyle(fontSize: 15),
                ),
                subtitle: Text(
                  cardData['route_name'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                trailing: Icon(Icons.document_scanner),
              ),
            ),
            SizedBox(
              child: ListTile(
                leading: Icon(Icons.document_scanner),
                title: Text(
                  "${locMgrProv.getText('total_tickets_scanned')}: ${cardData['scanned_ticket_count']}",
                  style: TextStyle(fontSize: 15),
                ),
                subtitle: Text(
                  "${locMgrProv.getText('total_cash')}:   ${cardData['total_cash_collected']} ${locMgrProv.getText('birr')}",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
                trailing: Icon(Icons.monetization_on_outlined),
              ),
            ),
            SizedBox(
              child: ListTile(
                leading: Icon(Icons.timelapse_outlined),
                title: Text(
                  "${locMgrProv.getText('start_time')}: ${MyUtils.formatTimeOnly(cardData['start_time'])}",
                  style: TextStyle(fontSize: 15),
                ),
                subtitle: Text(
                  "${locMgrProv.getText('end_time')}:   ${MyUtils.formatTimeOnly(cardData['end_time'])}",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
                trailing: Icon(Icons.lock_clock_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
