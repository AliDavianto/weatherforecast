import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherforecast/utility/converter.dart';
import '../provider/weather_provider.dart';
import '../const/colors.dart';
import '../model/weather_model.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart'; // Ensure this import is included for date formatting

class Homepage extends StatelessWidget {
  //Main view
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    // Fetch weather data once the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      weatherProvider.loadWeatherData(context);
    });

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: Column(
          children: [
            const LocationAndDate(),
            Expanded(
              child: ListView(
                children: [
                  if (weatherProvider.displayedWeather != null) ...[
                    const SizedBox(height: 20),

                    // Today's forecast
                    CurrentWeatherDisplay(
                        weather: weatherProvider.displayedWeather!),
                    const SizedBox(height: 24),
                    WeatherDetails(weather: weatherProvider.displayedWeather!),
                  ],
                  const SizedBox(height: 24),

                  //Next 3 days forecat
                  const NextDaysTitle(),
                  const SizedBox(height: 24),
                  if (weatherProvider.forecastWeatherList != null &&
                      weatherProvider.forecastWeatherList!.isNotEmpty)
                    ForecastList(
                        forecastWeatherList:
                            weatherProvider.forecastWeatherList!)
                  else if (weatherProvider.forecastWeatherList == null)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Location and date widget
class LocationAndDate extends StatelessWidget {
  const LocationAndDate({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current date and format it
    DateTime now = DateTime.now();
    String dayOfWeek = DateFormat('EEEE').format(now); // e.g., "Thursday"
    String formattedDate =
        DateFormat('d MMMM yyyy').format(now); // e.g., "21 August 2024"
    String formattedTime = DateFormat('HH : mm').format(now); // e.g., "08 : 32"

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Depok, West Java",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              "$dayOfWeek, $formattedDate",
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ],
        ),
        Text(
          formattedTime,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}

//Current Weather Display Widget
class CurrentWeatherDisplay extends StatelessWidget {
  final Weather weather;

  const CurrentWeatherDisplay({super.key, required this.weather});

  // Method to get the appropriate Lottie animation based on the weather description
  String getWeatherAnimation(String description) {
    // Get the current hour
    int currentHour = DateTime.now().hour;

    // Check if the current hour is 18 or later
    if (currentHour >= 18) {
      if (description.contains("cloud")) {
        return "assets/animation/moon_clouds.json";
      } else if (description.contains("rain")) {
        return "assets/animation/rain.json"; // Assuming you have this animation
      } else if (description.contains("clear") ||
          description.contains("sunny")) {
        return "assets/animation/moon.json"; // Assuming you have this animation
      } else {
        return "assets/animation/moon.json"; // Default to moon animation
      }
    } else {
      // Daytime animations
      if (description.contains("cloud")) {
        return "assets/animation/clouds.json";
      } else if (description.contains("rain")) {
        return "assets/animation/rain.json";
      } else if (description.contains("clear") ||
          description.contains("sunny")) {
        return "assets/animation/sun.json";
      } else {
        return "assets/animation/sun.json"; // Default to sun animation
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              "${kelvinToCelsius(weather.temperature)}°C",
              style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              weather.description,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ],
        ),
        // Display the Lottie animation based on weather condition
        Lottie.asset(
          getWeatherAnimation(weather.description),
          width: 150,
          height: 150,
        ),
      ],
    );
  }
}


//WeatherDetails Widget
class WeatherDetails extends StatelessWidget {
  final Weather weather;

  const WeatherDetails({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: const BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WeatherDetailItem(
            imagePath: 'assets/images/white_wind.png',
            value: "${weather.wind} km/h",
            label: "Wind",
          ),
          WeatherDetailItem(
            imagePath: 'assets/images/blue_humidity.png',
            value: "${weather.humidity} %",
            label: "Humidity",
          ),
        ],
      ),
    );
  }
}

//Weather Detail Item Widget
class WeatherDetailItem extends StatelessWidget {
  final String imagePath;
  final String value;
  final String label;

  const WeatherDetailItem({
    super.key,
    required this.imagePath,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          height: 40,
          width: 40,
        ),
        Text(
          value,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: white),
        ),
        Text(
          label,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: grey),
        ),
      ],
    );
  }
}

// Next 3 days forecast widget
class NextDaysTitle extends StatelessWidget {
  const NextDaysTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Next 3 Days",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: white),
    );
  }
}

class ForecastList extends StatelessWidget {
  final List<Weather> forecastWeatherList;

  const ForecastList({super.key, required this.forecastWeatherList});

  // Method to format date from the weather data
  String formatDate(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    return DateFormat('d MMM').format(parsedDate); // Format to "22 Aug"
  }

// Method to get the appropriate Lottie animation based on the weather description
  String getWeatherAnimation(String description) {
    if (description.contains("cloud")) {
      return "assets/animation/clouds.json";
    } else if (description.contains("rain")) {
      return "assets/animation/rain.json";
    } else if (description.contains("clear") || description.contains("sunny")) {
      return "assets/animation/sun.json";
    } else {
      return "assets/animation/sun.json"; // Default to sun animation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecastWeatherList.length,
        itemBuilder: (context, index) {
          Weather weather = forecastWeatherList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            elevation: 5,
            child: Container(
              width: 100,
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    formatDate(weather.dateTime), // Use the formatted date here
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: grey,
                    ),
                  ),
                  Lottie.asset(
                    getWeatherAnimation(weather.description),
                    width: 32,
                    height: 32,
                  ),
                  Text(
                    weather.weather,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
