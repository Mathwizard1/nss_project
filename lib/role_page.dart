import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RolesPage(),
    );
  }
}

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  RolesPageState createState() => RolesPageState();
}

class RolesPageState extends State<RolesPage> {
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const LinearProgressIndicator(value: 0.75),
            const SizedBox(height: 20),
            Text(
              'Your Role',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            const Text(
              'Choose the option which describes your role:',
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20),
            _buildRadioButton('Student'),
            const SizedBox(height: 10),
            _buildRadioButton('Mentor'),
            const SizedBox(height: 10),
            _buildRadioButton('PIC'),
            const Spacer(),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedRole != null ? Colors.blue[900] : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _selectedRole != null
                      ? () {
                          // Handle the submit action
                          debugPrint('Selected Role: $_selectedRole');
                        }
                      : null,
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButton(String role) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedRole == role ? Colors.blue[900] : Colors.white,
          side: const BorderSide(color: Colors.grey),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        onPressed: () {
          setState(() {
            _selectedRole = role;
          });
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            role,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _selectedRole == role ? Colors.white : Colors.blue[900],
            ),
          ),
        ),
      ),
    );
  }
}
