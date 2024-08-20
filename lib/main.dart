import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherforecast/const/colors.dart';
import '../views/homepage.dart';
import 'provider/weather_provider.dart';
import 'services/weather_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => WeatherProvider(WeatherService()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: background
      ),
      title: 'Weather App',
      home: const Homepage(),
    );
  }
}
