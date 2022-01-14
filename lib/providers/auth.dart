import 'dart:convert';

import 'package:booking_app/models/users/owner.dart';
import 'package:booking_app/models/users/user.dart';
import 'package:booking_app/utils/server_info.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _password;
  User? _user;

  User? get user {
    return _user;
  }

  String? get token {
    return _token;
  }

  String? get password {
    return _password;
  }

  Future<void> setPassword() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _password = _prefs.getString('password');
  }

  Future<bool> isLoggedIn() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _token = _prefs.getString('token');

    return _token != null;
  }

  Future<List<dynamic>> signup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone1,
    required String phone2,
    required String type,
    required String? facebook,
    required String? instagram,
    required String? tiktok,
    required Map address,
  }) async {
    try {
      final url = Uri.parse(ServerInfo.SIGN_UP);

      var _body = json.encode({
        "type": type,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "password": password,
        "address": address,
        "phone_1": phone1 == '' ? '0' : phone1,
        "phone_2": phone2 == '' ? '0' : phone2,
        "urls": {
          "facebook": facebook ?? 'No Facebook Account',
          "instagram": instagram ?? 'No Instagram Account',
          "tiktok": tiktok ?? 'No TikTok Account',
        },
      });

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: _body,
      );

      var result = json.decode(response.body);
      if (response.statusCode == 201) {
        final SharedPreferences _prefs = await SharedPreferences.getInstance();

        String _userId = result['data']['id'];
        _token = result['token'];
        _prefs.setString('token', _token!);

        return [true, _userId];
      } else {
        print('Auth: $result');
        return [false, result['msg']];
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final url = Uri.parse(ServerInfo.LOGIN);

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

        var _userData = _result['data'];

        _token = _result['token'];
        _prefs.setString('token', _token!);

        if (_userData['type'] == 'user')
          _user = User(
            idUser: _userData["_id"],
            firstName: _userData["firstName"],
            lastName: _userData["lastName"],
            photo: _userData['photo'],
            email: _userData["email"],
            phone1: _userData["phone1"] ?? '',
            phone2: _userData["phone2"] ?? '',
            isVerified:
                (_userData["isVerified"] ?? 'true').toLowerCase() == 'true',
            type: _userData["type"],
            address: _userData['address'],
          );
        else if (_userData['type'] == 'owner')
          _user = Owner(
            idUser: _userData["_id"],
            firstName: _userData["firstName"],
            lastName: _userData["lastName"],
            photo: _userData["photo"],
            email: _userData["email"],
            phone1: _userData["phone1"] ?? '',
            phone2: _userData["phone2"] ?? '',
            isVerified:
                (_userData["isVerified"] ?? 'true').toLowerCase() == 'true',
            type: _userData["type"],
            address: _userData['address'],
            hasInstitution: _userData['hasInstitution'] ?? false,
          );

        _prefs.setString('firstName', _user!.firstName);
        _prefs.setString('lastName', _user!.lastName);
        _prefs.setString('type', _user!.type);
        _prefs.setString('password', password);
        _prefs.setString('email', _user!.email);
        _prefs.setString('idUser', _user!.idUser);
        _prefs.setBool('isVerified', _user!.isVerified ?? false);
        if (_user!.photo != null) _prefs.setString('photo', _user!.photo!);
        _prefs.setString('phone1', _user!.phone1 ?? 'No Phone 1');
        _prefs.setString('phone2', _user!.phone2 ?? 'No Phone 2');
        _prefs.setString('country', _user!.address['country']);
        _prefs.setString('city', _user!.address['city']);
        _prefs.setString('location', _user!.address['location']);
        _prefs.setInt('building', _user!.address['building']);
        if (_user is Owner)
          _prefs.setBool('hasInstitution', (_user! as Owner).hasInstitution);

        return [true];
      } else {
        return [false, _result['msg']];
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<dynamic>> updateProfile({
    required Map<String, dynamic> data,
  }) async {
    try {
      final url = Uri.parse(ServerInfo.SERVER + '/user/${_user!.idUser}');

      var _body = json.encode({
        "firstName": data['firstName'],
        "lastName": data['lastName'],
        "password": data['password'],
        "address": {
          "country": data['country'],
          "city": data['city'],
          "location": data['location'],
          "building": data['building']
        },
        "phone_1": data['phone1'],
        "phone_2": data['phone2'] == '' ? 'No Phone 2' : data['phone2'],
        "urls": {
          "facebook": data['facebook'] ?? 'No Facebook Account',
          "instagram": data['instagram'] ?? 'No Instagram Account',
          "tiktok": data['tiktok'] ?? 'No Tik Tok Account',
        }
      });

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_token",
        },
        body: _body,
      );

      if (response.statusCode == 200) {
        _user = User(
          idUser: _user!.idUser,
          photo: _user!.photo,
          email: _user!.email,
          firstName: data['firstName'],
          lastName: data['lastName'],
          type: _user!.type,
          address: {
            "country": data['country'],
            "city": data['city'],
            "location": data['location'],
            "building": data['building']
          },
          phone1: data['phone1'],
          phone2: data['phone2'],
          isVerified: _user!.isVerified,
        );

        notifyListeners();

        return [true];
      } else {
        var result = json.decode(response.body);

        return [false, result['msg']];
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> setUser() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _type = _prefs.getString('type') ?? 'user';

    if (_type == 'user')
      _user = User(
        firstName: _prefs.getString('firstName')!,
        lastName: _prefs.getString('lastName')!,
        type: _type,
        email: _prefs.getString('email')!,
        idUser: _prefs.getString('idUser')!,
        isVerified: _prefs.getBool('isVerified'),
        photo: _prefs.getString('photo')!,
        phone1: _prefs.getString('phone1'),
        phone2: _prefs.getString('phone2'),
        address: {
          'country': _prefs.getString('country'),
          'city': _prefs.getString('city'),
          'location': _prefs.getString('location'),
          'building': _prefs.getInt('building'),
        },
      );
    else if (_type == 'owner')
      _user = Owner(
        hasInstitution: _prefs.getBool('hasInstitution') ?? false,
        firstName: _prefs.getString('firstName')!,
        lastName: _prefs.getString('lastName')!,
        type: _type,
        email: _prefs.getString('email')!,
        idUser: _prefs.getString('idUser')!,
        isVerified: _prefs.getBool('isVerified'),
        photo:
            _prefs.getString('photo') == null ? '' : _prefs.getString('photo')!,
        phone1: _prefs.getString('phone1'),
        phone2: _prefs.getString('phone2'),
        address: {
          'country': _prefs.getString('country'),
          'city': _prefs.getString('city'),
          'location': _prefs.getString('location'),
          'building': _prefs.getInt('building'),
        },
      );
  }

  Future<List<dynamic>> changePassword(String email, String? token) async {
    try {
      final url = Uri.parse('${ServerInfo.SERVER}/user/forgetPassword');

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          'authorization': 'Bearer $token',
        },
        body: json.encode(
          {
            'email': email,
          },
        ),
      );

      if (response.statusCode == 200) {
        return [true];
      } else {
        var result = json.decode(response.body);

        print('Auth: $result');
        return [false, result['msg']];
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<User?> getUserById({
    required String id,
  }) async {
    var _response = await http.get(Uri.parse(ServerInfo.USERS + '/$id'));

    var _data = json.decode(_response.body);
    if (_response.statusCode == 200) {
      var _userData = _data['data'];

      return User(
        idUser: _userData['_id'],
        isVerified: true,
        phone1: _userData['phone_1'],
        address: {},
        type: '',
        lastName: _userData['lastName'],
        firstName: _userData['firstName'],
        email: _userData['email'],
        photo: _userData['photo'],
        phone2: _userData['phone_2'],
      );
    }
  }

  Future<List<dynamic>> updatePhoto({
    required String userId,
    required String photo,
  }) async {
    var response = await http.post(
      Uri.parse(ServerInfo.USERS + '/$userId/photo'),
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $token',
      },
      body: json.encode({
        "photo": photo,
      }),
    );

    if (response.statusCode == 200) {
      return [true];
    } else {
      final _result = json.decode(response.body);

      return [false, _result['msg']];
    }
  }
}
