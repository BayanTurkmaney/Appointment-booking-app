import 'package:booking_app/models/employee.dart';
import 'package:booking_app/models/users/user.dart';
import 'package:booking_app/providers/auth.dart';
import 'package:booking_app/providers/employeeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class EmployeeCard extends StatefulWidget {
  final Employee employee;

  EmployeeCard({
    required this.employee,
  });

  @override
  _EmployeeCardState createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
  double rating = 0.0;
  User? user;
  String? userId, employeeId;
  String? token;
  late double _height;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = Provider.of<Auth>(context, listen: false).user;
    token = Provider.of<EmployeesProvider>(context, listen: false).token;
    userId = user!.idUser;
    employeeId = widget.employee.id;
    _height = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Padding(
      padding: EdgeInsets.only(left: _height / 50.61818181818182),
      child: Column(
        children: [
          Container(
            width: width * 0.23,
            height: screenHeight * 0.23,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.hardEdge,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/loading.gif'),
              imageErrorBuilder: (context, error, stackTrace) => Image(
                image: AssetImage(
                  'assets/images/logo.png',
                ),
              ),
              image: NetworkImage(widget.employee.photo!),
              fit: BoxFit.cover,
            ),
          ),
          RatingBar.builder(
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            updateOnDrag: true,
            itemSize: _height / 37.963636363636365,
            itemPadding: EdgeInsets.symmetric(
              horizontal: 1,
            ),
            onRatingUpdate: (value) {
              setState(() {
                this.rating = value;
              });
              _rateFunction(value);
            },
            minRating: 1,
            unratedColor: Colors.grey,
          ),
          Container(
            child: Text(
              widget.employee.firstName + ' ' + widget.employee.lastName,
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: _height / 42.18181818181818333333333333333,
              ),
            ),
          ),
          Text(
            widget.employee.speciality ?? '',
            style: TextStyle(
              fontFamily: 'OpenSans',
              color: Colors.grey,
              fontSize: _height / 42.18181818181818333333333333333,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _rateFunction(double rate) async {
    await Provider.of<EmployeesProvider>(context, listen: false).rateEmployee(
      rate: rate,
      employeeId: employeeId,
      token: token,
      userId: userId,
    );
  }
}
