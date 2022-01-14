import 'package:booking_app/constants/functions.dart';
import 'package:booking_app/providers/employeeProvider.dart';
import 'package:booking_app/screens/employee_app/AppointmentsScreen.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:booking_app/widgets/background-image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogInEmployee extends StatefulWidget {
  static const String route = '/log-emp';

  @override
  State<StatefulWidget> createState() {
    return LogInEmployeeState();
  }
}

class LogInEmployeeState extends State<LogInEmployee> {
  late String _email;
  late String _password;
  bool _isLoading = false;
  late double _height;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              child: Container(
                width: _height / 1.89818181818181825,
                height: _height / 1.89818181818181825,
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Card(
                  elevation: 10.0,
                  child: SingleChildScrollView(
                    child: Container(
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
                                  color: Colors.grey,
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
                                  color: Colors.grey,
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
                                height: _height /
                                    10.846753246753247142857142857143),
                            Container(
                              width: _height / 3.7963636363636365,
                              height: _height / 15.185454545454546,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: kGreen,
                                ),
                                child: _isLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
                                        'login',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              _height / 37.963636363636365,
                                        ),
                                      ),
                                onPressed: _login,
                              ),
                            ),
                            SizedBox(
                              height: _height / 37.963636363636365,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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

      List<dynamic> _list = await Provider.of<EmployeesProvider>(
        context,
        listen: false,
      ).loginEmployee(
        _email,
        _password,
      );

      setState(() {
        _isLoading = false;
      });

      if (_list[0]) {
        Navigator.of(context)
            .pushReplacementNamed(EmployeeAppointmentsScreen.route);
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
