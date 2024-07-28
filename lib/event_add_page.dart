import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: EventPage(),
    );
  }
}

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  EventPageState createState() => EventPageState();
}

class EventPageState extends State<EventPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  String? dropdownValue1 = 'None';
  String? dropdownValue2 = 'None';

  final List<String> dropdownOptions2 = ['None','Non Recurring','Recurring'];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitButtonEnabled = false;

  void _validateForm() {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    final isDropdownValid = dropdownValue1 != 'None' && dropdownValue2 != 'None';
    
    setState(() {
      _isSubmitButtonEnabled = isFormValid && isDropdownValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Handle back button
              },
            ),
            const SizedBox(width: 10),
            const Text('Event Page'),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    onChanged: _validateForm,
                    child: Column(
                      children: [
                        _buildTextField(_nameController, 'Name'),
                        const SizedBox(height: 10),
                        _buildTextField(_dateController, 'Date'),
                        const SizedBox(height: 10),
                        _buildTextField(_timeController, 'Time'),
                        const SizedBox(height: 10),
                        _buildTextField(_venueController, 'Venue'),
                        const SizedBox(height: 10),
                        _buildTextField(_hoursController, 'Hours', inputType: TextInputType.number),
                        const SizedBox(height: 10),
                        _buildWingDropdown(dropdownValue1, (String? newValue) {
                          setState(() {
                            dropdownValue1 = newValue!;
                          });
                          _validateForm();
                        }),
                        const SizedBox(height: 10),
                        _buildDropdown(dropdownValue2, dropdownOptions2, (String? newValue) {
                          setState(() {
                            dropdownValue2 = newValue!;
                          });
                          _validateForm();
                        }),
                        const SizedBox(height: 20), // Add some space to avoid overlapping with the floating button
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _isSubmitButtonEnabled
                      ? () {
                          Map <String,dynamic> NewEvent = {
                            "title" : _nameController.text.trim(),
                            "timestamp" : Timestamp.fromDate(DateTime.now()),
                            "venue" : _venueController.text.trim(),
                            "hours" : _hoursController.text.trim(),
                            "wing" : dropdownValue1,
                            "recurring" : dropdownValue2,
                          };
                          FirebaseFirestore.instance.collection("events").add(NewEvent);
                          

                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), backgroundColor: _isSubmitButtonEnabled ? Colors.blue.shade900 : Colors.grey, // full width and larger height
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 80,
            child: FloatingActionButton(
              onPressed: () {
                // Handle add image
              },
              child: const Icon(Icons.add_a_photo),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {TextInputType inputType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown(String? value, List<String> options, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      onChanged: onChanged,
      items: options.map<DropdownMenuItem<String>>((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      validator: (value) {
        if (value == 'None') {
          return 'Please select an option';
        }
        return null;
      },
    );
  }
}

Widget _buildWingDropdown(String? value, ValueChanged<String?> onChanged) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('configurables').doc("document").snapshots(),
      builder: (context, snapshot) {
        List<String> WingOptions = ['None'] +
                      snapshot.data!['wings'].map<String>((wing) {
                        String ret = wing;
                        return ret;}).toList();
        List<DropdownMenuItem<String>> WingMenuEntries =
          WingOptions.map((option) => DropdownMenuItem<String>(value: option, child : Text(option))).toList();
        return DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          onChanged: onChanged,
          items: WingMenuEntries,
          validator: (value) {
            if (value == 'None') {
              return 'Please select an option';
            }
            return null;
          },
        );
      }
    );
  }

