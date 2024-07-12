import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = 'Pranjal Kole';
  XFile? _imagefile;

  Future<void> _pickImage(ImageSource source) async {
    XFile? selected = await ImagePicker().pickImage(source: source);
    
    setState(() {
      _imagefile = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).width;

    String roll = '2302CS02';
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        child: const Text('Apply'),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(child: Text('Settings')),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: height / 10,
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(40.0)),
                        child: (_imagefile == null)
                            ? Image.asset(
                                'assets/images/defaultprofilepic.jpg',
                                width: width / 3.5,
                                height: width / 3.5,
                              )
                            : Image.file(
                                File(_imagefile!.path),
                                width: width / 3.5,
                                height: width / 3.5,
                              ),
                      ),
                      Positioned(
                        bottom: -10.0,
                        right: -15.0,
                        child: ElevatedButton(
                          onPressed: () {
                            _pickImage(ImageSource.gallery);
                          },
                          style: ButtonStyle(
                              shape:
                                  WidgetStateProperty.all(const CircleBorder()),
                              backgroundColor: WidgetStateProperty.all(
                                  const Color.fromARGB(255, 196, 196, 243))),
                          child: const Icon(Icons.edit),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 20,
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    roll,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height / 15,
                  ),
                ],
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                child: TextField(
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      label: Text(
                        'Change Name',
                        style: TextStyle(fontSize: 17.0),
                      )),
                  onChanged: (text) {
                    name = text;
                  },
                )),
          ],
        ),
      ),
    );
  }
}
