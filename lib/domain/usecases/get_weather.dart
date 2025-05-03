import 'package:weather_api_dio/domain/models/forecast_model.dart';
import 'package:weather_api_dio/service/api_service.dart';
import 'package:weather_api_dio/domain/models/weather_model.dart';

class GetWeatherByCity {
  final ApiService apiService;

  GetWeatherByCity(this.apiService);

  Future<WeatherModel> execute(String cityName) async {
    final weatherJson = await apiService.fetchCurrentWeather(cityName);
    return WeatherModel.fromJson(weatherJson);
  }
}

class GetForecastByCity {
  final ApiService apiService;

  GetForecastByCity(this.apiService);

  Future<List<ForecastModel>> execute(String cityName) async {
    final forecastJson = await apiService.fetchForecast(cityName);
    return forecastJson.map<ForecastModel>((e) => ForecastModel.fromJson(e)).toList();
  }
}
