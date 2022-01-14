import 'package:booking_app/constants/functions.dart';
import 'package:booking_app/providers/auth.dart';
import 'package:booking_app/providers/employeeProvider.dart';
import 'package:booking_app/screens/bottom_bar/home_owner_addServiceScreen.dart';
import 'package:booking_app/screens/employee_app/AppointmentsScreen.dart';
import 'package:booking_app/screens/login_signup/logInAsEmployeeOrOwner.dart';
import 'package:booking_app/screens/users_screens/main_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static const String route = '/splash';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late double _height;
  bool _firstTime = true;
  late String _type;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;

      _firstTime = false;
    }
  }

  Future<void> _navigate() async {
    final Auth _auth = Provider.of<Auth>(
      context,
      listen: false,
    );

    final EmployeesProvider _employeesProvider = Provider.of<EmployeesProvider>(
      context,
      listen: false,
    );

    bool _isLoggedIn = await _auth.isLoggedIn();
    bool _isEmployeeLoggedIn = await _employeesProvider.isLoggedIn();
    // SharedPreferences _prefs = await SharedPreferences.getInstance();
    // _prefs.clear();
    // Navigator.of(context).pushNamedAndRemoveUntil(
    //   LogInAs.route,
    //   (route) => false,
    // );

    if (_isLoggedIn) {
      await _auth.setUser();
      _auth.setPassword();

      _type = _auth.user!.type;
      await getPlans(context: context);
      await getCategories(context: context);

      if (_type == 'user') {
        Navigator.of(context).pushReplacementNamed(
          MainUser.route,
        );
      } else if (_type == 'owner') {
        Navigator.of(context).pushReplacementNamed(
          AddServiceScreen.route,
        );
      }
    } else if (_isEmployeeLoggedIn) {
      await _employeesProvider.setEmployee();

      await _employeesProvider.setPassword();

      Navigator.of(context)
          .pushReplacementNamed(EmployeeAppointmentsScreen.route);
    } else {
      //comment this
      Navigator.of(context).pushReplacementNamed(LogInAs.route);
    }
  }

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.center,
        child: AnimationLimiter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 1500),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                SizedBox(
                  height: _height / 3.4512396694214877272727272727273,
                ),
                SlideAnimation(
                  horizontalOffset: 50.0,
                  child: Container(
                    width: _height / 3.7963636363636365,
                    height: _height / 3.7963636363636365,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image(
                      image: AssetImage(
                        'assets/images/logo.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: _height / 3.4512396694214877272727272727273,
                ),
                SlideAnimation(
                  horizontalOffset: 50.0,
                  child: Text(
                    'TerminPro',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: _height / 25.30909090909091,
                      fontFamily: 'OpenSans',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
