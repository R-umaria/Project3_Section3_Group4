import 'package:flutter/material.dart';

class Fridge extends StatefulWidget {
  const Fridge({super.key});

  @override
  _FridgeState createState() => _FridgeState();
}

class _FridgeState extends State<Fridge> {
  bool _isOpen = false; // Default state is "Closed"
  double _temperature = 35.0; // Default temperature

  void _toggleDoor() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  void _increaseTemperature() {
    setState(() {
      _temperature += 0.5;
    });
  }

  void _decreaseTemperature() {
    setState(() {
      if (_temperature > 0.5) {
        _temperature -= 0.5;
      }
    });
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
          if (_temperature > 45.0) // Display warning if temperature exceeds 45
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Replace Water Filter',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
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
