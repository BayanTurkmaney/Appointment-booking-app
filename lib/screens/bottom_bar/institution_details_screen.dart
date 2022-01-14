import 'package:booking_app/constants/functions.dart';
import 'package:booking_app/models/employee.dart';
import 'package:booking_app/models/institution.dart';
import 'package:booking_app/models/service.dart';
import 'package:booking_app/providers/auth.dart';
import 'package:booking_app/providers/employeeProvider.dart';
import 'package:booking_app/providers/serviceProvider.dart';
import 'package:booking_app/screens/bottom_bar/appointments_screen.dart';
import 'package:booking_app/screens/service_form/addEmplyees.dart';
import 'package:booking_app/screens/service_form/addInstitution.dart';
import 'package:booking_app/screens/service_form/addServices.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:booking_app/widgets/custom_list_tile.dart';
import 'package:booking_app/widgets/custom_list_tile2.dart';
import 'package:booking_app/widgets/owner_custom_drawer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstitutionDetailsScreen extends StatefulWidget {
  static const String route = 'inst-details';

  @override
  _InstitutionDetailsScreenState createState() =>
      _InstitutionDetailsScreenState();
}

class _InstitutionDetailsScreenState extends State<InstitutionDetailsScreen> {
  late Institution _institution;
  bool _firstTime = true,
      _isLoading = true,
      _expanded = false,
      _expandedEmp = false;
  List<Service> _services = [];
  List<Employee> _employees = [];
  late double _height;
  String? _token;
  late int _sHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstTime) {
      _height = MediaQuery.of(context).size.height;

      _sHeight = _height.floor();
      _token = Provider.of<Auth>(context).token;
      Map<String, dynamic>? _args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      _institution = _args!['institution'];
      print('instbis:' + _institution.ownerId);
      print('token is:' + _token!);

      _getServicesAndEmployees();

      _firstTime = false;
    }
  }

  Future<void> _getServices() async {
    _services = await Provider.of<ServicesProvider>(
      context,
      listen: false,
    ).services(
      institutionId: _institution.id,
    );
  }

  Future<void> _getEmployees() async {
    _employees = await Provider.of<EmployeesProvider>(
      context,
      listen: false,
    ).employees(
      institutionId: _institution.id,
    );
  }

  Future<void> _getServicesAndEmployees() async {
    await _getServices();
    await _getEmployees();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlue,
        title: Text(
          '${_institution.name}',
          style: TextStyle(
              color: kWhite,
              fontSize: _sHeight > 759.27 ? 33 : 22,
              fontFamily: 'Quicksand'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                AddInstitution.route,
                arguments: {
                  'edit': true,
                  'institution': _institution,
                },
              );
            },
            icon: Icon(
              Icons.edit,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppointmentsScreen.route,
                arguments: {
                  'institution': _institution,
                },
              );
            },
            icon: Icon(
              Icons.history,
            ),
          ),
        ],
      ),
      drawer: OwnerCustomDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: black,
              ),
            )
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: _height / 2.530909090909091,
                    child: CarouselSlider(
                      items: [
                        Image(
                          image: NetworkImage(
                            _institution.photo,
                          ),
                          fit: BoxFit.cover,
                        ),
                        ..._institution.sliderImages
                            .map(
                              (image) => Image(
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
                    height: _height / 37.963636363636365,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          title: 'Email:',
                          info: _institution.email,
                        ),
                        SizedBox(
                          height: _height / 37.963636363636365,
                        ),
                        _buildInfoRow(
                          title: 'PayPal Email:',
                          info: _institution.paypalEmail,
                        ),
                        SizedBox(
                          height: _height / 37.963636363636365,
                        ),
                        _buildInfoRow(
                          title: 'Category:',
                          info: _institution.category,
                        ),
                        SizedBox(
                          height: _height / 37.963636363636365,
                        ),
                        _buildInfoRow(
                          title: 'Sub Categories:',
                          info: _institution.subCategories
                              .toString()
                              .replaceAll(']', '')
                              .replaceAll('[', ''),
                        ),
                        SizedBox(
                          height: _height / 37.963636363636365,
                        ),
                        _buildInfoRow(
                          title: 'Opens At:',
                          info: _institution.openAt.toString(),
                        ),
                        SizedBox(
                          height: _height / 37.963636363636365,
                        ),
                        _buildInfoRow(
                          title: 'Closes At:',
                          info: _institution.closeAt.toString(),
                        ),
                        SizedBox(
                          height: _height / 37.963636363636365,
                        ),
                        _buildInfoRow(
                          title: 'Opening Days:',
                          info: _institution.openingDays
                              .toString()
                              .replaceAll(']', '')
                              .replaceAll('[', ''),
                        ),
                        SizedBox(
                          height: _height / 25.30909090909091,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Services:',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: _height / 37.963636363636365,
                                // fontWeight: FontWeight.bold,
                                fontWeight: FontWeight.w600,
                              ),

                              // style: TextStyle(
                              //   fontSize:
                              //       _height / 34.512396694214877272727272727273,
                              //   fontWeight: FontWeight.w700,
                              //   color: Colors.black,
                              // ),
                            ),
                            _services.isEmpty
                                ? TextButton(
                                    onPressed: _addService,
                                    child: Text(
                                      '+ Add',
                                      style: TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontSize: _height / 37.963636363636365,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _expanded = !_expanded;
                                      });
                                    },
                                    icon: Icon(
                                      _expanded
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                    ),
                                  ),
                          ],
                        ),
                        _expanded
                            ? Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    constraints: BoxConstraints(
                                      maxHeight: _height / 1.89818181818181825,
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(),
                                    child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: _services
                                            .map(
                                              (service) => CustomListTile(
                                                edit: () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                    AddServices.route,
                                                    arguments: {
                                                      'edit': true,
                                                      'service': service,
                                                      'institutionSubCategories':
                                                          _institution
                                                              .subCategories,
                                                      'institutionId':
                                                          _institution.id,
                                                    },
                                                  );
                                                },
                                                delete: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: Text(
                                                        'Are you sure you want to '
                                                        'delete this service?',
                                                        style: TextStyle(
                                                          fontSize: _height /
                                                              37.963636363636365,
                                                          fontFamily:
                                                              'OPenSans',
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          child: Text(
                                                            'Yes',
                                                            style: TextStyle(
                                                              fontSize: _height /
                                                                  37.963636363636365,
                                                              color: kBlue,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            _deleteService(
                                                              service: service,
                                                            );
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text(
                                                            'No',
                                                            style: TextStyle(
                                                              fontSize: _height /
                                                                  37.963636363636365,
                                                              color: kBlue,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                subtitle:
                                                    service.price.toString(),
                                                title: service.name,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 2),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: TextButton(
                                        onPressed: _addService,
                                        child: Text(
                                          '+ Add',
                                          style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize:
                                                _height / 37.963636363636365,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                width: double.infinity,
                                child: Divider(
                                  color: Colors.grey[250],
                                  thickness: 2,
                                ),
                              ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Employees:',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: _height / 37.963636363636365,
                                // fontWeight: FontWeight.bold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            _employees.isEmpty
                                ? TextButton(
                                    onPressed: _addEmployee,
                                    child: Text(
                                      '+ Add',
                                      style: TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontSize: _height / 37.963636363636365,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _expandedEmp = !_expandedEmp;
                                      });
                                    },
                                    icon: Icon(
                                      _expandedEmp
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                    ),
                                  ),
                          ],
                        ),
                        _expandedEmp
                            ? Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    constraints: BoxConstraints(
                                      maxHeight: _height / 1.89818181818181825,
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(),
                                    child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: _employees
                                            .map(
                                              (employee) => CustomListTile2(
                                                edit: () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                    AddEmployees.route,
                                                    arguments: {
                                                      'edit': true,
                                                      'employee': employee,
                                                      'institutionId':
                                                          _institution.id,
                                                    },
                                                  );
                                                },
                                                delete: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: Text(
                                                        'Are you sure you want to '
                                                        'delete this employee?',
                                                        style: TextStyle(
                                                          fontSize: _height /
                                                              37.963636363636365,
                                                          fontFamily:
                                                              'OPenSans',
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          child: Text(
                                                            'Yes',
                                                            style: TextStyle(
                                                              fontSize: _height /
                                                                  37.963636363636365,
                                                              color: kBlue,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            _deleteEmployee(
                                                                employee:
                                                                    employee);
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text(
                                                            'No',
                                                            style: TextStyle(
                                                              fontSize: _height /
                                                                  37.963636363636365,
                                                              color: kBlue,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                subtitle: employee.firstName +
                                                    ' ' +
                                                    employee.lastName,
                                                title: employee.email,
                                                photo: employee.photo,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: TextButton(
                                      onPressed: _addEmployee,
                                      child: Text(
                                        '+ Add',
                                        style: TextStyle(
                                          fontFamily: 'Quicksand',
                                          fontSize:
                                              _height / 37.963636363636365,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                width: double.infinity,
                                child: Divider(
                                  color: Colors.grey[250],
                                  thickness: 2,
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Row _buildInfoRow({
    required String title,
    required String info,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              fontSize: _height / 37.963636363636365,
              // fontWeight: FontWeight.bold,
              // fontFamily: 'َQuicksand',
              fontFamily: 'OPenSans',
            ),
          ),
        ),
        Flexible(
          child: Text(
            info,
            style: TextStyle(
              fontSize: _height / 37.963636363636365,
              fontFamily: 'OPenSans',
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _deleteService({
    required Service service,
  }) async {
    Navigator.of(context).pop();

    setState(() {
      _isLoading = true;
    });

    Auth _auth = Provider.of<Auth>(
      context,
      listen: false,
    );

    String? _token = _auth.token;

    List<dynamic> _deletedList = await Provider.of<ServicesProvider>(
      context,
      listen: false,
    ).deleteService(
      serviceId: service.id,
      token: _token!,
    );

    setState(() {
      _isLoading = false;
    });

    if (_deletedList[0]) {
      showMessage(
        color: Colors.green,
        message: 'Service Deleted Successfully.',
        context: context,
      );

      await _getServices();

      setState(() {
        if (_services.isEmpty) _expanded = false;
        _isLoading = false;
      });
    } else {
      showMessage(
        color: Colors.red,
        message: _deletedList[1],
        context: context,
      );
    }
  }

  Future<void> _deleteEmployee({
    required Employee employee,
  }) async {
    Navigator.of(context).pop();

    setState(() {
      _isLoading = true;
    });

    Auth _auth = Provider.of<Auth>(
      context,
      listen: false,
    );

    String? _token = _auth.token;

    List<dynamic> _deletedList = await Provider.of<EmployeesProvider>(
      context,
      listen: false,
    ).deleteEmployee(
      employeeId: employee.id,
      token: _token!,
    );

    if (_deletedList[0]) {
      showMessage(
        color: Colors.green,
        message: 'Employee Deleted Successfully.',
        context: context,
      );

      await _getEmployees();

      setState(() {
        if (_employees.isEmpty) _expandedEmp = false;
        _isLoading = false;
      });
    } else {
      showMessage(
        color: Colors.red,
        message: _deletedList[1],
        context: context,
      );
    }
  }

  Future<void> _addService() async {
    var _refresh = await Navigator.of(context).pushNamed(
      AddServices.route,
      arguments: {
        'institutionId': _institution.id,
        'institutionSubCategories': _institution.subCategories,
      },
    );

    if (_refresh == 'true') {
      setState(() {
        _isLoading = true;
      });

      await _getServices();

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addEmployee() async {
    var _refresh = await Navigator.of(context).pushNamed(
      AddEmployees.route,
      arguments: {
        'institutionId': _institution.id,
      },
    );

    if (_refresh == 'true') {
      setState(() {
        _isLoading = true;
      });

      await _getEmployees();

      setState(() {
        _isLoading = false;
      });
    }
  }
}
