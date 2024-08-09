import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

import 'date_time_formatter.dart';
import 'package:nss_project/notification_page.dart';
import 'email_page.dart';

class DisplayEventPage extends StatefulWidget {
  final QueryDocumentSnapshot document;
  final String selectedRole ;

  const DisplayEventPage({super.key,required this.document,required this.selectedRole});

  @override
  DisplayEventPageState createState() => DisplayEventPageState();
}

class DisplayEventPageState extends State<DisplayEventPage> {
  DisplayEventPageState();

  Event event = Event(
    name: "Sample event",
    time: DateTime.now(),
    venue: "Room 101",
    longDescription: "Sample description",
    wing: "Technology",
    hours: 5,
  );

  bool _isEditing = false;
  bool _ismentorEditing = false;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _venueController;
  late TextEditingController _descriptionController;
  late TextEditingController _hoursController;
  late String _selectedWing;

  DateTime _selectedDateTime = DateTime.now();
  late TextEditingController _timeController;

  @override 
  void initState()
  {
    super.initState();

    ;

    syncdetails();
    initEdit();
  }

  void initEdit()
  {
    _nameController = TextEditingController(text: event.name);
    _timeController = TextEditingController(text: DateTimeFormatter.format(event.time));
    _venueController = TextEditingController(text: event.venue);
    _descriptionController = TextEditingController(text: event.longDescription);
    _hoursController = TextEditingController(text: event.hours.toString());
    _selectedWing = event.wing;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timeController.dispose();
    _venueController.dispose();
    _descriptionController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  Future<void> _deleteDocumentByName(BuildContext context) async {
    try {
      // Reference to the Firestore collection
        final DocumentReference documentref = widget.document.reference;

        // Delete the document
        await documentref.delete();

        // Optionally show a success message
        if(!context.mounted){ return; }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Document with name ${widget.document['title']} deleted successfully')),
        );

      // Pop the page
      addNotification("${widget.document['title']} event as been deleted.");
      if(!context.mounted){ return; }
      Navigator.of(context).pop();

    } catch (e) {
      // Handle errors (e.g., show an error message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete document: $e')),
      );
    }
  }

  Future updateDoc() async
  {
    var docpath=FirebaseFirestore.instance.collection('events').doc(widget.document.reference.id);
    docpath.update({'description':event.longDescription});
    docpath.update({'hours':event.hours});
    docpath.update({'venue':event.venue});
    docpath.update({'title':event.name});
    docpath.update({'wing':event.wing});
    docpath.update({'timestamp':Timestamp.fromDate(event.time)});
  }


  void _toggleEdit() 
  {
    if(widget.selectedRole == "pic"){
      if (_isEditing) {
        if (_formKey.currentState!.validate()) {
          setState(() {
            event.name = _nameController.text;
            event.time = _selectedDateTime;
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
            event.time = _selectedDateTime;
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

  void syncdetails()
  {
    event.time=widget.document['timestamp'].toDate();
    event.name=widget.document['title'];
    event.venue=widget.document['venue'];
    event.longDescription=widget.document['description'];
    event.hours=widget.document['hours'];
    event.wing=widget.document['wing'];
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (!context.mounted) return;
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _timeController.text = DateTimeFormatter.format(_selectedDateTime);
        });
      }
    }
  }

  Future generateCSV() async
  {
    // ignore: non_constant_identifier_names
    List<List<String>> CSVtemp=[<String>['Name','Roll Number','E-Mail','Group']];
    for(var x in widget.document.get('attending-volunteers'))
    {
      await FirebaseFirestore.instance.collection('users').doc(x).get().then((snapshot){CSVtemp.add(<String>[snapshot['full-name'],snapshot['roll-number'],snapshot['email'],snapshot['group']]);});
    }

    // ignore: non_constant_identifier_names
    String CSVdata=const ListToCsvConverter().convert(CSVtemp);

    Directory downloadDirectory=Directory('storage/emulated/0/Download');

    final File file=await(File('${downloadDirectory.path}/${widget.document['title']}.csv').create());
    await file.writeAsString(CSVdata);

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('configurables').doc('document').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
	  return const Scaffold(body: Center(child: CircularProgressIndicator()));
	}

	final wingsList = snapshot.data!['wings'].map<String>((dyn) { String ret = dyn; return ret; }).toList();

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
                                          controller: _timeController,
                                          readOnly: true,
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                            icon: Icon(Icons.calendar_today),
                                            labelText: 'Time'),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter time';
                                            }
                                            return null;
                                          },
                                          onTap: () => _selectDateTime(context),
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
                                      '${event.time}',
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
                                              .map<DropdownMenuItem<String>>((wing) => DropdownMenuItem<String>(
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
                                        Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => const EmailSender()));
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
                            : Padding(
                              padding: const EdgeInsets.only(bottom:20),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom:8.0),
                                    child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: _isEditing ? Colors.blue[900] : Colors.white, 
                                            backgroundColor: _isEditing ? Colors.white : Colors.blue[900],
                                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                                          ),
                                          onPressed: _isEditing ? null : () {

                                            generateCSV();
                                            // Implement your onPressed functionality here
                                          },
                                          child: const Text(
                                            'Download Excel Sheet',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ),
                              
                                  SizedBox(
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
                                ],
                              ),
                            ),
                  ),
                ],
              ),
              if (widget.selectedRole == "pic" || widget.selectedRole == "mentor")
                Positioned(
                  bottom: 190.0,
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
                    onPressed: (){ _deleteDocumentByName(context); },
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.delete),
                  ),
                ),
            ],
          ),
        );

      },
    );

    
  }
}

// Define the Event class
class Event {
  String name;
  DateTime time;
  String venue;
  String longDescription;
  String wing;
  int hours;

  Event({
    required this.name,
    required this.time,
    required this.venue,
    required this.longDescription,
    required this.wing,
    required this.hours,
  });
}
