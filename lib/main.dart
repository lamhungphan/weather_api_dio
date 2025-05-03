import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_api_dio/domain/usecases/get_weather.dart';
import 'package:weather_api_dio/presentation/blocs/weather_bloc.dart';
import 'package:weather_api_dio/presentation/screens/weather_screen.dart';
import 'package:weather_api_dio/service/api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final apiKey = dotenv.env['WEATHER_KEY'] ?? '';
  final apiService = ApiService(apiKey: apiKey);

  final getWeatherByCity = GetWeatherByCity(apiService);
  final getForecastByCity = GetForecastByCity(apiService);

  runApp(
    MyApp(
      getWeatherByCity: getWeatherByCity,
      getForecastByCity: getForecastByCity,
    ),
  );
}

class MyApp extends StatelessWidget {
  final GetWeatherByCity getWeatherByCity;
  final GetForecastByCity getForecastByCity;

  const MyApp({
    super.key,
    required this.getWeatherByCity,
    required this.getForecastByCity,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => WeatherBloc(
            getWeatherByCity: getWeatherByCity,
            getForecastByCity: getForecastByCity,
          ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const WeatherScreen(),
      ),
    );
  }
}
