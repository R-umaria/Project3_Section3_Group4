import 'package:flutter/material.dart';

class LightsWidget extends StatelessWidget {
  final double brightness;
  final Color color;
  final ValueChanged<double>? onBrightnessChange;
  final ValueChanged<Color>? onColorChange;

  const LightsWidget({
    Key? key,
    required this.brightness,
    required this.color,
    this.onBrightnessChange,
    this.onColorChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: brightness,
          min: 0.0,
          max: 100.0,
          divisions: 100,
          label: '${brightness.toInt()}%',
          onChanged: (newBrightness) {
            onBrightnessChange?.call(newBrightness);
          },
        ),
        DropdownButton<Color>(
          value: color,
          items: [
            DropdownMenuItem(value: Colors.red, child: const Text('Red')),
            DropdownMenuItem(value: Colors.green, child: const Text('Green')),
            DropdownMenuItem(value: Colors.blue, child: const Text('Blue')),
            DropdownMenuItem(value: Colors.yellow, child: const Text('Yellow')),
            DropdownMenuItem(value: Colors.white, child: const Text('White')),
            DropdownMenuItem(value: Colors.orange, child: const Text('Orange')),
          ],
          onChanged: (newColor) {
            onColorChange?.call(newColor!);
          },
        ),
      ],
    );
  }
}
