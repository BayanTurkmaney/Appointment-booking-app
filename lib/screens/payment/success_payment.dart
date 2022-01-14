import 'package:booking_app/utils/pallete.dart';
import 'package:flutter/material.dart';

class SuccessPayment extends StatefulWidget {
  static const route = '/succ-paym';

  @override
  State<SuccessPayment> createState() => _SuccessPaymentState();
}

class _SuccessPaymentState extends State<SuccessPayment> {
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
          backgroundColor: darkBlue,
          title: Text('Payment'),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            child: Icon(
              Icons.check_outlined,
              color: kWhite,
            ),
            backgroundColor: kGreen,
          ),
          SizedBox(
            height: _height / 37.963636363636365,
          ),
          Text('success payment'),
        ],
      ),
    );
  }
}
