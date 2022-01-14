import 'package:animated_text/animated_text.dart';
import 'package:booking_app/screens/employee_app/log_in_employee.dart';
import 'package:booking_app/screens/login_signup/logInScreen.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:booking_app/widgets/background-image.dart';
import 'package:flutter/material.dart';

class LogInAs extends StatefulWidget {
  static const String route = '/log-as';

  @override
  _LogInAsState createState() => _LogInAsState();
}

class _LogInAsState extends State<LogInAs> {
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
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 26,
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 600)
                        return Container(
                          width: _height / 2.4103896103896104761904761904762,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white.withOpacity(0.65)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: _height / 30.370909090909092,
                              ),
                              Container(
                                width: _height / 5.061818181818182,
                                height: _height / 15.185454545454546,
                                child: AnimatedText(
                                  alignment: Alignment.center,
                                  speed: Duration(milliseconds: 1000),
                                  controller: AnimatedTextController.loop,
                                  repeatCount: 1,
                                  displayTime: Duration(milliseconds: 1000),
                                  wordList: ['login as?', ''],
                                  textStyle: TextStyle(
                                      color: kGreen,
                                      fontFamily: 'OpenSans',
                                      fontSize: _height / 27.11688311688312,
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
                              SizedBox(
                                height: _height / 21.0909090909090,
                              ),
                              Container(
                                width: _height / 3.7963636363636365,
                                height:
                                    _height / 13.804958677685950909090909090909,
                                child: ElevatedButton(
                                  child: Text(
                                    'User or Owner',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: _height /
                                          42.18181818181818333333333333333,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: kGreen,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      LogInScreen.route,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: _height / 37.963636363636365,
                              ),
                              Container(
                                width: _height / 3.7963636363636365,
                                height:
                                    _height / 13.804958677685950909090909090909,
                                child: TextButton(
                                  child: Text(
                                    'Employee',
                                    style: TextStyle(
                                      color: kGreen,
                                      fontSize: _height / 37.963636363636365,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    primary: kGreen,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        width: 2,
                                        color: kGreen,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      LogInEmployee.route,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 1,
                                    width: _height / 6.3272727272727275,
                                    color: Colors.black,
                                  ),
                                  Text('Or'),
                                  Container(
                                    height: 1,
                                    width: _height / 6.3272727272727275,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: _height / 37.963636363636365,
                              ),
                              GestureDetector(
                                onTap: () =>
                                    Navigator.pushNamed(context, 'TypeUser'),
                                child: Container(
                                  child: Text(
                                    'Create New Account',
                                    style: TextStyle(
                                      color: kGreen,
                                      fontSize: _height / 37.963636363636365,
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
                                height: _height / 37.963636363636365,
                              ),
                            ],
                          ),
                        );
                      else
                        return Container(
                          width: _height / 2.530909090909091,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: kWhite,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: _height / 30.370909090909092,
                              ),
                              Center(
                                child: Text(
                                  'Login as?',
                                  style: TextStyle(
                                    color: kGreen,
                                    fontSize: _height / 15.185454545454546,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    _height / 10.846753246753247142857142857143,
                              ),
                              Container(
                                width: _height / 4.745454545454545625,
                                height:
                                    _height / 13.804958677685950909090909090909,
                                child: ElevatedButton(
                                  child: Text(
                                    'User or Owner',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: _height / 25.30909090909091,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: kGreen,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      LogInScreen.route,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: _height / 37.963636363636365,
                              ),
                              Container(
                                width: _height / 4.745454545454545625,
                                height:
                                    _height / 13.804958677685950909090909090909,
                                child: TextButton(
                                  child: Text(
                                    'Employee',
                                    style: TextStyle(
                                      color: kGreen,
                                      fontSize: _height / 25.30909090909091,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    primary: kGreen,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        width: 2,
                                        color: kGreen,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      LogInEmployee.route,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: _height / 25.30909090909091,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 1,
                                    width: _height / 9.49090909090909125,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    'Or',
                                    style: TextStyle(
                                      fontSize: _height / 37.963636363636365,
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    width: _height / 9.49090909090909125,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: _height / 37.963636363636365,
                              ),
                              GestureDetector(
                                onTap: () =>
                                    Navigator.pushNamed(context, 'TypeUser'),
                                child: Container(
                                  child: Text(
                                    'Create New Account',
                                    style: TextStyle(
                                      color: kGreen,
                                      fontSize: _height / 30.370909090909092,
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
                                height: _height / 37.963636363636365,
                              ),
                            ],
                          ),
                        );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
