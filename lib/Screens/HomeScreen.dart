import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/Screens/forcast_screen.dart';

import '../Service/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  String _city = "london";
  Map<String, dynamic>? _ciurrntWeather;
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final weatherdata = await _weatherService.fetchCurrentWeather(_city);
      setState(() {
        _ciurrntWeather = weatherdata;
      });
    } catch (e) {
      print(e);
    }
  }

  void _showCitySelectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter City Name"),
          content: TypeAheadField(
            suggestionsCallback: (Pattern) async {
              return await _weatherService.fetchCitySuggestion(Pattern);
            },
            builder: (context, controller, focusNode) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "City",
                ),
              );
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion['name']),
              );
            },
            onSelected: (city) {
              setState(() {
                _city = city['name'];
              });
            },
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cansel")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _fetchWeather();
                },
                child: Text("OK"))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _ciurrntWeather == null
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1A2344),
                      Color.fromARGB(255, 125, 32, 142),
                      Colors.purple,
                      Color.fromARGB(255, 151, 44, 171),
                    ]),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1A2344),
                      Color.fromARGB(255, 125, 32, 142),
                      Colors.purple,
                      Color.fromARGB(255, 151, 44, 171),
                    ]),
              ),
              child: ListView(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: _showCitySelectDialog,
                      child: Text(
                        _city,
                        style: GoogleFonts.lato(
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Center(
                    child: Column(
                      children: [
                        Image.network(
                          'http:${_ciurrntWeather!['current']['condition']['icon']}',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          '${_ciurrntWeather!['current']['temp_c'].round()}°C',
                          style: GoogleFonts.lato(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_ciurrntWeather!['current']['condition']['text']}',
                          style: GoogleFonts.lato(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Max : ${_ciurrntWeather!['forecast']['forecastday'][0]['day']['maxtemp_c'].round()}°C',
                              style: GoogleFonts.lato(
                                fontSize: 22,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Min : ${_ciurrntWeather!['forecast']['forecastday'][0]['day']['mintemp_c'].round()}°C',
                              style: GoogleFonts.lato(
                                fontSize: 22,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildWeatherDetails(
                          'الشروق ',
                          Icons.wb_sunny,
                          _ciurrntWeather!['forecast']['forecastday'][0]
                              ['astro']['sunrise']),
                      _buildWeatherDetails(
                          'الغروب',
                          Icons.brightness_3,
                          _ciurrntWeather!['forecast']['forecastday'][0]
                              ['astro']['Sunset']),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildWeatherDetails(
                        'الرطوبه',
                        Icons.opacity,
                        '${_ciurrntWeather!['current']['humidity']}%',
                      ),
                      _buildWeatherDetails(
                        'الرياح (كم/س)',
                        Icons.wind_power,
                        '${_ciurrntWeather!['current']['wind_kph']}',
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 35,
                  ),

                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForecastScreen(city: _city),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1A2344), // لون الخلفية
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), // حجم الزر
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // شكل الحواف الدائرية
                            ),
                            elevation: 8, // إضافة ظل للزرار
                          ),
                          child: Text(
                            "توقعات الطقس",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // تكبير حجم النص
                            ),
                          ),
                        ),
                      )


                ],
              ),
            ),
    );
  }

  Widget _buildWeatherDetails(String lable, IconData icon, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3,
            sigmaY: 3,
          ),
          child: Container(
            padding: EdgeInsets.all(5),
            width: 150,
            height: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                    colors: [
                      Color(0xFF1A2344).withOpacity(0.5),
                      Color(0xFF1A2344).withOpacity(0.2),
                    ])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  lable,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  value is String ? value : value.toString(),
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
