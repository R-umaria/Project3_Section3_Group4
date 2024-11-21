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
            _buildFridgeStatus(context),
            const Divider(),
            _buildLightsStatus(),
            const Divider(),
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

  // Garage Door Animation
  Widget _buildGarageDoorAnimation() {
    final bool isGarageOpen = sensorData['garageDoorOpen'] ?? false;

    return ListTile(
      leading: Icon(
        isGarageOpen ? Icons.garage_outlined : Icons.garage_rounded,
        color: isGarageOpen ? Colors.green : Colors.red,
      ),
      title: const Text('Garage Door'),
      subtitle: Text('Status: ${isGarageOpen ? "Open" : "Closed"}'),
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

  // Blinds Visualization
  Widget _buildBlindsVisualization() {
    final double blindsPosition = sensorData['blindsPosition'] ?? 50.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Blinds',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10),
        Stack(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
            Positioned(
              top: 100 - blindsPosition,
              child: Container(
                height: blindsPosition,
                width: double.infinity,
                color: Colors.brown.shade700,
              ),
            ),
          ],
        ),
        Center(child: Text('${blindsPosition.toStringAsFixed(0)}% Open')),
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
  Widget _buildSecurityCamera(BuildContext context) {
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
              builder: (context) => CameraFeedScreen(),
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
  @override
  _CameraFeedScreenState createState() => _CameraFeedScreenState();
}

class _CameraFeedScreenState extends State<CameraFeedScreen> {
  late final Player player;
  late final VideoController controller;

  @override
  void initState() {
    super.initState();
    player = Player();
    controller = VideoController(player);
    player.open(Media('simulated_feed.mp4'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera Feed')),
      body: Center(
        child: Video(
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
