import 'package:flutter/material.dart';

import 'package:nss_project/date_time_formatter.dart';

import 'package:nss_project/event_page.dart';
import 'package:nss_project/sprofile_page.dart';
import 'package:nss_project/mentordummyeventpage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MentorHomePage extends StatefulWidget {
  final String role;

  const MentorHomePage({super.key, required this.role});

  @override
  MentorHomePageState createState() => MentorHomePageState();
}

class MentorHomePageState extends State<MentorHomePage> {
  bool isFirstTabSelected = true;
  String selectedWing = 'All';

  @override
  Widget build(BuildContext context) {
  final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.role[0].toUpperCase() + widget.role.substring(1)),
        actions: [
        
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: SizedBox(
        height: height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isFirstTabSelected = true;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isFirstTabSelected
                              ? Colors.blue[800]
                              : Colors.blue[300],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 24.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Attendance or gallery',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isFirstTabSelected = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isFirstTabSelected
                              ? Colors.blue[300]
                              : Colors.blue[800],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 24.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Edit or Report',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('configurables')
                    .doc("document")
                    .snapshots(),
                builder: (context, snapshot) {
                  List<String> WingOptions = ["All"] +
                      snapshot.data!['wings'].map<String>((wing) {
                        String ret = wing;
                        return ret;
                      }).toList();
                  List<DropdownMenuEntry<String>> WingMenuEntries =
                      WingOptions.map((option) => DropdownMenuEntry<String>(
                          value: option, label: option)).toList();
                  return DropdownMenu<String>(
                    initialSelection: 'All',
                    requestFocusOnTap: false,
                    expandedInsets: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    textStyle: const TextStyle(color: Colors.white),
                    inputDecorationTheme: const InputDecorationTheme(
                      fillColor: Color.fromARGB(255, 128, 112, 185),
                      filled: true,
                    ),
                    label: const Text(
                      'NSS Wing',
                      style: TextStyle(color: Colors.white),
                    ),
                    onSelected: (String? wing) {
                      setState(() {
                        if (wing != null) {
                          selectedWing = wing;
                        }
                      });
                    },
                    dropdownMenuEntries: WingMenuEntries,
                  );
                }),
            StreamBuilder(
                stream: (selectedWing == 'All')
                    ? FirebaseFirestore.instance.collection("events").snapshots()
                    : FirebaseFirestore.instance
                        .collection("events")
                        .where('wing', isEqualTo: selectedWing)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Flexible(
                      child: ListView.builder(
                          itemExtent: height*0.1,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return _buildEvent(snapshot.data!.docs[index],
                                context, isFirstTabSelected);
                          }),
                    );
                  }
                  return const Text('Working');
                }),
          ],
        ),
      ),
    );
  }
}

Widget _buildEvent(QueryDocumentSnapshot<Map<String, dynamic>> event,
    BuildContext context, bool isFirstTabSelected) {
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('icondata')
          .where('wing', isEqualTo: event['wing'])
          .snapshots(),
      builder: (context, snapshot) {
        return Card.outlined(
          elevation: 0.5,
          margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
          color: Colors.white70,
          child: ListTile(
            tileColor: const Color.fromARGB(255, 251, 250, 250),
            title: Text(event['title']),
            subtitle:
                Text(DateTimeFormatter.format(event['timestamp'].toDate())),
            leading: Icon(
                IconData(snapshot.data!.docs[0]['codepoint'],
                    fontFamily: 'MaterialIcons'),
                color: Color(snapshot.data!.docs[0]['color'])),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${event['hours']} Hrs'),
                const Text('Active', style: TextStyle(color: Colors.green))
              ],
            ),
            onTap: () {
              // ON TAP IS TRIGGERED WHEN A TILE IS CLICKED
              // PUT THE IF ELSE OF WHICH EVENT PAGE TO GO TO HERE
              // istaboneselected is aldready a arg in this function
              if (isFirstTabSelected) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MentorDummyEventPage(document: event)));
                // Add attendence / gallery page
                //Navigator.push(context,MaterialPageRoute(builder: (context)=>DisplayEventPage(document: event, selectedRole: "mentor",)));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DisplayEventPage(
                              document: event,
                              selectedRole: 'mentor',
                            )));
              }
            },
          ),
        );
      });
}
