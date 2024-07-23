import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class DisplayEventPage extends StatefulWidget {
  final QueryDocumentSnapshot document;
  final String selectedRole ;

  const DisplayEventPage({super.key,required this.document,required this.selectedRole});

  @override
  DisplayEventPageState createState() => DisplayEventPageState();
}

class DisplayEventPageState extends State<DisplayEventPage> {
  DisplayEventPageState();
  // List of wings for editing
  late final List<String> wingsList;

  Event event = Event(
    name: "Sample event",
    date: "2024",
    time: "10:00 AM",
    venue: "Room 101",
    longDescription: "Sample description",
    wing: "Technology",
    hours: 5,
  );

  bool _isEditing = false;
  bool _ismentorEditing = false;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _venueController;
  late TextEditingController _descriptionController;
  late TextEditingController _hoursController;
  late String _selectedWing;

  @override 
  void initState()
  {
    super.initState();
    syncdetails();
    initEdit();
  }

  void initEdit()
  {
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


Future updateDoc() async
{
  var docpath=FirebaseFirestore.instance.collection('events').doc(widget.document.reference.id);
  docpath.update({'description':event.longDescription});
  docpath.update({'hours':event.hours});
  docpath.update({'venue':event.venue});
  docpath.update({'title':event.name});
  docpath.update({'wing':event.wing});
  docpath.update({'timestamp':event.time});
}


  void _toggleEdit() 
  {
    if(widget.selectedRole == "pic"){
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
            updateDoc();
            _isEditing = false;
          });
        }
      } else {
        setState(() {
          _isEditing = true;
        });
      }
    }
    if(widget.selectedRole == "mentor"){
      if (_ismentorEditing) {
        if (_formKey.currentState!.validate()) {
          setState(() {
            event.date = _dateController.text;
            event.time = _timeController.text;
            event.venue = _venueController.text;
            updateDoc();
            _ismentorEditing = false;
          });
        }
      } else {
        setState(() {
          _ismentorEditing = true;
        });
      }
    }
  }

  void _deleteEvent() {
    // Implement delete functionality here
  }

  void syncdetails()
  {
    event.time=widget.document['timestamp'].toString();
    event.name=widget.document['title'];
    event.venue=widget.document['venue'];
    event.longDescription=widget.document['description'];
    event.hours=widget.document['hours'];
    event.wing=widget.document['wing'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                        (_isEditing || _ismentorEditing)
                            ? Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _dateController,
                                      keyboardType: TextInputType.datetime,
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
                                      keyboardType: TextInputType.text,
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
                                    fontSize: 20,
                                    color: Colors.blue,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                        const SizedBox(height: 20),
                        (_isEditing || _ismentorEditing)
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Wing: $_selectedWing',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
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
                                      fontSize: 20,
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
                child: widget.selectedRole == "volunteer"
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
                            'Register',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : widget.selectedRole == "mentor"
                        ? Column(
                            children: [
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
          if (widget.selectedRole == "pic" || widget.selectedRole == "mentor")
            Positioned(
              bottom: 90.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: _toggleEdit,
                child: Icon((_isEditing || _ismentorEditing) ? Icons.check : Icons.edit),
              ),
            ),
          if (widget.selectedRole == "pic" && _isEditing)
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
