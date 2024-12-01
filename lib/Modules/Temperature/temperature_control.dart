import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TemperatureControl extends StatefulWidget {
  final double initialTemperature;
  final Function(double) onTemperatureChange;

  const TemperatureControl({
    Key? key,
    required this.initialTemperature,
    required this.onTemperatureChange,
  }) : super(key: key);

  @override
  _TemperatureControlState createState() => _TemperatureControlState();
}

class _TemperatureControlState extends State<TemperatureControl> {
  late double _currentTemperature;
  late double _desiredTemperature;
  String _fanStatus = "Off"; // Default fan status
  Timer? _adjustTimer;

  @override
  void initState() {
    super.initState();
    _currentTemperature = widget.initialTemperature;
    _desiredTemperature = widget.initialTemperature;
    _log('Initializing TemperatureControl widget');
    _loadSavedPreferences();
  }

  @override
  void dispose() {
    _log('Disposing TemperatureControl widget');
    _adjustTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadSavedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentTemperature =
          prefs.getDouble('currentTemperature') ?? _currentTemperature;
      _desiredTemperature =
          prefs.getDouble('desiredTemperature') ?? _desiredTemperature;
      _fanStatus = prefs.getString('fanStatus') ?? "Off";
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('currentTemperature', _currentTemperature);
    await prefs.setDouble('desiredTemperature', _desiredTemperature);
    await prefs.setString('fanStatus', _fanStatus);
  }

  void _startAdjustment() {
    _adjustTimer?.cancel();
    if (_fanStatus == "Auto" || _fanStatus == "On") {
      _adjustTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_currentTemperature > _desiredTemperature) {
            _currentTemperature -= 0.5;
            if (_currentTemperature <= _desiredTemperature) {
              _currentTemperature = _desiredTemperature;
              timer.cancel();
            }
          } else if (_currentTemperature < _desiredTemperature) {
            _currentTemperature += 0.5;
            if (_currentTemperature >= _desiredTemperature) {
              _currentTemperature = _desiredTemperature;
              timer.cancel();
            }
          }
        });
        widget.onTemperatureChange(_currentTemperature);
        _savePreferences();
      });
    }
  }

  void _setDesiredTemperature(double value) {
    setState(() {
      _desiredTemperature = value;
      _savePreferences();
      if (_fanStatus == "Auto" || _fanStatus == "On") {
        _startAdjustment();
      }
    });
  }

  void _toggleFanStatus(String newStatus) {
    setState(() {
      _fanStatus = newStatus;
      _savePreferences();
      if (newStatus == "Auto" || newStatus == "On") {
        _startAdjustment();
      } else {
        _adjustTimer?.cancel();
      }
    });
  }

  void _log(String message) {
    debugPrint('[TemperatureControl] $message');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(41, 47, 54, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Fan Status:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              DropdownButton<String>(
                dropdownColor: const Color(0xFF2D2F36),
                value: _fanStatus,
                items: ['Off', 'On', 'Auto']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(
                            status,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ))
                    .toList(),
                onChanged: (String? newStatus) {
                  _toggleFanStatus(newStatus!);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Current Temperature: ${_currentTemperature.toStringAsFixed(1)}°C',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Desired Temperature:',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          Slider(
            value: _desiredTemperature,
            min: 15.0,
            max: 30.0,
            divisions: 30,
            activeColor: Colors.blueAccent,
            inactiveColor: Colors.blue[100],
            label: '${_desiredTemperature.toStringAsFixed(1)}°C',
            onChanged: (value) {
              _setDesiredTemperature(value);
            },
          ),
        ],
      ),
    );
  }
}
