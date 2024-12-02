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
    return Row(
      children: [
        SizedBox(
          width: 600,
          child: Slider(
            value: brightness,
            min: 0.0,
            max: 100.0,
            divisions: 100,
            activeColor: const Color.fromRGBO(78, 205, 196, 1),
            inactiveColor: const Color.fromARGB(126, 155, 203, 200),
            label: '${brightness.toInt()}%',
            onChanged: (newBrightness) {
              onBrightnessChange?.call(newBrightness);
            },
          ),
        ),
        DropdownButton<Color>(
          value: color,
          items: const [
            DropdownMenuItem(value: Colors.red, child: Text('Red', style: TextStyle(color: Color.fromRGBO(247, 255, 247, 1)),)),
            DropdownMenuItem(value: Colors.green, child: Text('Green', style: TextStyle(color: Color.fromRGBO(247, 255, 247, 1)),)),
            DropdownMenuItem(value: Colors.blue, child: Text('Blue', style: TextStyle(color: Color.fromRGBO(247, 255, 247, 1)),)),
            DropdownMenuItem(value: Colors.yellow, child: Text('Yellow', style: TextStyle(color: Color.fromRGBO(247, 255, 247, 1)),)),
            DropdownMenuItem(value: Colors.white, child: Text('White', style: TextStyle(color: Color.fromRGBO(247, 255, 247, 1)),)),
            DropdownMenuItem(value: Colors.orange, child: Text('Orange', style: TextStyle(color: Color.fromRGBO(247, 255, 247, 1)),)),
          ],
          onChanged: (newColor) {
            onColorChange?.call(newColor!);
          },
        ),
      ],
    );
  }
}
