import 'package:weather_api_dio/domain/models/forecast_model.dart';
import 'package:weather_api_dio/domain/models/weather_model.dart';
import 'package:weather_api_dio/service/api_service.dart';

class WeatherRepository {
  final ApiService apiService;

  WeatherRepository(this.apiService);

  Future<WeatherModel> getWeather(String city) async {
    final json = await apiService.fetchCurrentWeather(city);
    return WeatherModel.fromJson(json);
  }

  Future<List<ForecastModel>> getForecast(String city) async {
    final listJson = await apiService.fetchForecast(city);
    return listJson
        .map((json) => ForecastModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<WeatherModel> getWeatherByLocation(double lat, double lon) async {
    final json = await apiService.fetchCurrentWeatherByLocation(
      lat: lat,
      lon: lon,
    );
    return WeatherModel.fromJson(json);
  }
}
