import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_api_dio/data/model/forecast_model.dart';
import 'package:weather_api_dio/data/model/weather_model.dart';

class WeatherRepository {
  final Dio dio;
  final String apiKey;
  final String baseUrl = dotenv.env['WEATHER_URL']!;

  WeatherRepository({required this.apiKey}) : dio = Dio();

  Future<WeatherModel> getWeather(String city) async {
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

      return WeatherModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Không tìm thấy thành phố. Vui lòng kiểm tra lại tên.');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
          'Kết nối đến máy chủ bị hết thời gian. Vui lòng thử lại sau.',
        );
      } else if (e.type == DioExceptionType.unknown) {
        throw Exception(
          'Không có kết nối mạng. Vui lòng kiểm tra kết nối internet.',
        );
      } else {
        throw Exception('Đã xảy ra lỗi máy chủ. Vui lòng thử lại sau.');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi không xác định. Vui lòng thử lại.');
    }
  }

  Future<List<ForecastModel>> getForecast(String city) async {
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

      final List list = response.data['list'];
      return list.map((json) => ForecastModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Không tìm thấy thành phố. Vui lòng kiểm tra lại tên.');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
          'Kết nối đến máy chủ bị hết thời gian. Vui lòng thử lại sau.',
        );
      } else if (e.type == DioExceptionType.unknown) {
        throw Exception(
          'Không có kết nối mạng. Vui lòng kiểm tra kết nối internet.',
        );
      } else {
        throw Exception('Đã xảy ra lỗi máy chủ. Vui lòng thử lại sau.');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi không xác định. Vui lòng thử lại.');
    }
  }
}
