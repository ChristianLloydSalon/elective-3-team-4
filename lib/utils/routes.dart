import 'package:flutter/material.dart';
import '../Screens/home_screen.dart';
import 'package:classenger_frontend/screens/login_signup_screen.dart';

class Routes {
  static const loginRoute = '/login';
  static const homePageRoute = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginSignupScreen(title: 'Log in or Sign up',));
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}