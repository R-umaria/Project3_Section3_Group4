import 'package:flutter/material.dart';
import 'Modules/hmi_interface/hmi_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example simulated data
    final Map<String, dynamic> simulatedData = {
      'fanStatus': 'On',
      'temperatureTrend': [22.0, 22.5, 23.0, 23.5, 24.0],
      'garageDoorOpen': false,
      'fridgeOpen': true,
    };

    return MaterialApp(
      title: 'Smart Home App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HMIInterface(sensorData: simulatedData),
    );
  }
}
