import 'package:booking_app/utils/pallete.dart';
import 'package:flutter/material.dart';

class CustomListTile2 extends StatelessWidget {
  final String title, subtitle;
  final Function edit;
  final Function delete;
  final String? photo;
  late double _height;
  CustomListTile2(
      {required this.title,
      required this.subtitle,
      required this.edit,
      required this.delete,
      required this.photo});

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
            leading: FadeInImage(
              image: NetworkImage(photo!),
              imageErrorBuilder: (context, error, stackTrace) => Image(
                image: AssetImage(
                  'assets/images/logo.png',
                ),
              ),
              fit: BoxFit.cover,
              placeholder: AssetImage(
                'assets/images/loading.gif',
              ),
            ),
            title: Container(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: _height / 42.18181818181818333333333333333,
                    color: Colors.black,
                    fontFamily: 'OpenSans'),
              ),
            ),
            subtitle: Container(
              child: Text(
                subtitle,
                style: TextStyle(
                    fontSize: _height / 42.18181818181818333333333333333,
                    color: Colors.grey,
                    fontFamily: 'OpenSans'),
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
