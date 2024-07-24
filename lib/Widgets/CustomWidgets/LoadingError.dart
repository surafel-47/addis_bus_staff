// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, must_be_immutable, file_names

import 'package:flutter/material.dart';
import '../../Repositories/ScreenColors.dart';
import 'CustomeWidgets.dart';

class LoadingErrorScreen extends StatelessWidget {
  final VoidCallback onPressed;
  String title;
  String btnText;

  LoadingErrorScreen({required this.onPressed, this.title = "Unable to Fetch Page", this.btnText = "Tap to Try Again"});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 30),
        SizedBox(
          height: 250,
          width: 250,
          child: Image.asset('./assets/noConn.png'),
        ),
        SizedBox(height: 15),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 35),
        MyCustomAsyncButton(
          borderRadius: 10,
          backgroundColor: MyColors.whiteText,
          txtColor: MyColors.primaryColor,
          btnText: btnText,
          btnWidth: 200,
          btnOnTap: () async {
            onPressed();
          },
        ),
        SizedBox(height: 70),
      ],
    );
  }
}
