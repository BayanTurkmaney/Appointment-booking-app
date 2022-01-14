import 'package:booking_app/models/employee.dart';
import 'package:booking_app/models/institution.dart';
import 'package:booking_app/models/service.dart';
import 'package:booking_app/models/users/user.dart';
import 'package:booking_app/providers/appointmentProvider.dart';
import 'package:booking_app/providers/auth.dart';
import 'package:booking_app/providers/employeeProvider.dart';
import 'package:booking_app/providers/institutionProvider.dart';
import 'package:booking_app/providers/serviceProvider.dart';
import 'package:booking_app/screens/payment/select_employee.dart';
import 'package:booking_app/screens/payment/select_services.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:booking_app/widgets/employee_card.dart';
import 'package:booking_app/widgets/service_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class Details extends StatefulWidget {
  static const String route = '/detail';

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  bool _isFavorite = false,
      _firstTime = true,
      details = true,
      _isLoading = true;
  late Institution _institution;
  User? _user;
  List<Service> _services = [];
  List<Employee> _employees = [];
  double rating = 0.0;
  String? userId, institutionId;
  String? token;
  late double _height;
  late String _institutionId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;
      _user = Provider.of<Auth>(context).user;
      Map<String, dynamic>? _args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      _institutionId = _args!['institutionId'];
      _getInstitution();
      userId = _user!.idUser;
      _getEmployeesAndServices();

      _firstTime = false;
    }
  }

  Future<void> _getInstitution() async {
    _institution = (await Provider.of<InstitutionProvider>(
      context,
      listen: false,
    ).getInstitutionById(
      institutionId: _institutionId,
    ))!;
  }

  Future<void> _getServices() async {
    _services = await Provider.of<ServicesProvider>(
      context,
      listen: false,
    ).services(
      institutionId: _institutionId,
    );
  }

  Future<void> _getEmployees() async {
    _employees = await Provider.of<EmployeesProvider>(
      context,
      listen: false,
    ).employees(
      institutionId: _institutionId,
    );
  }

  Future<void> _getEmployeesAndServices() async {
    await _getServices();
    await _getEmployees();

    setState(() {
      _isLoading = false;
    });
  }

  String family = 'OpenSans';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: black,
              ),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: _height / 2.7609917355371901818181818181818,
                        child: CarouselSlider(
                          items: [
                            FadeInImage(
                              placeholder: AssetImage(
                                'assets/images/loading.gif',
                              ),
                              imageErrorBuilder: (_, __, ___) => Image(
                                image: AssetImage(
                                  'assets/images/logo.png',
                                ),
                              ),
                              image: NetworkImage(_institution.photo),
                              fit: BoxFit.cover,
                            ),
                            if (_institution.sliderImages.isNotEmpty)
                              ..._institution.sliderImages
                                  .map(
                                    (image) => FadeInImage(
                                      placeholder: AssetImage(
                                        'assets/images/loading.gif',
                                      ),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) => Image(
                                        image: AssetImage(
                                          'assets/images/logo.png',
                                        ),
                                      ),
                                      image: NetworkImage(image),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  .toList(),
                          ],
                          options: CarouselOptions(
                            autoPlay: true,
                            height: _height / 2.530909090909091,
                            viewportFraction: 1,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text(
                                  _institution.name,
                                  style: TextStyle(
                                    fontFamily: family,
                                    fontSize: _height / 25.30909090909091,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text(
                                  _institution.subCategories.join(', '),
                                  style: TextStyle(
                                    fontSize: _height / 37.963636363636365,
                                    color: Colors.grey,
                                    fontFamily: family,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text(
                                  (_institution.address['country'] == null ||
                                              _institution.address['country'] ==
                                                  '') &&
                                          (_institution.address['city'] ==
                                                  null ||
                                              _institution.address['city'] ==
                                                  '')
                                      ? 'Unknown'
                                      : _institution.address['country']
                                              .toString() +
                                          ', ' +
                                          _institution.address['city']
                                              .toString(),
                                  style: TextStyle(
                                    fontFamily: family,
                                    fontSize: _height / 37.963636363636365,
                                    // fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: _height / 37.963636363636365,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    'Rating:   ',
                                    style: TextStyle(
                                      fontFamily: family,
                                      fontSize: _height / 37.963636363636365,
                                      // fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  Expanded(
                                    child: RatingBar.builder(
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
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                top: 5,
                                bottom: 5,
                                left: _height / 37.963636363636365,
                              ),
                              child: Divider(
                                color: Colors.grey[250],
                                thickness: 2,
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Icon(Icons.timer),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'opens at:   ${_institution.openAt}:00',
                                          style: TextStyle(
                                            fontFamily: family,
                                            fontSize:
                                                _height / 37.963636363636365,
                                            // fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: _height / 37.963636363636365,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Icon(Icons.timer),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'closes at:   ${_institution.closeAt}:00',
                                          style: TextStyle(
                                            fontFamily: family,
                                            fontSize:
                                                _height / 37.963636363636365,
                                            // fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                top: 5,
                                bottom: 5,
                                left: _height / 37.963636363636365,
                              ),
                              child: Divider(
                                color: Colors.grey[250],
                                thickness: 2,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Description',
                                style: TextStyle(
                                  fontFamily: family,
                                  fontSize: _height /
                                      42.18181818181818333333333333333,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text(
                                  _institution.description,
                                  style: TextStyle(
                                    fontFamily: family,
                                    fontSize: _height /
                                        42.18181818181818333333333333333,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: _height / 7.592727272727273,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Services:',
                                style: TextStyle(
                                  fontSize: _height /
                                      33.011857707509882608695652173913,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              constraints: BoxConstraints(
                                maxHeight: 300,
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => ServiceCard(
                                  details: details,
                                  servicesListLength: _services.length,
                                  service: _services[index],
                                  institution: _institution,
                                ),
                                itemCount: _services.length >= 3
                                    ? 3
                                    : _services.length,
                              ),
                            ),
                            SizedBox(
                              height: _height / 37.963636363636365,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  Provider.of<Appointments>(
                                    context,
                                    listen: false,
                                  ).setValue(
                                    key: 'institutionId',
                                    value: _institution.id,
                                  );
                                  Navigator.of(context).pushNamed(
                                    SelectService.route,
                                    arguments: {
                                      'subCategories':
                                          _institution.subCategories,
                                      'services': _services,
                                      'employees': _employees,
                                      'institution': _institution,
                                    },
                                  );
                                },
                                child: Text(
                                  '+ see all services',
                                  style: TextStyle(
                                    fontSize: _height / 37.963636363636365,
                                    color: Colors.blue,
                                    fontFamily: 'Quicksand',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: _height / 18.9818181818181825,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Staff:',
                                style: TextStyle(
                                  fontSize: _height /
                                      33.011857707509882608695652173913,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: _height / 18.9818181818181825,
                            ),
                            Container(
                              width: double.infinity,
                              constraints: BoxConstraints(
                                maxHeight: 300,
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => EmployeeCard(
                                  employee: _employees[index],
                                ),
                                itemCount: _employees.length,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    SelectEmployee.route,
                                    arguments: {'institution': _institution},
                                  );
                                },
                                child: Text(
                                  '+ see all employees',
                                  style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: _height / 37.963636363636365,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 100,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: _height / 25.30909090909091,
                  left: _height / 37.963636363636365,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: _height / 25.30909090909091,
                  right: _height / 37.963636363636365,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                    },
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: _isFavorite
                          ? Icon(
                              Icons.favorite_border_outlined,
                              size: _height / 25.30909090909091,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.favorite,
                              size: _height / 25.30909090909091,
                              color: Colors.red,
                            ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: _height / 7.592727272727273,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(_height / 37.963636363636365),
                        topRight: Radius.circular(_height / 37.963636363636365),
                      ),
                      color: black,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Services',
                                style: TextStyle(
                                  fontSize: _height /
                                      33.011857707509882608695652173913,
                                  color: kWhite,
                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                _services.length.toString(),
                                style: TextStyle(
                                  fontSize: _height / 30.370909090909092,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 10,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Provider.of<Appointments>(
                                context,
                                listen: false,
                              ).setValue(
                                key: 'institutionId',
                                value: _institution.id,
                              );
                              Navigator.of(context).pushNamed(
                                SelectService.route,
                                arguments: {
                                  'subCategories': _institution.subCategories,
                                  'services': _services,
                                  'employees': _employees,
                                  'institution': _institution,
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Book a service',
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  color: kBlue,
                                  fontSize: _height / 37.963636363636365,
                                ),
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
    );
  }

  Future<void> _rateFunction(double rate) async {
    await Provider.of<InstitutionProvider>(context, listen: false)
        .rateInstitution(
      rate: rate,
      token: token,
      userId: userId,
      institutionId: _institutionId,
    );
  }
}
