import 'dart:convert';

import 'package:booking_app/models/service.dart';
import 'package:booking_app/utils/server_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ServicesProvider with ChangeNotifier {
  Map<String, dynamic> _serviceData = {};
  List<Service> _services = [];

  Future<List<Service>> services({
    required String institutionId,
  }) async {
    _services.clear();
    try {
      var _response = await http.get(
        Uri.parse(
          ServerInfo.SERVICES + '/$institutionId/all',
        ),
      );

      if (_response.statusCode == 200) {
        var _data = json.decode(_response.body);

        List<dynamic> _tmpServices = _data['data'];

        _tmpServices.forEach((service) {
          _services.add(
            Service(
              institutionId: service['institution'],
              id: service['_id'],
              atLeast: service['atLeast'].toString() == 'true',
              category: service['category'],
              description: service['description'],
              hasRetainer: service['hasRetainer'].toString() == 'true',
              length: int.parse(service['length'].toString()),
              name: service['name'],
              price: double.parse(service['price'].toString()),
              retainer: int.parse(service['retainer'].toString()),
            ),
          );
        });
      }

      return [
        ..._services.where(
          (service) => service.institutionId == institutionId,
        ),
      ];
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Map<String, dynamic> get serviceData {
    return {..._serviceData};
  }

  void setServiceData({
    required Map<String, dynamic> newData,
  }) {
    _serviceData = newData;
  }

  Future<List<dynamic>> addService({
    required String institutionId,
    required String token,
  }) async {
    try {
      var response = await http.post(
        Uri.parse(ServerInfo.SERVICES),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: json.encode({
          "institution": institutionId,
          "name": _serviceData['sname'],
          "category": _serviceData['category'],
          "description": _serviceData['serviceDescription'],
          "length": _serviceData['duration'],
          "price": _serviceData['priceOfService'],
          "atLeast": _serviceData['atLeast'] ?? false,
          "retainer": _serviceData['retainer'] ?? 0,
          "hasRetainer": _serviceData['hasRetainer'] ?? false,
        }),
      );

      var result = json.decode(response.body);
      if (response.statusCode == 201) {
        return [true, result['data']['id']];
      } else {
        print('Service: $result');
        return [false, result['msg']];
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<dynamic>> updateService({
    required String token,
    required String serviceId,
  }) async {
    try {
      var response = await http.put(
        Uri.parse(ServerInfo.SERVICES + '/$serviceId'),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: json.encode({
          "name": _serviceData['sname'],
          "category": _serviceData['category'],
          "description": _serviceData['serviceDescription'],
          "length": _serviceData['duration'],
          "price": _serviceData['priceOfService'],
          "atLeast": _serviceData['atLeast'] ?? false,
          "retainer": _serviceData['retainer'] ?? 0,
          "hasRetainer": _serviceData['hasRetainer'] ?? false,
        }),
      );

      var result = json.decode(response.body);
      if (response.statusCode == 200) {
        return [true, result['data']['id']];
      } else {
        print('Service: $result');
        return [false, result['msg']];
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<dynamic>> deleteService({
    required String serviceId,
    required String token,
  }) async {
    var _response = await http.delete(
      Uri.parse(
        ServerInfo.SERVICES + '/$serviceId',
      ),
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (_response.statusCode == 200) {
      _services.removeWhere(
        (service) => service.id == serviceId,
      );

      return [true];
    } else {
      var result = json.decode(_response.body);
      print('Service: $result');
      return [false, result['msg']];
    }
  }

  Future<List<Service>> getAppointmentServicesByIds({
    required List<String> servicesIds,
  }) async {
    List<Service> _appointmentServices = [];

    servicesIds.forEach((serviceId) async {
      var _response = await http.get(
        Uri.parse(ServerInfo.SERVICES + '/$serviceId'),
      );

      if (_response.statusCode == 200) {
        var _tmpData = json.decode(_response.body);

        var _data = _tmpData['data'];

        _appointmentServices.add(
          Service(
            institutionId: _data['institution']['_id'],
            id: _data['_id'],
            atLeast: _data['atLeast'].toString() == 'true',
            category: _data['category'],
            description: _data['description'],
            hasRetainer: _data['hasRetainer'].toString() == 'true',
            length: int.parse(_data['length'].toString()),
            name: _data['name'],
            price: double.parse(_data['price'].toString()),
            retainer: int.parse(_data['retainer'].toString()),
          ),
        );
      }
    });

    return _appointmentServices;
  }
}
