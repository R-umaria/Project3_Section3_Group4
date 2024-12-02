import 'package:flutter/material.dart';

class BlindsWidget extends StatelessWidget {
  final double position;
  final ValueChanged<double>? onBlindsPositionChange;

  const BlindsWidget({
    Key? key,
    required this.position,
    this.onBlindsPositionChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 100,
            maxWidth: 200,
          ),
        ),
        Container(
          width: 600,
          child: Slider(
            value: position,
            min: 0.0,
            max: 100.0,
            divisions: 100,
            activeColor: const Color.fromRGBO(78, 205, 196, 1),
            inactiveColor: const Color.fromARGB(126, 155, 203, 200),
            label: '${position.toInt()}%',
            onChanged: (newPosition) {
              onBlindsPositionChange?.call(newPosition);
            },
          ),
        ),
        Text('Blinds Position: ${position.toInt()}%', style: TextStyle(color: Color.fromRGBO(247, 255, 247, 1)),),
      ],
    );
  }
}
