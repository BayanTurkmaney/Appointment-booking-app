import 'package:booking_app/providers/appointmentProvider.dart';
import 'package:booking_app/providers/auth.dart';
import 'package:booking_app/providers/employeeProvider.dart';
import 'package:booking_app/providers/institutionProvider.dart';
import 'package:booking_app/providers/serviceProvider.dart';
import 'package:booking_app/screens/bottom_bar/appointments_screen.dart';
import 'package:booking_app/screens/bottom_bar/edit_profile_screen.dart';
import 'package:booking_app/screens/bottom_bar/home_owner_addServiceScreen.dart';
import 'package:booking_app/screens/bottom_bar/institution_details_screen.dart';
import 'package:booking_app/screens/bottom_bar/profile.dart';
import 'package:booking_app/screens/bottom_bar/user_appointments.dart';
import 'package:booking_app/screens/bottom_bar/user_settings.dart';
import 'package:booking_app/screens/employee_app/AppointmentsScreen.dart';
import 'package:booking_app/screens/employee_app/log_in_employee.dart';
import 'package:booking_app/screens/login_signup/forget_password_screen.dart';
import 'package:booking_app/screens/login_signup/logInAsEmployeeOrOwner.dart';
import 'package:booking_app/screens/login_signup/logInScreen.dart';
import 'package:booking_app/screens/login_signup/splash_screen.dart';
import 'package:booking_app/screens/login_signup/verify_code.dart';
import 'package:booking_app/screens/payment/review_and_confirm.dart';
import 'package:booking_app/screens/payment/select_employee.dart';
import 'package:booking_app/screens/payment/select_services.dart';
import 'package:booking_app/screens/payment/select_time.dart';
import 'package:booking_app/screens/payment/success_payment.dart';
import 'package:booking_app/screens/service_form/addEmplyees.dart';
import 'package:booking_app/screens/service_form/addInstitution.dart';
import 'package:booking_app/screens/service_form/addServices.dart';
import 'package:booking_app/screens/users_screens/details.dart';
import 'package:booking_app/screens/users_screens/home.dart';
import 'package:booking_app/screens/users_screens/institutions_screen.dart';
import 'package:booking_app/screens/users_screens/main_user.dart';
import 'package:booking_app/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './screens/login_signup/signUpScreen.dart';
import 'screens/login_signup/typeUser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (value) => runApp(
      MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => InstitutionProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => EmployeesProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ServicesProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Appointments(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        title: 'Booking App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                headline1: TextStyle(
                  fontFamily: 'OpenSans',
                  // fontWeight: FontWeight.bold,
                  fontSize: 2,
                  color: Colors.black,
                ),
                // title: TextStyle(
                //   fontFamily: 'OpenSans',
                //   fontWeight: FontWeight.bold,
                //   color: black,b
                // ),
              ),
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              color: kWhite,
              fontSize: 25,
            ),
          ),
        ),
        routes: {
          Profile.route: (ctx) => Profile(),
          SignUPScreen.route: (ctx) => SignUPScreen(),
          LogInScreen.route: (ctx) => LogInScreen(),
          TypeUser.route: (ctx) => TypeUser(),
          AddServiceScreen.route: (ctx) => AddServiceScreen(),
          AddInstitution.route: (ctx) => AddInstitution(),
          AddEmployees.route: (ctx) => AddEmployees(),
          AddServices.route: (ctx) => AddServices(),
          Home.route: (ctx) => Home(),
          AppointmentsScreen.route: (ctx) => AppointmentsScreen(),
          InstitutionDetailsScreen.route: (ctx) => InstitutionDetailsScreen(),
          EditProfileScreen.route: (ctx) => EditProfileScreen(),
          ForgetPasswordScreen.route: (ctx) => ForgetPasswordScreen(),
          InstitutionsScreen.route: (ctx) => InstitutionsScreen(),
          Details.route: (ctx) => Details(),
          SelectService.route: (ctx) => SelectService(),
          SelectEmployee.route: (ctx) => SelectEmployee(),
          SuccessPayment.route: (ctx) => SuccessPayment(),
          SelectTime.route: (ctx) => SelectTime(),
          LogInAs.route: (ctx) => LogInAs(),
          LogInEmployee.route: (ctx) => LogInEmployee(),
          EmployeeAppointmentsScreen.route: (ctx) =>
              EmployeeAppointmentsScreen(),
          Confirm.route: (ctx) => Confirm(),
          UserSettings.route: (ctx) => UserSettings(),
          UserAppointments.route: (ctx) => UserAppointments(),
          MainUser.route: (ctx) => MainUser(),
          VerifyCodeScreen.route: (ctx) => VerifyCodeScreen(),
        },
      ),
    );
  }
}
