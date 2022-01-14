import 'package:booking_app/constants/functions.dart';
import 'package:booking_app/providers/auth.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:booking_app/widgets/background-image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const route = '/forget-pass';

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late String _email;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
        BackgroundImage(image: 'assets/images/login_bg.png'),
        LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Form(
              key: _formKey,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    'Forgot Password',
                    style: TextStyle(color: Colors.white),
                  ),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: _height / 10.123636363636364,
                            ),
                            Container(
                              width:
                                  _height / 2.4103896103896104761904761904762,
                              child: Text(
                                'Enter your email we will send instruction to reset your password',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _height / 30.370909090909092,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: _height / 37.963636363636365,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Colors.grey.withOpacity(0.4),
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: kGreen,
                                  ),
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    color: kGreen,
                                    fontSize: _height / 30.370909090909092,
                                  ),
                                ),
                                style: TextStyle(color: kWhite),
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
                            ),
                            SizedBox(
                              height: _height / 25.30909090909091,
                            ),
                            Container(
                              width: _height / 5.061818181818182,
                              height: _height / 15.185454545454546,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: kGreen,
                                ),
                                onPressed: _resetPassword,
                                child: _isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: kWhite,
                                        ),
                                      )
                                    : Text(
                                        'Send',
                                        style: TextStyle(
                                          fontSize:
                                              _height / 37.963636363636365,
                                        ),
                                      ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Form(
              key: _formKey,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  title: Padding(
                    padding: EdgeInsets.only(
                      top: _height / 42.18181818181818333333333333333,
                    ),
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _height / 18.9818181818181825,
                      ),
                    ),
                  ),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: _height / 7.592727272727273,
                            ),
                            Container(
                              width:
                                  _height / 2.4103896103896104761904761904762,
                              child: Text(
                                'Enter your email we will send instruction to reset your password',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width:
                                    _height / 2.4103896103896104761904761904762,
                                height: _height / 12.654545454545455,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Colors.grey.withOpacity(0.4),
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: kGreen,
                                      size: 40,
                                    ),
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                      color: kGreen,
                                      fontSize: 30,
                                    ),
                                  ),
                                  style: TextStyle(
                                    color: kWhite,
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
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              width:
                                  _height / 6.9024793388429754545454545454545,
                              height: _height / 18.9818181818181825,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: kGreen,
                                  textStyle: TextStyle(fontSize: 30),
                                ),
                                onPressed: _resetPassword,
                                child: _isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: kWhite,
                                        ),
                                      )
                                    : Text(
                                        'Send',
                                        style: TextStyle(
                                          fontSize:
                                              _height / 37.963636363636365,
                                        ),
                                      ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        })
      ],
    );
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      Auth _auth = Provider.of<Auth>(context, listen: false);

      String? _token = _auth.token;

      List<dynamic> _list = await _auth.changePassword(_email, _token);

      setState(() {
        _isLoading = false;
      });

      if (_list[0]) {
        Navigator.of(context).pop();
      } else
        showMessage(
          message: _list[1],
          color: Colors.red,
          context: context,
        );
    }
  }
}
