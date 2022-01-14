import 'package:booking_app/models/appointment.dart';
import 'package:booking_app/models/employee.dart';
import 'package:booking_app/models/service.dart';
import 'package:booking_app/models/users/user.dart';
import 'package:booking_app/providers/auth.dart';
import 'package:booking_app/providers/employeeProvider.dart';
import 'package:booking_app/providers/serviceProvider.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentCard extends StatefulWidget {
  final Appointment appointment;
  final double height;
  final Function delete;
  final Employee? employee;

  AppointmentCard({
    required this.appointment,
    required this.delete,
    required this.height,
    this.employee,
  });

  @override
  _AppointmentCardState createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  late User? _user;
  late Employee? _employee;
  List<Service> _services = [];
  bool _firstTime = true, _isLoading = true;
  late double _height;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _employee = widget.employee;
      _height = MediaQuery.of(context).size.height;
      _getUserAndEmployeeAndServices();
      _firstTime = false;
    }
  }

  Future<void> _getUserAndEmployeeAndServices() async {
    _user = await Provider.of<Auth>(context, listen: false).getUserById(
      id: widget.appointment.userId,
    );

    if (_employee == null)
      _employee = await Provider.of<EmployeesProvider>(
        context,
        listen: false,
      ).getEmployeeById(
        id: widget.appointment.employeeId,
      );

    _services = await Provider.of<ServicesProvider>(
      context,
      listen: false,
    ).getAppointmentServicesByIds(
      servicesIds: widget.appointment.servicesIds,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showDetails,
      child: Container(
        padding: EdgeInsets.all(40.0),
        width: _height / 7.592727272727273,
        height: _height / 2.530909090909091,
        child: Card(
          elevation: 5,
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin:
                          EdgeInsets.only(left: _height / 30.370909090909092),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: _height / 37.963636363636365,
                          ),
                          SizedBox(
                            height: _height / 37.963636363636365,
                          ),
                          Row(
                            children: [
                              Text(
                                'name:',
                                style: TextStyle(
                                  color: black,
                                  fontFamily: 'OpenSans',
                                  fontSize: _height / 37.963636363636365,

                                  // fontWeight: FontWeight.w500
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Container(
                                child: Text(
                                  _user!.firstName + ' ' + _user!.lastName,
                                  style: TextStyle(
                                    color: black,
                                    fontFamily: 'OpenSans',
                                    fontSize: _height / 37.963636363636365,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Text(
                                'employee:',
                                style: TextStyle(
                                  color: black,
                                  fontFamily: 'OpenSans',
                                  fontSize: _height / 37.963636363636365,
                                  // fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Container(
                                child: Text(
                                  _employee!.firstName +
                                      ' ' +
                                      _employee!.lastName,
                                  style: TextStyle(
                                    color: black,
                                    fontFamily: 'OpenSans',
                                    fontSize: _height / 37.963636363636365,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Text(
                                'time:',
                                style: TextStyle(
                                  color: black,
                                  fontSize: 20,
                                  fontFamily: 'OpenSans',
                                  // fontWeight: FontWeight.w500
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                widget.appointment.date,
                                style: TextStyle(
                                  color: black,
                                  fontFamily: 'OpenSans',
                                  fontSize: _height / 37.963636363636365,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _showDetails() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(_height / 37.963636363636365),
          topLeft: Radius.circular(_height / 37.963636363636365),
        ),
      ),
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
      builder: (context) => _buildModalContent(
        height: widget.height,
        context: context,
      ),
    );
  }

  Container _buildModalContent({
    required double height,
    required BuildContext context,
  }) {
    return Container(
      height: height * .8,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  _buildDetails(height),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildDetails(double height) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            title: 'User:',
            value: _user!.firstName + ' ' + _user!.lastName,
            height: height,
          ),
          SizedBox(
            height: 20,
          ),
          _buildInfoRow(
            title: 'Employee',
            value: _employee!.firstName + ' ' + _employee!.lastName,
            height: height,
          ),
          SizedBox(
            height: 20,
          ),
          _buildInfoRow(
            title: 'Time:',
            value: widget.appointment.date,
            height: height,
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            'Booked Services:',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: black,
              height: 1,
              fontWeight: FontWeight.bold,
              fontSize: height / 34.512396694214877272727272727273,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: _services
                .map(
                  (e) => Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(
                        color: black,
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        e.name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          height: 1,
                          fontWeight: FontWeight.bold,
                          fontSize: height / 34.512396694214877272727272727273,
                        ),
                      ),
                      subtitle: Text(
                        e.price.toStringAsFixed(2),
                        style: TextStyle(
                          color: Colors.black,
                          height: 1,
                          fontSize: height / 34.512396694214877272727272727273,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }

  Row _buildInfoRow({
    required String title,
    required String value,
    required double height,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            height: 1,
            fontWeight: FontWeight.bold,
            fontSize: height / 34.512396694214877272727272727273,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            height: 1,
            fontSize: height / 34.512396694214877272727272727273,
          ),
        ),
      ],
    );
  }
}
