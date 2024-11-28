import 'package:flutter/material.dart';

class LightsControlPage extends StatefulWidget {
  @override
  _LightsControlPageState createState() => _LightsControlPageState();
}

class _LightsControlPageState extends State<LightsControlPage> {
  bool lightStatus = false; // Light status: true for on, false for off
  int brightnessLevel = 75; // Brightness level (0-100)
  String color = 'white'; // Light color

  // Simulated function to load data (can be adapted to read from file or database)
  void loadData(String filePath) {
    // Example simulated data - replace this with actual file reading logic
    setState(() {
      lightStatus = true; // Light is on
      brightnessLevel = 80; // Brightness level
      color = 'blue'; // Light color
    });
  }

  // Update functions
  void toggleLightStatus() {
    setState(() {
      lightStatus = !lightStatus;
    });
  }

  void updateBrightness(double value) {
    setState(() {
      brightnessLevel = value.toInt();
    });
  }

  void updateColor(String selectedColor) {
    setState(() {
      color = selectedColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bedroom - Lights'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Light Status
            GestureDetector(
              onTap: toggleLightStatus,
              child: Icon(
                Icons.lightbulb,
                size: 100,
                color: lightStatus ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),

            // Brightness Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Brightness',
                  style: TextStyle(fontSize: 16),
                ),
                Text('$brightnessLevel%'),
              ],
            ),
            Slider(
              value: brightnessLevel.toDouble(),
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: updateBrightness,
            ),

            // Color Picker
            const SizedBox(height: 20),
            const Text('Color'),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                children: [
                  _buildColorSwatch(Colors.red, 'red'),
                  _buildColorSwatch(Colors.orange, 'orange'),
                  _buildColorSwatch(Colors.yellow, 'yellow'),
                  _buildColorSwatch(Colors.green, 'green'),
                  _buildColorSwatch(Colors.blue, 'blue'),
                  _buildColorSwatch(Colors.purple, 'purple'),
                  _buildColorSwatch(Colors.pink, 'pink'),
                  _buildColorSwatch(Colors.white, 'white'),
                  _buildColorSwatch(Colors.grey, 'grey'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSwatch(Color swatchColor, String colorName) {
    return GestureDetector(
      onTap: () => updateColor(colorName),
      child: Container(
        decoration: BoxDecoration(
          color: swatchColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: color == colorName ? Colors.black : Colors.transparent,
            width: 3,
          ),
        ),
      ),
    );
  }
}
