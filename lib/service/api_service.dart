import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final Dio dio;
  final String apiKey;
  final String baseUrl = dotenv.env['WEATHER_URL']!;

  ApiService({required this.apiKey}) : dio = Dio();

  Future<Map<String, dynamic>> fetchCurrentWeather(String city) async {
    try {
      final response = await dio.get(
        '$baseUrl/weather',
        queryParameters: {
          'q': city,
          'appid': apiKey,
          'units': 'metric',
          'lang': 'vi',
        },
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<List<dynamic>> fetchForecast(String city) async {
    try {
      final response = await dio.get(
        '$baseUrl/forecast',
        queryParameters: {
          'q': city,
          'appid': apiKey,
          'units': 'metric',
          'lang': 'vi',
        },
      );
      return response.data['list'];
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchCurrentWeatherByLocation({
    required double lat,
    required double lon,
  }) async {
    try {
      final response = await dio.get(
        '$baseUrl/weather',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': apiKey,
          'units': 'metric',
          'lang': 'vi',
        },
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  void _handleDioError(DioException e) {
    if (e.response?.statusCode == 404) {
      throw Exception('Không tìm thấy thành phố. Vui lòng kiểm tra lại tên');
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw Exception(
        'Kết nối đến máy chủ bị hết thời gian. Vui lòng thử lại sau',
      );
    } else if (e.type == DioExceptionType.unknown) {
      throw Exception(
        'Không có kết nối mạng. Vui lòng kiểm tra kết nối internet',
      );
    } else {
      throw Exception('Đã xảy ra lỗi máy chủ. Vui lòng thử lại sau');
    }
  }
}
