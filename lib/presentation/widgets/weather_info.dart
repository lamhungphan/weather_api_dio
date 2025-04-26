import 'package:flutter/material.dart';
import 'package:weather_api_dio/data/model/weather_model.dart';

class WeatherInfo extends StatelessWidget {
  final WeatherModel weather;

  const WeatherInfo({required this.weather, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          weather.cityName,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Image.network(
          'http://openweathermap.org/img/wn/${weather.iconCode}@2x.png',
          width: 100,
          height: 100,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error, size: 50, color: Colors.red);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const CircularProgressIndicator();
          },
        ),
        Text(
          '${weather.temperature}°C',
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
        ),
        Text(weather.description, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        Text('Độ ẩm: ${weather.humidity}%'),
        Text('Gió: ${weather.windSpeed} m/s'),
      ],
    );
  }
}
