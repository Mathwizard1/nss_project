import 'package:flutter/material.dart';
import 'dart:io';
import 'student_view_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';

class PeoplePage extends StatefulWidget {
  final String userRole;
  const PeoplePage({super.key, required this.userRole});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  var tempvolunteerstream = FirebaseFirestore.instance
      .collection("users")
      .where('role', isEqualTo: 'volunteer');
  var volunteerstream = FirebaseFirestore.instance
      .collection("users")
      .where('role', isEqualTo: 'volunteer');

  Future openDialog() {
    TextEditingController searchcontroller = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Enter Roll Number"),
            content: SearchBar(
              controller: searchcontroller,
            ),
            actions: [
              FloatingActionButton(
                  child: const Text("Submit"),
                  onPressed: () {
                    setState(() {
                      volunteerstream = volunteerstream.where('roll-number',
                          isEqualTo:
                              searchcontroller.text.trim().toUpperCase());
                      Navigator.pop(context);
                    });
                  })
            ],
          );
        });
  }

  Future generateCSV() async {
    // ignore: non_constant_identifier_names
    List<List<String>> CSVtemp = [
      <String>[
        'Name',
        'Roll Number',
        'E-Mail',
        'Group',
        'Semester 1',
        'Semester 2'
      ]
    ];
    await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'volunteer')
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((document) {
        CSVtemp.add(<String>[
          document.get('full-name'),
          document.get('roll-number'),
          document.get('email'),
          document.get('group'),
          document.get('sem-1-hours').toString(),
          document.get('sem-2-hours').toString()
        ]);
      });
    });

    // ignore: non_constant_identifier_names
    String CSVdata = const ListToCsvConverter().convert(CSVtemp);

    Directory downloadDirectory = Directory('storage/emulated/0/Download');

    final File file =
        await (File('${downloadDirectory.path}/Students.csv').create());
    await file.writeAsString(CSVdata);
  }

  @override
  Widget build(BuildContext context) {
    String mentorname = "Pranjal";
    //double width = MediaQuery.sizeOf(context).width;
    //double height = MediaQuery.sizeOf(context).height;
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.search),
          onPressed: () {
            openDialog();
          },
        ),
        appBar: AppBar(
          title: Text('Hey $mentorname'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  setState(() {
                    volunteerstream = tempvolunteerstream;
                  });
                },
                icon: const Icon(Icons.refresh)),

            IconButton(
                onPressed: () {
                  generateCSV();
                },
                icon: const Icon(Icons.edit_document)),

            // SIGN OUT DOES NOT WORK
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Students'),
              Tab(text: 'Mentors'),
              Tab(
                text: 'Secretary',
              )
            ],
            labelStyle: TextStyle(fontSize: 22, height: 1.8),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: TabBarView(
            children: <Widget>[
              StreamBuilder(
                  stream: volunteerstream.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: Text("Loading"));
                    }

                    List<QueryDocumentSnapshot<Map<String, dynamic>>> stdlist =
                        [for (var i in snapshot.data!.docs) i];
                    return ListView.builder(
                        itemCount: stdlist.length,
                        itemBuilder: (context, index) {
                          return _buildPerson(
                              stdlist[index], widget.userRole, context);
                        });
                  }),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where('role', isEqualTo: 'mentor')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text('Hello Darkness my ..');
                    }

                    List<QueryDocumentSnapshot<Map<String, dynamic>>> stdlist =
                        [for (var i in snapshot.data!.docs) i];
                    return ListView.builder(
                        itemCount: stdlist.length,
                        itemBuilder: (context, index) {
                          return _buildPerson(
                              stdlist[index], widget.userRole, context);
                        });
                  }),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where('role', isEqualTo: 'secretary')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.active) {
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          stdlist = [for (var i in snapshot.data!.docs) i];
                      return ListView.builder(
                          itemCount: stdlist.length,
                          itemBuilder: (context, index) {
                            return _buildPerson(
                                stdlist[index], widget.userRole, context);
                          });
                    }
                    return const Text('Hello Darkness my ..');
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildPerson(QueryDocumentSnapshot<Map<String, dynamic>> person,
    String userRole, BuildContext context) {
  return SizedBox(
    height: 80,
    child: InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StudentViewPage(person: person)));
      },
      child: Card(
          elevation: 0.5,
          color: Colors.white70,
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                color: (person['role'] == 'volunteer')
                    ? Colors.blue
                    : ((person['role'] == 'mentor'))
                        ? Colors.red
                        : const Color.fromARGB(255, 255, 204, 1),
                child: const Icon(
                  Icons.account_circle,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      getCapitalizedName(person['full-name']),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        Text(
                          '${person['roll-number']}',
                          style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(201, 119, 109, 109)),
                        ),
                        (person['role'] == 'volunteer')
                            ? Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'Hours: ${person['sem-1-hours'] + person['sem-2-hours']}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Color.fromARGB(201, 119, 109, 109)),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  )
                ],
              ),
            ],
          )),
    ),
  );
}

String getCapitalizedName(String name) {
  String ret = '';
  bool doCap = true;
  for (int i = 0; i < name.length; i++) {
    if (doCap) {
      ret = ret + name[i].toUpperCase();
      doCap = false;
    } else {
      ret = ret + name[i];
      if (name[i] == ' ') {
        doCap = true;
      }
    }
  }
  return ret;
}
