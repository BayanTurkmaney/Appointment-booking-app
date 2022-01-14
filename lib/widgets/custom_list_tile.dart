import 'package:booking_app/utils/pallete.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title, subtitle;
  final Function edit;
  final Function delete;
  late double _height;

  CustomListTile({
    required this.title,
    required this.subtitle,
    required this.edit,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.all(_height / 75.92727272727273),
      child: Container(
        width: double.infinity,
        height: _height / 7.592727272727273,
        child: Card(
          elevation: 10.0,
          child: ListTile(
            title: Container(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: _height / 37.963636363636365,
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
            subtitle: Container(
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: _height / 37.963636363636365,
                  color: Colors.grey,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
            trailing: Container(
              width: _height / 7.592727272727273,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: kBlue,
                    ),
                    onPressed: () {
                      edit();
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      delete();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
