String kelvinToCelsius(int kelvin) {
  double result = kelvin - 273.15;
  // Round the result to the nearest integer
  int roundedResult = result.round();
  // Return as a string without decimal places
  return roundedResult.toString();
}
