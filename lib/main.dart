import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_api_dio/domain/repositories/weather_repository.dart';
import 'package:weather_api_dio/domain/usecases/get_weather.dart';
import 'package:weather_api_dio/presentation/blocs/weather_bloc.dart';
import 'package:weather_api_dio/presentation/screens/weather_screen.dart';
import 'package:weather_api_dio/service/api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final apiKey = dotenv.env['WEATHER_KEY'] ?? '';
  final apiService = ApiService(apiKey: apiKey);
  final repository = WeatherRepository(apiService);

  final getWeatherByCity = GetWeatherByCity(repository);
  final getForecastByCity = GetForecastByCity(repository);
  final getWeatherByLocation = GetWeatherByLocation(repository);

  runApp(
    MyApp(
      getWeatherByCity: getWeatherByCity,
      getForecastByCity: getForecastByCity,
      getWeatherByLocation: getWeatherByLocation,
    ),
  );
}

class MyApp extends StatelessWidget {
  final GetWeatherByCity getWeatherByCity;
  final GetForecastByCity getForecastByCity;
  final GetWeatherByLocation getWeatherByLocation;

  const MyApp({
    super.key,
    required this.getWeatherByCity,
    required this.getForecastByCity,
    required this.getWeatherByLocation,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => WeatherBloc(
            getWeatherByCity: getWeatherByCity,
            getForecastByCity: getForecastByCity,
            getWeatherByLocation: getWeatherByLocation,
          ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const WeatherScreen(),
      ),
    );
  }
}
