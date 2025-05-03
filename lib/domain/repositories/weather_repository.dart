import 'package:weather_api_dio/domain/models/forecast_model.dart';
import 'package:weather_api_dio/domain/models/weather_model.dart';
import '/service/api_service.dart';

class WeatherRepository {
  final ApiService apiService;

  WeatherRepository(this.apiService);

  Future<WeatherModel> getWeather(String city) async {
    final json = await apiService.fetchCurrentWeather(city);
    return WeatherModel.fromJson(json);
  }

  Future<List<ForecastModel>> getForecast(String city) async {
    final listJson = await apiService.fetchForecast(city);
    return listJson.map((json) => ForecastModel.fromJson(json)).toList();
  }
}
