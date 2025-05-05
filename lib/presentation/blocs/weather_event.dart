import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class WeatherRequested extends WeatherEvent {
  final String city;

  const WeatherRequested(this.city);

  @override
  List<Object> get props => [city];
}

class ForecastRequested extends WeatherEvent {
    final String city;

  const ForecastRequested(this.city);

  @override
  List<Object> get props => [this.city];
}

class FetchWeatherByLocation extends WeatherEvent {
  final double lat;
  final double lon;

  FetchWeatherByLocation({required this.lat, required this.lon});
}
