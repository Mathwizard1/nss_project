import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DisplayEventPage(),
    );
  }
}

class DisplayEventPage extends StatefulWidget {
  const DisplayEventPage({super.key});

  @override
  DisplayEventPageState createState() => DisplayEventPageState();
}

class DisplayEventPageState extends State<DisplayEventPage> {
  final String _selectedRole = "pic"; // Change this value to test different roles

  // List of wings for editing
  List<String> wingsList = [
    "Technology",
    "Science",
    "Arts",
    "Sports",
    "Community Service",
  ];

  Event event = Event(
    name: "Flutter Workshop",
    date: "2024-08-01",
    time: "10:00 AM",
    venue: "Room 101",
    longDescription: "A comprehensive workshop on Flutter development.",
    wing: "Technology",
    hours: 5,
  );

  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _venueController;
  late TextEditingController _descriptionController;
  late TextEditingController _hoursController;
  late String _selectedWing;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: event.name);
    _dateController = TextEditingController(text: event.date);
    _timeController = TextEditingController(text: event.time);
    _venueController = TextEditingController(text: event.venue);
    _descriptionController = TextEditingController(text: event.longDescription);
    _hoursController = TextEditingController(text: event.hours.toString());
    _selectedWing = event.wing;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _venueController.dispose();
    _descriptionController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    if (_isEditing) {
      if (_formKey.currentState!.validate()) {
        setState(() {
          event.name = _nameController.text;
          event.date = _dateController.text;
          event.time = _timeController.text;
          event.venue = _venueController.text;
          event.longDescription = _descriptionController.text;
          event.wing = _selectedWing;
          event.hours = int.parse(_hoursController.text);
          _isEditing = false;
        });
      }
    } else {
      setState(() {
        _isEditing = true;
      });
    }
  }

  void _deleteEvent() {
    // Implement delete functionality here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Center(
                child: Text(
                  _isEditing ? 'Edit Event' : event.name,
                  style: TextStyle(
                    fontSize: _isEditing ? 24 : 28,
                    decoration: _isEditing ? null : TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 48), // To balance the space taken by the back button
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _isEditing
                            ? TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(labelText: 'Event Name'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter event name';
                                  }
                                  return null;
                                },
                              )
                            : Container(),
                        const SizedBox(height: 20),
                        _isEditing
                            ? Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _dateController,
                                      decoration: const InputDecoration(labelText: 'Date'),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter date';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _timeController,
                                      decoration: const InputDecoration(labelText: 'Time'),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter time';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  '${event.date} at ${event.time}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                        const SizedBox(height: 20),
                        _isEditing
                            ? TextFormField(
                                controller: _venueController,
                                decoration: const InputDecoration(labelText: 'Venue'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter venue';
                                  }
                                  return null;
                                },
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.venue,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Wing: $_selectedWing',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(height: 10),
                        _isEditing
                            ? TextFormField(
                                controller: _descriptionController,
                                maxLines: 5,
                                decoration: const InputDecoration(labelText: 'Description'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter description';
                                  }
                                  return null;
                                },
                              )
                            : Text(
                                event.longDescription,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                        const SizedBox(height: 20),
                        _isEditing
                            ? Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedWing,
                                      items: wingsList
                                          .map((wing) => DropdownMenuItem(
                                                value: wing,
                                                child: Text(wing),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedWing = value!;
                                        });
                                      },
                                      decoration: const InputDecoration(labelText: 'Wing'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select wing';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _hoursController,
                                      decoration: const InputDecoration(labelText: 'Hours'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter hours';
                                        }
                                        if (int.tryParse(value) == null) {
                                          return 'Please enter a valid number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    '${event.hours} hours',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _selectedRole == "students"
                    ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.blue[900],
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                          ),
                          onPressed: () {
                            // Implement your onPressed functionality here
                          },
                          child: const Text(
                            'Upload Images',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : _selectedRole == "mentors"
                        ? Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white, backgroundColor: Colors.blue[900],
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  ),
                                  onPressed: () {
                                    // Implement your onPressed functionality here
                                  },
                                  child: const Text(
                                    'Upload Gallery',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white, backgroundColor: Colors.blue[900],
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  ),
                                  onPressed: () {
                                    // Implement your onPressed functionality here
                                  },
                                  child: const Text(
                                    'Generate and Send Email to PIC',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: _isEditing ? Colors.blue[900] : Colors.white, 
                                backgroundColor: _isEditing ? Colors.white : Colors.blue[900],
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                              ),
                              onPressed: _isEditing ? null : () {
                                // Implement your onPressed functionality here
                              },
                              child: const Text(
                                'View Gallery',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
              ),
            ],
          ),
          if (_selectedRole == "pic")
            Positioned(
              bottom: 90.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: _toggleEdit,
                child: Icon(_isEditing ? Icons.check : Icons.edit),
              ),
            ),
          if (_selectedRole == "pic" && _isEditing)
            Positioned(
              bottom: 90.0,
              right: 80.0,
              child: FloatingActionButton(
                onPressed: _deleteEvent,
                backgroundColor: Colors.red,
                child: const Icon(Icons.delete),
              ),
            ),
        ],
      ),
    );
  }
}

// Define the Event class
class Event {
  String name;
  String date;
  String time;
  String venue;
  String longDescription;
  String wing;
  int hours;

  Event({
    required this.name,
    required this.date,
    required this.time,
    required this.venue,
    required this.longDescription,
    required this.wing,
    required this.hours,
  });
}
