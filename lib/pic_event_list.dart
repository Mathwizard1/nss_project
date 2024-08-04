import 'package:flutter/material.dart';

import 'package:nss_project/picprofile_page.dart';
import 'package:nss_project/event_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MaterialApp(
    home: PicEventList(),
  ));
}

class PicEventList extends StatefulWidget {
  const PicEventList({super.key});

  @override
  State<PicEventList> createState() => _PicEventListState();
}

class _PicEventListState extends State<PicEventList> {

  String selectedWing = 'All';
  String selectedMentor = 'All';
  Stream<DocumentSnapshot<Map<String, dynamic>>>? ConfigurablesStream;
  Stream<QuerySnapshot<Map<String, dynamic>>>? EventStream;
  Stream<QuerySnapshot<Map<String, dynamic>>>? MentorStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ConfigurablesStream = FirebaseFirestore.instance.collection('configurables').doc("document").snapshots();
    EventStream = FirebaseFirestore.instance.collection("events").snapshots();
    MentorStream = FirebaseFirestore.instance.collection("users").where('role',isEqualTo: 'mentor').snapshots();
  }
  @override
  Widget build(BuildContext context) {
    String mentorname = "Pranjal";

    //double width = MediaQuery.sizeOf(context).width;
    //double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Hey $mentorname'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const PicProfilePage()));
            },
          ),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.exit_to_app)),
        ],
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding:EdgeInsets.fromLTRB(0,5,10,0),
                    child: Divider(color: Colors.black,indent: 10,),),
                ),
                Text('View events',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w400,color: Color.fromARGB(255, 0, 0, 0),),),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding:EdgeInsets.fromLTRB(10,5,0,0),
                    child: Divider(color: Colors.black,indent: 4, endIndent: 10,),),
                ),
              ],
            ),
            StreamBuilder(
              stream: MentorStream,
              builder:(context,mentorshot) => StreamBuilder(
                  stream: ConfigurablesStream,
                  builder: (context, snapshot) {
                    if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
                    List<String> WingOptions = ["All"] +
                        snapshot.data!['wings'].map<String>((wing) {
                          String ret = wing;
                          return ret;
                        }).toList();
                    List<DropdownMenuEntry<String>> WingMenuEntries =
                        WingOptions.map((option) => DropdownMenuEntry<String>(value: option, label: option)).toList();
                    List<String> MentorOptions = ["All"] + 
                        mentorshot.data!.docs.map<String>((mentor) {
                          String ret = mentor['full-name'];
                          return ret;
                        }).toList();
                    List<DropdownMenuEntry<String>> MentorMenuEntries =
                        MentorOptions.map((option) => DropdownMenuEntry<String>(value: option, label: option)).toList();
                    return Column(
                      children: [
                        DropdownMenu<String>(
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
                        ),
                        DropdownMenu<String>(
                          initialSelection: 'All',
                          requestFocusOnTap: false,
                          expandedInsets: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          textStyle: const TextStyle(color: Colors.white),
                          inputDecorationTheme: const InputDecorationTheme(
                            fillColor: Color.fromARGB(255, 0, 255, 102),
                            filled: true,
                          ),
                          label: const Text(
                            'Mentor',
                            style: TextStyle(color: Colors.white),
                          ),
                          onSelected: (String? mentor) {
                            setState(() {
                              if (mentor != null) {
                                selectedMentor = mentor;
                              }
                            });
                          },
                          dropdownMenuEntries: MentorMenuEntries,
                        ),
                        
                      ],
                    );
                  }),
            ),
            StreamBuilder(
                stream: EventStream,
                builder: (context, snapshot) {
                  List<QueryDocumentSnapshot<Map<String,dynamic>>> events = [for(var x in snapshot.data!.docs) 
                                                                                    if((selectedWing == 'All') ? true :x['wing'] == selectedWing)
                                                                                    if((selectedMentor == 'All') ? true: x['organizing-mentor'].contains(selectedMentor)) x];
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          return _buildEvent(
                              events[index], context);
                        });
                  }
                  return const Text('Hello Darkness my ..');
                }),
          ]),
    );
  }
}

Widget _buildEvent(
    QueryDocumentSnapshot<Map<String, dynamic>> event, BuildContext context) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance.collection('icondata').where('wing',isEqualTo: event['wing']).snapshots(),
    builder: (context, snapshot) {
      return Card.outlined(
        elevation: 0.5,
        margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
        color: Colors.white70,
        child: ListTile(
          tileColor: const Color.fromARGB(255, 251, 250, 250),
          title: Text(event['title']),
          subtitle: Text(event['subtitle']),
          leading: Icon(
              IconData(snapshot.data!.docs[0]['codepoint'], fontFamily: 'MaterialIcons'),
              color: Color(snapshot.data!.docs[0]['color'])),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${event['hours']} Hrs'),
              const Text('Active', style: TextStyle(color: Colors.green))
            ],
          ),
          onTap: () {
            Navigator.push(context,MaterialPageRoute(builder: (context)=>DisplayEventPage(document: event,selectedRole: "pic",)));
          },
        ),
      );
    }
  );
}
