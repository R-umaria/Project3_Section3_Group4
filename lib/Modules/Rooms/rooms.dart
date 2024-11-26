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
      appBar: AppBar(
        title: Text('Room Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _roomNameController,
                    decoration: InputDecoration(
                      labelText: 'Room Name',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (newName) {
                      setState(() {
                        widget.room.name = newName;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      widget.room.name = _roomNameController.text;
                    });
                  },
                  child: Text('Update'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Card(
              child: ListTile(
                title: Text('Temperature: ${widget.room.temperature.toStringAsFixed(1)} °C'),
                subtitle: Text('Humidity: ${widget.room.humidity.toStringAsFixed(1)} %'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Devices:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.room.devices.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.room.devices[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          widget.room.devices.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
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
          ],
        ),
      ),
    );
  }
}