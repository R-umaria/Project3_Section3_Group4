import 'package:flutter/material.dart';

class Locks {
  bool _isLocked = false; // Default state is unlocked

  void lock() {
    _isLocked = true;
  }

  void unlock() {
    _isLocked = false;
  }

  bool getLockStatus() => _isLocked;
}

class LocksWidget extends StatefulWidget {
  final Locks locks;

  const LocksWidget({Key? key, required this.locks}) : super(key: key);

  @override
  _LocksWidgetState createState() => _LocksWidgetState();
}

class _LocksWidgetState extends State<LocksWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
            'Lock Status: ${widget.locks.getLockStatus() ? "Locked" : "Unlocked"}'),
        ElevatedButton(
          onPressed: () {
            setState(() {
              if (widget.locks.getLockStatus()) {
                widget.locks.unlock();
              } else {
                widget.locks.lock();
              }
            });
          },
          child: Text(widget.locks.getLockStatus() ? 'Unlock' : 'Lock'),
        ),
      ],
    );
  }
}
