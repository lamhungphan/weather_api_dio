import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_api_dio/domain/models/weather_model.dart';

class DetailWeatherWidget extends StatelessWidget {
  final WeatherModel weather;

  const DetailWeatherWidget({required this.weather, super.key});

  @override
  Widget build(BuildContext context) {
    final String iconUrl = dotenv.env['WEATHER_ICON']!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              weather.cityName,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Image.network(
              '$iconUrl/${weather.iconCode}@4x.png',
              width: 180,
              height: 180,
              fit: BoxFit.contain,

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
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              weather.description,
              style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
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
    );
  }

  Widget _buildWeatherDetail(IconData icon, String value, String label) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 18, color: Colors.black)),
        Icon(icon, size: 32, color: Colors.blueAccent),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
        ),
      ],
    );
  }
}
