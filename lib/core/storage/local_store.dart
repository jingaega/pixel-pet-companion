import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  static const _kHunger = 'hunger';
  static const _kHappiness = 'happiness';
  static const _kEnergy = 'energy';
  static const _kCoins = 'coins';
  static const _kSleeping = 'sleeping';
  static const _kLastUpdated = 'last_updated';

  Future<Map<String, dynamic>> read() async {
    final sp = await SharedPreferences.getInstance();
    return {
      'hunger': sp.getInt(_kHunger),
      'happiness': sp.getInt(_kHappiness),
      'energy': sp.getInt(_kEnergy),
      'coins': sp.getInt(_kCoins),
      'sleeping': sp.getBool(_kSleeping),
      'last_updated': sp.getString(_kLastUpdated),
    };
  }

  Future<void> write({
    required int hunger,
    required int happiness,
    required int energy,
    required int coins,
    required bool sleeping,
    required String lastUpdatedIso,
  }) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kHunger, hunger);
    await sp.setInt(_kHappiness, happiness);
    await sp.setInt(_kEnergy, energy);
    await sp.setInt(_kCoins, coins);
    await sp.setBool(_kSleeping, sleeping);
    await sp.setString(_kLastUpdated, lastUpdatedIso);
  }
}
