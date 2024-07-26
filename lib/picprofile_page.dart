import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// import 'package:nss_project/leaderboard_page.dart';

class PicProfilePage extends StatefulWidget {
  const PicProfilePage({super.key});

  @override
  State<PicProfilePage> createState() => _PicProfilePageState();
}

class _PicProfilePageState extends State<PicProfilePage> {
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
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Column(children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      label: Text(
                        'Change Name',
                        style: TextStyle(fontSize: 17.0),
                      )),
                  onChanged: (text) {
                    name = text;
                  },
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Configurables()));
                    },
                    child: const Text(
                      'Change Configurables',
                      style: TextStyle(decoration: TextDecoration.underline),
                    )),
                // Padding(
                //   padding: const EdgeInsets.all(5.0),
                //   child: SizedBox(
                //         width: double.infinity,
                //         child: ElevatedButton(
                //           style: ElevatedButton.styleFrom(
                //             foregroundColor: Colors.white,
                //             backgroundColor: Colors.blue[900],
                //           ),
                //           onPressed: (){
                //             Navigator.push(context,MaterialPageRoute(builder: (context)=>LeaderboardPage()));
                //           },
                //           child: const Text(
                //             'Leaderboard',
                //             style: TextStyle(
                //               fontSize: 16,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //         ),
                //       ),
                // ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class Configurables extends StatefulWidget {
  const Configurables({super.key});

  @override
  State<Configurables> createState() => _ConfigurablesState();
}

class _ConfigurablesState extends State<Configurables> {
 
  bool isHoursChanged = false;
  bool isWingsChanged = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;

    late int totalhours;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isHoursChanged) {
            FirebaseFirestore.instance
                .collection('configurables')
                .doc('documen')
                .set({'mandatory-hours': totalhours}, SetOptions(merge: true));
          }
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('configurables')
                      .doc('documen')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      totalhours = snapshot.data!['mandatory-hours'];
                      List<String> wings =
                          snapshot.data!['wings'].map<String>((wing) {
                        String ret = wing;
                        return ret;
                      }).toList();
                      return Container(
                        height: height / 1.5,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextField(
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  label: Text(
                                    'Change Total Hours Required',
                                    style: TextStyle(fontSize: 17.0),
                                  )),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (text) {
                                totalhours = int.parse(text);
                                isHoursChanged = true;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text('wings'),
                            Flexible(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: wings.length + 1,
                                  itemBuilder: (context, index) {
                                    String? newWing;
                                    if (index == wings.length) {
                                      return TextButton(
                                          onPressed: () => showDialog(
                                            context: context,
                                            builder:(BuildContext context){
                                              return AlertDialog(
                                                title: const Text('Name of new wing'),
                                                content: TextField(
                                                  onChanged: (text){newWing = text;},
                                                ),
                                                actions: [
                                                  TextButton(onPressed: (){
                                                    if(newWing != null){
                                                      wings.add(newWing ?? '');
                                                      FirebaseFirestore.instance.collection('configurables').doc('documen').set({'wings': wings}, SetOptions(merge: true));
                                                      setState(() {});
                                                    }
                                                    Navigator.pop(context);

                                                 

                                                  }, child: const Text('confirm'),)
                                                ],
                                              );
                                            }
                                          ),
                                          child: const Text('add event'));
                                    }
                                    return Card(
                                      child: ListTile(
                                        title: Text(wings[index]),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () =>
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context){
                                               return AlertDialog(
                                                title: const Text('Do you want to delete this wing'),
                                                actions: [
                                                  TextButton(onPressed: (){Navigator.pop(context);}, child: const  Text('No')),
                                                  TextButton(onPressed: (){
                                                    wings.removeAt(index);
                                                    FirebaseFirestore.instance.collection('configurables').doc('documen').set({'wings': wings}, SetOptions(merge: true));
                                                    setState(() {});
                                                    Navigator.pop(context);
                                                  }, child: const Text('Yes')),
                                              
                                                ],
                                              );},
                                            ),
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
                      );
                    }
                    return const Text("No connection");
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

