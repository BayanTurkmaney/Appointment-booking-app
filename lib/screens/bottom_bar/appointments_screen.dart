import 'package:booking_app/constants/functions.dart';
import 'package:booking_app/models/appointment.dart';
import 'package:booking_app/models/institution.dart';
import 'package:booking_app/providers/appointmentProvider.dart';
import 'package:booking_app/providers/auth.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:booking_app/widgets/appointment_card.dart';
import 'package:booking_app/widgets/custom_appbar.dart';
import 'package:booking_app/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentsScreen extends StatefulWidget {
  static const String route = 'appointments';

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  late Institution _institution;
  bool _firstTime = true;
  List<Appointment> _appointments = [];
  bool _isLoading = true;
  late double _height;
  late int _sHeight;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;
      _sHeight = _height.floor();
      Map<String, dynamic>? _args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      _institution = _args!['institution'];
      _getAppointments();
      _firstTime = false;
    }
  }

  Future<void> _getAppointments() async {
    _appointments = await Provider.of<Appointments>(
      context,
      listen: false,
    ).appointments(
      institutionId: _institution.id,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_sHeight > 759.27
            ? _height / 6.9024793388429754545454545454545
            : _height / 7.592727272727273),
        child: AppBar(
          title: Text(
            '${_institution.name}',
            style: TextStyle(
                color: kWhite,
                fontSize: _sHeight > 759.27 ? 33 : 22,
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
      // drawer: CustomDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: black,
              ),
            )
          : _appointments.isEmpty
              ? Center(
                  child: Container(
                    child: Text(
                      'There is no appointments at the moment',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _height / 37.963636363636365,
                        color: Colors.grey,
                        fontFamily: 'OPenSans',
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  itemBuilder: (context, index) => AppointmentCard(
                    appointment: _appointments[index],
                    height: MediaQuery.of(context).size.height,
                    delete: () => _deleteAppointment(
                      appointmentId: _appointments[index].id,
                    ),
                  ),
                  itemCount: _appointments.length,
                  physics: BouncingScrollPhysics(),
                ),
    );
  }

  Future<void> _deleteAppointment({
    required String appointmentId,
  }) async {
    Navigator.of(context).pop();

    setState(() {
      _isLoading = true;
    });

    Auth _auth = Provider.of<Auth>(
      context,
      listen: false,
    );

    String? _token = _auth.token;

    List<dynamic> _deletedList = await Provider.of<Appointments>(
      context,
      listen: false,
    ).deleteAppointment(
      appointmentId: appointmentId,
      token: _token!,
    );

    setState(() {
      _isLoading = false;
    });

    if (_deletedList[0]) {
      showMessage(
        color: Colors.green,
        message: 'Appointment Deleted Successfully.',
        context: context,
      );
    } else {
      showMessage(
        color: Colors.red,
        message: _deletedList[1],
        context: context,
      );
    }
  }
}
