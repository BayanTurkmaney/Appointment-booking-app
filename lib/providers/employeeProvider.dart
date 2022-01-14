import 'dart:convert';

import 'package:booking_app/models/employee.dart';
import 'package:booking_app/utils/server_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EmployeesProvider with ChangeNotifier {
  Employee? _employee;
  String? _token;
  String? _password;

  String? get password {
    return _password;
  }

  Future<void> setPassword() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _password = _prefs.getString('password');
  }

  Employee? get employee {
    return _employee;
  }

  String? get token {
    return _token;
  }

  Map<String, dynamic> _employeeData = {};
  List<Employee> _employees = [];

  Future<bool> isLoggedIn() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _token = _prefs.getString('employeeToken');
    return _token != null;
  }

  Future<void> setEmployee() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    _employee = Employee(
      firstName: _prefs.getString('firstName')!,
      lastName: _prefs.getString('lastName')!,
      email: _prefs.getString('email')!,
      photo: _prefs.getString('photo')!,
      institutionId: _prefs.getString('institutionId')!,
      id: _prefs.getString('id')!,
      password: _prefs.getString('password')!,
      rating: _prefs.getDouble('rating')!,
      speciality: _prefs.getString('speciality')!,
    );
  }

  Future<List<Employee>> employees({
    required String institutionId,
  }) async {
    _employees.clear();

    try {
      var _response = await http.get(
        Uri.parse(
          ServerInfo.EMPLOYEES + '/$institutionId/all',
        ),
      );

      if (_response.statusCode == 200) {
        var _data = json.decode(_response.body);

        List<dynamic> _tmpEmployees = _data['data'];

        _tmpEmployees.forEach((employee) {
          String? _photo = employee['photo'];

          _employees.add(
            Employee(
              institutionId: employee['institution'],
              email: employee['email'],
              firstName: employee['firstName'],
              lastName: employee['lastName'],
              password: employee['password'],
              photo: _photo!,
              rating: 0,
              speciality: employee['speciality'],
              id: employee['_id'],
            ),
          );
        });
      }

      return [
        ..._employees.where(
          (employee) => employee.institutionId == institutionId,
        ),
      ];
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Map<String, dynamic> get employeeData {
    return {..._employeeData};
  }

  void setEmployeeData({
    required Map<String, dynamic> newData,
  }) {
    _employeeData = newData;
  }

  Future<List<dynamic>> loginEmployee(
    String email,
    String password,
  ) async {
    try {
      final url = Uri.parse(ServerInfo.EMPLOYEES + '/login');

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(
          {
            'email': email,
            'password': password,
          },
        ),
      );

      var _result = json.decode(response.body);

      if (response.statusCode == 200) {
        final SharedPreferences _prefs = await SharedPreferences.getInstance();

        var _empData = _result['data'];

        _token = _result['token'];
        _prefs.setString('employeeToken', _token!);

        _employee = Employee(
          firstName: _empData["firstName"],
          lastName: _empData["lastName"],
          email: _empData["email"],
          id: _empData["_id"],
          institutionId: _empData["institutionId"],
          password: password,
          photo: _empData["photo"],
          rating: _empData["rating"] ?? 0,
          speciality: _empData["specialty"],
        );

        _prefs.setString('firstName', _employee!.firstName);
        _prefs.setString('lastName', _employee!.lastName);
        _prefs.setString('email', _employee!.email);
        _prefs.setString('password', password);
        _prefs.setString('id', _employee!.id);
        _prefs.setString('institutionId', _employee!.institutionId);
        _prefs.setDouble('rating', _employee!.rating);
        _prefs.setString('speciality', _employee!.speciality!);
        _prefs.setString('photo', _empData["photo"]);

        return [true];
      } else {
        return [false, _result['msg']];
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<dynamic>> addEmployee({
    required String institutionId,
    required String token,
  }) async {
    try {
      var response = await http.post(
        Uri.parse(ServerInfo.EMPLOYEES),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: json.encode({
          "institution": institutionId,
          "email": _employeeData['email'],
          "firstName": _employeeData['firstName'],
          "lastName": _employeeData['lastName'],
          "password": _employeeData['password'],
          "specialty": _employeeData['speciality'],
        }),
      );

      var result = json.decode(response.body);
      if (response.statusCode == 201) {
        return [true, result['data']['id']];
      } else {
        print('Employee: $result');
        return [false, result['msg']];
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<dynamic>> updateEmployee({
    required String employeeId,
    required String token,
  }) async {
    try {
      var response = await http.put(
        Uri.parse(ServerInfo.EMPLOYEES + '/$employeeId'),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: json.encode({
          "email": _employeeData['email'],
          "firstName": _employeeData['firstName'],
          "lastName": _employeeData['lastName'],
          "password": _employeeData['password'],
          "specialty": _employeeData['specialty'],
        }),
      );

      var result = json.decode(response.body);
      if (response.statusCode == 200) {
        return [true, result['data']['id']];
      } else {
        print('Employee: $result');
        return [false, result['msg']];
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<dynamic>> deleteEmployee({
    required String employeeId,
    required String token,
  }) async {
    var _response = await http.delete(
      Uri.parse(
        ServerInfo.EMPLOYEES + '/$employeeId',
      ),
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (_response.statusCode == 200) {
      _employees.removeWhere(
        (employee) => employee.id == employeeId,
      );

      return [true];
    } else {
      var result = json.decode(_response.body);
      print('Employee: $result');
      return [false, result['msg']];
    }
  }

  Future<Employee?> getEmployeeById({
    required String id,
  }) async {
    var _response = await http.get(Uri.parse(ServerInfo.EMPLOYEES + '/$id'));

    var _data = json.decode(_response.body);
    if (_response.statusCode == 200) {
      var _employeeData = _data['data'];

      String? _photo = _employeeData['photo'];

      return Employee(
        id: _employeeData['_id'],
        password: '',
        institutionId: _employeeData['institution'],
        rating: double.parse(_employeeData['rate'].toString()),
        speciality: _employeeData['specialty'],
        lastName: _employeeData['lastName'],
        firstName: _employeeData['firstName'],
        email: _employeeData['email'],
        photo: _photo,
      );
    }
  }

  Future<List<dynamic>> getEmployeeWorkingTimes({
    required String employeeId,
  }) async {
    try {
      var _response = await http.get(
        Uri.parse(ServerInfo.EMPLOYEES + '/$employeeId/times'),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      var _result = json.decode(_response.body);

      if (_response.statusCode == 200) {
        return [
          true,
          (_result as List).map((e) => e as String).toList(),
        ];
      } else {
        print('Employee: $_result');
        return [false, _result['msg']];
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<dynamic>> rateEmployee({
    required double rate,
    required String? employeeId,
    required String? userId,
    required String? token,
  }) async {
    try {
      var url = Uri.parse('${ServerInfo.EMPLOYEES}/$employeeId/rate');

      var response = await http.put(
        url,
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: json.encode({
          'id': userId,
          'rate': rate.toString(),
        }),
      );

      if (response.statusCode == 200) {
        return [true];
      } else
        return [false];
    } catch (e) {
      print(e);
      throw (e);
    }
  }
}
