import 'package:dio/dio.dart';
import 'package:weather_api_dio/data/model/forecast_model.dart';
import 'package:weather_api_dio/data/model/weather_model.dart';

class WeatherRepository {
  final Dio dio;
  final String apiKey;

  WeatherRepository({required this.apiKey}) : dio = Dio();

  Future<WeatherModel> getWeather(String city) async {
    try {
      final response = await dio.get(
        'https://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'q': city,
          'appid': apiKey,
          'units': 'metric',
          'lang': 'vi',
        },
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch weather: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }

  Future<List<Forecast>> getForecast(String city) async {
    try {
      // Lấy lat/lon từ tên thành phố
      final weather = await getWeather(city);
      final lat = weather.lat;
      final lon = weather.lon;

      // Gọi forecast
      final forecastRes = await dio.get(
        'https://api.openweathermap.org/data/2.5/forecast',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': apiKey,
          'units': 'metric',
          'lang': 'vi',
        },
      );

      if (forecastRes.statusCode == 200) {
        final List list = forecastRes.data['list'];
        return list.map((json) => Forecast.fromJson(json)).toList();
      } else {
        throw Exception('Forecast error: ${forecastRes.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error fetching forecast: $e');
    }
  }
}
