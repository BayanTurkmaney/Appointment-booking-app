import 'package:booking_app/providers/institutionProvider.dart';
import 'package:booking_app/screens/bottom_bar/profile.dart';
import 'package:booking_app/screens/login_signup/logInAsEmployeeOrOwner.dart';
import 'package:booking_app/screens/users_screens/home.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _firstTime = true;
  late double _height;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _height = MediaQuery.of(context).size.height;
    if (_firstTime) {}
  }

  String family = 'Quicksand';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: EdgeInsets.only(top: _height / 25.30909090909091),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Text(
              'Main Menu',
              style: TextStyle(
                color: black,
                fontFamily: family,
                fontWeight: FontWeight.bold,
                fontSize: _height / 30.370909090909092,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: _height / 50.61818181818182,
                  right: _height / 50.61818181818182),
              child: Divider(
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () async {
                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                _prefs.clear();
                Navigator.of(context).pushReplacementNamed(
                  Home.route,
                );
              },
              title: Text(
                'Home',
                style: TextStyle(
                  color: black,
                  fontSize: _height / 37.963636363636365,
                  fontFamily: family,
                ),
              ),
              leading: Icon(
                Icons.home,
                color: black,
                size: _height / 30.370909090909092,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(Profile.route);
              },
              title: Text(
                'Profile',
                style: TextStyle(
                  color: black,
                  fontSize: _height / 37.963636363636365,
                  fontFamily: family,
                ),
              ),
              leading: Icon(
                Icons.person,
                color: black,
                size: _height / 30.370909090909092,
              ),
            ),
            ListTile(
              onTap: () {
                // Navigator.of(context).pushNamed(Profile.route);
              },
              title: Text(
                'Offers',
                style: TextStyle(
                  color: black,
                  fontSize: _height / 37.963636363636365,
                  fontFamily: family,
                ),
              ),
              leading: Icon(
                Icons.local_offer,
                color: black,
                size: _height / 30.370909090909092,
              ),
            ),
            ListTile(
              onTap: () async {
                Provider.of<InstitutionProvider>(
                  context,
                  listen: false,
                ).clearArrays();
                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                _prefs.clear();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  LogInAs.route,
                  (route) => false,
                );
              },
              title: Text(
                'Logout',
                style: TextStyle(
                  color: black,
                  fontSize: _height / 37.963636363636365,
                  fontFamily: family,
                ),
              ),
              leading: Icon(
                Icons.exit_to_app,
                color: black,
                size: _height / 30.370909090909092,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
