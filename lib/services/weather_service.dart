import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';
import '../models/weather_model.dart';

/// Talks to Open-Meteo — a free weather API that needs NO API key.
/// Docs: https://open-meteo.com/
class WeatherService {
  static const String _forecastBase =
      'https://api.open-meteo.com/v1/forecast';

  static const String _geocodeBase =
      'https://geocoding-api.open-meteo.com/v1/search';

  /// Gets a 7-day weather forecast using coordinates.
  ///
  /// Returns a [WeatherBundle] containing:
  /// - Location name
  /// - Current weather
  /// - 7-day forecast
  Future<WeatherBundle> getWeather({
    required double latitude,
    required double longitude,
    required String locationName,
  }) async {
    final uri = Uri.parse(_forecastBase).replace(
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current':
            'temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m,is_day',
        'daily':
            'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max',
        'timezone': 'auto',
        'forecast_days': '7',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load weather (${response.statusCode})',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    return WeatherBundle(
      locationName: locationName,
      current: CurrentWeather.fromJson(json),
      daily: DailyForecast.listFromJson(json),
    );
  }

  /// Searches for a city by name.
  ///
  /// Returns up to 8 matching cities with their coordinates.
  Future<List<CityResult>> searchCity(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final uri = Uri.parse(_geocodeBase).replace(
      queryParameters: {
        'name': query.trim(),
        'count': '8',
        'language': 'en',
        'format': 'json',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'City search failed (${response.statusCode})',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    final results = json['results'] as List<dynamic>?;

    if (results == null) {
      return [];
    }

    return results
        .map(
          (e) => CityResult.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  /// Looks up a city by name and returns its current weather.
  ///
  /// This method is intentionally named [getWeatherByCity] because
  /// Dart does not support method overloading.
  Future<WeatherModel> getWeatherByCity(String cityName) async {
    final matches = await searchCity(cityName);

    if (matches.isEmpty) {
      throw Exception(
        'City "$cityName" not found. Check the spelling and try again.',
      );
    }

    final city = matches.first;

    final uri = Uri.parse(_forecastBase).replace(
      queryParameters: {
        'latitude': city.latitude.toString(),
        'longitude': city.longitude.toString(),
        'current':
            'temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m,is_day',
        'daily':
            'temperature_2m_max,temperature_2m_min',
        'timezone': 'auto',
        'forecast_days': '1',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Could not load weather for ${city.displayName}.',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    final current = json['current'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;

    return WeatherModel(
      cityName: city.name,
      country: city.country,
      temperature:
          (current['temperature_2m'] as num).toDouble(),
      feelsLike:
          (current['apparent_temperature'] as num).toDouble(),
      humidity:
          (current['relative_humidity_2m'] as num).toInt(),
      windSpeed:
          (current['wind_speed_10m'] as num).toDouble(),
      weatherCode:
          (current['weather_code'] as num).toInt(),
      isDay:
          current['is_day'] == 1,
      tempMax:
          (daily['temperature_2m_max'][0] as num).toDouble(),
      tempMin:
          (daily['temperature_2m_min'][0] as num).toDouble(),
    );
  }
}
