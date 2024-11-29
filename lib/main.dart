import 'package:flutter/material.dart';
import 'Modules/HomeScreen/home_screen.dart';
import 'package:media_kit/media_kit.dart';

void main() {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures Flutter services are initialized.
  MediaKit.ensureInitialized(); // Initialize MediaKit globally.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Ease App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(), // Ensure HomeScreen is the starting point
    );
  }
}
