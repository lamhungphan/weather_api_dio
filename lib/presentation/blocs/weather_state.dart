import 'package:equatable/equatable.dart';
import 'package:weather_api_dio/domain/models/forecast_model.dart';
import 'package:weather_api_dio/domain/models/weather_model.dart';

abstract class WeatherState extends Equatable {
  final String? currentCity;

  const WeatherState({this.currentCity});

  @override
  List<Object?> get props => [currentCity];
}

class WeatherInitial extends WeatherState {
  const WeatherInitial() : super(currentCity: null);
}

class WeatherLoading extends WeatherState {
  const WeatherLoading({String? currentCity}) : super(currentCity: currentCity);
}

class WeatherLoaded extends WeatherState {
  final WeatherModel weather;

  const WeatherLoaded(this.weather, {required String currentCity})
    : super(currentCity: currentCity);

  @override
  List<Object?> get props => [weather, currentCity];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message, {String? currentCity})
    : super(currentCity: currentCity);

  @override
  List<Object?> get props => [message, currentCity];
}

class ForecastLoading extends WeatherState {
  const ForecastLoading({String? currentCity})
    : super(currentCity: currentCity);
}

class ForecastLoaded extends WeatherState {
  final List<ForecastModel> forecasts;

  const ForecastLoaded(this.forecasts, {String? currentCity})
    : super(currentCity: currentCity);

  @override
  List<Object?> get props => [forecasts, currentCity];
}

class ForecastError extends WeatherState {
  final String message;

  const ForecastError(this.message, {String? currentCity})
    : super(currentCity: currentCity);

  @override
  List<Object?> get props => [message, currentCity];
}
