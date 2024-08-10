import 'package:flutter/material.dart';

class SecretaryRecEventslist extends StatefulWidget {
  const SecretaryRecEventslist({super.key});

  @override
  State<SecretaryRecEventslist> createState() => _SecretaryRecEventslistState();
}

class _SecretaryRecEventslistState extends State<SecretaryRecEventslist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Recuring Events'),
        ),
      ),
    );
  }
}
