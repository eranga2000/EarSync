import 'package:flutter/material.dart';

class ScreenSize {
 static  double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

static double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}
}