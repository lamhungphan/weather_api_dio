import 'package:dio/dio.dart';
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
          'units': 'metric', // Nhiệt độ tính bằng °C
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
}