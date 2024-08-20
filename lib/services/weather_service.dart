// weather_service.dart
import '../model/weather_model.dart';
import '../api/api.dart';

class WeatherService {
  Future<List<Weather>> fetchWeatherDataFromApi() async {
    List<dynamic> weatherJson = await fetchWeatherData(); // Replace with actual API call
    return weatherJson.map((json) => Weather.fromJson(json)).toList();
  }
}
