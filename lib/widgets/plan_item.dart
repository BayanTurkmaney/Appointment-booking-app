import 'package:booking_app/models/plan.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:flutter/material.dart';

class PlanItem extends StatelessWidget {
  final Plan plan;
  late double _height;
  PlanItem({
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.3,
      height: _height * 0.4,
      color: kWhite,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: width * 0.4,
                height: _height * 0.04,
                color: kBlue,
                child: Text(
                  plan.price.toStringAsFixed(2),
                  style: TextStyle(
                    color: kWhite,
                    fontSize: _height / 37.963636363636365,
                    fontFamily: 'OpenSans',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              plan.name + ':',
              style: TextStyle(
                fontSize: _height / 37.963636363636365,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
                color: kBlue,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SKU:',
                  style: TextStyle(
                    color: black,
                    fontSize: _height / 37.963636363636365,
                    fontFamily: 'OpenSans',
                    // fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  plan.sku,
                  style: TextStyle(
                    fontSize: _height / 37.963636363636365,
                    color: black,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Employees Limit:',
                    style: TextStyle(
                      fontSize: _height / 37.963636363636365,
                      fontFamily: 'OpenSans',
                      //fontWeight: FontWeight.w400,
                      color: black,
                    ),
                  ),
                ),
                Text(
                  plan.employeesLimit.toString(),
                  style: TextStyle(
                    fontSize: _height / 37.963636363636365,
                    color: black,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: _height / 37.963636363636365,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Services Limit:',
                    style: TextStyle(
                      fontSize: _height / 37.963636363636365,
                      // fontWeight: FontWeight.w400,
                      color: black,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
                Text(
                  plan.servicesLimit.toString(),
                  style: TextStyle(
                    fontSize: _height / 37.963636363636365,
                    color: black,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
