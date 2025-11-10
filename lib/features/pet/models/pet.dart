class Pet {
  int hunger;     // 0 (starving) .. 100 (full) but we invert for UI
  int happiness;  // 0 .. 100
  int energy;     // 0 .. 100
  int coins;
  bool sleeping;

  Pet({
    required this.hunger,
    required this.happiness,
    required this.energy,
    required this.coins,
    required this.sleeping,
  });

  String get moodLabel {
    if (happiness > 80) return "Ecstatic";
    if (happiness > 60) return "Happy";
    if (happiness > 40) return "Okay";
    if (happiness > 20) return "Gloomy";
    return "Sad";
  }
}
