import 'package:flutter/material.dart';
// import 'package:nss_project/sprofile_page.dart';
// import 'dart:io';

class StudentViewPage extends StatefulWidget {
  const StudentViewPage({super.key});

  @override
  State<StudentViewPage> createState() => _StudentViewPageState();
}

class _StudentViewPageState extends State<StudentViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student View'),
      ),
    );
  }
}
