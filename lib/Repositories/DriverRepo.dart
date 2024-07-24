// ignore_for_file: file_names, unused_catch_clause, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Models/DriverModel.dart';
import 'myUtiils.dart';

class DriverRepo extends ChangeNotifier {
  static DriverModel driverModel = DriverModel();

  static Future<dynamic> getRouteHistory(DateTime date) async {
    final String url = '${MyUtils.BASE_URL}/staffApi/getRouteHistory?driver_obj_id=${driverModel.objectId}&selected_date=$date';

    return fetchData(Url: url);
  }

  static Future<dynamic> getCurrentRoute() async {
    final String url = '${MyUtils.BASE_URL}/staffApi/getCurrentRoute?driver_obj_id=${driverModel.objectId}';

    return fetchData(Url: url);
  }

  static Future<dynamic> getAllStations() async {
    final String url = '${MyUtils.BASE_URL}/staffApi/getAllStations';

    return fetchData(Url: url);
  }

  static Future<dynamic> getCurrentLocation() async {
    final String url = '${MyUtils.BASE_URL}/staffApi/getCurrentLocation?driver_obj_id=${driverModel.objectId}';

    return fetchData(Url: url);
  }

  static Future<dynamic> updateCurrentLocation({required double long, required double lat}) async {
    final String url = '${MyUtils.BASE_URL}/staffApi/updateCurrentLocation?driver_obj_id=${driverModel.objectId}&long=$long&lat=$lat';

    return fetchData(Url: url);
  }

  static Future<dynamic> getRouteStations(String routeId) async {
    final String url = '${MyUtils.BASE_URL}/staffApi/getRouteStations?route_id=$routeId';

    return fetchData(Url: url);
  }

  static Future<dynamic> startCurrentRoute() async {
    final String url = '${MyUtils.BASE_URL}/staffApi/startCurrentRoute?driver_obj_id=${driverModel.objectId}';

    return fetchData(Url: url);
  }

  static Future<dynamic> completeCurrentRoute() async {
    final String url = '${MyUtils.BASE_URL}/staffApi/completeCurrentRoute?driver_obj_id=${driverModel.objectId}';

    return fetchData(Url: url);
  }

  static Future<dynamic> changeDriverPin(String newPin) async {
    final String url = '${MyUtils.BASE_URL}/staffApi/changeDriverPin?driver_obj_id=${driverModel.objectId}&new_pin=$newPin';

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
