import 'package:weather_api_dio/domain/models/forecast_model.dart';
import 'package:weather_api_dio/domain/models/weather_model.dart';
import 'package:weather_api_dio/domain/repositories/weather_repository.dart';

class GetWeatherByCity {
  final WeatherRepository repository;

  GetWeatherByCity(this.repository);

  Future<WeatherModel> execute(String cityName) async {
    return await repository.getWeather(cityName);
  }
}

class GetForecastByCity {
  final WeatherRepository repository;

  GetForecastByCity(this.repository);

  Future<List<ForecastModel>> execute(String cityName) async {
    return await repository.getForecast(cityName);
  }
}

class GetWeatherByLocation {
  final WeatherRepository repository;

  GetWeatherByLocation(this.repository);

  Future<WeatherModel> execute(double lat, double lon) async {
    return await repository.getWeatherByLocation(lat, lon);
  }
}
