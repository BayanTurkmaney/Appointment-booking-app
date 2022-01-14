import 'package:booking_app/screens/login_signup/logInAsEmployeeOrOwner.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:booking_app/widgets/background-image.dart';
import 'package:flutter/material.dart';

class VerifyCodeScreen extends StatefulWidget {
  static const route = '/verify-code';

  @override
  _VerifyCodeScreenState createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  late var _code;
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
        Form(
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
                'Verify',
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
                          width: _height / 2.4103896103896104761904761904762,
                          child: Text(
                            'Check Your Phone Then Enter The Code Which We Sent Here:',
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
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              fillColor: Colors.grey.withOpacity(0.7),
                              filled: true,
                              prefixIcon: Icon(
                                Icons.confirmation_number,
                                color: kWhite,
                              ),
                              labelText: 'code 6-digits',
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontSize: _height / 30.370909090909092,
                              ),
                            ),
                            style: TextStyle(color: kWhite),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Code is required';
                              }

                              return null;
                            },
                            onSaved: (String? value) {
                              _code = value!;
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
                            onPressed: () {
                              Navigator.pushNamed(context, LogInAs.route);
                            },
                            child: _isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: kWhite,
                                    ),
                                  )
                                : Text(
                                    'Send',
                                    style: TextStyle(
                                      fontSize: _height / 37.963636363636365,
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
        )
      ],
    );
  }
}
