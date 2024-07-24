// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, use_key_in_widget_constructors, file_names

import 'dart:async';

import 'package:addis_bus_mgt/Repositories/DriverRepo.dart';
import 'package:addis_bus_mgt/Widgets/Drivers/DriverScreens/DHomeScreen/AwaitingTaskScreen.dart';
import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Repositories/Localizations.dart';
import '../../../CustomWidgets/LoadingError.dart';
import 'DrivingScreen.dart';
import 'StartDrivingScreen.dart';

class DHomeScreen extends StatefulWidget {
  const DHomeScreen({Key? key});

  @override
  State<DHomeScreen> createState() => _DHomeScreenState();
}

class _DHomeScreenState extends State<DHomeScreen> {
  Timer? timer;
  Future<dynamic>? fetchedData;

  Future<void> fetchPageData() async {
    try {
      fetchedData = await Future.value(DriverRepo.getCurrentRoute());
    } catch (e) {
      fetchedData = Future.error(e); // Set fetchedData to an error future
    }
    setState(() {}); // Trigger a rebuild
  }

  void startRepeatingMethod({time = 2}) {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    // Start a new timer
    timer = Timer.periodic(Duration(seconds: time), (timer) async {
      fetchPageData();
    });
  }

  void stopRepeatingMethod() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    startRepeatingMethod();
  }

  @override
  void dispose() {
    stopRepeatingMethod();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LocalizationManager>(context, listen: true);
    return LayoutBuilder(
      builder: (context, constraints) {
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
                    if (result['current_route'] == null) {
                      startRepeatingMethod(time: 5);
                      return AwaitingTaskScreen();
                    } else if (result['current_route']['route_started'] == false) {
                      stopRepeatingMethod();
                      return StartDrivingScreen(
                        cardData: result,
                        refershHomeScreenPageFunction: fetchPageData,
                      );
                    } else {
                      startRepeatingMethod(time: 20);
                      return DrivingScreen(
                        cardData: result,
                        refershHomeScreenPageFunction: fetchPageData,
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
      },
    );
  }
}
