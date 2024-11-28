import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Fridge extends StatefulWidget {
  const Fridge({super.key});

  @override
  _FridgeState createState() => _FridgeState();
}

class _FridgeState extends State<Fridge> {
  bool _isOpen = false; // Default state is "Closed"
  double _temperature = 35.0; // Default temperature
  String?
      _warningMessage; // Warning message for invalid temperature or filter replacement

  @override
  void initState() {
    super.initState();
    _loadFridgeState();
  }

  Future<void> _loadFridgeState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isOpen = prefs.getBool('fridge_open') ?? false;
      _temperature = prefs.getDouble('fridge_temperature') ?? 35.0;
      _checkTemperatureWarnings();
    });
  }

  Future<void> _saveFridgeState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('fridge_open', _isOpen);
    await prefs.setDouble('fridge_temperature', _temperature);
  }

  void _toggleDoor() {
    setState(() {
      _isOpen = !_isOpen;
    });
    _saveFridgeState();
  }

  void _increaseTemperature() {
    setState(() {
      _temperature += 0.5;
      _checkTemperatureWarnings();
    });
    _saveFridgeState();
  }

  void _decreaseTemperature() {
    setState(() {
      _temperature -= 0.5;
      _checkTemperatureWarnings();
    });
    _saveFridgeState();
  }

  void _checkTemperatureWarnings() {
    if (_temperature < 25.0) {
      _warningMessage = "Invalid Temperature";
    } else if (_temperature > 45.0) {
      _warningMessage = "Replace Water Filter";
    } else {
      _warningMessage = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fridge Control'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Fridge is ${_isOpen ? "Open" : "Closed"}',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _toggleDoor,
            child: Text(_isOpen ? 'Close Fridge' : 'Open Fridge'),
          ),
          const SizedBox(height: 40),
          Text(
            'Current Temperature: ${_temperature.toStringAsFixed(1)}°F',
            style: const TextStyle(fontSize: 24),
          ),
          if (_warningMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _warningMessage!,
                style: TextStyle(
                  fontSize: 18,
                  color: _warningMessage == "Invalid Temperature"
                      ? Colors.orange
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _decreaseTemperature,
                child: const Text('-0.5'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _increaseTemperature,
                child: const Text('+0.5'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
