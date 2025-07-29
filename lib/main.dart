import 'package:flutter/material.dart';
import 'weather_service.dart';
import 'weather_widget.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App with Autocomplete',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
      ),
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  String _selectedCity = '';
  final List<String> _citySuggestions = [
    'Chennai', 'Delhi', 'Mumbai', 'Kolkata', 'Bangalore',
    'Hyderabad', 'Ahmedabad', 'Pune', 'Jaipur', 'Lucknow',
    'New York', 'London', 'Tokyo', 'Paris', 'Sydney',
    'Berlin', 'Toronto', 'Dubai', 'Singapore', 'Cape Town', 'Madurai',
  ];

  Map<String, dynamic>? _weatherData;
  String? _error;

  void _getWeather() async {
    if (_selectedCity.isEmpty) return;

    final data = await WeatherService.fetchWeather(_selectedCity);

    setState(() {
      if (data != null && data['main'] != null) {
        _weatherData = data;
        _error = null;
      } else {
        _weatherData = null;
        _error = '⚠️ Could not fetch weather for "$_selectedCity"';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('🌤️ Weather App')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') return const Iterable<String>.empty();
                return _citySuggestions.where((String option) =>
                    option.toLowerCase().startsWith(textEditingValue.text.toLowerCase()));
              },
              onSelected: (String selection) {
                setState(() {
                  _selectedCity = selection;
                });
              },
              fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onEditingComplete: onEditingComplete,
                  decoration: InputDecoration(
                    labelText: 'Enter City',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        _selectedCity = controller.text;
                        _getWeather();
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 24),
            if (_weatherData != null)
              WeatherWidget(weatherData: _weatherData!),
            if (_error != null)
              Text(_error!, style: TextStyle(color: Colors.red, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
