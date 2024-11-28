import 'dart:async';
import 'package:flutter/material.dart';
import 'Modules/hmi_interface/hmi_interface.dart';
import 'Modules/Temperature/temperature_control.dart';
import 'Modules/Rooms/rooms.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RoomsPage(
      room: Room(
        name: "Bedroom",
        temperature: 20.0,
        humidity: 16.0,
        devices: ["Light", "Fan", "Blinds"],
      ),
    ),
  ));
}
