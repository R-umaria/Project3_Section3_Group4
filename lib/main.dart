import 'dart:async';
import 'package:flutter/material.dart';
import 'Modules/hmi_interface/hmi_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> sensorData = {
    'fanStatus': 'On',
    'temperatureTrend': [22.0, 22.5, 23.0, 23.5, 24.0],
    'garageDoorOpen': false,
    'fridgeOpen': true,
    'lightsBrightness': 75.0,
    'lightsColor': Colors.blue,
    'blindsPosition': 75.0,
    'tvOn': true,
    'tvChannel': 'Netflix',
    'cameraLiveFeed': true,
  };

  late Timer _dataUpdateTimer;

  @override
  void initState() {
    super.initState();
    // Start periodic updates to simulate data changes
    _dataUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _simulateDataChanges();
    });
  }

  @override
  void dispose() {
    _dataUpdateTimer.cancel(); // Cancel the timer when the app is disposed
    super.dispose();
  }

  void _simulateDataChanges() {
    setState(() {
      // Simulate changes in the fan status
      sensorData['fanStatus'] =
          (sensorData['fanStatus'] == 'On') ? 'Off' : 'On';

      // Update the temperature trend with new random values
      List<double> currentTrend =
          List<double>.from(sensorData['temperatureTrend']);
      double lastTemperature = currentTrend.last;
      currentTrend.add(lastTemperature + (lastTemperature < 26.0 ? 0.5 : -0.5));
      if (currentTrend.length > 10) {
        currentTrend.removeAt(0); // Keep the list length manageable
      }
      sensorData['temperatureTrend'] = currentTrend;

      // Simulate garage door opening/closing
      sensorData['garageDoorOpen'] = !(sensorData['garageDoorOpen'] as bool);

      // Simulate fridge door opening/closing
      sensorData['fridgeOpen'] = !(sensorData['fridgeOpen'] as bool);

      // Simulate blinds position changes
      double blindsPosition = sensorData['blindsPosition'] as double;
      sensorData['blindsPosition'] =
          (blindsPosition < 100.0) ? blindsPosition + 5.0 : 0.0;

      // Simulate lights brightness and color changes
      sensorData['lightsBrightness'] =
          (sensorData['lightsBrightness'] as double == 100.0) ? 50.0 : 100.0;
      sensorData['lightsColor'] =
          (sensorData['lightsColor'] == Colors.blue) ? Colors.red : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HMIInterface(sensorData: sensorData),
    );
  }
}
