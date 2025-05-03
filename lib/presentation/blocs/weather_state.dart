import 'package:equatable/equatable.dart';
import 'package:weather_api_dio/domain/models/forecast_model.dart';
import 'package:weather_api_dio/domain/models/weather_model.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherModel weather;

  const WeatherLoaded(this.weather);

  @override
  List<Object> get props => [weather];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object> get props => [message];
}

class ForecastLoading extends WeatherState {}

class ForecastLoaded extends WeatherState {
  final List<ForecastModel> forecasts;

  const ForecastLoaded(this.forecasts);

  @override
  List<Object> get props => [forecasts];
}

class ForecastError extends WeatherState {
  final String message;

  ForecastError(this.message);

  @override
  List<Object> get props => [message];
}
