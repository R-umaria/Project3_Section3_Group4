import 'package:flutter/material.dart';

class GarageDoorWidget extends StatelessWidget {
  final bool isOpen;
  final ValueChanged<bool>? onDoorToggle;

  const GarageDoorWidget({
    Key? key,
    required this.isOpen,
    this.onDoorToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Garage Door is ${isOpen ? "Open" : "Closed"}'),
        ElevatedButton(
          onPressed: () {
            onDoorToggle?.call(!isOpen);
          },
          child: Text(isOpen ? 'Close Door' : 'Open Door'),
        ),
      ],
    );
  }
}
