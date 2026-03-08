import 'package:ev_products_app/core/environment/environments.dart';
import 'package:flutter/material.dart';

class HeightUtil {
  HeightUtil._();

  static double getHeightDevice(BuildContext context, double dpHeight) {
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * dpHeight / Environments.dpHeightBaseline;
  }
}