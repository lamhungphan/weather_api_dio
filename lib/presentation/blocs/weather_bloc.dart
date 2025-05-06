import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_api_dio/domain/usecases/get_weather.dart';
import 'package:weather_api_dio/presentation/blocs/weather_event.dart';
import 'package:weather_api_dio/presentation/blocs/weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeatherByCity getWeatherByCity;
  final GetForecastByCity getForecastByCity;
  final GetWeatherByLocation getWeatherByLocation;

  WeatherBloc({
    required this.getWeatherByCity,
    required this.getForecastByCity,
    required this.getWeatherByLocation,
  }) : super(const WeatherInitial()) {
    
    // ----------- WEATHER REQUESTED -----------
    on<WeatherRequested>((event, emit) async {
      // ⛔ Nếu đang loading → bỏ qua
      if (state is WeatherLoading) return;

      // ⛔ Nếu trùng thành phố → bỏ qua
      // final currentCity = state.currentCity ?? '';
      // if (currentCity.toLowerCase().trim() == event.city.toLowerCase().trim()) return;

      emit(WeatherLoading(currentCity: event.city));

      try {
        final weather = await getWeatherByCity.execute(event.city);
        emit(WeatherLoaded(weather, currentCity: event.city));
      } catch (e) {
        final message = e.toString().replaceAll(RegExp(r'Exception: *'), '');
        emit(WeatherError(message, currentCity: event.city));
      }
    });

    // ----------- FORECAST REQUESTED -----------
    on<ForecastRequested>((event, emit) async {
      emit(ForecastLoading(currentCity: event.city));

      try {
        final forecastList = await getForecastByCity.execute(event.city);
        emit(ForecastLoaded(forecastList, currentCity: event.city));
      } catch (e) {
        final message = e.toString().replaceAll(RegExp(r'Exception: *'), '');
        emit(ForecastError(message, currentCity: event.city));
      }
    });

    // ----------- WEATHER BY LOCATION -----------
    on<FetchWeatherByLocation>((event, emit) async {
      emit(const WeatherLoading());

      try {
        final weather = await getWeatherByLocation.execute(event.lat, event.lon);
        emit(WeatherLoaded(weather, currentCity: weather.cityName)); // Gán city name nếu có
      } catch (e) {
        final message = e.toString().replaceAll(RegExp(r'Exception: *'), '');
        emit(WeatherError(message));
      }
    });
  }
}
