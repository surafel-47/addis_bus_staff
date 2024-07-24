// ignore_for_file: file_names, non_constant_identifier_names

import 'package:intl/intl.dart';

class MyUtils {
  static String BASE_URL = 'http://192.168.8.118:3000';

  static String formatTimeOnly(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('hh:mm a').format(dateTime);
  }

  static String formateDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('MMM dd,yyyy HH:mm a').format(dateTime);
  }

  static void validatePin(String pin) {
    // Regular expression for a 4-digit numeric PIN code
    RegExp pinRegex = RegExp(r'^\d{4}$');

    // Check if the input pin matches the regex pattern
    if (!pinRegex.hasMatch(pin)) {
      throw 'Invalid PIN code. Please enter a 4-digit numeric PIN.';
    }
  }
}
