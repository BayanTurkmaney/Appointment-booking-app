import 'package:booking_app/screens/bottom_bar/user_appointments.dart';
import 'package:booking_app/screens/bottom_bar/user_settings.dart';
import 'package:booking_app/screens/users_screens/home.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:booking_app/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class MainUser extends StatefulWidget {
  static const route = '/main-user';

  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  var screens = [
    Home(),
    UserAppointments(),
    UserSettings(),
  ];
  int index = 0;
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
    return Scaffold(
      drawer: CustomDrawer(),
      body: screens[index],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: black,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (index) {
            setState(() {
              this.index = index;
            });
          },
          selectedItemColor: black,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(
            color: Colors.green,
          ),
          unselectedLabelStyle: TextStyle(
            color: Colors.black,
          ),
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(
                Icons.home,
                size: _height / 25.30909090909091,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Appointments',
              icon: Icon(
                Icons.timer,
                size: _height / 25.30909090909091,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Settings',
              icon: Icon(
                Icons.settings,
                size: _height / 25.30909090909091,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
