// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../Repositories/Localizations.dart';

class AwaitingTaskScreen extends StatelessWidget {
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
              SizedBox(height: 60),
              Text(
                locMgrProv.getText("no_route_assigned"),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(46, 0, 0, 0),
                ),
                height: cardH * 0.5,
                width: cardH * 0.5,
                child: Lottie.asset(
                  './assets/empty.json',
                ),
              ),
              SizedBox(height: 20),
              Text(
                locMgrProv.getText("await_please"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
