import 'package:flutter/material.dart';
import 'entertainment_system.dart';
import 'locks.dart';
import 'blinds.dart';

void main() {
  runApp(HomeEaseApp());
}

class HomeEaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomeEase',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Instances of the classes
  final EntertainmentSystem entertainmentSystem = EntertainmentSystem();
  final Locks locks = Locks();
  final Blinds blinds = Blinds();

  bool isFrontDoorLocked = false; // Front door lock state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HomeEase')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lock and Unlock Button
            Text(
              'Front Door: ${isFrontDoorLocked ? "Locked" : "Unlocked"}',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (isFrontDoorLocked) {
                    locks.unlock();
                  } else {
                    locks.lock();
                  }
                  isFrontDoorLocked = locks.getLockStatus();
                });
              },
              child: Text(
                isFrontDoorLocked ? 'Unlock Door' : 'Lock Door',
              ),
            ),
            SizedBox(height: 20),
            // Blinds Position Slider
            Text(
              'Blinds Position: ${blinds.getBlindPosition()}%',
              style: TextStyle(fontSize: 20),
            ),
            Slider(
              value: blinds.getBlindPosition().toDouble(),
              min: 0,
              max: 100,
              divisions: 10,
              label: '${blinds.getBlindPosition()}%',
              onChanged: (newValue) {
                setState(() {
                  blinds.setBlindPosition(newValue.toInt());
                });
              },
            ),
            SizedBox(height: 20),
            // Entertainment System Section
            Text(
              'Entertainment System',
              style: TextStyle(fontSize: 24),
            ),
            // Channel Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      entertainmentSystem.setChannel(
                          (entertainmentSystem.getChannel() - 1).clamp(0, 100));
                    });
                  },
                  child: Text('Previous Channel'),
                ),
                SizedBox(width: 10),
                Text(
                  'Channel: ${entertainmentSystem.getChannel()}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      entertainmentSystem.setChannel(entertainmentSystem.getChannel() + 1);
                    });
                  },
                  child: Text('Next Channel'),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Volume Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      entertainmentSystem.setVolume(
                          (entertainmentSystem.getVolume() - 1).clamp(0, 100));
                    });
                  },
                  child: Text('Decrease Volume'),
                ),
                SizedBox(width: 10),
                Text(
                  'Volume: ${entertainmentSystem.getVolume()}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      entertainmentSystem.setVolume(entertainmentSystem.getVolume() + 1);
                    });
                  },
                  child: Text('Increase Volume'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
