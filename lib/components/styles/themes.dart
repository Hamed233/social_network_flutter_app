import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

import 'colors.dart';

ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.yellow,
  scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
  unselectedWidgetColor: Colors.grey,
  appBarTheme: AppBarTheme(
    titleSpacing: 20.0,
    // backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: HexColor('333739'),
      statusBarIconBrightness: Brightness.dark,
    ),
    backgroundColor: HexColor('333739'),
    elevation: 0.0,
    titleTextStyle: const TextStyle(
      color: Colors.grey,
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
    ),
    iconTheme: const IconThemeData(
      color: Colors.grey,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: AppColors.appMainColors,
    unselectedItemColor: Colors.grey,
    elevation: 20.0,
    backgroundColor: HexColor('333739'),
  ),
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontSize: 25,
      color: Colors.grey,
      fontWeight: FontWeight.bold,
    ),
    headline2: TextStyle(
      fontSize: 20,
      color: Colors.grey,
      fontWeight: FontWeight.bold,
    ),
    headline3: TextStyle(
      fontSize: 17,
      color: Colors.grey,
      fontWeight: FontWeight.bold,
    ),
    headline4: TextStyle(
      fontSize: 14,
      color: Colors.grey,
      fontWeight: FontWeight.w500,
      height: 1.3,
    ),

    bodyText1: TextStyle(
      fontSize: 16,
      color: Colors.grey,
      fontWeight: FontWeight.w500,
    ),
    bodyText2: TextStyle(
      fontSize: 14,
      color: Colors.grey,
      fontWeight: FontWeight.w500,
      // fontFamily: 'Monadi',
    ),
    subtitle1: TextStyle(
        color: Colors.grey,
        fontSize: 12,
        height: 1.5),
  ),
  cardColor: HexColor('333739'),
);

ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.yellow,
  scaffoldBackgroundColor: Color.fromARGB(255, 241, 241, 241),
  unselectedWidgetColor: Colors.grey,
  appBarTheme: AppBarTheme(
    titleSpacing: 20.0,
    // backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: AppColors.appMainColors,
      statusBarIconBrightness: Brightness.light,
    ),
    backgroundColor: Colors.white,
    elevation: 0.0,
    titleTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: AppColors.appMainColors,
    unselectedItemColor: Colors.grey,
    elevation: 20.0,
    backgroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    headline1: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 25.0,
    ),
    headline2: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
    headline3: TextStyle(
      fontSize: 17,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    headline4: TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.w500,
      height: 1.3,
    ),
    bodyText2: TextStyle(
      color: Colors.black,
    ),
    subtitle1: TextStyle(
        color: Colors.black,
        fontSize: 12,
        height: 1.5),
  ),
  cardColor: Colors.white,
);
