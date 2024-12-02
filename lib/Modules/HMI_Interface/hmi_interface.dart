import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

// Temperature Graph Visualization
class TemperatureGraph extends StatelessWidget {
  final List<double> temperatureTrend;

  const TemperatureGraph({Key? key, required this.temperatureTrend})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<_ChartData> chartData = temperatureTrend
        .asMap()
        .entries
        .map((entry) => _ChartData(entry.key.toDouble(), entry.value))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Temperature Trend',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Chart Data Class for Temperature Graph
class _ChartData {
  final double time;
  final double temperature;

  _ChartData(this.time, this.temperature);
}

// Blinds Visualization
class BlindsVisualization extends StatelessWidget {
  final double blindsPosition;

  const BlindsVisualization({Key? key, required this.blindsPosition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Blinds',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(247, 255, 247, 1)),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          width: 1000,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.17,
                      0.34,
                      0.51,
                      0.68,
                      0.85,
                      0.99,
                    ],
                    colors: [
                    Color.fromRGBO(255, 242, 189, 1),
                    Color.fromRGBO(244, 215, 151, 1),
                    Color.fromRGBO(235, 181, 1381, 1),
                    Color.fromRGBO(218, 127, 125, 1),
                    Color.fromRGBO(181, 114, 142, 1),
                    Color.fromRGBO(119, 110, 153, 1),
                    ],
                  )
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 1000,
                  height: (blindsPosition / 100) * 200,
                  decoration: const BoxDecoration(
                    color:const Color.fromRGBO(59, 65, 73, 0.8),
                    border: Border(bottom: BorderSide(width: 3, color: Color.fromRGBO(47, 47, 47, 1)),),

                  )
                ),
                ),
              
            ],
          ),
        ),
        Center(
          child: Text(
            '${blindsPosition.toStringAsFixed(0)}% Shut',
            style: const TextStyle(fontSize: 16, color: Color.fromRGBO(247, 255, 247, 1) ),
          ),
        ),
      ],
    );
  }
}

// Entertainment System Visualization
class EntertainmentSystemVisualization extends StatelessWidget {
  final bool isTvOn;
  final int volume;
  final int channel;

  const EntertainmentSystemVisualization({
    Key? key,
    required this.isTvOn,
    required this.volume,
    required this.channel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        isTvOn ? Icons.tv : Icons.tv_off,
        color: isTvOn ? Colors.green : Colors.red,
      ),
      title: const Text('Entertainment System'),
      subtitle: Text(
          isTvOn ? 'TV On - Channel: $channel, Volume: $volume' : 'TV Off'),
    );
  }
}

// Fridge Visualization
class FridgeWidget extends StatelessWidget {
  final ValueNotifier<bool> isFridgeOpen;
  final ValueNotifier<double> temperature;

  const FridgeWidget({
    Key? key,
    required this.isFridgeOpen,
    required this.temperature,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Door Status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Fridge Door', style: TextStyle(fontSize: 18)),
            Switch(
              value: isFridgeOpen.value,
              onChanged: (value) {
                isFridgeOpen.value = value;
              },
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Temperature Display
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Temperature', style: TextStyle(fontSize: 18)),
            Slider(
              value: temperature.value,
              min: 25.0,
              max: 45.0,
              divisions: 20,
              label: '${temperature.value.toStringAsFixed(1)} °F',
              onChanged: (value) {
                temperature.value = value;
              },
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Water Filter Visualization
        _buildWaterFilter(temperature.value),
      ],
    );
  }

  Widget _buildWaterFilter(double currentTemperature) {
    String status;
    Color statusColor;

    if (currentTemperature < 30.0) {
      status = 'Replace Water Filter';
      statusColor = Colors.red;
    } else if (currentTemperature > 40.0) {
      status = 'Invalid Temperature';
      statusColor = Colors.orange;
    } else {
      status = 'Filter OK';
      statusColor = Colors.green;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Water Filter Status', style: TextStyle(fontSize: 18)),
        Text(
          status,
          style: TextStyle(fontSize: 16, color: statusColor),
        ),
      ],
    );
  }
}

// Garage Door Visualization
class GarageDoorVisualization extends StatelessWidget {
  final bool isGarageOpen;

  const GarageDoorVisualization({Key? key, required this.isGarageOpen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Garage Door',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            height: 100,
            width: 100,
            color: isGarageOpen ? Colors.green : Colors.red,
            child: Center(
              child: Text(
                isGarageOpen ? 'Open' : 'Closed',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Lights Visualization
class LightsWidget extends StatefulWidget {
  final ValueNotifier<Color> selectedColor;
  final ValueNotifier<double> brightness;

  const LightsWidget({
    Key? key,
    required this.selectedColor,
    required this.brightness,
  }) : super(key: key);

  @override
  _LightsWidgetState createState() => _LightsWidgetState();
}

class _LightsWidgetState extends State<LightsWidget> {
  final List<Color> availableColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.white,
    Colors.orange,
  ];

  String _getColorName(Color color) {
    if (color == Colors.red) return "Red";
    if (color == Colors.green) return "Green";
    if (color == Colors.blue) return "Blue";
    if (color == Colors.yellow) return "Yellow";
    if (color == Colors.white) return "White";
    if (color == Colors.orange) return "Orange";
    return "Custom Color";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brightness Slider
        Slider(
          value: widget.brightness.value,
          min: 0.0,
          max: 100.0,
          divisions: 10,
          label: '${widget.brightness.value.toStringAsFixed(0)}%',
          onChanged: (value) {
            setState(() {
              widget.brightness.value = value;
            });
          },
        ),
        const SizedBox(height: 16),

        // Color Dropdown
        DropdownButton<Color>(
          value: availableColors.contains(widget.selectedColor.value)
              ? widget.selectedColor.value
              : availableColors.first,
          items: availableColors
              .map((color) => DropdownMenuItem<Color>(
                    value: color,
                    child: Container(
                      width: 24,
                      height: 24,
                      color: color,
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                    ),
                  ))
              .toList(),
          onChanged: (Color? newColor) {
            if (newColor != null) {
              setState(() {
                widget.selectedColor.value = newColor;
              });
            }
          },
        ),
        Text(
          'Color: ${_getColorName(widget.selectedColor.value)}, Brightness: ${widget.brightness.value.toStringAsFixed(0)}%',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

// Locks Visualization
class LocksVisualization extends StatelessWidget {
  final bool isLocked;

  const LocksVisualization({Key? key, required this.isLocked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        isLocked ? Icons.lock : Icons.lock_open,
        color: isLocked ? Colors.red : Colors.green,
      ),
      title: const Text('Locks'),
      subtitle: Text(isLocked ? 'Locked' : 'Unlocked'),
    );
  }
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
    player.open(Media('assets/sample_video.mp4'));
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
