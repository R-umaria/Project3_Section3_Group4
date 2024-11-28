import 'dart:async';
import 'package:flutter/material.dart';
import 'Modules/hmi_interface/hmi_interface.dart';
import 'Modules/Rooms/rooms.dart';
import 'Modules/Lights/lights.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/rooms',
    routes: {
      '/rooms': (context) => RoomsPage(
            room: Room(
              name: "Bedroom",
              temperature: 20.0,
              humidity: 16.0,
              devices: ["Light", "Fan", "Blinds"],
            ),
          ),
      '/lights': (context) => const LightsPage(), // Define the LightsPage route
    },
  ));
}
