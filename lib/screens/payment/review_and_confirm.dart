import 'package:booking_app/constants/functions.dart';
import 'package:booking_app/providers/appointmentProvider.dart';
import 'package:booking_app/providers/auth.dart';
import 'package:booking_app/screens/payment/success_payment.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Confirm extends StatefulWidget {
  static const String route = '/confirm';

  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  bool _isLoading = false;
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_height / 5.061818181818182),
        child: AppBar(
          backgroundColor: black,
          title: Text(
            'Payment',
            style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: _height / 34.512396694214877272727272727273),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: kGreen,
              ),
            )
          : Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: _height / 37.963636363636365,
                    ),
                    Text(
                      'Confirm your appointment:',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: _height / 30.370909090909092,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: _height / 37.963636363636365,
                    ),
                    Text(
                      'Click here to activate your appointment by entering your '
                      'financial account information ',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: _height / 37.963636363636365,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: _height / 7.592727272727273,
                        ),
                        width: _height / 3.7963636363636365,
                        height: _height / 10.123636363636364,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: black,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(
                            _height / 31.6363636363636375,
                          ),
                          color: Colors.grey[200],
                        ),
                        child: TextButton(
                          onPressed: _done,
                          child: Text(
                            'pay',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: _height / 30.370909090909092,
                              color: black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _done() async {
    setState(() {
      _isLoading = true;
    });

    String? _token = Provider.of<Auth>(
      context,
      listen: false,
    ).token;

    List<dynamic> _addingList = await Provider.of<Appointments>(
      context,
      listen: false,
    ).addAppointmentsAndPayForServices(
      token: _token!,
    );

    setState(() {
      _isLoading = false;
    });

    if (_addingList[0]) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        SuccessPayment.route,
        (route) => false,
      );
    } else {
      print(_addingList[1]);
      showMessage(
        message: _addingList[1],
        color: Colors.red,
        context: context,
      );
    }
  }
}
