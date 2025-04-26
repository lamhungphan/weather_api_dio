import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_api_dio/data/repositories/weather_repository_impl.dart';
import 'package:weather_api_dio/presentation/blocs/weather_bloc.dart';
import 'package:weather_api_dio/presentation/screens/weather_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  print(dotenv.env); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiKey = dotenv.env['API_KEY'] ?? '';
    return BlocProvider(
      create: (context) => WeatherBloc(WeatherRepository(apiKey: apiKey)),
      child: MaterialApp(
        title: 'Weather App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const WeatherScreen(),
      ),
    );
  }
}
