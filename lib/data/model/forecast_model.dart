class Forecast {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String iconCode;

  Forecast({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.iconCode,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      dateTime: DateTime.parse(json['dt_txt']),
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
    );
  }
}
