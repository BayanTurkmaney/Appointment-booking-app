import 'dart:ui';

import 'package:booking_app/providers/auth.dart';
import 'package:booking_app/screens/login_signup/verify_code.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:booking_app/widgets/background-image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class SignUPScreen extends StatefulWidget {
  static const String route = 'SignUPScreen';

  @override
  State<StatefulWidget> createState() {
    return SignUPScreenState();
  }
}

class SignUPScreenState extends State<SignUPScreen> {
  bool _isTablet = false;
  Map<String, dynamic> _data = {};
  Map<String, dynamic> _address = {};
  late String _type;
  bool _firstTime = true, _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late double _height;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;

      Map<String, dynamic>? _args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      _type = _args!['type'];

      _firstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage(
          image: 'assets/images/login_bg.png',
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: ClipRRect(
            borderRadius: BorderRadius.circular(_height / 37.963636363636365),
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    return Container(
                      width: _height / 1.8247272727272728,
                      height: _height / 1.38049586776859,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: kWhite.withOpacity(0.76),
                          ),
                          padding: EdgeInsets.only(left: 10),
                          margin: EdgeInsets.all(_height / 31.6363636363636375),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _buildFName(),
                                _buildLName(),
                                _buildEmail(),
                                _buildPassword(),
                                _buildPhoneNumber(),
                                _buildPhoneNumber2(),
                                _buildCountry(),
                                _buildCity(),
                                _buildLocation(),
                                _buildBuilding(),
                                SizedBox(
                                  height: _height / 15.185454545454546,
                                ),
                                Container(
                                  width: _height / 4.745454545454545625,
                                  height: _height /
                                      13.804958677685950909090909090909,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: kGreen,
                                    ),
                                    child: _isLoading
                                        ? CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Text(
                                            'Sign Up',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: _height /
                                                  42.18181818181818333333333333333,
                                            ),
                                          ),
                                    onPressed: _signUp,
                                  ),
                                ),
                                SizedBox(
                                  height: _height / 37.963636363636365,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Already have an account? ',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, 'LogInScreen');
                                      },
                                      child: Text(
                                        'Login',
                                        style: kBodyText.copyWith(
                                          color: kGreen,
                                          fontWeight: FontWeight.bold,
                                          fontSize: _height /
                                              42.18181818181818333333333333333,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    _isTablet = true;
                    return Container(
                      width: _height / 2.7609917355371901818181818181818,
                      height: _height / 1.2447093889716840983606557377049,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Card(
                        elevation: 10.0,
                        child: SingleChildScrollView(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: kWhite,
                            ),
                            margin:
                                EdgeInsets.all(_height / 31.6363636363636375),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _buildFName(),
                                  SizedBox(
                                    height: _height / 37.963636363636365,
                                  ),
                                  _buildLName(),
                                  SizedBox(
                                    height: _height / 37.963636363636365,
                                  ),
                                  _buildEmail(),
                                  SizedBox(
                                    height: _height / 37.963636363636365,
                                  ),
                                  _buildPassword(),
                                  SizedBox(
                                    height: _height / 37.963636363636365,
                                  ),
                                  _buildPhoneNumber(),
                                  SizedBox(
                                    height: _height / 37.963636363636365,
                                  ),
                                  _buildPhoneNumber2(),
                                  SizedBox(
                                    height: _height / 37.963636363636365,
                                  ),
                                  _buildCountry(),
                                  SizedBox(
                                    height: _height / 37.963636363636365,
                                  ),
                                  _buildCity(),
                                  SizedBox(
                                    height: _height / 37.963636363636365,
                                  ),
                                  _buildLocation(),
                                  SizedBox(
                                    height: _height / 37.963636363636365,
                                  ),
                                  _buildBuilding(),
                                  SizedBox(
                                      height: _height / 15.185454545454546),
                                  Container(
                                    width: _height / 4.745454545454545625,
                                    height: _height /
                                        13.804958677685950909090909090909,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: kGreen,
                                      ),
                                      child: _isLoading
                                          ? CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : Text(
                                              'Sign Up',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    _height / 25.30909090909091,
                                              ),
                                            ),
                                      onPressed: _signUp,
                                    ),
                                  ),
                                  SizedBox(
                                    height: _height / 37.963636363636365,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Already have an account? ',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize:
                                              _height / 31.6363636363636375,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            'LogInScreen',
                                          );
                                        },
                                        child: Text(
                                          'Login',
                                          style: kBodyText.copyWith(
                                              color: kGreen,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  _height / 37.963636363636365),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFName() {
    return TextFormField(
      style: TextStyle(
        fontSize: _isTablet
            ? _height / 25.30909090909091
            : _height / 37.963636363636365,
      ),
      decoration: InputDecoration(
        hintText: 'First Name',
        hintStyle: TextStyle(
            fontSize: _isTablet
                ? _height / 25.30909090909091
                : _height / 42.18181818181818333333333333333,
            color: kGreen),
        icon: Icon(
          Icons.person,
          color: kGreen,
          size: _isTablet
              ? _height / 18.9818181818181825
              : _height / 30.370909090909092,
        ),
        labelStyle: TextStyle(
          color: kGreen,
          fontSize: _height / 42.18181818181818333333333333333,
        ),
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'First Name is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _data['firstName'] = value!;
      },
    );
  }

  Widget _buildLName() {
    return TextFormField(
      style: TextStyle(
        fontSize: _isTablet
            ? _height / 25.30909090909091
            : _height / 37.963636363636365,
      ),
      decoration: InputDecoration(
        hintText: 'Last Name',
        hintStyle: TextStyle(
            fontSize: _isTablet
                ? _height / 25.30909090909091
                : _height / 42.18181818181818333333333333333,
            color: kGreen),
        icon: Icon(
          Icons.person,
          color: kGreen,
          size: _isTablet
              ? _height / 18.9818181818181825
              : _height / 30.370909090909092,
        ),
        labelStyle: TextStyle(
            color: kGreen,
            fontSize: _height / 42.18181818181818333333333333333),
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Last Name is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _data['lastName'] = value!;
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      style: TextStyle(
        fontSize: _isTablet
            ? _height / 25.30909090909091
            : _height / 37.963636363636365,
      ),
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: TextStyle(
            fontSize: _isTablet
                ? _height / 25.30909090909091
                : _height / 42.18181818181818333333333333333,
            color: kGreen),
        icon: Icon(
          Icons.email,
          color: kGreen,
          size: _isTablet
              ? _height / 18.9818181818181825
              : _height / 30.370909090909092,
        ),
        labelStyle: TextStyle(
            color: kGreen,
            fontSize: _height / 42.18181818181818333333333333333),
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Email is Required';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }

        return null;
      },
      onSaved: (String? value) {
        _data['email'] = value!;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      style: TextStyle(
        fontSize: _isTablet
            ? _height / 25.30909090909091
            : _height / 37.963636363636365,
      ),
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(
            fontSize: _isTablet
                ? _height / 25.30909090909091
                : _height / 42.18181818181818333333333333333,
            color: kGreen),
        icon: Icon(
          Icons.remove_red_eye_outlined,
          color: kGreen,
          size: _isTablet
              ? _height / 18.9818181818181825
              : _height / 30.370909090909092,
        ),
        labelStyle: TextStyle(
            color: kGreen,
            fontSize: _height / 42.18181818181818333333333333333),
      ),
      obscureText: true,
      keyboardType: TextInputType.text,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Password is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _data['password'] = value!;
      },
    );
  }

  Widget _buildPhoneNumber() {
    return TextFormField(
      style: TextStyle(
        fontSize: _isTablet
            ? _height / 25.30909090909091
            : _height / 37.963636363636365,
      ),
      decoration: InputDecoration(
        hintText: 'Phone Number 1',
        hintStyle: TextStyle(
            fontSize: _isTablet
                ? _height / 25.30909090909091
                : _height / 42.18181818181818333333333333333,
            color: kGreen),
        icon: Icon(
          Icons.phone,
          color: kGreen,
          size: _isTablet
              ? _height / 18.9818181818181825
              : _height / 30.370909090909092,
        ),
        labelStyle: TextStyle(
            color: kGreen,
            fontSize: _height / 42.18181818181818333333333333333),
      ),
      keyboardType: TextInputType.number,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Phone Number 1 is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _data['phone1'] = value!;
      },
    );
  }

  Widget _buildPhoneNumber2() {
    return TextFormField(
      style: TextStyle(
        fontSize: _isTablet
            ? _height / 25.30909090909091
            : _height / 37.963636363636365,
      ),
      decoration: InputDecoration(
        hintText: 'Phone Number 2 (Optional)',
        hintStyle: TextStyle(
            fontSize: _isTablet
                ? _height / 25.30909090909091
                : _height / 42.18181818181818333333333333333,
            color: kGreen),
        icon: Icon(
          Icons.phone,
          color: kGreen,
          size: _isTablet
              ? _height / 18.9818181818181825
              : _height / 30.370909090909092,
        ),
        labelStyle: TextStyle(
            color: kGreen,
            fontSize: _height / 42.18181818181818333333333333333),
      ),
      keyboardType: TextInputType.number,
      onSaved: (String? value) {
        _data['phone2'] = value!;
      },
    );
  }

  Widget _buildCountry() {
    return TextFormField(
      style: TextStyle(
        fontSize: _isTablet
            ? _height / 25.30909090909091
            : _height / 37.963636363636365,
      ),
      decoration: InputDecoration(
        hintText: 'Country',
        hintStyle: TextStyle(
            fontSize: _isTablet
                ? _height / 25.30909090909091
                : _height / 42.18181818181818333333333333333,
            color: kGreen),
        icon: Icon(
          Icons.edit_location_sharp,
          color: kGreen,
          size: _isTablet
              ? _height / 18.9818181818181825
              : _height / 30.370909090909092,
        ),
        labelStyle: TextStyle(
            color: kGreen,
            fontSize: _height / 42.18181818181818333333333333333),
      ),
      keyboardType: TextInputType.text,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Country number is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _address['country'] = value!;
      },
    );
  }

  Widget _buildCity() {
    return TextFormField(
      style: TextStyle(
        fontSize: _isTablet
            ? _height / 25.30909090909091
            : _height / 37.963636363636365,
      ),
      decoration: InputDecoration(
        hintText: 'City',
        hintStyle: TextStyle(
            fontSize: _isTablet
                ? _height / 25.30909090909091
                : _height / 42.18181818181818333333333333333,
            color: kGreen),
        icon: Icon(
          Icons.location_city,
          color: kGreen,
          size: _isTablet
              ? _height / 18.9818181818181825
              : _height / 30.370909090909092,
        ),
        labelStyle: TextStyle(
            color: kGreen,
            fontSize: _height / 42.18181818181818333333333333333),
      ),
      keyboardType: TextInputType.text,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'City number is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _address['city'] = value!;
      },
    );
  }

  Widget _buildLocation() {
    return TextFormField(
      style: TextStyle(
        fontSize: _isTablet
            ? _height / 25.30909090909091
            : _height / 37.963636363636365,
      ),
      decoration: InputDecoration(
        hintText: 'Location',
        hintStyle: TextStyle(
            fontSize: _isTablet
                ? _height / 25.30909090909091
                : _height / 42.18181818181818333333333333333,
            color: kGreen),
        icon: Icon(
          Icons.location_city,
          color: kGreen,
          size: _isTablet
              ? _height / 18.9818181818181825
              : _height / 30.370909090909092,
        ),
        labelStyle: TextStyle(
            color: kGreen,
            fontSize: _height / 42.18181818181818333333333333333),
      ),
      keyboardType: TextInputType.text,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Location is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _address['location'] = value!;
      },
    );
  }

  Widget _buildBuilding() {
    return TextFormField(
      style: TextStyle(
        fontSize: _isTablet
            ? _height / 25.30909090909091
            : _height / 37.963636363636365,
      ),
      decoration: InputDecoration(
        hintText: 'Building',
        hintStyle: TextStyle(
            fontSize: _isTablet
                ? _height / 25.30909090909091
                : _height / 42.18181818181818333333333333333,
            color: kGreen),
        icon: Icon(
          Icons.location_city,
          color: kGreen,
          size: _isTablet
              ? _height / 18.9818181818181825
              : _height / 30.370909090909092,
        ),
        labelStyle: TextStyle(
            color: kGreen,
            fontSize: _height / 42.18181818181818333333333333333),
      ),
      keyboardType: TextInputType.number,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Building is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _address['building'] = value!;
      },
    );
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      _data['address'] = _address;

      List<dynamic> _signUpList = await Provider.of<Auth>(
        context,
        listen: false,
      ).signup(
        address: _data['address'],
        email: _data['email'],
        type: _type,
        lastName: _data['lastName'],
        firstName: _data['firstName'],
        password: _data['password'],
        phone1: _data['phone1'],
        phone2: _data['phone2'] ?? 'No Phone 2',
        facebook: _data['facebook'],
        instagram: _data['instagram'],
        tiktok: _data['tiktok'],
      );

      setState(() {
        _isLoading = false;
      });

      if (_signUpList[0]) {
        Navigator.of(context).pushReplacementNamed(VerifyCodeScreen.route);
      } else {
        _showErrorMessage(message: _signUpList[1]);
      }
    }
  }

  void _showErrorMessage({
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
