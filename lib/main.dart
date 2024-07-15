/*import 'package:book_point/screens/Authentication.dart';
import 'package:book_point/models/auth_model.dart';
import 'package:book_point/utils/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_layout.dart';
import 'screens/booking_page.dart';
import 'screens/success_booked.dart';


Future main() async {
  /*final dbHelper = DatabaseHelper(
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: '',
    databaseName: 'book_point',
  );*/

  //await dbHelper.openConnection();
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb){
await Firebase.initializeApp(
  //name: 'Secondary App',
  options: const FirebaseOptions(
  apiKey: "AIzaSyCRUHBUoh_OePVCFCa4VxFG5Uu-NINM_Vg",
  appId: "1:306851339266:web:674c2288c71c3acf08db1b",
  authDomain:"bookpoint-23f70.firebaseapp.com" ,
  storageBucket: "bookpoint-23f70.appspot.com",
  messagingSenderId: "306851339266",
  projectId: "bookpoint-23f70",
  //measurementId: "G-NGZPTXZ13T"
  ));

  }else{
  await Firebase.initializeApp();
  }
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      body: Center(
        child: Text(
          details.exceptionAsString(),
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  };

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
        //home: SplashScreen(child: LoginForm(key: ,) ,),
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
/*
  final dbHelper = DatabaseHelper(
    host: '',
    port: 3306,
    user: 'your_username',
    password: 'your_password',
    databaseName: 'your_database_name',
  );

  await dbHelper.openConnection();

  // Example usage:
  //await dbHelper.authService('user@example.com', 'password123');
  //await dbHelper.registerUser('John Doe', 'john@example.com', 'securePassword');

  //await dbHelper.closeConnection();
}*/
*/


//import 'package:book_point/components/login_form.dart';
import 'package:book_point/doctor_main_layout.dart';
import 'package:book_point/doctor_section/requests.dart';
import 'package:book_point/screens/Authentication.dart';
import 'package:book_point/models/auth_model.dart';
import 'package:book_point/screens/appointment_page.dart';
//import 'package:book_point/screens/home_screen.dart';
//import 'package:book_point/shared/theme/widgets/bottom_nav_bars/main_nav_bar.dart';
//import 'package:book_point/screens/splash_screen.dart';
import 'package:book_point/utils/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'main_layout.dart';
import 'screens/booking_page.dart';
//import 'package:book_point/providers/database_connection.dart';
//import 'screens/doctor_details.dart';

import 'screens/success_booked.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Initializing Firebase...");

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCRUHBUoh_OePVCFCa4VxFG5Uu-NINM_Vg",
          authDomain: "bookpoint-23f70.firebaseapp.com",
          databaseURL: "https://bookpoint-23f70-default-rtdb.firebaseio.com",
          projectId: "bookpoint-23f70",
          storageBucket: "bookpoint-23f70.appspot.com",
          messagingSenderId: "306851339266",
          appId: "1:306851339266:web:674c2288c71c3acf08db1b",
          measurementId: "G-NGZPTXZ13T"
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    print("Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      body: Center(
        child: Text(
          details.exceptionAsString(),
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    print("Building MyApp...");
    return ChangeNotifierProvider<AuthModel>(
      create: (context) => AuthModel(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Bookpoint',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.kulimParkTextTheme(
            Theme.of(context).textTheme,
          ),
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
          '/': (context) => const Authentication(),
          'main': (context) => const MainLayout(),
          'booking_page': (context) => BookingPage(),
          'appointment_page':(context) => const AppointmentPage(),
          'success_booking': (context) => const AppointmentBooked(),
          'doctor':(context)=>const DoctorMainLayout(),
          '/doctor/requests': (context) {
            final Map<String, dynamic> doctor = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return const RequestPage();
          }
        },
      ),
    );
  }
}
