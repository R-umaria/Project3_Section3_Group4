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
        Slider(
          value: position,
          min: 0.0,
          max: 100.0,
          divisions: 100,
          label: '${position.toInt()}%',
          onChanged: (newPosition) {
            onBlindsPositionChange?.call(newPosition);
          },
        ),
        Text('Blinds Position: ${position.toInt()}%'),
      ],
    );
  }
}
