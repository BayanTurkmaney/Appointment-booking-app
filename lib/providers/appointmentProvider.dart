import 'dart:async';
import 'dart:convert';

import 'package:booking_app/models/appointment.dart';
import 'package:booking_app/utils/server_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Appointments with ChangeNotifier {
  List<Appointment> _appointments = [];
  Map<String, String> _appointmentData = {};
  List<Map<String, String>> _appointmentsData = [];
  List<String> _servicesIds = [];

  bool addServiceId({
    required String serviceId,
  }) {
    if (!_servicesIds.contains(serviceId)) {
      _servicesIds.add(serviceId);
      return true;
    }
    return false;
  }

  Future<List<Appointment>> employeeAppointments({
    required bool firstTime,
    required String employeeId,
  }) async {
    if (firstTime) await _getAppointmentsByEmployee(employeeId: employeeId);
    return [..._appointments];
  }

  Future<List<Appointment>> _getAppointmentsByEmployee({
    required String employeeId,
  }) async {
    _appointments.clear();

    var _response = await http.get(
      Uri.parse(
        ServerInfo.APPOINTMENTS + '?total=true&sort=1&employee=$employeeId',
      ),
    );

    var _data = json.decode(_response.body);
    if (_response.statusCode == 200) {
      List<dynamic> _tmpAppointmentsData = _data['data'];

      _tmpAppointmentsData.forEach((appointment) {
        _appointments.add(
          Appointment(
            date: appointment['date'],
            employeeId: employeeId,
            history: appointment['history'].toString(),
            id: appointment['_id'],
            institutionId: appointment['institution']['_id'],
            servicesIds: (appointment['service'] as List)
                .map((e) => e['_id'].toString())
                .toList(),
            userId: appointment['user'],
          ),
        );
      });
    }

    return [..._appointments];
  }

  Future<List<Appointment>> getAppointmentsByUser({
    required String? userId,
  }) async {
    _appointments.clear();

    var _response = await http.get(
      Uri.parse(
        ServerInfo.APPOINTMENTS + '?total=true&sort=1&user=$userId',
      ),
    );

    var _data = json.decode(_response.body);
    if (_response.statusCode == 200) {
      List<dynamic> _tmpAppointmentsData = _data['data'];

      _tmpAppointmentsData.forEach((appointment) {
        _appointments.add(
          Appointment(
            date: appointment['date'],
            employeeId: appointment['employee']['_id'],
            history: appointment['history'].toString(),
            id: appointment['_id'],
            institutionId: appointment['institution']['_id'],
            servicesIds: (appointment['service'] as List)
                .map((e) => e['_id'].toString())
                .toList(),
            userId: userId!,
          ),
        );
      });
    }

    return [..._appointments];
  }

  List<String> get servicesIds {
    return [..._servicesIds];
  }

  void setValue({
    required String key,
    required String value,
  }) {
    _appointmentData[key] = value;
  }

  Map<String, dynamic> get appointmentsData {
    return {..._appointmentData};
  }

  Future<List<Appointment>> appointments({
    required String institutionId,
  }) async {
    _appointments.clear();

    var _response = await http.get(
      Uri.parse(
        ServerInfo.APPOINTMENTS +
            '?total=true&sort=1&institution=$institutionId',
      ),
    );

    if (_response.statusCode == 200) {
      var _data = json.decode(_response.body);

      List<dynamic> _tmpAppointments = _data['data'];

      _tmpAppointments.forEach((appointment) {
        _appointments.add(
          Appointment(
            id: appointment['_id'],
            date: appointment['date'],
            institutionId: appointment['institution']['_id'],
            employeeId: appointment['employee']['_id'],
            userId: appointment['user'],
            servicesIds: (appointment['service'] as List)
                .map((e) => e['_id'].toString())
                .toList(),
            history: appointment['history'].toString(),
          ),
        );
      });
    }

    return [..._appointments];
  }

  Future<List<dynamic>> deleteAppointment({
    required String appointmentId,
    required String token,
  }) async {
    try {
      var _response = await http.delete(
        Uri.parse(
          ServerInfo.APPOINTMENTS + '/$appointmentId',
        ),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      if (_response.statusCode == 200) {
        _appointments.removeWhere(
          (appointment) => appointment.id == appointmentId,
        );

        return [true];
      } else {
        var _data = json.decode(_response.body);
        return [false, _data['msg']];
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<dynamic>> addAppointmentsAndPayForServices({
    required String token,
  }) async {
    List<dynamic> _addingList = await _addAppointments(token: token);

    List<dynamic> _payingList = await _payForServices(
      token: token,
      institutionId: _appointmentData['institutionId']!,
      userId: _appointmentData['userId']!,
    );

    if (_addingList[0]) {
      if (_payingList[0]) {
        _appointmentsData.clear();
        _appointmentData.clear();
        _servicesIds.clear();
        return [true];
      } else {
        return [false, _payingList[1]];
      }
    } else {
      return [false, _addingList[1]];
    }
  }

  Future<List<dynamic>> _payForServices({
    required String token,
    required String userId,
    required String institutionId,
  }) async {
    var _response = await http.post(
      Uri.parse(
        ServerInfo.PAYMENTS + '/pay/$userId',
      ),
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "services": _servicesIds,
        "institution": institutionId,
      }),
    );

    if (_response.statusCode == 200) {
      return [true];
    } else {
      var _data = json.decode(_response.body);
      if (_data['msg'] != null)
        return [false, _data['msg']];
      else
        return [false, _data['err'][0]['message']];
    }
  }

  Future<List<dynamic>> _addAppointments({
    required String token,
  }) async {
    var _response;
    bool _result = true;
    var _data;

    _appointmentsData.forEach((data) async {
      var _body = {
        'history': DateTime.now().toIso8601String(),
      };

      _body.addAll(data);

      _response = await http.post(
        Uri.parse(
          ServerInfo.APPOINTMENTS,
        ),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: _body,
      );
      if (_response.statusCode == 200) {
        _result = true;
      } else {
        _result = false;
        _data = json.decode(_response.body);
      }
    });

    if (_result) {
      return [true];
    } else {
      return [false, _data['msg']];
    }
  }
}
