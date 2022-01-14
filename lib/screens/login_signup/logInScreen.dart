import 'package:animated_text/animated_text.dart';
import 'package:booking_app/constants/functions.dart';
import 'package:booking_app/models/users/user.dart';
import 'package:booking_app/providers/auth.dart';
import 'package:booking_app/screens/bottom_bar/home_owner_addServiceScreen.dart';
import 'package:booking_app/screens/login_signup/forget_password_screen.dart';
import 'package:booking_app/screens/login_signup/signUpScreen.dart';
import 'package:booking_app/screens/users_screens/main_user.dart';
import 'package:booking_app/widgets/background-image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/pallete.dart';

class LogInScreen extends StatefulWidget {
  static const String route = 'LogInScreen';

  @override
  State<StatefulWidget> createState() {
    return LogInScreenState();
  }
}

class LogInScreenState extends State<LogInScreen> {
  late String _email;
  late String _password;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isTablet = false;
  late double _height;
  bool _firstTime = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;

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
                      height: _height / 1.9980861244019139473684210526316,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kWhite.withOpacity(0.70),
                          ),
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(_height / 31.6363636363636375),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    focusColor: kGreen,
                                    labelStyle: TextStyle(
                                      color: kGreen,
                                      fontSize: _height /
                                          42.18181818181818333333333333333,
                                    ),
                                    icon: Icon(
                                      Icons.email,
                                      color: kGreen,
                                    ),
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
                                    _email = value!;
                                  },
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    focusColor: kGreen,
                                    labelStyle: TextStyle(
                                      color: kGreen,
                                      fontSize: _height /
                                          42.18181818181818333333333333333,
                                    ),
                                    icon: Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: kGreen,
                                    ),
                                  ),
                                  obscureText: true,
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Password is Required';
                                    }

                                    return null;
                                  },
                                  onSaved: (String? value) {
                                    _password = value!;
                                  },
                                ),
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
                                        : Container(
                                            width: _height / 5.061818181818182,
                                            height:
                                                _height / 15.185454545454546,
                                            child: AnimatedText(
                                              alignment: Alignment.center,
                                              speed:
                                                  Duration(milliseconds: 1000),
                                              controller:
                                                  AnimatedTextController.loop,
                                              repeatCount: 1,
                                              displayTime:
                                                  Duration(milliseconds: 300),
                                              wordList: ['login ', ''],
                                              textStyle: TextStyle(
                                                  color: kWhite,
                                                  fontFamily: 'OpenSans',
                                                  fontSize: _height /
                                                      37.963636363636365,
                                                  fontWeight: FontWeight.w700),
                                              onAnimate: (index) {},
                                              onFinished: () {
                                                setState(() {
                                                  controller:
                                                  AnimatedTextController.stop;
                                                });
                                              },
                                            ),
                                          ),
                                    onPressed: _login,
                                  ),
                                ),
                                SizedBox(
                                  height: _height / 37.963636363636365,
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .pushNamed(ForgetPasswordScreen.route),
                                  child: Container(
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 1,
                                          color: kWhite,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                // GestureDetector(
                                //   onTap: () => Navigator.of(context)
                                //       .pushNamed(SignUPScreen.route,
                                //           arguments: {'type': }),
                                //   child: Container(
                                //     padding: EdgeInsets.all(5),
                                //     child: Text(
                                //       'Signup instead?',
                                //       style: TextStyle(
                                //         color: kGreen,
                                //         fontSize: _height /
                                //             42.18181818181818333333333333333,
                                //         // fontWeight: FontWeight.bold,
                                //       ),
                                //     ),
                                //     decoration: BoxDecoration(
                                //       border: Border(
                                //         bottom: BorderSide(
                                //           width: 1,
                                //           color: kWhite,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
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
                            alignment: Alignment.center,
                            margin:
                                EdgeInsets.all(_height / 31.6363636363636375),
                            child: Column(
                              children: [
                                Container(
                                  child: Text(
                                    'log in',
                                    style: TextStyle(
                                        color: red,
                                        fontSize: _height / 37.963636363636365),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      TextFormField(
                                        style: TextStyle(
                                          fontSize: _height / 25.30909090909091,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Email',
                                          hintStyle: TextStyle(
                                            fontSize: _isTablet
                                                ? _height / 25.30909090909091
                                                : 10,
                                            color: kGreen,
                                          ),
                                          focusColor: kGreen,
                                          labelStyle: TextStyle(
                                            color: kGreen,
                                            fontSize: _height /
                                                42.18181818181818333333333333333,
                                          ),
                                          icon: Icon(
                                            Icons.email,
                                            color: kGreen,
                                            size: _isTablet
                                                ? _height / 18.9818181818181825
                                                : _height / 37.963636363636365,
                                          ),
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
                                          _email = value!;
                                        },
                                      ),
                                      SizedBox(
                                        height: _height / 37.963636363636365,
                                      ),
                                      TextFormField(
                                        style: TextStyle(
                                          fontSize: _height / 25.30909090909091,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Password',
                                          hintStyle: TextStyle(
                                            fontSize: _isTablet
                                                ? _height / 25.30909090909091
                                                : 10,
                                            color: kGreen,
                                          ),
                                          focusColor: kGreen,
                                          labelStyle: TextStyle(
                                            color: kGreen,
                                            fontSize: _height /
                                                42.18181818181818333333333333333,
                                          ),
                                          icon: Icon(
                                            Icons.remove_red_eye_outlined,
                                            color: kGreen,
                                            size: _isTablet
                                                ? _height / 18.9818181818181825
                                                : _height / 37.963636363636365,
                                          ),
                                        ),
                                        obscureText: true,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'Password is Required';
                                          }

                                          return null;
                                        },
                                        onSaved: (String? value) {
                                          _password = value!;
                                        },
                                      ),
                                      SizedBox(
                                          height: _height /
                                              10.846753246753247142857142857143),
                                      Container(
                                        width: _height / 6.3272727272727275,
                                        height: _height / 18.9818181818181825,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: kGreen,
                                          ),
                                          child: _isLoading
                                              ? CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                              : Container(
                                                  width: _height /
                                                      5.061818181818182,
                                                  height: _height /
                                                      15.185454545454546,
                                                  child: AnimatedText(
                                                    alignment: Alignment.center,
                                                    speed: Duration(
                                                        milliseconds: 1000),
                                                    controller:
                                                        AnimatedTextController
                                                            .loop,
                                                    repeatCount: 1,
                                                    displayTime: Duration(
                                                        milliseconds: 1000),
                                                    wordList: ['login', ''],
                                                    textStyle: TextStyle(
                                                        color: kWhite,
                                                        fontFamily: 'OpenSans',
                                                        fontSize: _height /
                                                            27.11688311688312,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                    onAnimate: (index) {},
                                                    onFinished: () {
                                                      setState(() {
                                                        controller:
                                                        AnimatedTextController
                                                            .stop;
                                                      });
                                                    },
                                                  ),
                                                ),
                                          onPressed: _login,
                                        ),
                                      ),
                                      SizedBox(
                                        height: _height / 37.963636363636365,
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            Navigator.of(context).pushNamed(
                                          ForgetPasswordScreen.route,
                                        ),
                                        child: Container(
                                          child: Text(
                                            'Forgot Password?',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize:
                                                  _height / 30.370909090909092,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: 1,
                                                color: kWhite,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            Navigator.of(context).pushNamed(
                                          SignUPScreen.route,
                                        ),
                                        child: Container(
                                          child: Text(
                                            'Signup instead?',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize:
                                                  _height / 30.370909090909092,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: 1,
                                                color: kWhite,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      List<dynamic> _list = await Provider.of<Auth>(
        context,
        listen: false,
      ).login(
        _email,
        _password,
      );

      setState(() {
        _isLoading = false;
      });

      if (_list[0]) {
        User? _user = Provider.of<Auth>(
          context,
          listen: false,
        ).user;

        if (_user!.type == 'owner') {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AddServiceScreen.route,
            (route) => false,
          );
        } else if (_user.type == 'user')
          Navigator.of(context).pushNamedAndRemoveUntil(
            MainUser.route,
            (route) => false,
          );
      } else {
        showMessage(
          message: _list[1],
          color: Colors.red,
          context: context,
        );
      }
    }
  }
}
