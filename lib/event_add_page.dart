import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'date_time_formatter.dart';
import 'notification_page.dart';

import 'package:textfield_tags/textfield_tags.dart';

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
  late List<String> wingslist;
  List<String> mentorlist = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  DateTime _selectedDateTime = DateTime.now();
  final TextEditingController _dateController = TextEditingController();

  late double _distanceToField;
  late StringTagController _wingTagController;
  late double _distanceToField2;
  late StringTagController _mentorTagController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
    _distanceToField2 = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _description.dispose();
    _venueController.dispose();
    _hoursController.dispose();
    _dateController.dispose();
    _wingTagController.dispose();
    _mentorTagController.dispose();
  }

  Future<void> getWings() async
  {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('configurables').doc('document').get();

      if (snapshot.exists) {
        List<dynamic> arrayField = snapshot.get('wings'); 
        setState(() {
          wingslist = List<String>.from(arrayField);
        });
      }
      else
      {
        wingslist = ["None"];
      }
  }

  Future<void> getMentors() async {
    // Query the 'users' collection for documents where 'role' is 'mentors'
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'mentor')
        .get();

    // Iterate through the query results and extract the 'name' field
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      String? name = doc.get('full-name');
      if (name != null) {
        mentorlist.add(name);
      }
    }

    if(mentorlist.isEmpty)
    {
      mentorlist.add("All");
    }
}

  @override
  void initState() {
    super.initState();
    getWings();
    getMentors();
    _dateController.text = DateTimeFormatter.format(_selectedDateTime);
    _wingTagController = StringTagController();
    _mentorTagController = StringTagController();
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
          _dateController.text = DateTimeFormatter.format(_selectedDateTime);
        });
      }
    }
  }

  String? dropdownValue1 = 'None';
  String? dropdownValue2 = 'None';

  final List<String> dropdownOptions2 = ['None','Non Recurring','Recurring'];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitButtonEnabled = false;

  void _validateForm(String intText) {
    final isFormValid = (_formKey.currentState?.validate() ?? false) && (!intText.contains(RegExp(r"[., -]")));
    final isDropdownValid = dropdownValue1 != 'None' && dropdownValue2 != 'None';
    
    setState(() {
      _isSubmitButtonEnabled = isFormValid && isDropdownValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            SizedBox(width: 10),
            Text('Event Page'),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    onChanged: (){_validateForm(_hoursController.text.trim());},
                    child: Column(
                      children: [
                        _buildTextField(_nameController, 'Name', 1),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            labelText: 'Select Date and Time',
                          ),
                          onTap: () => _selectDateTime(context),
                        ),
                        _buildTextField(_description, 'description', 3),
                        const SizedBox(height: 10),
                        _buildTextField(_venueController, 'Venue', 1),
                        const SizedBox(height: 10),
                        _buildTextField(_hoursController, 'Hours', 1, inputType: TextInputType.number),
                        const SizedBox(height: 10),
                        _buildWingDropdown(dropdownValue1, (String? newValue) {
                          setState(() {
                            dropdownValue1 = newValue!;
                          });
                          _validateForm(_hoursController.text.trim());
                        }),
                        const SizedBox(height: 10),
                        _buildDropdown(dropdownValue2, dropdownOptions2, (String? newValue) {
                          setState(() {
                            dropdownValue2 = newValue!;
                          });
                          _validateForm(_hoursController.text.trim());
                        }),
                        const SizedBox(height: 10),
            Autocomplete<String>(
              optionsViewBuilder: (context, onSelected, options) {
                return Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 4.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Material(
                      elevation: 4.0,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return TextButton(
                              onPressed: () {
                                onSelected(option);
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '#$option',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 74, 137, 92),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return wingslist.where((String option) {
                  return (option.toLowerCase()).contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selectedTag) {
                _wingTagController.onTagSubmitted(selectedTag);
              },
              fieldViewBuilder: (context, textEditingController, focusNode,
                  onFieldSubmitted) {
                return TextFieldTags<String>(
                  textEditingController: textEditingController,
                  focusNode: focusNode,
                  textfieldTagsController: _wingTagController,
                  letterCase: LetterCase.normal,
                  validator: (String tag) {
                    if (!wingslist.contains(tag)) {
                      return 'No Wing found for collborators';
                    } else if (_wingTagController.getTags!.contains(tag)) {
                      return 'Wing already in list';
                    }
                    return null;
                  },
                  inputFieldBuilder: (context, inputFieldValues) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        controller: inputFieldValues.textEditingController,
                        focusNode: inputFieldValues.focusNode,
                        decoration: InputDecoration(
                          isDense: true,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 74, 137, 92),
                              width: 3.0,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 74, 137, 92),
                              width: 3.0,
                            ),
                          ),
                          helperText: 'Enter Collaborator wings',
                          helperStyle: const TextStyle(
                            color: Color.fromARGB(255, 74, 137, 92),
                          ),
                          hintText: inputFieldValues.tags.isNotEmpty
                              ? ''
                              : "Enter Wings",
                          errorText: inputFieldValues.error,
                          prefixIconConstraints:
                              BoxConstraints(maxWidth: _distanceToField * 0.74),
                          prefixIcon: inputFieldValues.tags.isNotEmpty
                              ? SingleChildScrollView(
                                  controller:
                                      inputFieldValues.tagScrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children: inputFieldValues.tags
                                          .map((String tag) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                        color: Color.fromARGB(255, 74, 137, 92),
                                      ),
                                      margin:
                                          const EdgeInsets.only(right: 10.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            child: Text(
                                              tag,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onTap: () {
                                              //print("$tag selected");
                                            },
                                          ),
                                          const SizedBox(width: 4.0),
                                          InkWell(
                                            child: const Icon(
                                              Icons.cancel,
                                              size: 14.0,
                                              color: Color.fromARGB(
                                                  255, 233, 233, 233),
                                            ),
                                            onTap: () {
                                              inputFieldValues
                                                  .onTagRemoved(tag);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList()),
                                )
                              : null,
                        ),
                        onChanged: inputFieldValues.onTagChanged,
                        onSubmitted: inputFieldValues.onTagSubmitted,
                      ),
                    );
                  },
                );
              },
            ),
                      const SizedBox(height: 10),
            Autocomplete<String>(
              optionsViewBuilder: (context, onSelected, options) {
                return Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 4.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Material(
                      elevation: 4.0,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return TextButton(
                              onPressed: () {
                                onSelected(option);
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  option,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 74, 137, 92),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return mentorlist.where((String option) {
                  return (option.toLowerCase()).contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selectedTag) {
                _mentorTagController.onTagSubmitted(selectedTag);
              },
              fieldViewBuilder: (context, textEditingController, focusNode,
                  onFieldSubmitted) {
                return TextFieldTags<String>(
                  textEditingController: textEditingController,
                  focusNode: focusNode,
                  textfieldTagsController: _mentorTagController,
                  letterCase: LetterCase.normal,
                  validator: (String tag) {
                    if (!mentorlist.contains(tag)) {
                      return 'No mentors found';
                    } else if (_mentorTagController.getTags!.contains(tag)) {
                      return 'Mentor already selected';
                    }
                    return null;
                  },
                  inputFieldBuilder: (context, inputFieldValues) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        controller: inputFieldValues.textEditingController,
                        focusNode: inputFieldValues.focusNode,
                        decoration: InputDecoration(
                          isDense: true,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 74, 137, 92),
                              width: 3.0,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 74, 137, 92),
                              width: 3.0,
                            ),
                          ),
                          helperText: 'Enter organizing mentors',
                          helperStyle: const TextStyle(
                            color: Color.fromARGB(255, 74, 137, 92),
                          ),
                          hintText: inputFieldValues.tags.isNotEmpty
                              ? ''
                              : "Enter Mentors",
                          errorText: inputFieldValues.error,
                          prefixIconConstraints:
                              BoxConstraints(maxWidth: _distanceToField2 * 0.74),
                          prefixIcon: inputFieldValues.tags.isNotEmpty
                              ? SingleChildScrollView(
                                  controller:
                                      inputFieldValues.tagScrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children: inputFieldValues.tags
                                          .map((String tag) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                        color: Color.fromARGB(255, 74, 137, 92),
                                      ),
                                      margin:
                                          const EdgeInsets.only(right: 10.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            child: Text(
                                              tag,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onTap: () {
                                              //print("$tag selected");
                                            },
                                          ),
                                          const SizedBox(width: 4.0),
                                          InkWell(
                                            child: const Icon(
                                              Icons.cancel,
                                              size: 14.0,
                                              color: Color.fromARGB(
                                                  255, 233, 233, 233),
                                            ),
                                            onTap: () {
                                              inputFieldValues
                                                  .onTagRemoved(tag);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList()),
                                )
                              : null,
                        ),
                        onChanged: inputFieldValues.onTagChanged,
                        onSubmitted: inputFieldValues.onTagSubmitted,
                      ),
                    );
                  },
                );
              },
            ),
                      const SizedBox(height: 50),
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
                            "timestamp" : Timestamp.fromDate(_selectedDateTime),
                            "description" : _description.text.trim(),
                            "venue" : _venueController.text.trim(),
                            "hours" : int.parse(_hoursController.text.trim()),
                            "wing" : dropdownValue1,
                            "recurring" : dropdownValue2,
                            "registered-volunteers":[],
                            "organizing-mentor": _mentorTagController.getTags!.toList(),
                            "collaborators": _wingTagController.getTags!.toList(),
                            "are-photos-final": false
                          };
                          FirebaseFirestore.instance.collection("events").add(NewEvent);
                          addNotification("${_nameController.text.trim()} Event added. Event on ${DateTimeFormatter.format(_selectedDateTime)}");
                          Navigator.pop(context);
                          
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

  Widget _buildTextField(TextEditingController controller, String labelText, int boxlines, {TextInputType inputType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      maxLines: boxlines,
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

