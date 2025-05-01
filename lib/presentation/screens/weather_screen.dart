import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_api_dio/presentation/blocs/weather_bloc.dart';
import 'package:weather_api_dio/presentation/blocs/weather_event.dart';
import 'package:weather_api_dio/presentation/blocs/weather_state.dart';
import 'package:weather_api_dio/presentation/widgets/forecast_info.dart';
import 'package:weather_api_dio/presentation/widgets/weather_info.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  final List<String> _sampleCities = [
    'Ha noi',
    'Ho Chi Minh',
    'Da Nang',
    'Tokyo',
    'New York',
  ];
  String? _selectedCity;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🌤️ Weather App'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'Nhập tên thành phố',
                        prefixIcon: Icon(Icons.location_city),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedCity = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedCity,
                      decoration: const InputDecoration(
                        labelText: 'Hoặc chọn thành phố',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                      ),
                      items:
                          _sampleCities.map((city) {
                            return DropdownMenuItem(
                              value: city,
                              child: Text(city),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCity = value;
                          _cityController.text = value ?? '';
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _fetchWeather,
                      icon: const Icon(Icons.search),
                      label: const Text('Xem thời tiết'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          248,
                          186,
                          105,
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _predictWeather,
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Dự đoán 5 ngày tới'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          201,
                          247,
                          203,
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WeatherLoaded) {
                    return WeatherInfo(weather: state.weather);
                  } else if (state is ForecastLoaded) {
                    return ForecastInfo(forecasts: state.forecasts);
                  } else if (state is WeatherError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const Center(
                    child: Text(
                      'Hãy nhập hoặc chọn thành phố để xem thời tiết',
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _fetchWeather() {
    final city = _cityController.text.trim();
    if (city.isNotEmpty) {
      context.read<WeatherBloc>().add(WeatherRequested(city));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập hoặc chọn một thành phố')),
      );
    }
  }

  void _predictWeather() {
    final city = _cityController.text.trim();
    if (city.isNotEmpty) {
      context.read<WeatherBloc>().add(ForecastRequested(city));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập hoặc chọn một thành phố')),
      );
    }
  }
}
