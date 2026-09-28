import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_data.dart';
import '../utils/weather_utils.dart';

class ForecastCard extends StatelessWidget {
  final DailyForecast forecast;
  final bool isToday;

  const ForecastCard({
    super.key,
    required this.forecast,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final dayLabel = isToday ? 'Today' : DateFormat('EEE').format(forecast.date);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Text(
              dayLabel,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          Icon(WeatherUtils.iconFor(forecast.weatherCode), color: Colors.white, size: 22),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(Icons.water_drop, size: 14, color: Colors.white.withValues(alpha: 0.7)),
                  const SizedBox(width: 4),
                  Text(
                    '${forecast.precipitationProbability.toInt()}%',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          Text(
            '${forecast.minTemp.round()}°',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 15),
          ),
          const SizedBox(width: 8),
          Text(
            '${forecast.maxTemp.round()}°',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
