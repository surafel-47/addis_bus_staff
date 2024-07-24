// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, file_names, use_key_in_widget_constructors

import 'package:addis_bus_mgt/Models/DriverModel.dart';
import 'package:addis_bus_mgt/Widgets/OnBoarding/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Repositories/DriverRepo.dart';
import '../../../Repositories/Localizations.dart';
import '../../../Repositories/ScreenColors.dart';
import '../../../Repositories/myUtiils.dart';

class MyDrawer extends StatelessWidget {
  double scrH = 0, scrW = 0;
  final void Function(int index) onTapItem;
  MyDrawer({required this.onTapItem});

  @override
  Widget build(BuildContext context) {
    final locMgrProv = Provider.of<LocalizationManager>(context, listen: true);

    scrH = MediaQuery.of(context).size.height;
    scrW = MediaQuery.of(context).size.width;

    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: scrH * 0.28,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/person.png"),
                      foregroundImage: NetworkImage("${MyUtils.BASE_URL}/ProfileImages/${DriverRepo.driverModel.driverImg}"),
                      backgroundColor: Color.fromARGB(255, 17, 29, 163),
                      radius: scrH * 0.05,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      title: Text(
                        DriverRepo.driverModel.name,
                        style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.phone,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      title: Text(
                        DriverRepo.driverModel.phoneNo,
                        style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                onTapItem(2);
                Navigator.of(context).pop();
              },
              child: ListTile(
                leading: Icon(Icons.person, size: scrW * 0.08),
                title: Text(locMgrProv.getText("my_account"), style: TextStyle(fontSize: scrW * 0.045, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                onTapItem(0);
                Navigator.of(context).pop();
              },
              child: ListTile(
                leading: Icon(Icons.rotate_90_degrees_cw_outlined, size: scrW * 0.08),
                title: Text(locMgrProv.getText("current_route"), style: TextStyle(fontSize: scrW * 0.045, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                onTapItem(1);
                Navigator.of(context).pop();
              },
              child: ListTile(
                leading: Icon(Icons.history, size: scrW * 0.08),
                title: Text(locMgrProv.getText("route_history"), style: TextStyle(fontSize: scrW * 0.045, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                if (locMgrProv.currentLanguage == 'en') {
                  locMgrProv.changeLanguage('am');
                } else {
                  locMgrProv.changeLanguage('en');
                }
              },
              child: ListTile(
                leading: Icon(Icons.language_outlined, size: scrW * 0.08),
                title: Text(locMgrProv.getText("language"), style: TextStyle(fontSize: scrW * 0.045, fontWeight: FontWeight.bold)),
                trailing: Container(
                  alignment: Alignment.center,
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color.fromARGB(52, 0, 0, 0),
                  ),
                  child: Text(
                    locMgrProv.currentLanguage == 'en' ? 'en' : 'አማ',
                    style: TextStyle(fontFamily: 'NotoSansEthiopic', color: MyColors.whiteText, fontSize: 16),
                  ),
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            InkWell(
              onTap: () {
                DriverRepo.driverModel = DriverModel();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        home: LoginInScreen(),
                      );
                    },
                  ),
                  (route) => false,
                );
              },
              child: ListTile(
                leading: Icon(Icons.logout, size: scrW * 0.08, color: Colors.black),
                title: Text(locMgrProv.getText('log_out'), style: TextStyle(fontSize: scrW * 0.045, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
