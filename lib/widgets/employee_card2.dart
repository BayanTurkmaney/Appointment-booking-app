import 'dart:ui';

import 'package:booking_app/models/employee.dart';
import 'package:booking_app/providers/appointmentProvider.dart';
import 'package:booking_app/screens/payment/select_time.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeCard2 extends StatefulWidget {
  final Employee employee;
  final int servicesListLength;

  EmployeeCard2({
    required this.employee,
    required this.servicesListLength,
  });

  @override
  _EmployeeCard2State createState() => _EmployeeCard2State();
}

class _EmployeeCard2State extends State<EmployeeCard2> {
  @override
  bool? _val = false;
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return SizedBox(
      width: width,
      child: Column(
        children: [
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: _val,
            onChanged: (value) {
              setState(() {
                _val = value;
              });
              if (_val!) {
                Provider.of<Appointments>(
                  context,
                  listen: false,
                ).setValue(
                  key: 'employeeId',
                  value: widget.employee.id,
                );

                Navigator.pushNamed(context, SelectTime.route, arguments: {
                  'employeeId': widget.employee.id,
                  'servicesListLength': widget.servicesListLength,
                });
              }
            },
            title: Padding(
              padding: EdgeInsets.only(top: screenHeight / 75.92727272727273),
              child: Container(
                child: Text(
                  widget.employee.firstName + '' + widget.employee.lastName,
                  style: TextStyle(
                      fontSize: screenHeight / 37.963636363636365,
                      fontFamily: 'Opensans'),
                ),
              ),
            ),
            subtitle: Container(
              child: Text(
                widget.employee.speciality ?? '',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: screenHeight / 50.61818181818182,
                    fontFamily: 'Opensans'),
              ),
            ),
            selected: false,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: screenHeight / 151.8545454545455,
              bottom: screenHeight / 151.8545454545455,
              left: screenHeight / 37.963636363636365,
            ),
            child: Divider(
              color: Colors.grey[250],
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}
