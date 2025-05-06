import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_api_dio/presentation/blocs/weather_bloc.dart';
import 'package:weather_api_dio/presentation/blocs/weather_event.dart';
import 'package:weather_api_dio/presentation/blocs/weather_state.dart';
import 'package:weather_api_dio/presentation/widgets/five_days_forecast_widget.dart';
import 'package:weather_api_dio/presentation/widgets/hourly_forecast_widget.dart';
import 'package:weather_api_dio/presentation/widgets/detail_weather_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geocoding/geocoding.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  final List<String> _sampleCities = [
    'Ha noi',
    'Ho Chi Minh',
    'Da Nang',
    'Tokyo',
    'New York',
  ];
  String? _selectedCity;
  bool _isCityValid = false;
  String? _currentCity;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchWeatherByLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF81D4FA),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextField(
                            controller: _cityController,
                            decoration: const InputDecoration(
                              labelText: 'Nhập tên thành phố',
                              prefixIcon: Icon(Icons.location_city),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _selectedCity = null;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedCity,
                            decoration: const InputDecoration(
                              labelText: 'Hoặc chọn thành phố',
                              prefixIcon: Icon(Icons.location_on),
                              border: OutlineInputBorder(),
                            ),
                            items:
                                _sampleCities.map((city) {
                                  return DropdownMenuItem(
                                    value: city,
                                    child: Text(city),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCity = value;
                                _cityController.text = value ?? '';
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed:
                                _shouldDisableSearchButton()
                                    ? null
                                    : _fetchWeather,
                            icon: const Icon(Icons.search),
                            label: const Text('Xem thời tiết'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE1F5FE),
                              minimumSize: const Size.fromHeight(50),
                            ),
                          ),

                          const SizedBox(height: 12),
                          if (_isCityValid)
                            ElevatedButton.icon(
                              onPressed: _predictWeather,
                              icon: const Icon(Icons.calendar_today),
                              label: const Text('Dự đoán 5 ngày tới'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE1F5FE),
                                minimumSize: const Size.fromHeight(50),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    BlocConsumer<WeatherBloc, WeatherState>(
                      listener: (context, state) {
                        if (state is WeatherError || state is ForecastError) {
                          final message = (state as dynamic).message;
                          _showErrorDialog(context, message);
                          setState(() {
                            _isCityValid = false;
                          });
                        } else if (state is WeatherLoaded) {
                          setState(() {
                            _isCityValid = true;
                            _currentCity =
                                state.currentCity?.toLowerCase().trim();
                          });
                        }
                      },
                      builder: (context, state) {
                        if (state is WeatherLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is WeatherLoaded) {
                          return DetailWeatherWidget(weather: state.weather);
                        } else if (state is ForecastLoaded) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FiveDaysForecastWidget(
                                forecasts: state.forecasts,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                '🌦️ Dự báo 24 giờ tới',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              HourlyForecastWidget(forecasts: state.forecasts),
                            ],
                          );
                        } else if (state is ForecastLoaded) {}

                        return const Center(
                          child: Text(
                            'Nhập hoặc chọn thành phố để xem thời tiết',
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _fetchWeather() async {
    if (!await checkConnection(context)) return;

    final city = _cityController.text.trim();
    if (city.isNotEmpty) {
      setState(() {
        _isCityValid = false;
      });
      context.read<WeatherBloc>().add(WeatherRequested(city));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập hoặc chọn một thành phố')),
      );
    }
  }

  void _predictWeather() async {
    if (!await checkConnection(context)) return;

    final city = _cityController.text.trim();
    if (city.isNotEmpty) {
      context.read<WeatherBloc>().add(ForecastRequested(city));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập hoặc chọn một thành phố')),
      );
    }
  }

  Future<bool> checkConnection(BuildContext context) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      _showErrorDialog(
        context,
        'Không có kết nối mạng. Vui lòng kiểm tra Wi-Fi hoặc dữ liệu di động',
      );
      return false;
    }
    return true;
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Lỗi'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Đóng'),
              ),
            ],
          ),
    );
  }

  bool _shouldDisableSearchButton() {
    final inputCity = _cityController.text.toLowerCase().trim();
    return _currentCity != null && _currentCity == inputCity;
  }

  void _fetchWeatherByLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return _showErrorDialog(context, 'Dịch vụ định vị đang tắt');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return _showErrorDialog(context, 'Bạn cần cấp quyền vị trí');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return _showErrorDialog(
        context,
        'Không thể sử dụng vị trí vì bị từ chối vĩnh viễn.',
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      final cityName =
          placemarks.first.locality ?? placemarks.first.subAdministrativeArea;

      setState(() {
        _cityController.text = cityName ?? '';
        _selectedCity = null;
      });

      context.read<WeatherBloc>().add(
        FetchWeatherByLocation(lat: position.latitude, lon: position.longitude),
      );
    } catch (e) {
      _showErrorDialog(context, 'Lỗi khi lấy vị trí: $e');
    }
  }
}
