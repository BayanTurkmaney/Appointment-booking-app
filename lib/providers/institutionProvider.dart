import 'dart:convert';

import 'package:booking_app/models/category.dart';
import 'package:booking_app/models/institution.dart';
import 'package:booking_app/models/plan.dart';
import 'package:booking_app/utils/server_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class InstitutionProvider with ChangeNotifier {
  Map<String, dynamic> _institutionData = {};

  List<Category> _categories = [];

  List<Institution> _institutions = [];

  List<Plan> _plans = [];

  void clearArrays() {
    _institutionData.clear();
    _categories.clear();
    _institutions.clear();
    _plans.clear();
  }

  Future<List<Category>> categories() async {
    if (_categories.isEmpty) {
      try {
        var _response = await http.get(Uri.parse(ServerInfo.CATEGORIES));

        if (_response.statusCode == 200) {
          print('3');
          var _data = json.decode(_response.body);
          List<dynamic> _tmpCategories = _data['data'];
          _tmpCategories.forEach((category) {
            _categories.add(
              Category(
                name: category['name'],
                id: category['_id'],
                image: category['image'],
              ),
            );
          });
        }
      } catch (e) {
        print(e);
        throw e;
      }
    }
    print('4');
    _categories.forEach((element) {
      print(element.name);
    });
    return [..._categories];
  }

  Future<List<Plan>> plans() async {
    if (_plans.isEmpty) {
      try {
        var _response = await http.get(Uri.parse(ServerInfo.PLANS));

        if (_response.statusCode == 200) {
          List<dynamic> _tmpPlans = json.decode(_response.body);
          _tmpPlans.forEach((plan) {
            if (plan['available'].toString() == 'true')
              _plans.add(
                Plan(
                  sku: plan['sku'].toString(),
                  servicesLimit: int.parse(plan['serviceLimit'].toString()),
                  employeesLimit: int.parse(plan['employeeLimit'].toString()),
                  id: plan['_id'].toString(),
                  name: plan['name'].toString(),
                  description: plan['description'].toString(),
                  price: double.parse(plan['price'].toString()),
                  length: int.parse(plan['length'].toString()),
                ),
              );
          });
        }
      } catch (e) {
        print(e);
        throw e;
      }
    }
    return [..._plans];
  }

  List<Institution> get institutions {
    return [..._institutions];
  }

  Map<String, dynamic> get institutionData {
    return {..._institutionData};
  }

  void setInstitutionData({
    required Map<String, dynamic> newData,
  }) {
    _institutionData = newData;
  }

  Future<List<dynamic>> addInstitution({
    required String ownerId,
    required String token,
  }) async {
    var response = await http.post(
      Uri.parse(ServerInfo.INSTITUTIONS),
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $token',
      },
      body: json.encode({
        "subCategory": _institutionData['subCategory'].toString().split(','),
        "slider": _institutionData['slider'],
        "paypalEmail": _institutionData['paypalEmail'],
        "openingDays": _institutionData['openingDays']
            .map((e) => e.trim())
            .toList()
            .map((e) => e.toLowerCase())
            .toList(),
        "owner": ownerId,
        "email": _institutionData['email'],
        "name": _institutionData['name'],
        "subtitle": _institutionData['subtitle'].toString(),
        "description": _institutionData['description'],
        "category": _institutionData['category'].toString(),
        "phone": _institutionData['phone'].toString(),
        "photo": _institutionData['photo'],
        "openAt": _institutionData['openAt'],
        "closeAt": _institutionData['closeAt'],
        "address": {
          "country": _institutionData['country'],
          "city": _institutionData['city'],
        }
      }),
    );

    var result = json.decode(response.body);
    if (response.statusCode == 201) {
      // bool _planSubscription = await _subscribeToPlan(
      //   planId: planId,
      //   token: token,
      //   institutionId: result['data']['id'],
      // );
      //
      // if (_planSubscription) {
      //   return [true, result['data']['id']];
      // } else {
      //   return [false, result['msg']];
      // }

      return [true, result['data']['id']];
    } else {
      print('Institution: $result');
      return [false, result['msg']];
    }
  }

  Future<Institution?> getInstitutionById({
    required String institutionId,
  }) async {
    var _response = await http.get(
      Uri.parse(ServerInfo.INSTITUTIONS + '/$institutionId'),
    );

    if (_response.statusCode == 200) {
      var _data = json.decode(_response.body);

      var _tmpInstitution = _data['data'];

      String _photo = _tmpInstitution['photo'];

      final Map<String, String> _address = {
        'country': _tmpInstitution['address'][0]['country'].toString(),
        'city': _tmpInstitution['address'][0]['city'].toString(),
      };

      Institution _institution = Institution(
        id: _tmpInstitution['_id'],
        category: _tmpInstitution['category'],
        email: _tmpInstitution['email'],
        closeAt: int.parse(_tmpInstitution['closeAt'].toString()),
        description: _tmpInstitution['description'],
        ownerId: _tmpInstitution['owner'],
        name: _tmpInstitution['name'],
        openAt: int.parse(_tmpInstitution['openAt'].toString()),
        photo: _photo,
        subtitle: _tmpInstitution['subtitle'],
        openingDays: (_tmpInstitution['openingDays'] as List)
            .map((e) => e as String)
            .toList(),
        paypalEmail: _tmpInstitution['paypalEmail'],
        subCategories: (_tmpInstitution['subCategory'] as List)
            .map((e) => e as String)
            .toList(),
        address: _address,
        blocked: _tmpInstitution['blocked'].toString() == 'true',
        freezed: _tmpInstitution['freezed'].toString() == 'true',
        notified: _tmpInstitution['notified'].toString() == 'true',
        rate: double.parse(_tmpInstitution['rate'].toString()),
        sliderImages: (_tmpInstitution['slider'] as List).map((e) {
          return e['image'].toString();
        }).toList(),
        planId: _tmpInstitution['subscription']['plan'],
        phone: _tmpInstitution['phone'],
      );

      _institutions.add(
        _institution,
      );

      return _institution;
    }
  }

  Future<List<Institution>> getInstitutionsByCategory({
    required String category,
    required int page,
  }) async {
    List<Institution> _tmpInstitutions = [];

    var _response = await http.get(
      Uri.parse(ServerInfo.INSTITUTIONS +
          '?cat=$category&limit=10&skip=${page * 10}'),
    );

    if (_response.statusCode == 200) {
      var _data = json.decode(_response.body);

      List<dynamic> _tmpInstitutionsData = _data['data'];

      _tmpInstitutionsData.forEach((institution) {
        String _photo = institution['photo'];

        final Map<String, String> _address = {
          'country': institution['address'][0]['country'].toString(),
          'city': institution['address'][0]['city'].toString(),
        };

        _tmpInstitutions.add(
          Institution(
            id: institution['_id'],
            category: institution['category'],
            email: institution['email'],
            closeAt: int.parse(institution['closeAt'].toString()),
            description: institution['description'],
            ownerId: institution['owner'],
            name: institution['name'],
            openAt: int.parse(institution['openAt'].toString()),
            photo: _photo,
            subtitle: institution['subtitle'],
            openingDays: (institution['openingDays'] as List)
                .map((e) => e as String)
                .toList(),
            paypalEmail: institution['paypalEmail'],
            subCategories: (institution['subCategory'] as List)
                .map((e) => e as String)
                .toList(),
            address: _address,
            blocked: institution['blocked'].toString() == 'true',
            freezed: institution['freezed'].toString() == 'true',
            notified: institution['notified'].toString() == 'true',
            rate: double.tryParse(institution['rate'].toString()) ?? 0,
            sliderImages: institution['slider'] == null
                ? []
                : (institution['slider'] as List).map((e) {
                    return e['image'].toString();
                  }).toList(),
            planId: institution['subscription']['plan'],
            phone: institution['phone'],
          ),
        );
      });
    }
    return _tmpInstitutions;
  }

  Future<Institution?> getInstitutionByOwnerId({
    required String ownerId,
    required String token,
  }) async {
    var _response = await http.get(
        Uri.parse(
          ServerInfo.INSTITUTIONS + '/$ownerId/owner',
        ),
        headers: {
          'authorization': 'Bearer $token',
        });

    if (_response.statusCode == 200) {
      var _data = json.decode(_response.body);

      var _tmpInstitution = _data['data'];

      String _photo = _tmpInstitution['photo'];

      final Map<String, String> _address = {
        'country': _tmpInstitution['address'][0]['country'].toString(),
        'city': _tmpInstitution['address'][0]['city'].toString(),
      };

      Institution _institution = Institution(
        id: _tmpInstitution['_id'],
        category: _tmpInstitution['category'],
        email: _tmpInstitution['email'],
        closeAt: int.parse(_tmpInstitution['closeAt'].toString()),
        description: _tmpInstitution['description'],
        ownerId: _tmpInstitution['owner'],
        name: _tmpInstitution['name'],
        openAt: int.parse(_tmpInstitution['openAt'].toString()),
        photo: _photo,
        subtitle: _tmpInstitution['subtitle'],
        openingDays: (_tmpInstitution['openingDays'] as List)
            .map((e) => e as String)
            .toList(),
        paypalEmail: _tmpInstitution['paypalEmail'],
        subCategories: (_tmpInstitution['subCategory'] as List)
            .map((e) => e as String)
            .toList(),
        address: _address,
        blocked: _tmpInstitution['blocked'].toString() == 'true',
        freezed: _tmpInstitution['freezed'].toString() == 'true',
        notified: _tmpInstitution['notified'].toString() == 'true',
        rate: double.parse(_tmpInstitution['rate'].toString()),
        sliderImages: (_tmpInstitution['slider'] as List).map((e) {
          return e['image'].toString();
        }).toList(),
        planId: _tmpInstitution['subscription']['plan'],
        phone: _tmpInstitution['phone'],
      );

      _institutions.add(
        _institution,
      );

      return _institution;
    }
  }

  Future<List<dynamic>> updateInstitution({
    required String token,
    required String institutionId,
    required String ownerId,
    required String planId,
  }) async {
    var _response = await http.put(
      Uri.parse(ServerInfo.INSTITUTIONS + '/$institutionId'),
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $token',
      },
      body: json.encode({
        "subCategory":
            _institutionData['subCategory'].toString().split(',').toString(),
        "slider": _institutionData['slider'],
        "paypalEmail": _institutionData['paypalEmail'],
        "openingDays": _institutionData['openingDays'],
        "owner": ownerId,
        "email": _institutionData['email'],
        "name": _institutionData['name'],
        "subtitle": _institutionData['subtitle'],
        "description": _institutionData['description'],
        "category": _institutionData['category'].toString(),
        "address": _institutionData['address'],
        "phone": _institutionData['phone'].toString(),
        "openAt": _institutionData['openAt'],
        "closeAt": _institutionData['closeAt'],
        'photo': _institutionData['photo'],
      }),
    );

    var _result = json.decode(_response.body);

    if (_response.statusCode == 200) {
      List<dynamic> _planUnSubscriptionList = await unSubscribeFromPlan(
        token: token,
        institutionId: institutionId,
      );

      if (_planUnSubscriptionList[0]) {
        List<dynamic> _planSubscriptionList = await subscribeToPlan(
          planId: planId,
          token: token,
          ownerId: ownerId,
          institutionId: _result['data']['id'],
        );

        if (_planSubscriptionList[0]) {
          return [true, _result['data']['id']];
        } else {
          return [false, _result['msg']];
        }
      } else {
        return [false, _result['msg']];
      }
    } else {
      print('Institution: $_result');
      return [false, _result['msg']];
    }
  }

  Future<List<dynamic>> deleteInstitution({
    required String institutionId,
    required String token,
  }) async {
    var _response = await http.delete(
      Uri.parse(
        ServerInfo.INSTITUTIONS + '/$institutionId',
      ),
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (_response.statusCode == 200) {
      _institutions.removeWhere(
        (institution) => institution.id == institutionId,
      );

      return [true];
    } else {
      var result = json.decode(_response.body);
      print('Institution: $result');
      return [false, result['msg']];
    }
  }

  Future<List<dynamic>> subscribeToPlan({
    required String planId,
    required String token,
    required String institutionId,
    required String ownerId,
  }) async {
    var response = await http.put(
      Uri.parse(ServerInfo.INSTITUTIONS + '/$institutionId/subscribe'),
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $token',
      },
      body: json.encode({
        "id": planId,
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> _payList = await _payForPlan(
        token: token,
        institutionId: institutionId,
        planId: planId,
        ownerId: ownerId,
      );

      if (_payList[0]) {
        return [true];
      } else {
        return [false, _payList[1]];
      }
    } else {
      var result = json.decode(response.body);
      print('Institution: $result');
      return [false, result['msg']];
    }
  }

  Future<List<dynamic>> unSubscribeFromPlan({
    required String token,
    required String institutionId,
  }) async {
    var response = await http.put(
      Uri.parse(ServerInfo.INSTITUTIONS + '/$institutionId/unsubscribe'),
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return [true];
    } else {
      var result = json.decode(response.body);
      print('Institution: $result');
      return [false, result['msg']];
    }
  }

  Future<List<dynamic>> _payForPlan({
    required String token,
    required String institutionId,
    required String ownerId,
    required String planId,
  }) async {
    var _response = await http.post(
      Uri.parse(
        ServerInfo.PAYMENTS + '/subscription/$ownerId',
      ),
      body: jsonEncode({
        "id": planId,
        "institution": institutionId,
      }),
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (_response.statusCode == 200) {
      var _result = json.decode(_response.body);
      _launchURL(
        url: _result['redirect_url'],
      );
      return [true];
    } else {
      var _result = json.decode(_response.body);
      return [false, _result['msg']];
    }
  }

  Future<bool> _launchURL({
    required String url,
  }) async {
    return await canLaunch(url)
        ? await launch(url)
        : throw 'Could not launch $url';
  }

  Future<List<dynamic>> rateInstitution({
    required double rate,
    required String? institutionId,
    userId,
    token,
  }) async {
    try {
      var url = Uri.parse('${ServerInfo.INSTITUTIONS}/$institutionId/rate');
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
