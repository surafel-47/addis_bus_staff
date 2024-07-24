// ignore_for_file: file_names

class DriverModel {
  String objectId;
  String driverId;
  String name;
  String phoneNo;
  String assignedBusId;
  String driverImg;
  String pin;

  DriverModel({
    this.objectId = '',
    this.driverId = '',
    this.name = '',
    this.phoneNo = '',
    this.assignedBusId = '',
    this.driverImg = '',
    this.pin = '',
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      objectId: json['_id'] ?? '',
      driverId: json['driver_id'] ?? '',
      name: json['name'] ?? '',
      phoneNo: json['phone_no'] ?? '',
      assignedBusId: json['assigned_bus_id'] ?? '',
      driverImg: json['driver_img'] ?? '',
      pin: json['pin'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': objectId,
      'driver_id': driverId,
      'name': name,
      'phone_no': phoneNo,
      'assigned_bus_id': assignedBusId,
      'driver_img': driverImg,
      'pin': pin,
    };
  }

  void printDriverDetails() {
    // print('Object ID: $objectId');
    // print('Driver ID: $driverId');
    // print('Name: $name');
    // print('Phone Number: $phoneNo');
    // print('Assigned Bus ID: $assignedBusId');
    // print('Driver Image: $driverImg');
    // print('PIN: $pin');
  }
}
