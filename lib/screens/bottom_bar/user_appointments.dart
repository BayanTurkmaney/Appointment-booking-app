import 'package:booking_app/models/appointment.dart';
import 'package:booking_app/models/users/user.dart';
import 'package:booking_app/providers/appointmentProvider.dart';
import 'package:booking_app/providers/auth.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:booking_app/widgets/appoint_user_card.dart';
import 'package:booking_app/widgets/custom_appbar.dart';
import 'package:booking_app/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAppointments extends StatefulWidget {
  static const route = '/user-appointment';

  @override
  _UserAppointmentsState createState() => _UserAppointmentsState();
}

class _UserAppointmentsState extends State<UserAppointments> {
  bool firstTime = true, _isLoading = true;
  late User? user;
  late double _height;
  List<Appointment> _appointments = [];
  late int _sHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstTime) {
      _height = MediaQuery.of(context).size.height;
      _sHeight = _height.floor();
      user = Provider.of<Auth>(
        context,
        listen: false,
      ).user;

      _getAppointmentsByUser();

      firstTime = false;
    }
  }

  Future<void> _getAppointmentsByUser() async {
    _appointments = await Provider.of<Appointments>(
      context,
      listen: false,
    ).getAppointmentsByUser(userId: user!.idUser);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_height / 7.592727272727273),
        child: AppBar(
          title: Text(
            'My Appointments',
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: black,
              ),
            )
          : _appointments.isEmpty
              ? Center(
                  child: Text(
                    'You Don\'t Have Any Appointments',
                    style: TextStyle(
                      fontSize: _height / 37.963636363636365,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  itemBuilder: (context, index) => AppointmentUserCard(
                    appointment: _appointments[index],
                    height: MediaQuery.of(context).size.height,
                    user: user,
                  ),
                  itemCount: _appointments.length,
                  physics: BouncingScrollPhysics(),
                ),
    );
  }
}
