import 'package:ev_products_app/core/environment/environments.dart';
import 'package:flutter/material.dart';

/// Utilidad para escalar alturas verticales desde un baseline de diseno.
class HeightUtil {
  HeightUtil._();

  /// Convierte una altura de diseno (`dpHeight`) a pixeles del dispositivo
  /// de forma proporcional usando el baseline definido por la app.
  /// usando regla de tres simple
  static double getHeightDevice(BuildContext context, double dpHeight) {
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * dpHeight / Environments.dpHeightBaseline;
  }
}