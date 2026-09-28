/// Simple weather model for a single city, used by WeatherScreen +
/// WeatherCard. Built from the free Open-Meteo API (no API key needed).
class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int weatherCode;
  final bool isDay;
  final double tempMax;
  final double tempMin;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    required this.isDay,
    required this.tempMax,
    required this.tempMin,
  });

  /// Human-readable condition text, e.g. "Clear sky", "Light rain".
  String get description => _labelFor(weatherCode);

  /// A matching emoji/icon-ish string for quick display (WeatherCard also
  /// has its own icon widget — this is a convenience fallback).
  static String _labelFor(int code) {
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
}
