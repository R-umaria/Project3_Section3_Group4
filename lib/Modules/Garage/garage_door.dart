import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GarageDoor extends StatefulWidget {
  const GarageDoor({super.key});

  @override
  _GarageDoorState createState() => _GarageDoorState();
}

class _GarageDoorState extends State<GarageDoor> {
  bool _isOpen = false; // Default state is "Closed"

  @override
  void initState() {
    super.initState();
    _loadGarageDoorState();
  }

  Future<void> _loadGarageDoorState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isOpen = prefs.getBool('garage_door_open') ?? false;
    });
  }

  Future<void> _saveGarageDoorState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('garage_door_open', _isOpen);
  }

  void _toggleDoor() {
    setState(() {
      _isOpen = !_isOpen;
    });
    _saveGarageDoorState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garage Door Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Garage Door is ${_isOpen ? "Open" : "Closed"}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
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
