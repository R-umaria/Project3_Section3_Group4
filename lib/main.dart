import 'package:flutter/material.dart';
import 'Modules/Temperature/temperature_control.dart';
import 'Modules/Garage/garage_door.dart';
import 'Modules/Fridge/fridge.dart';

void main() {
  runApp(HomeEaseApp());
}

class HomeEaseApp extends StatelessWidget {
  const HomeEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomeEase App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TemperatureControl()),
                );
              },
              child: const Text('Temperature Control'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GarageDoor()),
                );
              },
              child: const Text('Garage Door'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Fridge()),
                );
              },
              child: const Text('Fridge'),
            ),
          ],
        ),
      ),
    );
  }
}
