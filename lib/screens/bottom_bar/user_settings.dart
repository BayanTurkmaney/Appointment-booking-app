import 'package:booking_app/screens/bottom_bar/profile.dart';
import 'package:booking_app/screens/login_signup/logInAsEmployeeOrOwner.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:booking_app/widgets/custom_appbar.dart';
import 'package:booking_app/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettings extends StatefulWidget {
  static const route = '/settings';

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  late double _height;
  bool _firstTime = true;
  late int _sHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;
      _sHeight = _height.floor();
      _firstTime = false;
    }
  }

  String family = 'OpenSans';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_height / 7.592727272727273),
        child: AppBar(
          title: Text(
            'Settings',
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
              width: double.infinity,
              height: _height / 5.061818181818182,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 158, 216, 240),
                    kBlue,
                    Color.fromARGB(255, 158, 216, 240),
                  ],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  tileMode: TileMode.clamp,
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: CustomDrawer(),
      body: ListView(
        padding: EdgeInsets.only(left: 15),
        children: [
          SizedBox(
            height: _height / 37.963636363636365,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Profile.route);
            },
            child: Row(
              children: [
                Icon(Icons.person),
                SizedBox(
                  width: 15,
                ),
                Text(
                  'My profile',
                  style: TextStyle(
                    fontFamily: family,
                    fontSize: _height / 37.963636363636365,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(_height / 37.963636363636365),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          Row(
            children: [
              Icon(Icons.attach_money),
              SizedBox(
                width: 15,
              ),
              Text(
                'Vouchers',
                style: TextStyle(
                  fontFamily: family,
                  fontSize: _height / 37.963636363636365,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(_height / 37.963636363636365),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          Row(
            children: [
              Icon(Icons.money),
              SizedBox(
                width: 15,
              ),
              Text(
                'Bills',
                style: TextStyle(
                  fontSize: _height / 37.963636363636365,
                  fontFamily: family,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(_height / 37.963636363636365),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          Row(
            children: [
              Icon(Icons.local_offer),
              SizedBox(
                width: 15,
              ),
              Text(
                'Offers',
                style: TextStyle(
                  fontSize: _height / 37.963636363636365,
                  fontFamily: family,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(_height / 37.963636363636365),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          Row(
            children: [
              Icon(Icons.language),
              SizedBox(
                width: 15,
              ),
              Text(
                'Language',
                style: TextStyle(
                  fontSize: _height / 37.963636363636365,
                  fontFamily: family,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(_height / 37.963636363636365),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          GestureDetector(
            onTap: () async {
              SharedPreferences _prefs = await SharedPreferences.getInstance();
              _prefs.clear();
              Navigator.of(context).pushNamedAndRemoveUntil(
                LogInAs.route,
                (route) => false,
              );
            },
            child: Row(
              children: [
                Icon(Icons.logout),
                SizedBox(
                  width: 15,
                ),
                Text(
                  'LogOut',
                  style: TextStyle(
                    fontSize: _height / 37.963636363636365,
                    fontFamily: family,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
