class WeatherModel {
  final String cityName;
  final double lat;
  final double lon;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final String iconCode;

  WeatherModel({
    required this.cityName,
    required this.lat,
    required this.lon,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.iconCode,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      lat: (json['coord']['lat'] as num).toDouble(),
      lon: (json['coord']['lon'] as num).toDouble(),
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      iconCode: json['weather'][0]['icon'],
    );
  }
}
