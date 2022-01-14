import 'dart:ui';

import 'package:booking_app/constants/functions.dart';
import 'package:booking_app/models/institution.dart';
import 'package:booking_app/models/service.dart';
import 'package:booking_app/providers/appointmentProvider.dart';
import 'package:booking_app/screens/payment/select_employee.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceCardCheck extends StatefulWidget {
  final bool details;
  final Service service;
  final Institution institution;
  final int servicesListLength;

  ServiceCardCheck({
    required this.details,
    required this.service,
    required this.institution,
    required this.servicesListLength,
  });

  @override
  _ServiceCardCheckState createState() => _ServiceCardCheckState();
}

class _ServiceCardCheckState extends State<ServiceCardCheck> {
  bool? _val = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          CheckboxListTile(
            // selectedTileColor: ,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (value) {
              setState(() {
                _val = value;
              });
              if (_val!) {
                if (widget.details) {
                  _showModal(screenHeight, width);
                } else {
                  Provider.of<Appointments>(
                    context,
                    listen: false,
                  ).setValue(
                    key: 'serviceId',
                    value: widget.service.id,
                  );

                  bool _result = Provider.of<Appointments>(
                    context,
                    listen: false,
                  ).addServiceId(
                    serviceId: widget.service.id,
                  );

                  if (_result) {
                    Navigator.pushNamed(context, SelectEmployee.route,
                        arguments: {
                          'institution': widget.institution,
                          'servicesListLength': widget.servicesListLength,
                        });
                  } else {
                    showMessage(
                      message: 'You Already Chose This Service',
                      color: Colors.blue,
                      context: context,
                    );
                  }
                }
              }
            },
            value: _val,
            activeColor: kBlue,
            checkColor: kWhite,
            title: Text(
              widget.service.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  fontSize: screenHeight / 37.963636363636365),
            ),
            subtitle: Text(
              widget.service.length.toString() + ' min',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
                fontFamily: 'OpenSans',
              ),
            ),
            selected: false,
          ),
          Container(
            width: width,
            padding: EdgeInsets.only(
              top: 5,
              bottom: 5,
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

  void _showModal(double screenHeight, double width) {
    showModalBottomSheet(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        height: (screenHeight / 3) * 2,
        width: width,
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Description',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      fontSize: screenHeight / 25.30909090909091),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(
                    widget.service.description,
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: screenHeight / 37.963636363636365,
                        color: Colors.grey),
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
