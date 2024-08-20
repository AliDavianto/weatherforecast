import 'package:flutter/material.dart';
import '../model/weather_model.dart';
import '../services/weather_service.dart';
import 'package:dio/dio.dart'; // Import Dio package for DioException

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService;
  WeatherProvider(this._weatherService);

  List<Weather>? todayWeatherList;
  List<Weather>? forecastWeatherList;
  Weather? displayedWeather;

  Future<void> loadWeatherData(BuildContext context) async {
    try {
      List<Weather> allWeatherList = await _weatherService.fetchWeatherDataFromApi();
      DateTime now = DateTime.now();
      String todayDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      List<Weather> allTodayWeatherList = allWeatherList.where((weather) {
        String weatherDate = weather.dateTime.split(' ')[0];
        return weatherDate == todayDate;
      }).toList();

      DateTime startDate = now.add(const Duration(days: 1));
      DateTime endDate = now.add(const Duration(days: 4));

      List<Weather> futureWeatherList = allWeatherList.where((weather) {
        String weatherDate = weather.dateTime.split(' ')[0];
        String weatherTime = weather.dateTime.split(' ')[1];
        DateTime weatherDateTime = DateTime.parse(weather.dateTime);
        return weatherTime == "12:00:00" &&
            weatherDate != todayDate &&
            weatherDateTime.isAfter(startDate) &&
            weatherDateTime.isBefore(endDate);
      }).toList();

      Weather? closestWeather = allTodayWeatherList.where((weather) {
        DateTime weatherDateTime = DateTime.parse(weather.dateTime);
        return weatherDateTime.isBefore(now) || weatherDateTime.isAtSameMomentAs(now);
      }).toList().reduce((a, b) {
        return DateTime.parse(a.dateTime).isAfter(DateTime.parse(b.dateTime)) ? a : b;
      });

      todayWeatherList = allTodayWeatherList;
      forecastWeatherList = futureWeatherList;
      displayedWeather = closestWeather;

      notifyListeners();
    } catch (e) {
      // Check if the context is still valid before showing the dialog
      if (context.mounted) {
        if (e is DioException && e.response != null) {
          _showErrorDialog(
            context,
            e.response!.statusCode,
            e.response!.statusMessage ?? 'An unknown error occurred.',
          );
        } else {
          _showErrorDialog(context, null, e.toString());
        }
      }
    }
  }

  void _showErrorDialog(BuildContext context, int? errorCode, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('Error ${errorCode ?? "Unknown"}: $message'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
