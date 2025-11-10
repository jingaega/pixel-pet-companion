import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:pixel_pet_companion/core/storage/local_store.dart';
import 'package:pixel_pet_companion/core/utils/ticker_service.dart';
import 'package:pixel_pet_companion/features/pet/models/pet.dart';

class PetController extends ChangeNotifier {
  final LocalStore _store = LocalStore();
  final TickerService _ticker = TickerService(period: const Duration(seconds: 1));

  Pet pet = Pet(hunger: 20, happiness: 60, energy: 60, coins: 0, sleeping: false);
  DateTime lastUpdated = DateTime.now();

  PetController() {
    _ticker.onTick = _tick;
  }

  Future<void> load() async {
    final data = await _store.read();
    pet.hunger = data['hunger'] ?? pet.hunger;
    pet.happiness = data['happiness'] ?? pet.happiness;
    pet.energy = data['energy'] ?? pet.energy;
    pet.coins = data['coins'] ?? pet.coins;
    pet.sleeping = data['sleeping'] ?? pet.sleeping;
    final last = data['last_updated'] as String?;
    if (last != null) {
      lastUpdated = DateTime.tryParse(last) ?? lastUpdated;
      _applyDecaySince(lastUpdated);
    }
    _ticker.start();
    notifyListeners();
  }

  Future<void> _save() async {
    await _store.write(
      hunger: pet.hunger,
      happiness: pet.happiness,
      energy: pet.energy,
      coins: pet.coins,
      sleeping: pet.sleeping,
      lastUpdatedIso: DateTime.now().toIso8601String(),
    );
  }

  void _applyDecaySince(DateTime last) {
    final now = DateTime.now();
    final elapsed = now.difference(last);
    final minutes = elapsed.inMinutes.clamp(0, 1000000);
    // Per-minute changes
    final hungerIncrease = minutes;      // +1
    final energyDecrease = minutes;      // -1
    final happinessDecrease = minutes ~/ 5; // -1 each 5 min

    pet.hunger = (pet.hunger + hungerIncrease).clamp(0, 100);
    pet.energy = (pet.energy - energyDecrease).clamp(0, 100);
    pet.happiness = (pet.happiness - happinessDecrease).clamp(0, 100);

    if (pet.sleeping) {
      final regen = (minutes * 1.5).floor();
      pet.energy = (pet.energy + regen).clamp(0, 100);
      pet.hunger = (pet.hunger - (minutes ~/ 3)).clamp(0, 100);
    }
  }

  void _tick() {
    if (DateTime.now().difference(lastUpdated) >= const Duration(seconds: 30)) {
      lastUpdated = DateTime.now();
      pet.hunger = (pet.hunger + 1).clamp(0, 100);
      pet.energy = (pet.energy - 1).clamp(0, 100);
      if (DateTime.now().second % 60 == 0) {
        pet.happiness = (pet.happiness - 1).clamp(0, 100);
      }
      if (pet.sleeping) {
        pet.energy = (pet.energy + 2).clamp(0, 100);
        pet.hunger = (pet.hunger - 1).clamp(0, 100);
      }
      _save();
      notifyListeners();
    }
  }

  // Actions
  void feed() {
    if (pet.hunger <= 10) {
      pet.happiness = (pet.happiness - 2).clamp(0, 100);
    }
    pet.hunger = (pet.hunger - 20).clamp(0, 100);
    pet.happiness = (pet.happiness + 4).clamp(0, 100);
    pet.coins = max(0, pet.coins - 1);
    _save();
    notifyListeners();
  }

  void petting() {
    pet.happiness = (pet.happiness + 8).clamp(0, 100);
    pet.coins += 1;
    _save();
    notifyListeners();
  }

  void play() {
    if (pet.energy < 10 || pet.hunger > 90) return;
    pet.happiness = (pet.happiness + 10).clamp(0, 100);
    pet.energy = (pet.energy - 10).clamp(0, 100);
    pet.hunger = (pet.hunger + 5).clamp(0, 100);
    pet.coins += 2;
    _save();
    notifyListeners();
  }

  void toggleSleep() {
    pet.sleeping = !pet.sleeping;
    if (pet.sleeping) {
      pet.energy = (pet.energy + 5).clamp(0, 100);
    } else {
      pet.happiness = (pet.happiness + 3).clamp(0, 100);
    }
    _save();
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker.stop();
    super.dispose();
  }
}
