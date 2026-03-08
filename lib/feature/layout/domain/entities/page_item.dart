import 'package:flutter/material.dart';

/// Entidad de dominio para representar una opcion de navegacion.
class PageItem {
  final int index;
  final String name;
  final String path;
  final IconData icon;

  PageItem({
    required this.index,
    required this.name,
    required this.path,
    required this.icon,
  });
}