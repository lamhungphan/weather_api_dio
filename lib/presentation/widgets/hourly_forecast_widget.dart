import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_api_dio/domain/models/forecast_model.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const HourlyForecastWidget({super.key, required this.forecasts});
  @override
  Widget build(BuildContext context) {
    final next24h = forecasts.take(8).toList();
    final String iconUrl = dotenv.env['WEATHER_ICON']!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          next24h.map((forecast) {
            final time = TimeOfDay.fromDateTime(
              forecast.dateTime,
            ).format(context);

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              color: const Color(0xFFB3E5FC),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        time,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Image.network(
                            '$iconUrl/${forecast.iconCode}@2x.png',
                            width: 60,
                            height: 60,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              '${forecast.description}',
                              style: const TextStyle(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${forecast.temperature.toStringAsFixed(0)}°C',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color:
                            forecast.temperature >= 30
                                ? Colors.deepOrange
                                : Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
