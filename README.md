# Pixel Pet Companion (Flutter, modular, offline-only)

A tiny pixel pet you can feed, pet, play with, and put to sleep. **No backend**, state is stored locally with `shared_preferences`.

## Highlights
- Modular **feature-first** foldering: `core/`, `features/pet/`, `theme/`
- `PetController` with Provider (`ChangeNotifier`) for state
- `LocalStore` for persistence, `TickerService` for time-based updates
- Pixel sprite built with `CustomPaint` — **no image assets**
- Clear separation of **model / state / view / widgets**

## Run
```bash
flutter pub get
flutter run
```

## Suggested Extensions
- Shop & inventory (cosmetics, food types)
- Multiple pet skins (swap sprite palettes)
- Daily streak quests
- Settings (tick rate, difficulty)
