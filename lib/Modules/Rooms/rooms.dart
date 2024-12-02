import 'package:flutter/material.dart';
import '../Temperature/temperature_control.dart';
import '../Blinds/blinds.dart';
import '../Entertainment_System/entertainment_system.dart';
import '../Fridge/fridge.dart' as fridge_module;
import '../Garage/garage_door.dart';
import '../Lights/lights.dart' as lights_module;
import '../HMI_Interface/hmi_interface.dart';

class Room {
  String name;
  List<String> devices;
  ValueNotifier<bool> garageDoorOpen = ValueNotifier<bool>(false);
  ValueNotifier<double> blindsPosition = ValueNotifier<double>(50.0);
  ValueNotifier<bool> tvOn = ValueNotifier<bool>(false);
  ValueNotifier<int> tvChannel = ValueNotifier<int>(1);
  ValueNotifier<int> tvVolume = ValueNotifier<int>(50);
  ValueNotifier<Color> lightsColor = ValueNotifier<Color>(Colors.white);
  ValueNotifier<double> lightsBrightness = ValueNotifier<double>(50.0);
  ValueNotifier<bool> lightsOn = ValueNotifier<bool>(false);
  ValueNotifier<bool> fridgeDoorOpen = ValueNotifier<bool>(false);
  ValueNotifier<double> temperature = ValueNotifier<double>(30.0);
  ValueNotifier<Color> selectedColor = ValueNotifier(Colors.red);

  Room({
    required this.name,
    double initialTemperature = 20.0,
    required this.devices,
  }) {
    temperature.value = initialTemperature;
  }

  void addDevice(String device) {
    if (!devices.contains(device)) {
      devices.add(device);
    }
  }

  void removeDevice(String device) {
    devices.remove(device);
  }

  void updateGarageDoorStatus(bool isOpen) {
    garageDoorOpen.value = isOpen;
  }

  void updateTvPower(bool isOn) {
    tvOn.value = isOn;
  }

  void updateTvChannel(int channel) {
    tvChannel.value = channel;
  }

  void updateTvVolume(int volume) {
    tvVolume.value = volume;
  }

  void updateBlindsPosition(double position) {
    blindsPosition.value = position;
  }

  void updateFridgeDoorOpen(bool isOpen) {
    fridgeDoorOpen.value = isOpen;
  }

  void updateLightsBrightness(double newBrightness) {
    lightsBrightness.value = newBrightness;
  }

  void updateLightsColor(Color newColor) {
    lightsColor.value = newColor;
  }

  void toggleFridgeDoor() {
    fridgeDoorOpen.value = !fridgeDoorOpen.value;
  }

  void updateTemperature(double newTemperature) {
    temperature.value = newTemperature;
  }
}

class RoomsPage extends StatefulWidget {
  final Room room;

  const RoomsPage({Key? key, required this.room}) : super(key: key);

  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  late TextEditingController _roomNameController;

  final List<Map<String, dynamic>> availableDevices = [
    {"name": "Blinds", "icon": Icons.blinds_rounded},
    {"name": "Entertainment System", "icon": Icons.tv},
    {"name": "Temperature Control", "icon": Icons.thermostat_outlined},
    {"name": "Fridge", "icon": Icons.kitchen_outlined},
    {"name": "Garage Door", "icon": Icons.garage},
    {"name": "Lights", "icon": Icons.lightbulb_outline}, // Lights
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

  String? _activeControl;

  @override
  void initState() {
    super.initState();
    _roomNameController = TextEditingController(text: widget.room.name);
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  void _addDevice(String deviceName) {
    setState(() {
      widget.room.addDevice(deviceName);
    });
  }

  void _setActiveControl(String? control) {
    setState(() {
      _activeControl = control;
    });
  }

  Widget _buildActiveControl() {
    switch (_activeControl) {
      case "Temperature Control":
        return Column(
          children: [
            TemperatureControl(
              initialTemperature: widget.room.temperature.value,
              onTemperatureChange: widget.room.updateTemperature,
            ),
            ValueListenableBuilder<double>(
              valueListenable: widget.room.temperature,
              builder: (context, temperature, child) {
                return TemperatureGraph(temperatureTrend: [temperature]);
              },
            ),
          ],
        );
      case "Blinds":
        return Column(
          children: [
            ValueListenableBuilder<double>(
              valueListenable: widget.room.blindsPosition,
              builder: (context, position, child) {
                return BlindsWidget(
                  position: position,
                  onBlindsPositionChange: (newPosition) {
                    widget.room.updateBlindsPosition(newPosition);
                  },
                );
              },
            ),
            ValueListenableBuilder<double>(
              valueListenable: widget.room.blindsPosition,
              builder: (context, position, child) {
                return BlindsVisualization(blindsPosition: position);
              },
            ),
          ],
        );
      case "Entertainment System":
        return Column(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: widget.room.tvOn,
              builder: (context, isOn, child) {
                return EntertainmentSystemWidget(
                  isOn: widget.room.tvOn.value,
                  channel: widget.room.tvChannel.value,
                  volume: widget.room.tvVolume.value,
                  onPowerChange: (isOn) {
                    setState(() {
                      widget.room.updateTvPower(isOn);
                    });
                  },
                  onChannelChange: (channel) {
                    setState(() {
                      widget.room.updateTvChannel(channel);
                    });
                  },
                  onVolumeChange: (volume) {
                    setState(() {
                      widget.room.updateTvVolume(volume);
                    });
                  },
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: widget.room.tvOn,
              builder: (context, isOn, child) {
                return EntertainmentSystemVisualization(
                  isTvOn: isOn,
                  channel: widget.room.tvChannel.value,
                  volume: widget.room.tvVolume.value,
                );
              },
            ),
          ],
        );

      case "Lights":
        return Column(
          children: [
            ValueListenableBuilder<Color>(
              valueListenable: widget.room.lightsColor,
              builder: (context, color, child) {
                return ValueListenableBuilder<double>(
                  valueListenable: widget.room.lightsBrightness,
                  builder: (context, brightness, child) {
                    return lights_module.LightsWidget(
                      brightness: brightness,
                      color: color,
                      onBrightnessChange: (newBrightness) {
                        widget.room.updateLightsBrightness(newBrightness);
                      },
                      onColorChange: (newColor) {
                        widget.room.updateLightsColor(newColor);
                      },
                    );
                  },
                );
              },
            ),
            ValueListenableBuilder<double>(
              valueListenable: widget.room.lightsBrightness,
              builder: (context, brightness, child) {
                return ValueListenableBuilder<Color>(
                  valueListenable: widget.room.lightsColor,
                  builder: (context, color, child) {
                    return ListTile(
                      leading: Icon(
                        Icons.lightbulb,
                        color: color.withOpacity(brightness / 100),
                      ),
                      title: const Text('Lights Visualization',style: TextStyle(color:Color.fromRGBO(247, 255, 247, 1)),),
                      subtitle: Text(
                        'Brightness: ${brightness.toStringAsFixed(0)}%, Color: ${_getColorName(color)}',
                        style: const TextStyle(color:Color.fromRGBO(247, 255, 247, 1)),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        );

      case "Fridge":
        return Column(
          children: [
            // Fridge Control Widget
            const fridge_module.FridgeWidget(),

            // Fridge Visualization
            ValueListenableBuilder<bool>(
              valueListenable: widget.room.fridgeDoorOpen,
              builder: (context, isFridgeOpen, child) {
                return ValueListenableBuilder<double>(
                  valueListenable: widget.room.temperature,
                  builder: (context, temperature, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Door Status: ${isFridgeOpen ? "Open" : "Closed"}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Temperature: ${temperature.toStringAsFixed(1)}°F',
                          style: const TextStyle(fontSize: 18),
                        ),
                        if (temperature < 25.0)
                          const Text(
                            'Invalid Temperature',
                            style:
                                TextStyle(fontSize: 16, color: Colors.orange),
                          )
                        else if (temperature > 45.0)
                          const Text(
                            'Replace Water Filter',
                            style: TextStyle(fontSize: 16, color: Colors.red),
                          )
                        else
                          const Text(
                            'Filter OK',
                            style: TextStyle(fontSize: 16, color: Colors.green),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );

      case "Garage Door":
        return Column(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: widget.room.garageDoorOpen,
              builder: (context, isOpen, child) {
                return GarageDoorWidget(
                  isOpen: isOpen,
                  onDoorToggle: widget.room.updateGarageDoorStatus,
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: widget.room.garageDoorOpen,
              builder: (context, isOpen, child) {
                return GarageDoorVisualization(isGarageOpen: isOpen);
              },
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 255, 247, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromRGBO(59, 69, 73, 1), size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.room.name,
          style: const TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Color.fromRGBO(59, 69, 73, 1)),
        ),
      ),
      body: Center(
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Container(
      constraints: const BoxConstraints(
        minWidth: 300,
        minHeight: 300,
        maxWidth: 1000,
        maxHeight: 800,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(59, 69, 73, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          TextField(
            controller: _roomNameController,
            decoration: const InputDecoration(
              labelText: 'Room Name',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            style: const TextStyle(color: Colors.white),
            onSubmitted: (newName) {
              setState(() {
                widget.room.name = newName;
              });
            },
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView(
              children: [
                ...widget.room.devices.map((deviceName) {
                  // Find the matching device in the availableDevices list
                  final device = availableDevices.firstWhere(
                    (d) => d['name'] == deviceName,
                    orElse: () => {"name": deviceName, "icon": Icons.device_unknown}, // Default if not found
                  );

                  return Container(
                    width: 800,
                    margin: const EdgeInsets.symmetric(vertical: 3.0), // Optional for spacing
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(78, 205, 196, 1), // Background color of the ListTile
                      borderRadius: BorderRadius.circular(8.0), // Optional rounded corners
                    ),
                    child: ListTile(
                      title: Text(
                        deviceName,
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      leading: Icon(
                        device['icon'], // Use the icon from the matched device
                        color: const Color.fromRGBO(247, 255, 247, 1),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Color.fromRGBO(247, 255, 247, 1)),
                        onPressed: () {
                          setState(() {
                            widget.room.removeDevice(deviceName);
                          });
                        },
                      ),
                      onTap: () {
                        _setActiveControl(deviceName);
                      },
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center, // Center-align the button
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 40), // Explicitly set width and height
                      backgroundColor: const Color.fromRGBO(156, 146, 163, 1),
                      foregroundColor: const Color.fromRGBO(247, 255, 247, 1),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Add Device'),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: availableDevices.map((device) {
                                  return ListTile(
                                    title: Text(device['name']),
                                    leading: Icon(device['icon']),
                                    onTap: () {
                                      _addDevice(device['name']);
                                      Navigator.pop(context);
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Add Device'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildActiveControl(),
        ],
      ),
    ),
  ),
),

    );
  }
}
