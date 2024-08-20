# Weather Forecast App

## Overview

Weather Forecast is a basic mobile application built using Flutter that provides current weather conditions and a 5-day weather forecast for a specified location. This app demonstrates skills in mobile app development, including API integration, state management, and error handling.

## Features

- Display current weather conditions
- Show a 5-day weather forecast
- Error handling with user-friendly messages
- Simple and intuitive UI/UX

## Getting Started

To run the Weather Forecast app on your local machine, follow these steps:

### Prerequisites

- Flutter SDK (version 3.0 or higher)
- Dart SDK
- An IDE with Flutter support (e.g., Visual Studio Code, Android Studio)

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/your-username/weather-forecast.git

2. **Navigate to the project directory:**

   cd weather-forecast

3. **Install the dependencies:**

   flutter pub get

4. **Set up the OpenWeatherMap API:**

  - Sign up for an API key from OpenWeatherMap.
  - Replace YOUR_API_KEY in lib/services/weather_service.dart with your API key.

5. **Run the app:**

  flutter run

## Usage

- **Select a location:** The app will default to Depok but can be modified to accept user input for other locations.
- **View current weather:** Check the current weather conditions displayed on the home screen.
- **Check the 5-day forecast:** Swipe or scroll to view the weather forecast for the next 5 days.

## Error Handling

The app includes error handling for common issues such as:

- **Unauthorized access:** Prompts the user to check their API key if there are access issues.
- **Connection errors:** Notifies the user if the app cannot connect to the server.

## Code Structure

- `lib/main.dart`: Entry point of the application.
- `lib/model/weather_model.dart`: Data models for weather data.
- `lib/services/weather_service.dart`: Service for fetching weather data from the OpenWeatherMap API.
- `lib/providers/weather_provider.dart`: State management and business logic for weather data.
- `lib/screens/home_screen.dart`: UI for displaying weather information.