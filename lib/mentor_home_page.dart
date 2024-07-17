import 'package:flutter/material.dart';

void main() {
  runApp(const MentorHomePageApp());
}

class MentorHomePageApp extends StatelessWidget {
  const MentorHomePageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MentorHomePage(),
    );
  }
}

class MentorHomePage extends StatefulWidget {
  const MentorHomePage({super.key});

  @override
  MentorHomePageState createState() => MentorHomePageState();
}

class MentorHomePageState extends State<MentorHomePage> {
  bool isFirstTabSelected = true;
  String dropdownValue = 'Option 1';

  final List<String> dropdownOptions = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];
  final List<String> tiles = List.generate(30, (index) => 'Tile ${index + 1}');

  void _onTileTap(String tile) {
    if (isFirstTabSelected) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Tab1Page(tile: tile)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Tab2Page(tile: tile)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentor Homepage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Handle settings action
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Handle settings action
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Handle logout action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFirstTabSelected = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isFirstTabSelected ? Colors.blue[800] : Colors.blue[300],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                      alignment: Alignment.center,
                      child: const Text(
                        'Tab 1',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFirstTabSelected = false;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isFirstTabSelected ? Colors.blue[300] : Colors.blue[800],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                      alignment: Alignment.center,
                      child: const Text(
                        'Tab 2',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              value: dropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: dropdownOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: tiles.map((tile) {
                  return GestureDetector(
                    onTap: () => _onTileTap(tile),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        border: Border.all(color: Colors.blue[800]!),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tile,
                            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Details',
                            style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Tab1Page extends StatelessWidget {
  final String tile;

  const Tab1Page({super.key, required this.tile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tab 1 Page'),
      ),
      body: Center(
        child: Text('This is $tile from Tab 1'),
      ),
    );
  }
}

class Tab2Page extends StatelessWidget {
  final String tile;

  const Tab2Page({super.key, required this.tile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tab 2 Page'),
      ),
      body: Center(
        child: Text('This is $tile from Tab 2'),
      ),
    );
  }
}
