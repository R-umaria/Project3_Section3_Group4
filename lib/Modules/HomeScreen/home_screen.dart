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
          backgroundColor: const Color.fromARGB(255, 47, 47, 47),
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
          backgroundColor: const Color.fromRGBO(47, 47 , 47, 1),
          title: const Text(
            'Security Options',
            style: TextStyle(color: Color.fromRGBO(247, 255, 247, 1)),
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
      backgroundColor: const Color.fromRGBO(247, 255, 247, 1), // Match RoomsPage background - Mint
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'HomeEase',
          style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Color.fromRGBO(41, 41, 41, 1)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: _showSecurityOptions,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 47, 47, 47),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, color: Color.fromRGBO(255, 255, 255, 1)),
              ),
              icon: const Icon(Icons.lock, color: Colors.white),
              label: const Text(
                'Security',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),


          const SizedBox(height: 16), // Add spacing
             // Rooms Title
          const Padding(
            padding: EdgeInsets.only(left: 8.0), // Add slight padding for alignment
            child: Text(
              'Rooms',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(41, 41, 41, 1),
              ),
            ),
          ),
          // Rooms Grid
            Expanded(
  child: Center(
    child: SizedBox(
      width: 1000,
       // Set a max width for the grid
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Keep 2 columns
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 5, // Adjust as necessary
        ),
        itemCount: _rooms.length + 1,
        itemBuilder: (context, index) {
          if (index == _rooms.length) {
            return GestureDetector(
              key: const Key('addRoomTile'),
              onTap: _addRoom,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(78, 205, 196, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Color.fromRGBO(247, 255, 247, 1),
                    size: 28,
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
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(41, 47, 54, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.meeting_room,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    room.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
