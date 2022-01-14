import 'package:booking_app/constants/functions.dart';
import 'package:booking_app/models/service.dart';
import 'package:booking_app/providers/auth.dart';
import 'package:booking_app/providers/serviceProvider.dart';
import 'package:booking_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/pallete.dart';

class AddServices extends StatefulWidget {
  static final route = '/add-service';

  @override
  _AddServicesState createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  bool _hasRetrainer = false, _atLeast = false, _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _data = {};
  int _currentStep = 0;
  bool _edit = false, _firstTime = true;
  late List<String> _categories;
  Service? _service;
  String _refresh = '';
  String? _value, _institutionId;
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
      _categories = _args['institutionSubCategories'];

      if (_edit) {
        _service = _args['service'];
        _value = _service!.category;
        _hasRetrainer = _service!.hasRetainer;
        _atLeast = _service!.atLeast;
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
                'Add Service',
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
          body: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(primary: kBlue),
            ),
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Stepper(
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
                        margin:
                            EdgeInsets.only(top: _height / 15.185454545454546),
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
                                  child: Text(
                                      _edit ? 'Update Service' : 'Add Service'),
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
            'Name',
            style: TextStyle(
                fontFamily: 'Opensans', fontSize: _height / 37.963636363636365),
          ),
          content: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name Of Service',
                  icon: Icon(
                    Icons.design_services,
                    color: black,
                  ),
                  labelStyle: TextStyle(
                      color: kBlue,
                      fontFamily: 'OpenSans',
                      fontSize: _height / 42.18181818181818333333333333333),
                ),
                initialValue: _edit ? _service!.name : null,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Name is Required';
                  }

                  return null;
                },
                onSaved: (String? value) {
                  _data['sname'] = value!;
                },
              ),
            ],
          ),
        ),
        Step(
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 1,
          title: Text(
            'Category',
            style: TextStyle(
                fontFamily: 'Opensans', fontSize: _height / 37.963636363636365),
          ),
          content: Column(
            children: [
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(border: Border.all(color: kBlue)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: _categories.map(buildMenueItem).toList(),
                    value: _value,
                    hint: Text('Choose Category'),
                    onChanged: (value) {
                      _data['category'] = value;
                      setState(() => this._value = value);
                    },
                    isExpanded: true,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: black,
                    ),
                    iconSize: _height / 18.9818181818181825,
                  ),
                ),
              ),
              TextFormField(
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Description',
                  icon: Icon(
                    Icons.category,
                    color: black,
                  ),
                  labelStyle: TextStyle(
                      color: kBlue,
                      fontFamily: 'OpenSans',
                      fontSize: _height / 42.18181818181818333333333333333),
                ),
                initialValue: _edit ? _service!.description : null,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Description is Required';
                  }

                  return null;
                },
                onSaved: (String? value) {
                  _data['serviceDescription'] = value!;
                },
              ),
            ],
          ),
        ),
        Step(
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 2,
          title: Text(
            'Price',
            style: TextStyle(
                fontFamily: 'Opensans', fontSize: _height / 37.963636363636365),
          ),
          content: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                  icon: Icon(
                    Icons.monetization_on_sharp,
                    color: black,
                  ),
                  labelStyle: TextStyle(
                      color: kBlue,
                      fontFamily: 'OpenSans',
                      fontSize: _height / 42.18181818181818333333333333333),
                ),
                initialValue: _edit ? _service!.price.toString() : null,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Price is Required';
                  }

                  return null;
                },
                onSaved: (String? value) {
                  _data['priceOfService'] = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Duration',
                  icon: Icon(
                    Icons.hourglass_bottom,
                    color: black,
                  ),
                  labelStyle: TextStyle(
                    fontFamily: 'OpenSans',
                    color: kBlue,
                    fontSize: _height / 42.18181818181818333333333333333,
                  ),
                ),
                keyboardType: TextInputType.number,
                initialValue: _edit ? _service!.length.toString() : null,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Duration is Required';
                  }

                  return null;
                },
                onSaved: (String? value) {
                  _data['duration'] = value!;
                },
              ),
              CheckboxListTile(
                value: _atLeast,
                onChanged: (value) => setState(() {
                  _atLeast = !_atLeast;
                }),
                title: Text(
                  'At Least?',
                  style: TextStyle(
                    fontFamily: 'Opensans',
                  ),
                ),
              ),
              CheckboxListTile(
                value: _hasRetrainer,
                onChanged: (value) => setState(() {
                  _hasRetrainer = !_hasRetrainer;
                }),
                title: Text(
                  'Has a Retainer?',
                  style: TextStyle(
                    fontFamily: 'Opensans',
                  ),
                ),
              ),
              _hasRetrainer
                  ? TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Retainer',
                        icon: Icon(
                          Icons.monetization_on_sharp,
                          color: black,
                        ),
                        labelStyle: TextStyle(
                            color: kBlue,
                            fontFamily: 'OpenSans',
                            fontSize:
                                _height / 42.18181818181818333333333333333),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Retainer is Required';
                        }

                        return null;
                      },
                      initialValue:
                          _edit ? _service!.retainer.toString() : null,
                      onSaved: (String? value) {
                        _data['retainer'] = value!;
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ];

  Future<void> _done() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      ServicesProvider _servicesProvider = Provider.of<ServicesProvider>(
        context,
        listen: false,
      );

      Auth _auth = Provider.of<Auth>(
        context,
        listen: false,
      );

      _data['hasRetainer'] = _hasRetrainer;
      _data['atLeast'] = _atLeast;

      _servicesProvider.setServiceData(
        newData: _data,
      );

      String? _token = _auth.token;

      late bool _doneSuccessfully;

      if (_edit) {
        List<dynamic> _list = await _servicesProvider.updateService(
          token: _token!,
          serviceId: _service!.institutionId,
        );

        _doneSuccessfully = _list[0];
        setState(() {
          _isLoading = false;
        });
        if (_doneSuccessfully) {
          showMessage(
            message: 'Service Updated Successfully.',
            color: Colors.green,
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
        List<dynamic> _list = await _servicesProvider.addService(
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
            message: 'Service Added Successfully.',
            color: Colors.green,
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

  DropdownMenuItem<String> buildMenueItem(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(fontSize: _height / 37.963636363636365),
      ),
    );
  }
}
