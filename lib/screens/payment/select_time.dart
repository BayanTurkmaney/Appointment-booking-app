import 'package:booking_app/constants/functions.dart';
import 'package:booking_app/providers/appointmentProvider.dart';
import 'package:booking_app/providers/employeeProvider.dart';
import 'package:booking_app/screens/payment/review_and_confirm.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:booking_app/widgets/date_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectTime extends StatefulWidget {
  static const route = '/select-time';

  @override
  _SelectTimeState createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  TextEditingController timeController = TextEditingController();
  List<String> _times = [];
  late String _employeeId;
  bool _firstTime = true, _isLoading = true;
  late int _servicesListLength;
  late double _height;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;

      Map<String, dynamic>? _args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      _employeeId = _args!['employeeId'];
      _servicesListLength = _args['servicesListLength'];
      _getTimes();
      _firstTime = false;
    }
  }

  Future<void> _getTimes() async {
    List<dynamic> _tmpList = await Provider.of<EmployeesProvider>(
      context,
      listen: false,
    ).getEmployeeWorkingTimes(
      employeeId: _employeeId,
    );

    if (_tmpList[0]) {
      _times = _tmpList[1];
    } else {
      showMessage(
        message: _tmpList[1],
        color: Colors.red,
        context: context,
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_height / 5.061818181818182),
        child: AppBar(
          backgroundColor: black,
          title: Text(
            'Select Time',
            style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: _height / 34.512396694214877272727272727273),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: black,
              ),
            )
          : _times.isEmpty
              ? Center(
                  child: Text(
                    'Unfortunately, No Times Available',
                    style: TextStyle(
                      fontSize: _height / 37.963636363636365,
                      color: Colors.grey,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: _height / 37.963636363636365,
                      ),
                      Container(
                        child: Text(
                          'When would you like to book the service?',
                          style: TextStyle(
                            fontFamily: 'Opensans',
                            fontSize: _height / 30.370909090909092,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _height / 37.963636363636365,
                      ),
                      ..._times
                          .map(
                            (date) => DateWidget(
                              date: date,
                              onTap: () => _onTap(
                                date: date,
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
    );
  }

  void _onTap({
    required String date,
  }) {
    int _servicesIdsListLength = Provider.of<Appointments>(
      context,
      listen: false,
    ).servicesIds.length;

    if (_servicesIdsListLength != _servicesListLength) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Do you want to choose another service?',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontFamily: 'OpenSans',
              color: black,
              height: 1,
              fontSize: 20,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(Confirm.route);
              },
              child: Text(
                'No',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  color: kBlue,
                  height: 1,
                  fontSize: 20,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<Appointments>(
                  context,
                  listen: false,
                ).setValue(
                  key: 'date',
                  value: date,
                );

                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'Yes',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  color: black,
                  height: 1,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      Navigator.of(context).pushNamed(Confirm.route);
    }
  }
}
