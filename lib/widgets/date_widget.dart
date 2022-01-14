import 'package:flutter/material.dart';

class DateWidget extends StatelessWidget {
  final String date;
  final Function onTap;
  late double _height;
  DateWidget({
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TextStyle(fontSize: 18),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: _height / 37.963636363636365,
                  color: Colors.grey,
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.only(
                left: 5.0,
                right: 18.0,
              ),
              child: Divider(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
