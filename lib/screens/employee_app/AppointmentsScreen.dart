import 'package:booking_app/constants/functions.dart';
import 'package:booking_app/models/appointment.dart';
import 'package:booking_app/models/employee.dart';
import 'package:booking_app/providers/appointmentProvider.dart';
import 'package:booking_app/providers/employeeProvider.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:booking_app/widgets/appointment_card.dart';
import 'package:booking_app/widgets/custom_appbar.dart';
import 'package:booking_app/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeAppointmentsScreen extends StatefulWidget {
  static const String route = 'employee-appointments';

  @override
  _EmployeeAppointmentsScreenState createState() =>
      _EmployeeAppointmentsScreenState();
}

class _EmployeeAppointmentsScreenState
    extends State<EmployeeAppointmentsScreen> {
  bool _firstTime = true, _isLoading = true;
  Employee? emp;
  late String _employeeId;
  List<Appointment> _appointments = [];
  late double _height;
  late int _sHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;

      _sHeight = _height.floor();

      emp = Provider.of<EmployeesProvider>(
        context,
        listen: false,
      ).employee;
      _employeeId = emp!.id;
      _getAppointmentsByEmployee();

      _firstTime = false;
    }
  }

  Future<void> _getAppointmentsByEmployee() async {
    _appointments = await Provider.of<Appointments>(
      context,
      listen: false,
    ).employeeAppointments(
      employeeId: _employeeId,
      firstTime: true,
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
            'My Appointments',
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
                  itemBuilder: (context, index) => AppointmentCard(
                    appointment: _appointments[index],
                    height: MediaQuery.of(context).size.height,
                    delete: () => _deleteAppointment(
                      appointmentId: _appointments[index].id,
                    ),
                    employee: emp,
                  ),
                  itemCount: _appointments.length,
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

    EmployeesProvider _auth = Provider.of<EmployeesProvider>(
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
        color: kBlue,
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
