// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, file_names, prefer_interpolation_to_compose_strings

import 'package:addis_bus_mgt/Widgets/CustomWidgets/CustomeWidgets.dart';
import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

import '../../../Repositories/CashierRepo.dart';
import '../../../Repositories/Localizations.dart';
import '../../../Repositories/ScreenColors.dart';
import '../../CustomWidgets/LoadingError.dart';
import '../../Drivers/DriverScreens/DHomeScreen/AwaitingTaskScreen.dart';

class CashierCurrentRouteScreen extends StatefulWidget {
  const CashierCurrentRouteScreen({super.key});

  @override
  State<CashierCurrentRouteScreen> createState() => _CashierCurrentRouteScreenState();
}

class _CashierCurrentRouteScreenState extends State<CashierCurrentRouteScreen> {
  Future<dynamic>? fetchedData;
  Future<void> fetchPageData() async {
    try {
      fetchedData = await Future.value(CashierRepo.getCurrentRouteCashier());
    } catch (e) {
      fetchedData = Future.error(e); // Set fetchedData to an error future
    }
    setState(() {}); // Trigger a rebuild
  }

  @override
  void initState() {
    super.initState();
    fetchPageData();
  }

  @override
  Widget build(BuildContext context) {
    final locMgrProv = Provider.of<LocalizationManager>(context, listen: true);

    return LayoutBuilder(builder: (context, constraints) {
      double cardW = constraints.maxWidth;
      double cardH = constraints.maxHeight;
      return SizedBox(
        height: cardH,
        child: Stack(
          children: [
            Positioned.fill(
              child: AsyncBuilder(
                future: fetchedData,
                waiting: (context) {
                  return SizedBox(width: cardW, height: cardH, child: Center(child: CircularProgressIndicator()));
                },
                error: (context, error, stackTrace) {
                  return SizedBox(
                    width: double.infinity,
                    child: LoadingErrorScreen(
                      onPressed: () {},
                    ),
                  );
                },
                builder: (context, result) {
                  if (result['driver'] == null) {
                    return Center(child: Text("No Driver Assigned For you :("));
                  } else if (result['current_route'] == null || result['current_route']['route_started'] == false) {
                    return AwaitingTaskScreen();
                  } else {
                    return Column(
                      children: [
                        SizedBox(height: 45),
                        SizedBox(
                          width: cardW * 0.9,
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
                                      result['current_route']['route_name'] ?? "",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    trailing: Icon(Icons.document_scanner),
                                  ),
                                ),
                                SizedBox(
                                  child: ListTile(
                                    leading: Icon(Icons.airplane_ticket_outlined),
                                    title: Text(
                                      locMgrProv.getText('total_tickets_scanned'),
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    subtitle: Text(
                                      result['current_route']['scanned_ticket_count']?.toString() ?? "0",
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: ListTile(
                                    leading: Icon(Icons.monetization_on_outlined),
                                    title: Text(
                                      locMgrProv.getText('total_cash'),
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    subtitle: Text(
                                      "${result['current_route']['total_cash_collected']?.toString() ?? "0"} ${locMgrProv.getText('birr')}",
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        InkWell(
                          onTap: () async {
                            try {
                              String ticketId = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.QR);

                              dynamic result = await CashierRepo.scanTicket(ticketId);

                              showDialog(
                                context: context,
                                builder: (BuildContext context2) {
                                  return Center(
                                    child: SizedBox(
                                      width: cardW * 0.8,
                                      height: cardH * 0.34,
                                      child: Card(
                                        elevation: 6,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              child: ListTile(
                                                leading: Icon(Icons.file_copy_outlined),
                                                title: Text(
                                                  "Name: " + result['customer_info']['name'],
                                                  style: TextStyle(fontSize: 15),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              child: ListTile(
                                                leading: Icon(Icons.people_alt),
                                                title: Text(
                                                  'Number of People',
                                                  style: TextStyle(fontSize: 15),
                                                ),
                                                subtitle: Text(
                                                  result['current_ticket']['num_of_people'].toString(),
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              child: ListTile(
                                                leading: Icon(Icons.attach_money_outlined),
                                                title: Text(
                                                  'Price',
                                                  style: TextStyle(fontSize: 15),
                                                ),
                                                subtitle: Text(
                                                  "${result['current_ticket']['price']} Birr",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );

                              MyCustomSnackBar(
                                      context: context,
                                      message: "Ticket With ID $ticketId  Scanned",
                                      leadingIcon: Icons.check_box,
                                      bgColor: Colors.green,
                                      leadingIconColor: Colors.white)
                                  .show();
                            } on PlatformException {
                              throw 'Platform Doesnt Support QR Scan';
                            } catch (err) {
                              MyCustomSnackBar(
                                      duration: Duration(milliseconds: 700),
                                      context: context,
                                      bgColor: const Color.fromARGB(255, 189, 20, 7),
                                      leadingIcon: Icons.error,
                                      leadingIconColor: Colors.white,
                                      message: err.toString())
                                  .show();
                            }
                          },
                          child: Center(
                            child: Card(
                              elevation: 20,
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: MyColors.btnBgColor),
                                width: 250,
                                height: 250,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.document_scanner_outlined, color: Colors.white, size: 100),
                                    SizedBox(height: 20),
                                    Text(
                                      locMgrProv.getText('scan_ticket'),
                                      style: TextStyle(fontSize: 20, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  fetchPageData();
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
