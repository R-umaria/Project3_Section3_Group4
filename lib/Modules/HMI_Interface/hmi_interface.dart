import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class HMIInterface extends StatelessWidget {
  final Map<String, dynamic> sensorData;

  const HMIInterface({Key? key, required this.sensorData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Home Monitoring')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildFanStatus(),
            const Divider(),
            _buildTemperatureGraph(),
            const Divider(),
            _buildGarageDoorAnimation(),
            const Divider(),
            _buildFridgeDoorAnimation(),
            const Divider(),
            _buildWaterFilterVisualization(),
            const Divider(),
            _buildLightsStatus(),
            const Divider(),
            const SizedBox(height: 20),
            _buildBlindsVisualization(),
            const Divider(),
            _buildEntertainmentSystem(),
            const Divider(),
            _buildSecurityCamera(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Fan Status Display
  Widget _buildFanStatus() {
    final String fanStatus = sensorData['fanStatus'] ?? 'Off';
    final Color fanColor = fanStatus == 'On' ? Colors.green : Colors.grey;

    return ListTile(
      leading: Icon(Icons.toys, color: fanColor),
      title: const Text('Fan Status'),
      subtitle: Text('Current Status: $fanStatus'),
    );
  }

  // Temperature Graph
  Widget _buildTemperatureGraph() {
    final List<double> tempData =
        List<double>.from(sensorData['temperatureTrend'] ?? [22.0]);

    final List<_ChartData> chartData = tempData
        .asMap()
        .entries
        .map((entry) => _ChartData(entry.key.toDouble(), entry.value))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Temperature Trend',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: SfCartesianChart(
            primaryXAxis: NumericAxis(
              title: AxisTitle(text: 'Time'),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: 'Temperature (°C)'),
            ),
            series: <LineSeries<_ChartData, double>>[
              LineSeries<_ChartData, double>(
                dataSource: chartData,
                xValueMapper: (_ChartData data, _) => data.time,
                yValueMapper: (_ChartData data, _) => data.temperature,
                color: Colors.blue,
              )
            ],
          ),
        ),
      ],
    );
  }

  // Fridge Status and Alert
  Widget _buildFridgeStatus(BuildContext context) {
    final bool isFridgeOpen = sensorData['fridgeOpen'] ?? false;

    if (isFridgeOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Fridge Alert'),
            content: const Text('The fridge door is open! Please close it.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }

    return ListTile(
      leading: Icon(
        isFridgeOpen ? Icons.kitchen_outlined : Icons.kitchen,
        color: isFridgeOpen ? Colors.red : Colors.blue,
      ),
      title: const Text('Fridge'),
      subtitle: Text('Status: ${isFridgeOpen ? "Open" : "Closed"}'),
    );
  }

  // Lights Visualization
  Widget _buildLightsStatus() {
    final double brightness = sensorData['lightsBrightness'] ?? 50.0;
    final Color color = sensorData['lightsColor'] ?? Colors.yellow;

    String getColorName(Color color) {
      if (color == Colors.red) return "Red";
      if (color == Colors.green) return "Green";
      if (color == Colors.blue) return "Blue";
      if (color == Colors.yellow) return "Yellow";
      if (color == Colors.white) return "White";
      if (color == Colors.orange) return "Orange";
      return "Custom Color";
    }

    return ListTile(
      leading:
          Icon(Icons.lightbulb, color: color.withOpacity(brightness / 100)),
      title: const Text('Lights'),
      subtitle: Text(
          'Brightness: ${brightness.toStringAsFixed(0)}%, Color: ${getColorName(color)}'),
    );
  }

  // Garage Door Animation
  Widget _buildGarageDoorAnimation() {
    final bool isGarageOpen = sensorData['garageDoorOpen'] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Garage Door',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10),
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          height: 200,
          width: 100,
          color: isGarageOpen ? Colors.green : Colors.red,
          child: Center(
            child: Text(
              isGarageOpen ? 'Open' : 'Closed',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

// Fridge Door Animation
  Widget _buildFridgeDoorAnimation() {
    final bool isFridgeOpen = sensorData['fridgeOpen'] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Fridge Door',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10),
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          height: 100,
          width: isFridgeOpen ? 150 : 100,
          color: isFridgeOpen ? Colors.blue : Colors.grey,
          child: Center(
            child: Text(
              isFridgeOpen ? 'Open' : 'Closed',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

// Blinds Visualization
  Widget _buildBlindsVisualization() {
    final double blindsPosition = sensorData['blindsPosition'] ?? 50.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Blinds',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200, // Fixed height for the blinds visualization
          width: double.infinity,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Background layer
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey.shade300,
              ),
              // Foreground layer (blinds filling from bottom)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: (blindsPosition / 100) * 200, // Proportional height
                  width: double.infinity,
                  color: Colors.brown.shade700,
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Text(
            '${blindsPosition.toStringAsFixed(0)}% Open',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  // Water Filter Visualization
  Widget _buildWaterFilterVisualization() {
    final double waterFilterPercentage =
        sensorData['waterFilterPercentage'] ?? 100.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Water Filter Status',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Stack(
          children: [
            Container(
              width: 50,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: 50,
                height: waterFilterPercentage,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        Center(
          child: Text(
            '${waterFilterPercentage.toStringAsFixed(0)}% Remaining',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  // Entertainment System
  Widget _buildEntertainmentSystem() {
    final bool isTvOn = sensorData['tvOn'] ?? false;
    final String channel = sensorData['tvChannel'] ?? "No Channel Selected";

    return ListTile(
      leading: Icon(
        isTvOn ? Icons.tv : Icons.tv_off,
        color: isTvOn ? Colors.green : Colors.red,
      ),
      title: const Text('Entertainment System'),
      subtitle: Text(isTvOn ? 'TV On - Channel: $channel' : 'TV Off'),
    );
  }

  // Security Cameras
  Widget _buildSecurityCamera(BuildContext context,
      {Widget? cameraFeedScreen}) {
    final bool hasLiveFeed = sensorData['cameraLiveFeed'] ?? false;

    return ListTile(
      leading: const Icon(Icons.security),
      title: const Text('Security Cameras'),
      subtitle: Text(hasLiveFeed ? 'Live Feed Available' : 'No Live Feed'),
      onTap: () {
        if (hasLiveFeed) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => cameraFeedScreen ?? const Placeholder(),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Camera Error'),
              content: const Text('No live feed available at the moment.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

// Helper class for chart data
class _ChartData {
  final double time;
  final double temperature;

  _ChartData(this.time, this.temperature);
}

// Camera Feed Screen
class CameraFeedScreen extends StatefulWidget {
  const CameraFeedScreen({Key? key}) : super(key: key);

  @override
  _CameraFeedScreenState createState() => _CameraFeedScreenState();
}

class _CameraFeedScreenState extends State<CameraFeedScreen> {
  late final Player player;
  late final VideoController controller;
  bool hasError = false; // Track if there's an error with the video feed.

  @override
  void initState() {
    super.initState();
    player = Player();
    controller = VideoController(player);

    try {
      player.open(
        Media('assets/sample_video.mp4'), // Replace with your video path.
      );
    } catch (e) {
      setState(() {
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Feed'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: hasError
            ? const Text(
                'Error: Unable to load video feed',
                style: TextStyle(fontSize: 18, color: Colors.red),
              )
            : Video(
                controller: controller,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
              ),
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
