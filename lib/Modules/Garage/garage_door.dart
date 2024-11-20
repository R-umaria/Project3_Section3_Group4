import 'package:flutter/material.dart';

class GarageDoor extends StatefulWidget {
  const GarageDoor({super.key});

  @override
  _GarageDoorState createState() => _GarageDoorState();
}

class _GarageDoorState extends State<GarageDoor> {
  bool _isOpen = false; // Default state is "Closed"

  void _toggleDoor() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garage Door Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centers content vertically
          crossAxisAlignment:
              CrossAxisAlignment.center, // Centers content horizontally
          children: [
            Text(
              'Garage Door is ${_isOpen ? "Open" : "Closed"}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(
                height: 20), // Add spacing between the text and button
            ElevatedButton(
              onPressed: _toggleDoor,
              child: Text(_isOpen ? 'Close Door' : 'Open Door'),
            ),
          ],
        ),
      ),
    );
  }
}
