import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../widgets/search_box.dart';
import '../widgets/weather_card.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // ==========================================================
  // CONTROLLERS & SERVICES
  // ==========================================================

  final TextEditingController cityController = TextEditingController();

  final WeatherService weatherService = WeatherService();

  // ==========================================================
  // STATE
  // ==========================================================

  WeatherModel? weather;

  bool loading = false;

  String errorMessage = '';

  // ==========================================================
  // SEARCH WEATHER
  // ==========================================================

  Future<void> searchWeather() async {
    final city = cityController.text.trim();

    // Empty city validation
    if (city.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a city name';
        weather = null;
      });

      return;
    }

    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Start loading
    setState(() {
      loading = true;
      errorMessage = '';
    });

    try {
      // ------------------------------------------------------
      // Search city and get weather
      //
      // getWeatherByCity() internally:
      // 1. Searches the city using Open-Meteo geocoding
      // 2. Gets latitude and longitude
      // 3. Gets current weather
      // 4. Returns WeatherModel
      // ------------------------------------------------------

      final result = await weatherService.getWeatherByCity(city);

      if (!mounted) return;

      setState(() {
        weather = result;
        loading = false;
        errorMessage = '';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        weather = null;

        errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌤️ Weather App'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),

        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              if (cityController.text.trim().isNotEmpty) {
                await searchWeather();
              }
            },

            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),

              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

              child: Column(
                children: [
                  // ==================================================
                  // SEARCH BOX
                  // ==================================================
                  SearchBox(
                    controller: cityController,
                    onSearch: searchWeather,
                  ),

                  const SizedBox(height: 30),

                  // ==================================================
                  // LOADING
                  // ==================================================
                  if (loading)
                    const Padding(
                      padding: EdgeInsets.only(top: 50),

                      child: Column(
                        children: [
                          CircularProgressIndicator(),

                          SizedBox(height: 20),

                          Text(
                            'Getting latest weather...',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  // ==================================================
                  // ERROR
                  // ==================================================
                  else if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 40),

                      child: Column(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),

                          const SizedBox(height: 15),

                          Text(
                            errorMessage,
                            textAlign: TextAlign.center,

                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 20),

                          ElevatedButton.icon(
                            onPressed: searchWeather,

                            icon: const Icon(Icons.refresh),

                            label: const Text('Try Again'),
                          ),
                        ],
                      ),
                    )
                  // ==================================================
                  // WEATHER CARD
                  // ==================================================
                  else if (weather != null)
                    WeatherCard(weather: weather!)
                  // ==================================================
                  // EMPTY STATE
                  // ==================================================
                  else
                    const Column(
                      children: [
                        SizedBox(height: 60),

                        Text('🌍', style: TextStyle(fontSize: 80)),

                        SizedBox(height: 20),

                        Text(
                          'Search for a city',

                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 10),

                        Text(
                          'Enter a city name to see current weather',

                          textAlign: TextAlign.center,

                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }
}
