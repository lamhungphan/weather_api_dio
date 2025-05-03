import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_api_dio/data/model/weather_model.dart';

class DetailWeatherWidget extends StatelessWidget {
  final WeatherModel weather;

  const DetailWeatherWidget({required this.weather, super.key});

  @override
  Widget build(BuildContext context) {
    final String iconUrl = dotenv.env['WEATHER_ICON']!;

    return Center(
      child: Card(
        color: const Color.fromARGB(255, 192, 227, 255),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                weather.cityName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Image.network(
                '$iconUrl/${weather.iconCode}@2x.png',
                width: 120,
                height: 120,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, size: 60, color: Colors.red);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 16),
              Text(
                '${weather.temperature}°C',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                weather.description,
                style: const TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildWeatherDetail(
                    Icons.water_drop,
                    '${weather.humidity}%',
                    'Độ ẩm',
                  ),
                  _buildWeatherDetail(
                    Icons.air,
                    '${weather.windSpeed} m/s',
                    'Gió',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blueAccent),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
