library parameters;

import 'package:flutter/material.dart';

String url = "https://d5dsstfjsletfcftjn3b.apigw.yandexcloud.net/";

class AppColors {
  static MaterialColor accent = makeColor(const Color(0xFFF2796B));
  static MaterialColor bg = makeColor(const Color(0xFFf6f6f6));
}

MaterialColor makeColor(Color c) {
  int r = c.red, g = c.green, b = c.blue;

  return MaterialColor(
    c.value,
    <int, Color>{
      50: Color.fromRGBO(r, g, b, .1),
      100: Color.fromRGBO(r, g, b, .2),
      200: Color.fromRGBO(r, g, b, .3),
      300: Color.fromRGBO(r, g, b, .4),
      400: Color.fromRGBO(r, g, b, .5),
      500: Color.fromRGBO(r, g, b, .6),
      600: Color.fromRGBO(r, g, b, .7),
      700: Color.fromRGBO(r, g, b, .8),
      800: Color.fromRGBO(r, g, b, .9),
      900: Color.fromRGBO(r, g, b, 1),
    },
  );
}
