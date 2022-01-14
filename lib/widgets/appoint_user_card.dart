import 'package:booking_app/models/appointment.dart';
import 'package:booking_app/models/employee.dart';
import 'package:booking_app/models/service.dart';
import 'package:booking_app/models/users/user.dart';
import 'package:booking_app/providers/employeeProvider.dart';
import 'package:booking_app/providers/serviceProvider.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentUserCard extends StatefulWidget {
  final Appointment appointment;
  final double height;
  final User? user;

  AppointmentUserCard({
    required this.appointment,
    required this.height,
    this.user,
  });

  @override
  _AppointmentUserCardState createState() => _AppointmentUserCardState();
}

class _AppointmentUserCardState extends State<AppointmentUserCard> {
  Employee? _employee;
  List<Service> _services = [];
  bool _firstTime = true, _isLoading = true;
  double count = 0.0;
  late double _height;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;
      _getUserAndEmployeeAndServices();

      _firstTime = false;
    }
  }

  Future<bool> _getUserAndEmployeeAndServices() async {
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

    double _tmpCount = 0.0;

    _services.forEach((element) {
      _tmpCount += element.price;
    });

    setState(() {
      count = _tmpCount;
      _isLoading = false;
    });

    return true;
  }

  String family = 'OpenSans';
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showDetails,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_height / 37.963636363636365),
        ),
        padding: EdgeInsets.all(_height / 42.18181818181818333333333333333),
        width: _height / 4.745454545454545625,
        height: _height / 1.8295728368017525301204819277108,
        child: Card(
          elevation: 5,
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: _height / 37.963636363636365,
                    ),
                    Container(
                      width: _height / 3.5315010570824525581395348837209,
                      height: _height / 21.0909090909090,
                      decoration: BoxDecoration(
                        color: kBlue,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('$count',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _height / 37.963636363636365,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: _height / 42.18181818181818333333333333333),
                        child: ListView(
                          children: [
                            SizedBox(
                              height: _height / 25.30909090909091,
                            ),
                            Row(
                              children: [
                                Text(
                                  'name:',
                                  style: TextStyle(
                                    color: black,
                                    fontSize: _height / 37.963636363636365,
                                    // fontWeight: FontWeight.w500
                                    fontFamily: family,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  child: Text(
                                    widget.user!.firstName +
                                        ' ' +
                                        widget.user!.lastName,
                                    style: TextStyle(
                                      color: black,
                                      fontFamily: family,
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
                                  'institution:',
                                  style: TextStyle(
                                    color: black,
                                    fontSize: _height / 37.963636363636365,
                                    // fontWeight: FontWeight.w500),
                                    fontFamily: family,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  child: Text(
                                    ' _institution!.name',
                                    style: TextStyle(
                                      color: black,
                                      fontFamily: family,
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
                                  'employee:',
                                  style: TextStyle(
                                      color: black,
                                      fontFamily: family,
                                      fontSize: _height / 37.963636363636365,
                                      fontWeight: FontWeight.w500),
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
                                        fontFamily: family,
                                        fontSize: _height / 37.963636363636365),
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
                                  'address:',
                                  style: TextStyle(
                                    color: black,
                                    fontSize: _height / 37.963636363636365,
                                    // fontWeight: FontWeight.w500
                                    fontFamily: family,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  child: Text(
                                    'address',
                                    style: TextStyle(
                                      color: black,
                                      fontFamily: family,
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
                                    fontFamily: family,
                                    fontSize: _height / 37.963636363636365,
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
                                    fontFamily: family,
                                    fontSize: _height / 37.963636363636365,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                    height: _height / 37.963636363636365,
                  ),
                  _buildDetails(height),
                  SizedBox(
                    height: _height / 37.963636363636365,
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
            value: widget.user!.firstName + ' ' + widget.user!.lastName,
            height: height,
          ),
          SizedBox(
            height: _height / 37.963636363636365,
          ),
          _buildInfoRow(
            title: 'Employee',
            value: _employee!.firstName + ' ' + _employee!.lastName,
            height: height,
          ),
          SizedBox(
            height: _height / 37.963636363636365,
          ),
          _buildInfoRow(
            title: 'Time:',
            value: widget.appointment.date,
            height: height,
          ),
          SizedBox(
            height: _height / 15.185454545454546,
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
            height: _height / 37.963636363636365,
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
