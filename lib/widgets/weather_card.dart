import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/weather_utils.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final gradient =
        WeatherUtils.gradientFor(weather.weatherCode, isDay: weather.isDay);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:  0.15),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            weather.country.isNotEmpty
                ? '${weather.cityName}, ${weather.country}'
                : weather.cityName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Icon(
            WeatherUtils.iconFor(weather.weatherCode, isDay: weather.isDay),
            color: Colors.white,
            size: 80,
          ),
          const SizedBox(height: 8),
          Text(
            '${weather.temperature.round()}°C',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.w200,
            ),
          ),
          Text(
            weather.description,
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ),
          const SizedBox(height: 4),
          Text(
            'Feels like ${weather.feelsLike.round()}°C',
            style: TextStyle(color: Colors.white.withValues(alpha:  0.85), fontSize: 14),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _InfoTile(
                icon: Icons.water_drop_outlined,
                label: 'Humidity',
                value: '${weather.humidity}%',
              ),
              _InfoTile(
                icon: Icons.air,
                label: 'Wind',
                value: '${weather.windSpeed.round()} km/h',
              ),
              _InfoTile(
                icon: Icons.thermostat,
                label: 'High / Low',
                value:
                    '${weather.tempMax.round()}° / ${weather.tempMin.round()}°',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha:  0.75), fontSize: 11),
        ),
      ],
    );
  }
}
