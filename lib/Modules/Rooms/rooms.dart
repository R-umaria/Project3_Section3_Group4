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
      backgroundColor: Color(0xFF2D2F36), // Dark background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _roomNameController,
                style: TextStyle(color: Colors.white, fontSize: 20),
                decoration: InputDecoration(
                  hintText: 'Bedroom',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                onSubmitted: (newName) {
                  setState(() {
                    widget.room.name = newName;
                  });
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                setState(() {
                  widget.room.name = _roomNameController.text;
                });
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF393D47),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Room Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Room',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Temperature: ${widget.room.temperature.toStringAsFixed(1)} °F',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'Humidity: ${widget.room.humidity.toStringAsFixed(1)}%',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  // Device List
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Devices:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        ...widget.room.devices.map((device) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(0xFF4E525E),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 8),
                              title: Text(
                                device,
                                style: TextStyle(color: Colors.white),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    widget.room.devices.remove(device);
                                  });
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6C63FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  // Add device dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      final TextEditingController _deviceController =
                          TextEditingController();
                      return AlertDialog(
                        title: Text('Add Device'),
                        content: TextField(
                          controller: _deviceController,
                          decoration: InputDecoration(hintText: 'Device Name'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                widget.room.addDevice(_deviceController.text);
                              });
                              Navigator.pop(context);
                            },
                            child: Text('Add'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Add Device'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
