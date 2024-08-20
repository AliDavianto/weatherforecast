class Weather {
  final int temperature;
  final int humidity;
  final int wind;
  final String dateTime;
  final String weather;
  final String description;
  final String icon;

  Weather({
    required this.temperature,
    required this.humidity,
    required this.wind,
    required this.dateTime,
    required this.weather,
    required this.description,
    required this.icon
  });

  factory Weather.fromJson(dynamic json) {
    return Weather(
      temperature: (json['main']['temp'] as num).toInt(),
      humidity: json['main']['humidity'],
      wind: (json['wind']['speed'] as num).toInt(),
      dateTime: json['dt_txt'],
      weather: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      icon : json['weather'][0]['icon']
    );
  }
}
