import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_api_dio/domain/models/forecast_model.dart';

class FiveDaysForecastWidget extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const FiveDaysForecastWidget({Key? key, required this.forecasts})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lấy các dự báo buổi trưa (12:00:00) trong 5 ngày
    final dailyForecasts =
        forecasts.where((f) => f.dateTime.hour == 12).take(5).toList();
    final String iconUrl = dotenv.env['WEATHER_ICON']!;

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
                  vertical: 10,
                  horizontal: 0,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _getGradientByTemperature(forecast.temperature),
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
                      '$iconUrl/${forecast.iconCode}@4x.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      '${forecast.temperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        fontSize: 38,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      forecast.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
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

List<Color> _getGradientByTemperature(double temp) {
  if (temp >= 35) {
    return [Colors.deepOrange.shade200, Colors.deepOrange.shade700];
  } else if (temp >= 29) {
    return [Colors.orange.shade100, Colors.orange.shade400];
  } else if (temp >= 20) {
    return [Colors.lightBlueAccent, Colors.blue.shade200];
  } else if (temp >= 10) {
    return [Colors.blue.shade100, Colors.blue.shade400];
  } else {
    return [Colors.indigo.shade100, Colors.blueGrey.shade300];
  }
}
