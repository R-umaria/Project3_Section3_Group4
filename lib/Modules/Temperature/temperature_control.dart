import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TemperatureControl extends StatefulWidget {
  const TemperatureControl({super.key});

  @override
  _TemperatureControlState createState() => _TemperatureControlState();
}

class _TemperatureControlState extends State<TemperatureControl> {
  double _currentTemperature = 23.0; // Default current temperature
  double _desiredTemperature = 22.0; // Default desired temperature
  String _fanStatus = "Off"; // Default fan status
  Timer? _adjustTimer;

  @override
  void initState() {
    super.initState();
    _log('Initializing TemperatureControl widget');
    _loadSavedPreferences(); // Load saved preferences on startup
  }

  @override
  void dispose() {
    _log('Disposing TemperatureControl widget');
    _adjustTimer?.cancel(); // Clean up the timer
    super.dispose();
  }

  // Load saved preferences
  Future<void> _loadSavedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentTemperature = prefs.getDouble('currentTemperature') ?? 23.0;
      _desiredTemperature = prefs.getDouble('desiredTemperature') ?? 22.0;
      _fanStatus = prefs.getString('fanStatus') ?? "Off";
      _log('Loaded preferences: currentTemperature=$_currentTemperature, '
          'desiredTemperature=$_desiredTemperature, fanStatus=$_fanStatus');
    });
  }

  // Save preferences
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('currentTemperature', _currentTemperature);
    await prefs.setDouble('desiredTemperature', _desiredTemperature);
    await prefs.setString('fanStatus', _fanStatus);
    _log('Saved preferences: currentTemperature=$_currentTemperature, '
        'desiredTemperature=$_desiredTemperature, fanStatus=$_fanStatus');
  }

  void _startAdjustment() {
    _log('Starting temperature adjustment in $_fanStatus mode');
    _adjustTimer?.cancel(); // Stop any existing timer
    if (_fanStatus == "Auto" || _fanStatus == "On") {
      _adjustTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_currentTemperature > _desiredTemperature) {
            _currentTemperature -= 0.5;
            _log(
                'Adjusting temperature: currentTemperature=$_currentTemperature');
            if (_currentTemperature <= _desiredTemperature) {
              _currentTemperature = _desiredTemperature; // Snap to exact value
              _log('Temperature reached desired value: $_currentTemperature');
              timer.cancel(); // Stop the timer
            }
          } else if (_currentTemperature < _desiredTemperature) {
            _currentTemperature += 0.5;
            _log(
                'Adjusting temperature: currentTemperature=$_currentTemperature');
            if (_currentTemperature >= _desiredTemperature) {
              _currentTemperature = _desiredTemperature; // Snap to exact value
              _log('Temperature reached desired value: $_currentTemperature');
              timer.cancel(); // Stop the timer
            }
          }
        });
        _savePreferences(); // Save temperature adjustments
      });
    }
  }

  void _setDesiredTemperature(double value) {
    _log('Setting desired temperature: $value');
    setState(() {
      _desiredTemperature = value;
      _savePreferences(); // Save desired temperature
      if (_fanStatus == "Auto" || _fanStatus == "On") {
        _startAdjustment();
      }
    });
  }

  void _toggleFanStatus(String newStatus) {
    _log('Fan status changed to: $newStatus');
    setState(() {
      _fanStatus = newStatus;
      _savePreferences(); // Save fan status
      if (newStatus == "Auto" || newStatus == "On") {
        _startAdjustment();
      } else {
        _adjustTimer?.cancel(); // Stop adjustment for "Off"
      }
    });
  }

  void _log(String message) {
    // Custom log function to include class name
    debugPrint('[TemperatureControl] $message');
  }

  @override
  Widget build(BuildContext context) {
    _log('Building TemperatureControl widget');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Control'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 300, // Adjusted width for better spacing
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Fan Status Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Fan Status:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded:
                            true, // Ensure dropdown fits the available space
                        value: _fanStatus,
                        items: ['Off', 'On', 'Auto']
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(
                                    status,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ))
                            .toList(),
                        onChanged: (String? newStatus) {
                          _toggleFanStatus(newStatus!);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Current Temperature Display
                Text(
                  'Current Temperature:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '${_currentTemperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),

                // Desired Temperature Display
                Text(
                  'Desired Temperature:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                Slider(
                  value: _desiredTemperature,
                  min: 15.0, // Updated range
                  max: 30.0, // Updated range
                  divisions: 30,
                  activeColor: Colors.blueAccent,
                  inactiveColor: Colors.blue[100],
                  label: '${_desiredTemperature.toStringAsFixed(1)}°C',
                  onChanged: (value) {
                    _setDesiredTemperature(value);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }
}
