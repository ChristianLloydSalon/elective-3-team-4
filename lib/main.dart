import 'package:flutter/material.dart';
import 'screens/login_signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  Map<int, Color> primaryColor = const {
    50: Color.fromRGBO(78, 92, 114, .1),
    100: Color.fromRGBO(78, 92, 114, .2),
    200: Color.fromRGBO(78, 92, 114, .3),
    300: Color.fromRGBO(78, 92, 114, .4),
    400: Color.fromRGBO(78, 92, 114, .5),
    500: Color.fromRGBO(78, 92, 114, .6),
    600: Color.fromRGBO(78, 92, 114, .7),
    700: Color.fromRGBO(78, 92, 114, .8),
    800: Color.fromRGBO(78, 92, 114, .9),
    900: Color.fromRGBO(78, 92, 114, 1),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Classenger',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xff4e5c72, primaryColor),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xff4e5c72),
        ),
        indicatorColor: const Color(0xff4e5c72),
        dividerColor: Colors.white,
        textTheme: TextTheme(
          headlineMedium: const TextStyle(color: Colors.black),
          headlineSmall: const TextStyle(color: Colors.black),
          labelSmall: TextStyle(color: Colors.grey[900]),
        ),
        // bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        //   backgroundColor: Color(0xff4e5c72),
        // ),
      ),
      home: LoginSignupScreen(title: 'Classenger'),
    );
  }
}
