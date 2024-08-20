import 'package:dio/dio.dart';

final dio = Dio();

Future<List<dynamic>> fetchWeatherData() async {
  String url =
      "http://api.openweathermap.org/data/2.5/forecast?q=Depok&appid=8683cba18067182d9a900254a8ebdc5e";

  Response response = await dio.get(url);
  if (response.statusCode == 200) {
    return response.data['list']; // Return the raw JSON data
  } else {
    throw Exception('Failed to load weather data');
  }
}
