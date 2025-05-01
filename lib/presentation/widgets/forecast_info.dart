import 'package:flutter/material.dart';
import 'package:weather_api_dio/data/model/forecast_model.dart';

class ForecastInfo extends StatelessWidget {
  final List<Forecast> forecasts;

  const ForecastInfo({Key? key, required this.forecasts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lấy các dự báo buổi trưa (12:00:00) trong 5 ngày
    final dailyForecasts =
        forecasts.where((f) => f.dateTime.hour == 12).take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '⛅ Dự báo 5 ngày tới',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dailyForecasts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final forecast = dailyForecasts[index];

              return Container(
                width: 180,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.lightBlueAccent, Colors.blue.shade200],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.network(
                      'https://openweathermap.org/img/wn/${forecast.iconCode}@2x.png',
                      width: 60,
                      height: 60,
                    ),
                    Text(
                      '${forecast.temperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      forecast.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
