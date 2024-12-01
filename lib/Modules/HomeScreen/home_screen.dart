import 'package:flutter/material.dart';
import '../Rooms/rooms.dart';
import '../HMI_Interface/hmi_interface.dart';
import '../Locks/locks.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Room> _rooms = [];

  void _addRoom() {
    // Navigate to the room creation screen (provided by the Rooms module)
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _roomNameController =
            TextEditingController();
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(41, 47, 54, 1),
          title: const Text(
            'Add Room',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: _roomNameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Room Name',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _rooms.add(Room(name: _roomNameController.text, devices: []));
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _showSecurityOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 202, 208, 214),
          title: const Text(
            'Security Options',
            style: TextStyle(color: Color.fromARGB(255, 28, 3, 34)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera, color: Colors.white),
                title: const Text('Cameras',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraFeedScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.white),
                title:
                    const Text('Locks', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop(); // Close dialog
                  showDialog(
                    context: context,
                    builder: (context) => _LocksDialog(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2F36), // Match RoomsPage background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Smart Home Dashboard',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: _showSecurityOptions,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(41, 47, 54, 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              icon: const Icon(Icons.security, color: Colors.white),
              label: const Text(
                'Security',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _rooms.length + 1,
                itemBuilder: (context, index) {
                  if (index == _rooms.length) {
                    return GestureDetector(
                      key: const Key('addRoomTile'),
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
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(41, 47, 54, 1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.meeting_room,
                              color: Colors.white, size: 36),
                          const SizedBox(height: 8),
                          Text(
                            room.name,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
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

class _LocksDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(41, 47, 54, 1),
      title: const Text(
        'Locks',
        style: TextStyle(color: Colors.white),
      ),
      content: LocksWidget(locks: Locks()),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}
