import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_data.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import '../utils/weather_utils.dart';
import '../widgets/forecast_card.dart';
import 'city_search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _weatherService = WeatherService();
  final _locationService = LocationService();

  WeatherBundle? _weather;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInitialWeather();
  }

  Future<void> _loadInitialWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLat = prefs.getDouble('lat');
    final savedLon = prefs.getDouble('lon');
    final savedName = prefs.getString('name');

    if (savedLat != null && savedLon != null && savedName != null) {
      await _fetchWeather(savedLat, savedLon, savedName);
    } else {
      await _useCurrentLocation();
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final position = await _locationService.getCurrentPosition();
      await _fetchWeather(
        position.latitude,
        position.longitude,
        'My Location',
      );
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _fetchWeather(double lat, double lon, String name) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final bundle = await _weatherService.getWeather(
        latitude: lat,
        longitude: lon,
        locationName: name,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('lat', lat);
      await prefs.setDouble('lon', lon);
      await prefs.setString('name', name);

      setState(() {
        _weather = bundle;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Could not load weather. Check your internet connection.';
      });
    }
  }

  Future<void> _openCitySearch() async {
    final city = await Navigator.push<CityResult>(
      context,
      MaterialPageRoute(builder: (_) => const CitySearchScreen()),
    );
    if (city != null) {
      await _fetchWeather(city.latitude, city.longitude, city.displayName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _weather != null
        ? WeatherUtils.gradientFor(_weather!.current.weatherCode,
            isDay: _weather!.current.isDay)
        : [const Color(0xFF56CCF2), const Color(0xFF2F80ED)];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              if (_weather != null) {
                final prefs = await SharedPreferences.getInstance();
                await _fetchWeather(
                  prefs.getDouble('lat') ?? 0,
                  prefs.getDouble('lon') ?? 0,
                  _weather!.locationName,
                );
              } else {
                await _useCurrentLocation();
              }
            },
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_error != null) {
      return ListView(
        children: [
          const SizedBox(height: 120),
          const Icon(Icons.cloud_off, color: Colors.white, size: 56),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              onPressed: _useCurrentLocation,
              icon: const Icon(Icons.my_location),
              label: const Text('Try again'),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton.icon(
              onPressed: _openCitySearch,
              icon: const Icon(Icons.search, color: Colors.white),
              label: const Text('Search a city',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );
    }

    final weather = _weather!;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white, size: 20),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        weather.locationName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.my_location, color: Colors.white),
                onPressed: _useCurrentLocation,
                tooltip: 'Use current location',
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: _openCitySearch,
                tooltip: 'Search city',
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Icon(
          WeatherUtils.iconFor(weather.current.weatherCode,
              isDay: weather.current.isDay),
          color: Colors.white,
          size: 96,
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            '${weather.current.temperature.round()}°',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 72,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
        Center(
          child: Text(
            WeatherUtils.labelFor(weather.current.weatherCode),
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        Center(
          child: Text(
            'Feels like ${weather.current.feelsLike.round()}°',
            style: TextStyle(color: Colors.white.withValues(alpha:  0.8), fontSize: 14),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:  0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatColumn(
                  icon: Icons.water_drop_outlined,
                  label: 'Humidity',
                  value: '${weather.current.humidity}%',
                ),
                _StatColumn(
                  icon: Icons.air,
                  label: 'Wind',
                  value: '${weather.current.windSpeed.round()} km/h',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '7-Day Forecast',
            style: TextStyle(
              color: Colors.white.withValues(alpha:  0.9),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...List.generate(weather.daily.length, (i) {
          return ForecastCard(
            forecast: weather.daily[i],
            isToday: i == 0,
          );
        }),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatColumn({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha:  0.7), fontSize: 12),
        ),
      ],
    );
  }
}
