import 'package:flutter/material.dart';

class LightsPage extends StatelessWidget {
  const LightsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lights'),
      ),
      body: Center(
        child: const Text(
          'Welcome to the Lights Page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
