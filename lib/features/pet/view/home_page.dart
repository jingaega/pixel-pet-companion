// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pixel_pet_companion/features/pet/state/pet_controller.dart';
import 'package:pixel_pet_companion/features/pet/widgets/gauge.dart';
import 'package:pixel_pet_companion/features/pet/widgets/pixel_pet_sprite.dart';
import 'package:pixel_pet_companion/features/pet/widgets/action_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _bob;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _bob = Tween<double>(begin: -4, end: 4).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pet = context.watch<PetController>();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pixel Pet Companion'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(children: [Icon(Icons.monetization_on), SizedBox(width: 4), Text('${pet.pet.coins}')]),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [cs.surface.withOpacity(0.98), cs.surfaceVariant.withOpacity(0.9)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Gauge(label: "Hunger", value: 100 - pet.pet.hunger, icon: Icons.restaurant),
                    SizedBox(width: 8),
                    Gauge(label: "Happy", value: pet.pet.happiness, icon: Icons.favorite),
                    SizedBox(width: 8),
                    Gauge(label: "Energy", value: pet.pet.energy, icon: Icons.bolt),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _bob,
                    builder: (context, _) {
                      return Transform.translate(
                        offset: Offset(0, _bob.value),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PixelPetSprite(sleeping: pet.pet.sleeping, mood: pet.pet.moodLabel),
                            SizedBox(height: 12),
                            Text(pet.pet.sleeping ? "Sleeping..." : "Mood: ${pet.pet.moodLabel}", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    ActionButton(label: "Feed", icon: Icons.restaurant, onTap: pet.feed, tooltip: "Costs 1 coin, lowers hunger"),
                    ActionButton(label: "Pet", icon: Icons.front_hand, onTap: pet.petting, tooltip: "Increases happiness"),
                    ActionButton(label: "Play", icon: Icons.sports_esports, onTap: pet.play, tooltip: "Boosts happiness, uses energy"),
                    ActionButton(label: pet.pet.sleeping ? "Wake" : "Sleep", icon: pet.pet.sleeping ? Icons.sunny : Icons.bedtime, onTap: pet.toggleSleep, tooltip: "Sleep regens energy, slows hunger"),
                  ],
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
