import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' show DateFormat;
import 'package:weather_app/secret.dart';
import 'additional_information.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String,dynamic>> weather;
  Future <Map<String,dynamic>> getcurrentWeather() async {
    try{
      String cityName='Tamil Nadu';
      final res = await http.get(
        Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openweatherAPIkey',
        ),
      );
      final data= jsonDecode(res.body);

      if(data['cod'] != '200'){
        throw 'An un expected error';
      }
      return data;
    }

    catch (e) {
      throw e.toString();
    }
}

@override
  void initState() {
    super.initState();
    weather = getcurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Weather App',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
             setState(() {
               weather = getcurrentWeather();
             });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body:
      FutureBuilder(
        future: weather,
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }

          final data= snapshot.data!;
          final weatherdata= data['list'][0];
          final temp=weatherdata['main']['temp'];
          final sky=weatherdata['weather'][0]['main'];
          final humidity=weatherdata['main']['humidity'];
          final pressure=weatherdata['main']['pressure'];
          final wind=weatherdata['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 SizedBox(
                   width: double.infinity,
                       child: Card(
                         elevation: 20,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10),
                         ),
                         child: ClipRRect(
                           borderRadius: BorderRadius.circular(10),
                           child: BackdropFilter(
                             filter: ImageFilter.blur(
                               sigmaX: 5,
                               sigmaY: 5,
                             ),
                           child:  Padding(
                             padding:  const EdgeInsets.all(10.0),
                             child:  Column(
                                 children: [
                                   Text(
                                       '$temp K',
                                     style: const TextStyle(
                                       fontSize: 34,
                                       fontWeight: FontWeight.bold,
                                     ),
                                   ),
                                   const SizedBox(height: 10),
                                    Icon(
                                     sky =='Clouds' || sky == 'Rain' ? Icons.cloud : Icons.sunny,
                                     size: 64,
                                   ),
                                   const SizedBox(height: 10),
                                    Text(
                                     sky,
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                   ),
                                 ],
                               ),
                           ),
                           ),
                         ),
                     ),
                     ),
                 const SizedBox(height: 20),
                const Text('Weather ForeCast', style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                ),
                 const SizedBox(height: 5),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index){
                      final forecast= data['list'][index +1];
                      final time= DateTime.parse(forecast['dt_txt']);
                      final temp=forecast['main']['temp'];
                      final icon=forecast['weather'][0]['main'];

                      return ForecastItem(
                               value: temp.toString(),
                               label: DateFormat().add_jmv().format(time),
                               icon: icon == 'Clouds' || icon== 'Rain' ? Icons.cloud : Icons.sunny,
                      );
                    }
                  ),
                ),

                const SizedBox(height: 20),
                const Text('Additional Information', style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                ),
                const SizedBox(height: 10),
               Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInformation(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value:  humidity.toString(),
                    ),
                    AdditionalInformation(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: wind.toString(),
                    ),
                    AdditionalInformation(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: pressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        ),
    );
  }
}