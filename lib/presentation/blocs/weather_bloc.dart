import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_api_dio/domain/usecases/get_weather.dart';
import 'package:weather_api_dio/presentation/blocs/weather_event.dart';
import 'package:weather_api_dio/presentation/blocs/weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeatherByCity getWeatherByCity;
  final GetForecastByCity getForecastByCity;

  WeatherBloc({required this.getWeatherByCity, required this.getForecastByCity})
    : super(WeatherInitial()) {
    on<WeatherRequested>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await getWeatherByCity.execute(event.city);
        emit(WeatherLoaded(weather));
      } catch (e) {
        final message = e.toString().replaceAll(RegExp(r'Exception: *'), '');
        emit(WeatherError(message));
      }
    });

    on<ForecastRequested>((event, emit) async {
      emit(ForecastLoading());
      try {
        final forecastList = await getForecastByCity.execute(event.city);
        emit(ForecastLoaded(forecastList));
      } catch (e) {
        final message = e.toString().replaceAll(RegExp(r'Exception: *'), '');
        emit(ForecastError(message));
      }
    });
  }
}
