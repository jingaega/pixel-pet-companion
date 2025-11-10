// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pixel_pet_companion/theme/app_theme.dart';
import 'package:pixel_pet_companion/features/pet/state/pet_controller.dart';
import 'package:pixel_pet_companion/features/pet/view/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PixelPetApp());
}

class PixelPetApp extends StatelessWidget {
  const PixelPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PetController()..load(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pixel Pet Companion',
        theme: buildAppTheme(),
        home: const HomePage(),
      ),
    );
  }
}
