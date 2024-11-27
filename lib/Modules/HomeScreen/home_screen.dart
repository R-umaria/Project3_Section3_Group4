import 'package:flutter/material.dart';
import '../Rooms/rooms.dart';
import '../HMI_Interface/hmi_interface.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Room> _rooms = []; // List to store added rooms

  void _addRoom() {
    // Navigate to the room creation screen (provided by the Rooms module)
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _roomNameController =
            TextEditingController();
        return AlertDialog(
          title: const Text('Add Room'),
          content: TextField(
            controller: _roomNameController,
            decoration: const InputDecoration(hintText: 'Room Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _rooms.add(Room(name: _roomNameController.text, devices: []));
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Home Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Security Options'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.camera),
                          title: const Text('Cameras'),
                          onTap: () {
                            Navigator.pop(context); // Close dialog
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CameraFeedScreen()),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.lock),
                          title: const Text('Locks'),
                          onTap: () {
                            // Navigate to locks screen (to be implemented)
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.security),
              label: const Text('Security'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate the maximum size for tiles
                  final int columns = (constraints.maxWidth ~/ 150)
                      .clamp(1, 5); // Max 5 columns
                  final double tileWidth =
                      constraints.maxWidth / columns - 16; // Adjust for padding
                  final double tileHeight = tileWidth; // Keep tiles square

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: tileWidth / tileHeight,
                    ),
                    itemCount: _rooms.length + 1, // Add one for "Add Room" tile
                    itemBuilder: (context, index) {
                      if (index == _rooms.length) {
                        // "Add Room" Tile
                        return GestureDetector(
                          onTap: _addRoom,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green, width: 2),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.green,
                                size: 36,
                              ),
                            ),
                          ),
                        );
                      }

                      // Room Tiles
                      final room = _rooms[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoomsPage(room: room),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              room.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
