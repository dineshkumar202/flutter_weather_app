import 'package:flutter/material.dart';

class WeatherWidget extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  WeatherWidget({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final city = weatherData['name'];
    final temp = weatherData['main']['temp'].toStringAsFixed(1);
    final feelsLike = weatherData['main']['feels_like'].toStringAsFixed(1);
    final humidity = weatherData['main']['humidity'];
    final description = weatherData['weather'][0]['description'];
    final iconCode = weatherData['weather'][0]['icon'];
    final iconUrl = 'http://openweathermap.org/img/wn/$iconCode@2x.png';

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('📍 $city', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Image.network(iconUrl, width: 100, height: 100),
            Text(
              '$temp°C | Feels like $feelsLike°C',
              style: TextStyle(fontSize: 20),
            ),
            Text('Humidity: $humidity%', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
              description[0].toUpperCase() + description.substring(1),
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
