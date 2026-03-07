import 'package:flutter/material.dart';

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