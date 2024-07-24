// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, use_key_in_widget_constructors, use_build_context_synchronously, file_names

import 'package:addis_bus_mgt/Models/CashierModel.dart';
import 'package:addis_bus_mgt/Repositories/CashierRepo.dart';
import 'package:addis_bus_mgt/Repositories/ScreenColors.dart';
import 'package:addis_bus_mgt/Widgets/CustomWidgets/CustomeWidgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Repositories/Localizations.dart';
import '../../../Repositories/myUtiils.dart';
import '../../OnBoarding/LoginScreen.dart';

class CMyAccountScreen extends StatelessWidget {
  TextEditingController fullnameCtr = TextEditingController();
  TextEditingController cashierId = TextEditingController();
  TextEditingController phoneNoCtr = TextEditingController();
  TextEditingController pinCodeCtr = TextEditingController();
  CMyAccountScreen() {
    fullnameCtr.text = "Abebe Kebede";
    cashierId.text = "GCFF33F";
    phoneNoCtr.text = "0964123123";
    pinCodeCtr.text = "3323";
  }

  @override
  Widget build(BuildContext context) {
    final locMgrProv = Provider.of<LocalizationManager>(context, listen: true);
    fullnameCtr.text = CashierRepo.cashierModel.name;
    cashierId.text = CashierRepo.cashierModel.cashierId;
    phoneNoCtr.text = CashierRepo.cashierModel.phoneNo;
    pinCodeCtr.text = CashierRepo.cashierModel.pin;

    return LayoutBuilder(
      builder: (context, constraints) {
        double cardW = constraints.maxWidth;
        double cardH = constraints.maxHeight;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          width: cardW,
          height: cardH,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(52, 0, 0, 0),
                    ),
                    child: InkWell(
                      onTap: () {
                        if (locMgrProv.currentLanguage == 'en') {
                          locMgrProv.changeLanguage('am');
                        } else {
                          locMgrProv.changeLanguage('en');
                        }
                      },
                      child: Text(
                        locMgrProv.currentLanguage == 'en' ? 'en' : 'አማ',
                        style: TextStyle(fontFamily: 'NotoSansEthiopic', color: MyColors.whiteText, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(52, 0, 0, 0),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.login_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        CashierRepo.cashierModel = CashierModel();
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
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  CircleAvatar(
                    minRadius: 40,
                    backgroundColor: MyColors.btnBgColor,
                    backgroundImage: AssetImage("./assets/person.png"),
                    foregroundImage: NetworkImage("${MyUtils.BASE_URL}/ProfileImages/${CashierRepo.cashierModel.cashierImg}"),
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
                txtController: cashierId,
                // hintText: locMgrProv.getText('cashier_id'),
                leadingIcon: Icons.file_copy_rounded,
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
              //   MyCustomTextField(
              //     backgroundColor: Color.fromARGB(255, 101, 100, 200),
              //     txtBoxEnabled: false,
              //     txtColor: const Color.fromARGB(255, 255, 255, 255),
              //     txtController: pinCodeCtr,
              //     // hintText: locMgrProv.getText('pin_code'),
              //     leadingIcon: Icons.key,
              //   ),
              SizedBox(height: 20),
              Expanded(child: SizedBox()),
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

                                    await CashierRepo.changeCashierPin(newPin);

                                    CashierRepo.cashierModel.pin = newPin;

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
