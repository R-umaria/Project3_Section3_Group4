import 'package:flutter/material.dart';

class Room {
  String name;
  double temperature;
  double humidity;
  List<String> devices;

  Room({
    required this.name,
    this.temperature = 20.0,
    this.humidity = 50.0,
    required this.devices,
  });

  void updateTemperature(double newTemperature) {
    temperature = newTemperature;
  }

  void updateHumidity(double newHumidity) {
    humidity = newHumidity;
  }

  void addDevice(String device) {
    if (!devices.contains(device)) {
      devices.add(device);
    }
  }

  void removeDevice(String device) {
    devices.remove(device);
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
    {"name": "Light", "icon": Icons.lightbulb_outline, "route": '/lights'},
    {"name": "Fan", "icon": Icons.ac_unit_outlined, "route": '/fan'},
    {"name": "Blinds", "icon": Icons.blinds_rounded, "route": '/blinds'},
    {"name": "TV", "icon": Icons.tv, "route": '/tv'},
    {"name": "Refrigerator", "icon": Icons.kitchen_outlined, "route": '/refrigerator'},
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2F36), // Dark background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.room.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(41, 47, 54, 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Room Temperature and Humidity Card
                Container(
                  padding: const EdgeInsets.all(16),
                  width: 1000,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF393D47),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Room',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Temperature: ${widget.room.temperature.toStringAsFixed(1)} °C',
                        style: const TextStyle(color: Color.fromRGBO(156, 146, 163, 0.7), fontSize: 18),
                      ),
                      Text(
                        'Humidity: ${widget.room.humidity.toStringAsFixed(1)}%',
                        style: const TextStyle(color: Color.fromRGBO(156, 146, 163, 0.7), fontSize: 18),
                      ),
                    ],
                  ),
                ),
                // Devices Card
                Container(
                  padding: const EdgeInsets.all(16),
                  width: 1000,
                  decoration: BoxDecoration(
                    color: const Color(0xFF393D47),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Devices',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: widget.room.devices.map((deviceName) {
                          final device = availableDevices.firstWhere(
                            (d) => d['name'] == deviceName,
                            orElse: () => {"icon": Icons.device_unknown, "route": null},
                          );
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: Icon(device['icon'], color: Colors.white),
                              title: Text(
                                deviceName,
                                style: const TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              onTap: () {
                                if (device['route'] != null) {
                                  Navigator.pushNamed(context, device['route']);
                                }
                              },
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    widget.room.devices.remove(deviceName);
                                  });
                                },
                              ),
                              tileColor: const Color(0xFF4ECDC4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Add Device Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C92A3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        String? selectedDevice;
                        return AlertDialog(
                          title: const Text('Add Device'),
                          content: DropdownButtonFormField<String>(
                            value: selectedDevice,
                            items: availableDevices.map((device) {
                              return DropdownMenuItem<String>(
                                value: device['name'],
                                child: Row(
                                  children: [
                                    Icon(device['icon'], color: Colors.black),
                                    const SizedBox(width: 8),
                                    Text(device['name']),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedDevice = value;
                              });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Select a Device',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                if (selectedDevice != null) {
                                  setState(() {
                                    widget.room.addDevice(selectedDevice!);
                                  });
                                }
                                Navigator.pop(context);
                              },
                              child: const Text('Add'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Add Device', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
