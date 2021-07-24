import 'package:crimeapp/Views/Home.dart';
import 'package:crimeapp/Views/SignIn.dart';
import 'package:crimeapp/Views/Splash.dart';
import 'package:flutter/material.dart';

class Navigate {
  static Map<String, Widget Function(BuildContext)> routes = {
    //'/': (context) => SplashScreen(),
    '/signin': (context) => SignIn(),
    '/home': (context) => Home()
  };
}
