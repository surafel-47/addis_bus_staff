// ignore_for_file: file_names

class CashierModel {
  String objectId;
  String pin;
  String cashierId;
  String name;
  String phoneNo;
  String cashierImg;

  CashierModel({
    this.objectId = '',
    this.pin = '',
    this.cashierId = '',
    this.name = '',
    this.phoneNo = '',
    this.cashierImg = '',
  });

  factory CashierModel.fromJson(Map<String, dynamic> json) {
    return CashierModel(
      objectId: json['_id'] ?? '',
      pin: json['pin'] ?? '',
      cashierId: json['cashier_id'] ?? '',
      name: json['name'] ?? '',
      phoneNo: json['phone_no'] ?? '',
      cashierImg: json['cashier_img'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': objectId,
      'pin': pin,
      'cashier_id': cashierId,
      'name': name,
      'phone_no': phoneNo,
      'cashier_img': cashierImg,
    };
  }

  void printCashierDetails() {
    // print('Object ID: $objectId');
    // print('PIN: $pin');
    // print('Cashier ID: $cashierId');
    // print('Name: $name');
    // print('Phone Number: $phoneNo');
    // print('Cashier Image: $cashierImg');
  }
}
