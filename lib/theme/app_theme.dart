import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
    useMaterial3: true,
    fontFamily: 'monospace',
    appBarTheme: const AppBarTheme(centerTitle: false),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
