import 'package:flutter/material.dart';

/// Open-Meteo uses WMO weather codes. This maps them to
/// an icon, a human label, and a gradient to theme the screen.
class WeatherUtils {
  static IconData iconFor(int code, {bool isDay = true}) {
    if (code == 0) return isDay ? Icons.wb_sunny_rounded : Icons.nightlight_round;
    if (code <= 2) return isDay ? Icons.wb_cloudy_rounded : Icons.nights_stay_rounded;
    if (code == 3) return Icons.cloud_rounded;
    if (code == 45 || code == 48) return Icons.foggy;
    if (code >= 51 && code <= 57) return Icons.grain_rounded;
    if (code >= 61 && code <= 67) return Icons.water_drop_rounded;
    if (code >= 71 && code <= 77) return Icons.ac_unit_rounded;
    if (code >= 80 && code <= 82) return Icons.beach_access_rounded;
    if (code >= 85 && code <= 86) return Icons.snowing;
    if (code >= 95) return Icons.thunderstorm_rounded;
    return Icons.help_outline_rounded;
  }

  static String labelFor(int code) {
    const map = {
      0: 'Clear sky',
      1: 'Mainly clear',
      2: 'Partly cloudy',
      3: 'Overcast',
      45: 'Fog',
      48: 'Depositing rime fog',
      51: 'Light drizzle',
      53: 'Moderate drizzle',
      55: 'Dense drizzle',
      56: 'Light freezing drizzle',
      57: 'Dense freezing drizzle',
      61: 'Slight rain',
      63: 'Moderate rain',
      65: 'Heavy rain',
      66: 'Light freezing rain',
      67: 'Heavy freezing rain',
      71: 'Slight snow',
      73: 'Moderate snow',
      75: 'Heavy snow',
      77: 'Snow grains',
      80: 'Slight rain showers',
      81: 'Moderate rain showers',
      82: 'Violent rain showers',
      85: 'Slight snow showers',
      86: 'Heavy snow showers',
      95: 'Thunderstorm',
      96: 'Thunderstorm w/ hail',
      99: 'Thunderstorm w/ heavy hail',
    };
    return map[code] ?? 'Unknown';
  }

  static List<Color> gradientFor(int code, {bool isDay = true}) {
    if (!isDay) {
      return [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)];
    }
    if (code == 0) {
      return [const Color(0xFF56CCF2), const Color(0xFF2F80ED)];
    }
    if (code <= 3) {
      return [const Color(0xFF757F9A), const Color(0xFFD7DDE8)];
    }
    if (code >= 51 && code <= 67 || code >= 80 && code <= 82) {
      return [const Color(0xFF373B44), const Color(0xFF4286f4)];
    }
    if (code >= 71 && code <= 86) {
      return [const Color(0xFFE6DADA), const Color(0xFF274046)];
    }
    if (code >= 95) {
      return [const Color(0xFF232526), const Color(0xFF414345)];
    }
    return [const Color(0xFF56CCF2), const Color(0xFF2F80ED)];
  }
}
