import 'package:flutter/material.dart';

class TemperatureControl extends StatefulWidget {
  const TemperatureControl({super.key});

  @override
  _TemperatureControlState createState() => _TemperatureControlState();
}

class _TemperatureControlState extends State<TemperatureControl> {
  double _temperature = 22.0; // Default temperature
  String _fanStatus = "Off"; // Default fan status

  void _increaseTemperature() {
    setState(() {
      _temperature += 0.5;
    });
  }

  void _decreaseTemperature() {
    setState(() {
      _temperature -= 0.5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Control'),
      ),
      body: Center(
        child: Container(
          width: 250, // Square size: width
          height: 250, // Square size: height
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fan Status Title and Dropdown in a Row
              Row(
                children: [
                  const Text(
                    'Fan Status:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                      width: 8), // Add spacing between title and dropdown
                  DropdownButton<String>(
                    value: _fanStatus,
                    items: ['Off', 'On', 'Auto']
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (String? newStatus) {
                      setState(() {
                        _fanStatus = newStatus!;
                      });
                    },
                  ),
                ],
              ),
              const Spacer(), // Add space between Fan Status and Temperature
              // Temperature Display
              Center(
                child: Text(
                  '${_temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(), // Add space between Temperature and Buttons
              // Buttons for Temperature Adjustment
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _decreaseTemperature,
                    child: const Text('-'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _increaseTemperature,
                    child: const Text('+'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
