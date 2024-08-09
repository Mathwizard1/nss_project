import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'leaderboard_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final DocumentReference _userDocumentReference;
  late final Stream<DocumentSnapshot> _userDocumentSnapshots;

  final nameController = TextEditingController();

  XFile? _imagefile;

  @override
  void initState() {
    super.initState();

    _userDocumentReference = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
    _userDocumentSnapshots = _userDocumentReference.snapshots();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    XFile? selected = await ImagePicker().pickImage(source: source);
    
    setState(() => _imagefile = selected);
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _userDocumentSnapshots,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
	  return Scaffold(
            appBar: AppBar(
              title: const Center(child: Text('Settings')),
            ),
	    body: Center(child: CircularProgressIndicator())
	  );
	}

        double width = MediaQuery.sizeOf(context).width;
        double height = MediaQuery.sizeOf(context).width;

	final name = snapshot.data!['full-name'];
	final roll = snapshot.data!['roll-number'];

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
	      _userDocumentReference.update({ 'full-name': nameController.text.trim(), });
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
                        const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: Column(
                      children: <Widget>[
                        TextField(
			controller: nameController,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            label: Text(
                              'Change Name',
                              style: TextStyle(fontSize: 17.0),
                            )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white, 
                                    backgroundColor: Colors.blue[900],
                                  ),
                                  onPressed: (){
                                    Navigator.push(context,MaterialPageRoute(builder: (context)=>LeaderboardPage()));
                                  },
                                  child: const Text(
                                    'Leaderboard',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                        ),
                        ]
                      ),
                  ),
              ],
            ),
          ),
        );
      },
    );

  }
}
