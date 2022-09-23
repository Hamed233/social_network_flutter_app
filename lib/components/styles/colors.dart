import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppColors {
  static Color? appMainColors = Colors.yellow[700];
}

class LightColors  {
  static const Color kLightYellow = Color(0xFFFFF9EC);
  static const Color kLightYellow2 = Color(0xFFFFE4C7);
  static const Color kDarkYellow = Color(0xFFF9BE7C);
  static const Color kPalePink = Color(0xFFFED4D6);

  static const Color kRed = Color(0xFFE46472);
  static const Color kLavender = Color(0xFFD5E4FE);
  static const Color kBlue = Color(0xFF6488E4);
  static const Color kLightGreen = Color(0xFFD9E6DC);
  static const Color kGreen = Color(0xFF309397);

  static const Color kDarkBlue = Color(0xFF0D253F);
}

class RandomColors {
  // Tasks Colors
  static Color allTasksColor = HexColor("#474956"); 
  static Color inprogressTasksColor = HexColor("#61cfed"); 
  static Color priorityTasksColor = HexColor("#09759f"); 
  static Color mightTasksColor = HexColor("#7d83c5"); 
  static Color doneTasksColor = HexColor("#5cce99"); 
  static Color archivedTasksColor = HexColor("#ffcf97"); 
  static Color staticTasksColor = HexColor("#051367"); 

  static const Color pinkSalmon = Color(0xFFFE95B4);
  static const Color frenchRose = Color(0xFFF15082);
  static const LinearGradient pinkGradient = LinearGradient(
    colors: [pinkSalmon, frenchRose],
  );

  static const Color lightBrown = Color(0xFFFEB395);
  static const Color brown = Color(0xFFF17E50);
  static const LinearGradient brownGradient = LinearGradient(
    colors: [lightBrown, brown],
  );

  static const Color lightLemon = Color(0xFFFEED95);
  static const Color lemon = Color(0xFFF1D650);
  static const LinearGradient lemonGradient = LinearGradient(
    colors: [lightLemon, lemon],
  );

  static const Color lightTosca = Color(0xFF95D1FE);
  static const Color tosca = Color(0xFF509EF1);
  static const LinearGradient toscaGradient = LinearGradient(
    colors: [lightTosca, tosca],
  );

  static const Color lightDonker = Color(0xFF9C95FE);
  static const Color donker = Color(0xFF6850F1);
  static const LinearGradient donkerGradient = LinearGradient(
    colors: [lightDonker, donker],
  );

  static const Color perano = Color(0xFFB09DF2);
  static const Color cornflowerBlue = Color(0xFF8C77FB);
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [perano, cornflowerBlue],
  );

  static const Color flesh = Color(0xFFFED3A0);
  static const Color yellowOrange = Color(0xFFFFA63F);
  static const LinearGradient orangeGradient = LinearGradient(
    colors: [flesh, yellowOrange],
  );

  static const Color anakiwa = Color(0xFF9FE7FB);
  static const Color pictonBlue = Color(0xFF46C6E9);
  static const LinearGradient blueGradient = LinearGradient(
    colors: [anakiwa, pictonBlue],
  );

  static const Color lightOrange = Color(0xFFFFCB52);
  static const Color orange = Color(0xFFFF7B02);
  static const LinearGradient darkOrangeGradient = LinearGradient(
    colors: [pinkSalmon, frenchRose],
  );

  static const Color lightGreen = Color(0xFF2AFEB7);
  static const Color green = Color(0xFF08C792);
  static const LinearGradient greenGradient = LinearGradient(
    colors: [lightGreen, green],
  );

  static const Color yellow = Color(0xFFFFE324);
  static const Color darkYellow = Color(0xFFFFB533);
  static const LinearGradient yellowGradient = LinearGradient(
    colors: [yellow, darkYellow],
  );

  static const Color greyBlue = Color(0xFF5581F1);
  static const Color darkBlue = Color(0xFF1153FC);
  static const LinearGradient darkBlueGradient = LinearGradient(
    colors: [greyBlue, darkBlue],
  );

  static const Color lightPurple = Color(0xFFE594FF);

  static const Color boldColorFont = Color(0xFF2A2E49);
  static const Color normalColorFont = Color(0xFFa2a1ae);

  static const Color darkGrey = Color(0xFF6C6C6C);
  static const Color grey = Color(0xFFB7B7B7);

  static const Color scaffoldColor = Color(0xFFFBFAFF);

  static const Color greenPastel = Color(0xFF90F0B3);
  static const Color redPastel = Color(0xFFF97C7C);
  static const Color redDarkPastel = Color(0xFFC23A22);
}

const Color kOutGoingMessage = Color(0xFF5B40D1);
const Color kInComingMessage = Color.fromARGB(255, 140, 118, 234);

//gradients
const Gradient kGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: <double>[
      0.3,
      0.4,
      0.5,
      0.6
    ],
    colors: <Color>[
      Color.fromARGB(255, 101, 93, 251),
      Color.fromARGB(255, 108, 101, 251),
      Color.fromARGB(255, 118, 111, 251),
      Color.fromARGB(255, 129, 122, 249),
    ]);