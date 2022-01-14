import 'package:booking_app/constants/functions.dart';
import 'package:booking_app/models/users/user.dart';
import 'package:booking_app/providers/auth.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:booking_app/widgets/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  static const String route = 'edit-profile';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  User? _user;
  bool _firstTime = true;
  Map<String, dynamic> _data = {};
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? _password;
  late double _height;
  late int _sHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;

      _user = Provider.of<Auth>(
        context,
        listen: false,
      ).user;
      _password = Provider.of<Auth>(
        context,
        listen: false,
      ).password;

      _firstTime = false;
    }
    _sHeight = _height.floor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_height / 7.592727272727273),
        child: AppBar(
          actions: [
            IconButton(
              onPressed: _isLoading ? null : _submit,
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          ],
          title: Text(
            'Edit Profile',
            style: TextStyle(
                color: kWhite,
                fontSize: _height / 31.6363636363636375,
                fontFamily: 'Quicksand'),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: ClipPath(
            clipper: MyCustomClipper(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 158, 216, 240),
                      kBlue,
                      Color.fromARGB(255, 158, 216, 240),
                    ],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                    tileMode: TileMode.clamp),
              ),
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: kGreen,
                ),
              )
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: _height / 37.963636363636365,
                      ),
                      TextFormField(
                        initialValue: _user!.firstName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'First Name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Please Enter Your First Name';
                          return null;
                        },
                        onSaved: (newValue) => _data['firstName'] = newValue,
                      ),
                      SizedBox(
                        height: _height / 37.963636363636365,
                      ),
                      TextFormField(
                        initialValue: _user!.lastName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Last Name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Please Enter Your Last Name';
                          return null;
                        },
                        onSaved: (newValue) => _data['lastName'] = newValue,
                      ),
                      SizedBox(
                        height: _height / 37.963636363636365,
                      ),
                      TextFormField(
                        initialValue: _password,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Please Enter Your Password';
                          return null;
                        },
                        onSaved: (newValue) => _data['password'] = newValue,
                      ),
                      SizedBox(
                        height: _height / 37.963636363636365,
                      ),
                      TextFormField(
                        initialValue: _user!.phone1.toString(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone 1',
                        ),
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Please Enter Your Phone 1';
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        onSaved: (newValue) => _data['phone1'] = newValue,
                      ),
                      SizedBox(
                        height: _height / 37.963636363636365,
                      ),
                      TextFormField(
                        initialValue: _user!.phone2.toString(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone 2',
                        ),
                        keyboardType: TextInputType.number,
                        onSaved: (newValue) => _data['phone2'] = newValue,
                      ),
                      SizedBox(
                        height: _height / 37.963636363636365,
                      ),
                      TextFormField(
                        initialValue: _user!.address['country'],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Country',
                        ),
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Please Enter Your Country';
                          return null;
                        },
                        onSaved: (newValue) => _data['country'] = newValue,
                      ),
                      SizedBox(
                        height: _height / 37.963636363636365,
                      ),
                      TextFormField(
                        initialValue: _user!.address['city'],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'City',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return 'Please Enter Your City';
                          return null;
                        },
                        onSaved: (newValue) => _data['city'] = newValue,
                      ),
                      SizedBox(
                        height: _height / 37.963636363636365,
                      ),
                      TextFormField(
                        initialValue: _user!.address['location'],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Location',
                        ),
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Please Enter Your Location';
                          return null;
                        },
                        onSaved: (newValue) => _data['location'] = newValue,
                      ),
                      SizedBox(
                        height: _height / 37.963636363636365,
                      ),
                      TextFormField(
                        initialValue: _user!.address['building'].toString(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Building',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Please Enter Your Building';
                          return null;
                        },
                        onSaved: (newValue) => _data['building'] = newValue,
                      ),
                      SizedBox(
                        height: _height / 18.9818181818181825,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      List<dynamic> _resultList = await Provider.of<Auth>(
        context,
        listen: false,
      ).updateProfile(
        data: _data,
      );

      setState(() {
        _isLoading = false;
      });

      if (_resultList[0]) {
        showMessage(
          message: 'Profile Updated Successfully.',
          color: Colors.green,
          context: context,
        );

        Future.delayed(
          Duration(seconds: 2),
          () {
            Navigator.of(context).pop('refresh');
          },
        );
      } else {
        showMessage(
          message: _resultList[1],
          color: Colors.red,
          context: context,
        );
      }
    }
  }
}
