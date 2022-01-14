import 'package:animated_text/animated_text.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:booking_app/widgets/background-image.dart';
import 'package:flutter/material.dart';

class TypeUser extends StatefulWidget {
  static const String route = 'TypeUser';

  @override
  _TypeUserState createState() => _TypeUserState();
}

class _TypeUserState extends State<TypeUser> {
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
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: _height / 7.592727272727273,
                    ),
                    Center(
                      child: Container(
                        width: double.infinity,
                        height: _height / 11.681118881118881538461538461538,
                        padding: EdgeInsets.all(15),
                        child: AnimatedText(
                          alignment: Alignment.center,
                          speed: Duration(milliseconds: 1000),
                          controller: AnimatedTextController.loop,
                          repeatCount: 1,
                          displayTime: Duration(milliseconds: 100),
                          wordList: ['Signup as:', ''],
                          textStyle: TextStyle(
                              color: kWhite,
                              fontFamily: 'OpenSans',
                              fontSize: _height / 16.87272727272727,
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
                    ),
                    SizedBox(
                      height: _height / 3.7963636363636365,
                    ),
                    Container(
                      width: _height / 2.4103896103896104761904761904762,
                      height: _height / 12.654545454545455,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: ElevatedButton(
                          child: Text(
                            'owner',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: _height / 25.30909090909091),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: kGreen.withOpacity(0.55),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              'SignUPScreen',
                              arguments: {
                                'type': 'owner',
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _height / 37.963636363636365,
                    ),
                    Container(
                      width: _height / 2.4103896103896104761904761904762,
                      height: _height / 12.654545454545455,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: ElevatedButton(
                            child: Text(
                              'user',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _height / 25.30909090909091),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: kGreen.withOpacity(0.55),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                'SignUPScreen',
                                arguments: {
                                  'type': 'user',
                                },
                              );
                            }),
                      ),
                    ),
                  ],
                );
              } else
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: _height / 7.592727272727273,
                    ),
                    Center(
                      child: Text(
                        'Sign up as:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _height / 10.846753246753247142857142857143,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _height / 3.7963636363636365,
                    ),
                    Container(
                      width: _height / 3.7963636363636365,
                      height: _height / 12.654545454545455,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: ElevatedButton(
                          child: Text(
                            'owner',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: _height / 15.185454545454546),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: kGreen,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              'SignUPScreen',
                              arguments: {
                                'type': 'owner',
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _height / 25.30909090909091,
                    ),
                    Container(
                      width: _height / 3.7963636363636365,
                      height: _height / 12.654545454545455,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: ElevatedButton(
                          child: Text(
                            'user',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: _height / 15.185454545454546),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: kGreen,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              'SignUPScreen',
                              arguments: {
                                'type': 'user',
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
            },
          ),
        ),
      ],
    );
  }
}
