import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_api_dio/data/repositories/weather_repository_impl.dart';
import 'package:weather_api_dio/presentation/blocs/weather_event.dart';
import 'package:weather_api_dio/presentation/blocs/weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;

  WeatherBloc(this.repository) : super(WeatherInitial()) {

    on<WeatherRequested>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await repository.getWeather(event.city);
        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError(e.toString()));
      }
    });

    on<ForecastRequested>((event, emit) async {
      emit(ForecastLoading());
      try {
        final forecastList = await repository.getForecast(event.city);
        emit(ForecastLoaded(forecastList));
      } catch (e) {
        emit(ForecastError(e.toString()));
      }
    });
    
  }
}
