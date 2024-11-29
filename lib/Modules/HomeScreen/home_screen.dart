import 'package:flutter/material.dart';
import '../Rooms/rooms.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Room> _rooms = []; // List to store added rooms

  void _addRoom() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController roomNameController =
            TextEditingController();
        return AlertDialog(
          title: const Text('Add Room'),
          content: TextField(
            controller: roomNameController,
            decoration: const InputDecoration(hintText: 'Room Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _rooms.add(Room(name: roomNameController.text, devices: []));
                });
                Navigator.pop(context);
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
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: _rooms.length + 1,
              itemBuilder: (context, index) {
                if (index == _rooms.length) {
                  return GestureDetector(
                    onTap: _addRoom,
                    child: Container(
                      color: Colors.green[100],
                      child:
                          const Icon(Icons.add, size: 36, color: Colors.green),
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
                    color: Colors.blue[100],
                    child: Center(
                      child: Text(
                        room.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
