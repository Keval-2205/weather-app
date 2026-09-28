# Weather App (Flutter)

A clean weather app for Android & iOS. Shows current conditions + a 7-day
forecast, using your GPS location or a searched city. Uses the free
**Open-Meteo** API — no API key or signup required.

## Features
- Current temperature, "feels like", humidity, wind speed
- Weather icon + condition label (clear, rainy, snowy, etc.)
- 7-day forecast list
- Use current GPS location, or search any city worldwide
- Remembers your last location between app launches
- Pull-to-refresh

## Project structure
```
weather_app/
├── pubspec.yaml
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/weather_data.dart     # Data classes
│   ├── services/
│   │   ├── weather_service.dart     # API calls (Open-Meteo)
│   │   └── location_service.dart    # GPS + permissions
│   ├── screens/
│   │   ├── home_screen.dart         # Main weather screen
│   │   └── city_search_screen.dart  # City search screen
│   ├── widgets/forecast_card.dart   # 7-day forecast row
│   └── utils/weather_utils.dart     # Icons/labels/colors per weather code
├── android/app/src/main/AndroidManifest.xml   # Android permissions
└── ios_Info_plist_additions.xml     # Paste into ios/Runner/Info.plist
```

## Setup (do this on your own computer)

1. **Install Flutter SDK** (if you haven't): https://docs.flutter.dev/get-started/install
   Verify with:
   ```
   flutter doctor
   ```

2. **Create the Flutter project shell**, then copy these files in:
   ```
   flutter create weather_app
   cd weather_app
   ```
   Now copy/overwrite `pubspec.yaml`, the `lib/` folder, and the Android
   manifest additions from this package into the newly created project
   (keep the rest of the generated `android/`, `ios/`, etc. folders as-is —
   only merge in the permission lines shown here).

3. **iOS only**: open `ios/Runner/Info.plist` and paste in the two keys from
   `ios_Info_plist_additions.xml`. Without this, iOS will crash the app the
   moment it asks for location permission.

4. **Install dependencies**:
   ```
   flutter pub get
   ```

5. **Run it**:
   ```
   flutter run
   ```
   (with an emulator/simulator running, or a phone connected via USB with
   USB debugging / developer mode on)

6. **Build a release APK** (Android) when you're ready to install it directly:
   ```
   flutter build apk --release
   ```
   The APK will be at `build/app/outputs/flutter-apk/app-release.apk` —
   copy it to your phone and install it.

   For iOS you'll need a Mac + Xcode and an Apple Developer account to build
   and install on a physical device:
   ```
   flutter build ios --release
   ```

## Notes
- No API key needed — Open-Meteo is free and open. If you'd rather use
  OpenWeatherMap or another provider, only `lib/services/weather_service.dart`
  needs to change.
- If location permission is denied, the app still works — just tap the
  search icon and pick a city manually.
- Temperatures are shown in Celsius by default. To switch to Fahrenheit, add
  `'temperature_unit': 'fahrenheit'` to the query parameters in
  `weather_service.dart`.
