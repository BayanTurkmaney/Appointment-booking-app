import 'package:booking_app/constants/functions.dart';
import 'package:booking_app/models/employee.dart';
import 'package:booking_app/providers/auth.dart';
import 'package:booking_app/providers/employeeProvider.dart';
import 'package:booking_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/pallete.dart';

class AddEmployees extends StatefulWidget {
  static final route = '/add-employee';

  @override
  _AddEmployeesState createState() => _AddEmployeesState();
}

class _AddEmployeesState extends State<AddEmployees> {
  List<String> urls = [];
  Map<String, dynamic> _data = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _firstTime = true, _isLoading = false, _edit = false;
  String _refresh = '';
  String? _institutionId;
  Employee? _employee;
  late double _height;
  late int _sHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;
      _sHeight = _height.floor();
      Map<String, dynamic>? _args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      if (_args != null) _edit = _args['edit'] ?? false;
      _institutionId = _args!['institutionId'];

      if (_edit) {
        _employee = _args['employee'];
      }
      _firstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_refresh);
        return true;
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(_height / 7.592727272727273),
            child: AppBar(
              title: Text(
                'Add Employees',
                style: TextStyle(
                    color: kWhite,
                    fontSize: _height / 31.6363636363636375,
                    fontFamily: 'Quicksand'),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: ClipPath(
                clipper: MyCustomClipper(),
                child: Container(
                  width: double.infinity,
                  height: _height / 5.061818181818182,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 158, 216, 240),
                        kBlue,
                        Color.fromARGB(255, 158, 216, 240),
                      ],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      tileMode: TileMode.clamp,
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: black,
                  ),
                )
              : Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(primary: kBlue),
                  ),
                  child: Stepper(
                    type: StepperType.vertical,
                    steps: getSteps(),
                    currentStep: _currentStep,
                    onStepContinue: () {
                      final isLastStep = _currentStep == getSteps().length - 1;
                      if (isLastStep) {
                      } else {
                        setState(() => _currentStep += 1);
                      }
                    },
                    onStepCancel: _currentStep == 0
                        ? null
                        : () => setState(() => _currentStep -= 1),
                    onStepTapped: (step) => setState(() => _currentStep = step),
                    controlsBuilder: (context, {onStepContinue, onStepCancel}) {
                      final isLastStep = _currentStep == getSteps().length - 1;
                      return Container(
                        margin: EdgeInsets.only(
                          top: _height / 15.185454545454546,
                        ),
                        child: !isLastStep
                            ? Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: onStepContinue,
                                      child:
                                          Text(isLastStep ? 'CONFIRM' : 'NEXT'),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  if (_currentStep != 0)
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: onStepCancel,
                                        child: Text('BACK'),
                                      ),
                                    ),
                                ],
                              )
                            : Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _done,
                                  child: _isLoading
                                      ? CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          _edit ? 'Update' : 'Add',
                                          style: TextStyle(
                                              fontFamily: 'Opensans',
                                              fontSize:
                                                  _height / 37.963636363636365),
                                        ),
                                ),
                              ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 0,
          title: Text(
            'Account',
            style: TextStyle(
                fontFamily: 'Opensans', fontSize: _height / 37.963636363636365),
          ),
          content: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'First Name',
                  icon: Icon(
                    Icons.person_outline,
                    color: black,
                  ),
                  labelStyle: TextStyle(
                      color: kBlue,
                      fontFamily: 'OpenSans',
                      fontSize: _height / 42.18181818181818333333333333333),
                ),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'First Name is Required';
                  }

                  return null;
                },
                initialValue: _edit ? _employee!.firstName : null,
                onSaved: (String? value) {
                  _data['firstName'] = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  icon: Icon(
                    Icons.person_outline,
                    color: black,
                  ),
                  labelStyle: TextStyle(
                      color: kBlue,
                      fontFamily: 'Opensans',
                      fontSize: _height / 42.18181818181818333333333333333),
                ),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'last name is Required';
                  }

                  return null;
                },
                onSaved: (String? value) {
                  _data['lastName'] = value!;
                },
                initialValue: _edit ? _employee!.lastName : null,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(
                    Icons.email,
                    color: black,
                  ),
                  labelStyle: TextStyle(
                      fontFamily: 'OpenSans',
                      color: kBlue,
                      fontSize: _height / 42.18181818181818333333333333333),
                ),
                initialValue: _edit ? _employee!.email : null,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Email is Required';
                  }

                  if (!RegExp(
                          r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                      .hasMatch(value)) {
                    return 'Please enter a valid email Address';
                  }

                  return null;
                },
                onSaved: (String? value) {
                  _data['email'] = value!;
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(
                    Icons.remove_red_eye_outlined,
                    color: black,
                  ),
                  labelStyle: TextStyle(
                      fontFamily: 'OpenSans',
                      color: kBlue,
                      fontSize: _height / 42.18181818181818333333333333333),
                ),
                initialValue: _edit ? _employee!.password : null,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Password is Required';
                  }

                  return null;
                },
                onSaved: (String? value) {
                  _data['password'] = value!;
                },
              ),
            ],
          ),
        ),
        Step(
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 1,
          title: Text(
            'Speciality',
            style: TextStyle(
                fontFamily: 'Opensans', fontSize: _height / 37.963636363636365),
          ),
          content: Container(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Speciality',
                icon: Icon(
                  Icons.business_center,
                  color: black,
                ),
                labelStyle: TextStyle(
                    fontFamily: 'OpenSans',
                    color: kBlue,
                    fontSize: _height / 42.18181818181818333333333333333),
              ),
              initialValue: _edit ? _employee!.speciality : null,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Speciality is Required';
                }

                return null;
              },
              onSaved: (String? value) {
                _data['speciality'] = value!;
              },
            ),
          ),
        ),
      ];

  Future<void> _done() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      EmployeesProvider _employeesProvider = Provider.of<EmployeesProvider>(
        context,
        listen: false,
      );

      Auth _auth = Provider.of<Auth>(context, listen: false);

      _employeesProvider.setEmployeeData(
        newData: _data,
      );

      String? _token = _auth.token;

      late bool _doneSuccessfully;

      if (_edit) {
        List<dynamic> _list = await _employeesProvider.updateEmployee(
          token: _token!,
          employeeId: _employee!.id,
        );

        _doneSuccessfully = _list[0];

        setState(() {
          _isLoading = false;
        });

        if (_doneSuccessfully) {
          showMessage(
            message: 'Employee Updated Successfully.',
            color: kBlue,
            context: context,
          );

          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
        } else {
          showMessage(
            message: _list[1],
            color: Colors.red,
            context: context,
          );
        }
      } else {
        List<dynamic> _list = await _employeesProvider.addEmployee(
          institutionId: _institutionId!,
          token: _token!,
        );

        _doneSuccessfully = _list[0];

        setState(() {
          _isLoading = false;
        });

        if (_doneSuccessfully) {
          _formKey.currentState!.reset();
          showMessage(
            message: 'Employee Added Successfully.',
            color: kBlue,
            context: context,
          );
        } else {
          showMessage(
            message: _list[1],
            color: Colors.red,
            context: context,
          );
        }
      }

      if (_doneSuccessfully) {
        _refresh = 'true';
      }
    }
  }
}
