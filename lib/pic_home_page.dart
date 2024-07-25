import 'package:flutter/material.dart';

import 'package:nss_project/people_page.dart';
import 'package:nss_project/picprofile_page.dart';
import 'package:nss_project/event_page.dart';
import 'package:nss_project/event_add_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MaterialApp(
    home: PicHomePage(),
  ));
}

class PicHomePage extends StatefulWidget {
  const PicHomePage({super.key});

  @override
  State<PicHomePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PicHomePage> {
  String selectedWing = 'All';
  @override
  Widget build(BuildContext context) {
    String mentorname = "Pranjal";

    //double width = MediaQuery.sizeOf(context).width;
    //double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed : (){
         Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EventPage()));
        
      }
      ),
      appBar: AppBar(
        title: Text('Hey $mentorname'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PeoplePage(userRole: "pic",)));
              },
              icon: const Icon(Icons.person)),
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
                    padding:EdgeInsets.fromLTRB(0,12,0,0),
                    child: Divider(color: Colors.black,indent: 10,),),
                ),
                Text('View events',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w400,color: Color.fromARGB(255, 0, 0, 0),),),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding:EdgeInsets.fromLTRB(0,12,0,0),
                    child: Divider(color: Colors.black,indent: 4, endIndent: 10,),),
                ),
              ],
            ),
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('configurables').doc("document").snapshots(),
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
                stream: (selectedWing == 'All')?
                    FirebaseFirestore.instance.collection("events").snapshots(): 
                    FirebaseFirestore.instance.collection("events").where('wing', isEqualTo: selectedWing).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Flexible(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return _buildEvent(
                                snapshot.data!.docs[index], context);
                          }),
                    );
                  }
                  return const Text('Hello Darkness my ..');
                }),
          ]),
    );
  }
}

Widget _buildEvent(
    QueryDocumentSnapshot<Map<String, dynamic>> event, BuildContext context) {
  return Card.outlined(
    elevation: 0.5,
    margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
    color: Colors.white70,
    child: ListTile(
      tileColor: const Color.fromARGB(255, 251, 250, 250),
      title: Text(event['title']),
      subtitle: Text(event['subtitle']),
      leading: Icon(
          IconData(event['icon']['codepoint'], fontFamily: 'MaterialIcons'),
          color: Color(event['icon']['color'])),
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
