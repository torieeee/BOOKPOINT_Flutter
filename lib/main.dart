import 'package:book_point/screens/Authentication.dart';
import 'package:book_point/models/auth_model.dart';
import 'package:book_point/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_layout.dart';
import 'screens/booking_page.dart';
import 'screens/doctor_details.dart';
import 'screens/success_booked.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  //this is for push navigator
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    //define ThemeData here
    
      return ChangeNotifierProvider<AuthModel>(
        create: (context)=>AuthModel(),
        child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Bookpoint',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          //pre-define input decoration
          inputDecorationTheme: const InputDecorationTheme(
            focusColor: Config.primaryColor,
            border: Config.outlinedBorder,
            focusedBorder: Config.focusBorder,
            errorBorder: Config.errorBorder,
            enabledBorder: Config.outlinedBorder,
            floatingLabelStyle: TextStyle(color: Config.primaryColor),
            prefixIconColor: Colors.black38,
          ),
          scaffoldBackgroundColor: Colors.white,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Config.primaryColor,
            selectedItemColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            unselectedItemColor: Colors.grey.shade700,
            elevation: 10,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        initialRoute: '/',
        routes: {
          //routes that will be used by the app
          //authentication is the sign_up and sign_in
          '/': (context) => const Authentication(),
         'main': (context) => const MainLayout(),
         //'doc_details': (context) => const DoctorDetails(),
         'booking_page': (context) => BookingPage(),
         'success_booking': (context) => const AppointmentBooked(),
        },
        ),
      );
    
  }
}