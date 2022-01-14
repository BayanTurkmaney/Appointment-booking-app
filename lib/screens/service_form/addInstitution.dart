import 'dart:convert';
import 'dart:io';

import 'package:booking_app/constants/functions.dart';
import 'package:booking_app/models/category.dart';
import 'package:booking_app/models/institution.dart';
import 'package:booking_app/models/plan.dart';
import 'package:booking_app/providers/auth.dart';
import 'package:booking_app/providers/institutionProvider.dart';
import 'package:booking_app/widgets/custom_appbar.dart';
import 'package:booking_app/widgets/plan_item.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../utils/pallete.dart';

class AddInstitution extends StatefulWidget {
  static final route = '/catego';

  @override
  _AddInstitutionState createState() => _AddInstitutionState();
}

class _AddInstitutionState extends State<AddInstitution> {
  String? _image;
  String? _chosenImage;
  List<File> _slider = [];
  int _currentStep = 0;
  bool _edit = false, _firstTime = true;
  Map<String, dynamic> _data = {};
  Institution? _institution;
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? _val;
  String? _value;
  bool _skippedPlan = false, _isLoading = true;
  List<Plan> _plans = [];
  List<Category> _categories = [];
  String? _opensAtTime, _closesAtTime;
  late double _height;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;

      _getPlansAndCategories();

      Map<String, dynamic>? _args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      if (_args != null) _edit = _args['edit'] ?? false;

      if (_edit) {
        _institution = _args!['institution'];
        _image = _institution!.photo;
        _value = _institution!.category;
      }

      _firstTime = false;
    }
  }

  Future<void> _getPlansAndCategories() async {
    _plans = await getPlans(context: context);
    _categories = await getCategories(context: context);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getImage() async {
    final _tmpImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _chosenImage = _tmpImage!.path;
    });
  }

  Future<void> _getImages() async {
    final _tmpImagesList = await ImagePicker().pickMultiImage();

    _tmpImagesList!.forEach((image) {
      if (_slider.length < 8) {
        final _imageFile = File(image.path);

        setState(() {
          _slider.add(_imageFile);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(_height / 7.592727272727273),
          child: AppBar(
            title: Text(
              _edit ? 'Update Institution' : 'Add Institution',
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
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 158, 216, 240),
                        kBlue,
                        Color.fromARGB(255, 158, 216, 240),
                      ],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      tileMode: TileMode.clamp),
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
                  child: CircularProgressIndicator(
                    color: black,
                  ),
                )
              : Stepper(
                  physics: BouncingScrollPhysics(),
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
                                    child: Text(
                                      'NEXT',
                                      // style: TextStyle(fontFamily: 'Quicksand'),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                if (_currentStep == 0)
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _skippedPlan = true;
                                        _val = null;
                                        onStepContinue!();
                                      },
                                      child: Text(
                                        'SKIP',
                                        // style:
                                        //     TextStyle(fontFamily: 'Quicksand'),
                                      ),
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
                                  _edit ? 'Update' : 'Add',
                                  style: TextStyle(fontFamily: 'OpenSans'),
                                ),
                              ),
                            ),
                    );
                  },
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
            'Plan',
            style: TextStyle(
                fontFamily: 'Opensans', fontSize: _height / 37.963636363636365),
          ),
          content: _currentStep == 0
              ? Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose Your Plan:',
                        style: TextStyle(
                            fontFamily: 'Opensans',
                            fontSize: _height / 37.963636363636365),
                      ),
                      SizedBox(
                        height: _height / 37.963636363636365,
                      ),
                      ..._plans.map(
                        (plan) => Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: PlanItem(
                                  plan: plan,
                                ),
                                onTap: () {
                                  setState(() {
                                    _val = plan.id;
                                  });
                                },
                                leading: Radio(
                                  value: plan.id,
                                  groupValue: _val,
                                  onChanged: (value) {
                                    setState(() {
                                      _val = value as String?;
                                    });
                                  },
                                  activeColor: kBlue,
                                  fillColor: MaterialStateColor.resolveWith(
                                    (states) => kBlue,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: _height / 37.963636363636365,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ),
        Step(
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 1,
          title: Text(
            'Account',
            style: TextStyle(
                fontFamily: 'Opensans', fontSize: _height / 37.963636363636365),
          ),
          content: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name Of Institution',
                  icon: Icon(
                    Icons.home_work,
                    color: black,
                  ),
                  labelStyle: TextStyle(
                      color: kBlue,
                      fontFamily: 'Opensans',
                      fontSize: _height / 42.18181818181818333333333333333),
                ),
                initialValue: _edit ? _institution!.name : null,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Name is Required';
                  }

                  return null;
                },
                onSaved: (String? value) {
                  _data['name'] = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Subtitle',
                  icon: Icon(
                    Icons.home_work,
                    color: Colors.black,
                  ),
                  labelStyle: TextStyle(
                      fontFamily: 'Opensans',
                      color: kBlue,
                      fontSize: _height / 42.18181818181818333333333333333),
                ),
                initialValue: _edit ? _institution!.subtitle : null,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Subtitle is Required';
                  }

                  return null;
                },
                onSaved: (String? value) {
                  _data['subtitle'] = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                  labelStyle: TextStyle(
                      fontFamily: 'Opensans',
                      color: kBlue,
                      fontSize: _height / 42.18181818181818333333333333333),
                ),
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
                initialValue: _edit ? _institution!.email : null,
                onSaved: (String? value) {
                  _data['email'] = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Paypal Email',
                  icon: Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                  labelStyle: TextStyle(
                      fontFamily: 'Opensans',
                      color: kBlue,
                      fontSize: _height / 42.18181818181818333333333333333),
                ),
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
                initialValue: _edit ? _institution!.paypalEmail : null,
                onSaved: (String? value) {
                  _data['paypalEmail'] = value!;
                },
              ),
              SizedBox(
                height: _height / 37.963636363636365,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: _image == null && _chosenImage == null
                        ? Center(
                            child: Text(
                              'No Image Chosen',
                              style: TextStyle(fontFamily: 'Opensans'),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : _edit
                            ? _image != null
                                ? Image(
                                    width: _height / 7.592727272727273,
                                    height: _height / 7.592727272727273,
                                    fit: BoxFit.cover,
                                    image: NetworkImage(_image!),
                                  )
                                : _chosenImage != null
                                    ? Image.file(
                                        File(_chosenImage!),
                                      )
                                    : Center(
                                        child: Text(
                                          'No Image Chosen',
                                          style:
                                              TextStyle(fontFamily: 'Opensans'),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                            : _image != null
                                ? Image(
                                    width: _height / 7.592727272727273,
                                    height: _height / 7.592727272727273,
                                    fit: BoxFit.cover,
                                    image: NetworkImage(_image!),
                                  )
                                : _chosenImage != null
                                    ? Image.file(
                                        File(_chosenImage!),
                                      )
                                    : Center(
                                        child: Text(
                                          'No Image Chosen',
                                          style:
                                              TextStyle(fontFamily: 'Opensans'),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                    width: _height / 7.592727272727273,
                    height: _height / 7.592727272727273,
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _getImage,
                    icon: Icon(Icons.camera_alt_sharp),
                    label: Text('pick from gallery'),
                  ),
                ],
              ),
              SizedBox(
                height: _height / 37.963636363636365,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _getImages,
                  icon: Icon(Icons.camera_alt_sharp),
                  label: Text(
                    'pick slider images (7 images max)',
                    style: TextStyle(fontFamily: 'Opensans'),
                  ),
                ),
              ),
              if (_slider.isNotEmpty)
                SizedBox(
                  height: _height / 37.963636363636365,
                ),
              if (_slider.isNotEmpty)
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: kBlue,
                      width: 2,
                    ),
                  ),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: _slider.length,
                    itemBuilder: (context, index) => Stack(
                      children: [
                        Card(
                          clipBehavior: Clip.hardEdge,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            width: _height / 5.061818181818182,
                            height: _height / 5.061818181818182,
                            child: Image.file(
                              _slider[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _slider.removeAt(index);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              clipBehavior: Clip.hardEdge,
                              width: _height / 30.370909090909092,
                              height: _height / 30.370909090909092,
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        Step(
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 2,
          title: Text(
            'Category',
            style: TextStyle(
                fontFamily: 'Opensans', fontSize: _height / 37.963636363636365),
          ),
          content: Column(
            children: [
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kBlue,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: [
                      ..._categories.map(
                        (e) {
                          return DropdownMenuItem(
                            value: e.name,
                            child: Text(
                              e.name,
                              style: TextStyle(
                                fontSize: _height / 37.963636363636365,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                    value: _value,
                    hint: Text(
                      'Choose Category',
                      style: TextStyle(fontSize: _height / 37.963636363636365),
                    ),
                    onChanged: (value) {
                      _data['category'] = value;
                      setState(() => _value = value);
                    },
                    isExpanded: true,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    iconSize: _height / 18.9818181818181825,
                  ),
                ),
              ),
              TextFormField(
                initialValue: _edit
                    ? _institution!.subCategories
                        .toString()
                        .replaceAll(']', '')
                        .replaceAll('[', '')
                    : null,
                decoration: InputDecoration(
                  labelText: 'Sub Category',
                  icon: Icon(
                    Icons.category_rounded,
                    color: Colors.black,
                  ),
                  labelStyle: TextStyle(
                    fontFamily: 'OpenSans',
                    color: kBlue,
                    fontSize: _height / 42.18181818181818333333333333333,
                  ),
                ),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Sub Category is Required';
                  }

                  return null;
                },
                onSaved: (String? value) {
                  _data['subCategory'] = value!;
                },
              ),
              TextFormField(
                maxLines: 2,
                initialValue: _edit ? _institution!.description : null,
                decoration: InputDecoration(
                  labelText: 'Description',
                  icon: Icon(
                    Icons.description,
                    color: Colors.black,
                  ),
                  labelStyle: TextStyle(
                    fontFamily: 'OpenSans',
                    color: kBlue,
                    fontSize: _height / 42.18181818181818333333333333333,
                  ),
                ),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Description is Required';
                  }

                  return null;
                },
                onSaved: (String? value) {
                  _data['description'] = value!;
                },
              ),
            ],
          ),
        ),
        Step(
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 3,
          title: Text(
            'Location',
            style: TextStyle(
                fontFamily: 'Opensans', fontSize: _height / 37.963636363636365),
          ),
          content: Column(
            children: [
              TextFormField(
                initialValue: _edit ? _institution!.address['country'] : null,
                decoration: InputDecoration(
                  labelText: 'Country',
                  icon: Icon(
                    Icons.location_on,
                    color: Colors.black,
                  ),
                  labelStyle: TextStyle(
                    color: kBlue,
                    fontFamily: 'Opensans',
                    fontSize: _height / 42.18181818181818333333333333333,
                  ),
                ),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Country is Required';
                  }

                  return null;
                },
                onSaved: (String? value) {
                  _data['country'] = value!;
                },
              ),
              TextFormField(
                initialValue: _edit ? _institution!.address['city'] : null,
                decoration: InputDecoration(
                  labelText: 'City',
                  icon: Icon(
                    Icons.location_city,
                    color: Colors.black,
                  ),
                  labelStyle: TextStyle(
                    fontFamily: 'Opensans',
                    color: kBlue,
                    fontSize: _height / 42.18181818181818333333333333333,
                  ),
                ),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'City is Required';
                  }

                  return null;
                },
                onSaved: (String? value) {
                  _data['city'] = value!;
                },
              ),
            ],
          ),
        ),
        Step(
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 4,
          title: Text(
            'Times',
            style: TextStyle(
                fontFamily: 'Opensans', fontSize: _height / 37.963636363636365),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _edit
                    ? _institution!.openingDays
                        .toString()
                        .replaceAll('[', '')
                        .replaceAll(']', '')
                    : null,
                decoration: InputDecoration(
                  labelText: 'Opening Days:',
                  helperText: 'e.g. Sunday, Monday, ...',
                  alignLabelWithHint: true,
                  icon: Icon(
                    Icons.category_rounded,
                    color: Colors.black,
                  ),
                  labelStyle: TextStyle(
                      color: kBlue,
                      fontFamily: 'OpenSans',
                      fontSize: _height / 42.18181818181818333333333333333),
                ),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Time is Required';
                  }

                  return null;
                },
                onSaved: (String? value) {
                  _data['openingDays'] = value!.split(',');
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Opens At',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: _height / 37.963636363636365,
                    ),
                  ),
                  TextButton(
                    child: Text(
                      _opensAtTime != null ? _opensAtTime! : 'Select Time',
                      style: TextStyle(
                        fontFamily: 'Opensans',
                        fontSize: _height / 37.963636363636365,
                      ),
                    ),
                    onPressed: () async {
                      String? _tmpTime = await _selectTime(context);

                      setState(() {
                        _opensAtTime = _tmpTime;
                      });
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: _height / 75.92727272727273,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Closes At',
                    style: TextStyle(
                      fontFamily: 'Opensans',
                      fontSize: _height / 37.963636363636365,
                    ),
                  ),
                  TextButton(
                    child: Text(
                      _closesAtTime != null ? _closesAtTime! : 'Select Time',
                      style: TextStyle(
                        fontSize: _height / 37.963636363636365,
                        fontFamily: 'Opensans',
                      ),
                    ),
                    onPressed: () async {
                      String? _tmpTime = await _selectTime(context);

                      setState(() {
                        _closesAtTime = _tmpTime;
                      });
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ],
              ),
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

      List<String> _sliderImagesBytes = [];
      _data['openAt'] = int.parse(_opensAtTime!.split(':')[0]);
      _data['closeAt'] = int.parse(_closesAtTime!.split(':')[0]);

      _slider.forEach((image) {
        List<int> _imageBytesArray = image.readAsBytesSync();

        _sliderImagesBytes.add(base64Encode(_imageBytesArray));
      });

      _data['photo'] = base64Encode(File(_chosenImage!).readAsBytesSync());
      _data['slider'] = _sliderImagesBytes;

      InstitutionProvider _institutionProvider =
          Provider.of<InstitutionProvider>(
        context,
        listen: false,
      );

      Auth _auth = Provider.of<Auth>(
        context,
        listen: false,
      );

      _institutionProvider.setInstitutionData(
        newData: _data,
      );

      String? _token = _auth.token;

      String? _ownerId = _auth.user!.idUser;

      late bool _doneSuccessfully;

      if (_edit) {
        List<dynamic> _list = await _institutionProvider.updateInstitution(
          token: _token!,
          ownerId: _ownerId,
          planId: _val!,
          institutionId: _institution!.id,
        );

        _doneSuccessfully = _list[0];

        if (_doneSuccessfully) {
          showMessage(
            message: 'Institution Updated Successfully.',
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
        List<dynamic> _list = await _institutionProvider.addInstitution(
          ownerId: _ownerId,
          token: _token!,
        );

        _doneSuccessfully = _list[0];

        if (_doneSuccessfully) {
          if (!_skippedPlan) {
            List<dynamic> _list2 = await _institutionProvider.subscribeToPlan(
              institutionId: _list[1],
              token: _token,
              ownerId: _auth.user!.idUser,
              planId: _val!,
            );

            if (_list2[0]) {
              _formKey.currentState!.reset();
              _val = null;
              showMessage(
                message: 'Institution Added Successfully.',
                color: kBlue,
                context: context,
              );
            } else {
              showMessage(
                message: _list2[1],
                color: Colors.red,
                context: context,
              );
            }
          } else {
            _formKey.currentState!.reset();

            showMessage(
              message: 'Institution Added Successfully.',
              color: kBlue,
              context: context,
            );
          }
        } else {
          showMessage(
            message: _list[1],
            color: Colors.red,
            context: context,
          );
        }
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _selectTime(BuildContext context) async {
    final TimeOfDay? _picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (_picked != null)
      return _stringifyTime(
        time: _picked,
      );
  }

  String _stringifyTime({
    required TimeOfDay time,
  }) {
    return time.hour.toString() +
        ':' +
        time.minute.toString() +
        ' ' +
        time.period.toString().split('.')[1].toUpperCase();
  }
}
