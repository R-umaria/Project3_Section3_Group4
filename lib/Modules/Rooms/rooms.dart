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
    // Check screen size for responsiveness
    bool isMobile = MediaQuery.of(context).size.width < 600;

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
                  hintStyle: TextStyle(
                    color: Colors.white54, 
                  ),
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
          children: [
            // Room Info Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color.fromRGBO(41, 47, 54, 1), // Background color
                borderRadius: BorderRadius.circular(12),
              ),
              child: Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Room Temperature and Humidity Card
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(30),
                      margin: EdgeInsets.only(bottom: isMobile ? 16 : 0, right: isMobile ? 0 : 16),
                      decoration: BoxDecoration(
                        color: Color(0xFF393D47), // Slightly darker card background
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Room',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Temperature: ${widget.room.temperature.toStringAsFixed(1)} °C',
                            style: TextStyle(
                              color: const Color.fromRGBO(156, 146, 163, 0.702),
                              fontSize: 25,
                              ),
                          ),
                          Text(
                            'Humidity: ${widget.room.humidity.toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: const Color.fromRGBO(156, 146, 163, 0.702),
                              fontSize: 25,
                              ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Devices Card
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF393D47),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Devices:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Column(
                            children: widget.room.devices.map((device) {
                              return Container(
                                width: 600,
                                margin: EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xFF4ECDC4), // Devices button color
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  leading: Icon(Icons.kitchen_outlined, color: Color.fromRGBO(245, 255, 245, 1),),
                                  title: Text(
                                    device,
                                    style: TextStyle(
                                      color: Colors.white, 
                                      fontSize: 20,
                                    ),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Add Device Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(156, 146, 163, 1), // Add Device button color
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
                        title: Text('Add Device',),
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
                child: Text(
                  'Add Device', 
                  style: TextStyle(
                    color: Color.fromRGBO(247, 255, 247, 1), 
                    fontSize: 20
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
