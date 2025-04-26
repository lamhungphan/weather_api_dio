import 'package:dio/dio.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:weather_api_dio/data/model/weather_model.dart';

class WeatherService {
  static const String _baseUrl = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;
  final Dio _dio;

  WeatherService(this.apiKey) : _dio = Dio();

  Future<WeatherModel> getWeather(String cityName) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'q': cityName,
          'appid': apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

  // Future<String> getCurrentCity() async {
  //   try {
  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //     }

  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );

  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       position.latitude,
  //       position.longitude,
  //     );

  //     if (placemarks.isNotEmpty) {
  //       return placemarks.first.locality ?? '';
  //     } else {
  //       return '';
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to get current city: $e');
  //   }
  // }
}
