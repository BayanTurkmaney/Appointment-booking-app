import 'package:booking_app/models/employee.dart';
import 'package:booking_app/models/institution.dart';
import 'package:booking_app/providers/employeeProvider.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:booking_app/widgets/employee_card2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectEmployee extends StatefulWidget {
  static const route = '/select-employees';

  @override
  _SelectEmployeeState createState() => _SelectEmployeeState();
}

class _SelectEmployeeState extends State<SelectEmployee> {
  late Institution _institution;
  bool _firstTime = true, _isLoading = true;
  List<Employee> _employees = [];
  late int _servicesListLength;
  late double _height;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;

      Map<String, dynamic>? _args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      _institution = _args!['institution'];
      _servicesListLength = _args['servicesListLength'];
      _getEmployees();
      _firstTime = false;
    }
  }

  Future<void> _getEmployees() async {
    _employees = await Provider.of<EmployeesProvider>(
      context,
      listen: false,
    ).employees(
      institutionId: _institution.id,
    );

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
            'Select Employee',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: _height / 34.512396694214877272727272727273,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: kGreen,
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) => EmployeeCard2(
                employee: _employees[index],
                servicesListLength: _servicesListLength,
              ),
              itemCount: _employees.length,
            ),
    );
  }
}
