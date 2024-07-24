// ignore_for_file: file_names, unused_catch_clause, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Models/CashierModel.dart';
import 'myUtiils.dart';

class CashierRepo extends ChangeNotifier {
  static CashierModel cashierModel = CashierModel();

  static Future<dynamic> changeCashierPin(String newPin) async {
    final String url = '${MyUtils.BASE_URL}/staffApi/changeCashierPin?cashier_obj_id=${cashierModel.objectId}&new_pin=$newPin';

    return fetchData(Url: url);
  }

  static Future<dynamic> getCurrentRouteCashier() async {
    final String url = '${MyUtils.BASE_URL}/staffApi/getCurrentRouteCashier?cashier_obj_id=${cashierModel.objectId}';

    return fetchData(Url: url);
  }

  static Future<dynamic> scanTicket(String ticketId) async {
    final String url = '${MyUtils.BASE_URL}/staffApi/scanTicket?cashier_obj_id=${cashierModel.objectId}&ticket_id=$ticketId';

    return fetchData(Url: url);
  }

  //----------------------------------------------------------------------------------------------------
  //----------------------Fetch Method for all Requests-----------------------------------
  static Future<dynamic> fetchData({
    String requestType = 'GET',
    required String Url,
    Map<String, String>? headers,
    dynamic body,
  }) async {
    http.Response response;

    Duration timeOutDuration = const Duration(seconds: 5);

    try {
      if (requestType == 'GET') {
        response = await http.get(Uri.parse(Url), headers: headers).timeout(timeOutDuration, onTimeout: () {
          throw const SocketException('Request timed out');
        });
      } else if (requestType == 'POST') {
        response = await http
            .post(
          Uri.parse(Url),
          headers: headers,
          body: json.encode(body),
        )
            .timeout(timeOutDuration, onTimeout: () {
          throw const SocketException('Request timed out');
        });
      } else {
        throw Exception('Invalid request type');
      }

      if (response.statusCode == 200) {
        dynamic data = json.decode(response.body);
        return data;
      } else {
        Map<String, dynamic> errorData = json.decode(response.body);
        throw errorData['msg'].toString();
      }
    } on SocketException catch (e) {
      throw 'Unable to Connect  (S)';
    } on HttpException catch (e) {
      throw 'Unable to Connect (H)';
    } on FormatException catch (e) {
      throw 'FormatException';
    } catch (e) {
      throw '$e';
    }
  }
}
