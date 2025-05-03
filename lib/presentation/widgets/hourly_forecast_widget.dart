import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_api_dio/data/model/forecast_model.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const HourlyForecastWidget({super.key, required this.forecasts});
 @override
  Widget build(BuildContext context) {
    // Chỉ lấy 8 mục đầu tiên (24 giờ tới)
    final next24h = forecasts.take(8).toList();
    final String iconUrl = dotenv.env['WEATHER_ICON']!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: next24h.map((forecast) {
        final time = TimeOfDay.fromDateTime(forecast.dateTime).format(context);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Giờ
                SizedBox(
                  width: 60,
                  child: Text(
                    time,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                // Icon + Thành phố + mô tả
                Expanded(
                  child: Row(
                    children: [
                      Image.network(
                        '$iconUrl/${forecast.iconCode}@2x.png',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '${forecast.description}',
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // Nhiệt độ
                Text(
                  '${forecast.temperature.toStringAsFixed(0)}°C',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
