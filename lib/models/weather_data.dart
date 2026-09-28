// Data models for current weather + daily forecast.
// Parses the JSON returned by the free Open-Meteo API (no API key needed).

class CurrentWeather {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int weatherCode;
  final bool isDay;

  CurrentWeather({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    required this.isDay,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    final current = json['current'];
    return CurrentWeather(
      temperature: (current['temperature_2m'] as num).toDouble(),
      feelsLike: (current['apparent_temperature'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      isDay: current['is_day'] == 1,
    );
  }
}

class DailyForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final int weatherCode;
  final double precipitationProbability;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCode,
    required this.precipitationProbability,
  });

  static List<DailyForecast> listFromJson(Map<String, dynamic> json) {
    final daily = json['daily'];
    final List<String> dates = List<String>.from(daily['time']);
    final List<num> maxTemps = List<num>.from(daily['temperature_2m_max']);
    final List<num> minTemps = List<num>.from(daily['temperature_2m_min']);
    final List<num> codes = List<num>.from(daily['weather_code']);
    final List<num> precip =
        List<num>.from(daily['precipitation_probability_max']);

    return List.generate(dates.length, (i) {
      return DailyForecast(
        date: DateTime.parse(dates[i]),
        maxTemp: maxTemps[i].toDouble(),
        minTemp: minTemps[i].toDouble(),
        weatherCode: codes[i].toInt(),
        precipitationProbability: precip[i].toDouble(),
      );
    });
  }
}

class WeatherBundle {
  final String locationName;
  final CurrentWeather current;
  final List<DailyForecast> daily;

  WeatherBundle({
    required this.locationName,
    required this.current,
    required this.daily,
  });
}

class CityResult {
  final String name;
  final String country;
  final double latitude;
  final double longitude;

  CityResult({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory CityResult.fromJson(Map<String, dynamic> json) {
    return CityResult(
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  String get displayName => country.isNotEmpty ? '$name, $country' : name;
}
