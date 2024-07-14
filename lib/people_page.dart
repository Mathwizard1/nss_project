import 'package:flutter/material.dart';
import 'package:nss_project/sprofile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'student_view_page.dart';

void main() {
  runApp(const MaterialApp(
    home: PeoplePage(),
  ));
}

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  @override
  Widget build(BuildContext context) {
    int numberoftabs = 2;
    List<String> tabnames = ['Students', 'Mentor'];
    List<String> students = [
      'student1',
      'student2',
      'student3',
      'student4',
      'student2',
      'student3',
      'student4'
    ];
    List<String> events = [
      'mentor1',
      'mentor2',
      'mentor3',
      'mentor4',
      'mentor2',
      'mentor3',
      'mentor4'
    ];
    String mentorname = "Pranjal";
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return DefaultTabController(
      initialIndex: 0,
      length: numberoftabs,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hey $mentorname'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
              },
            ),

            // SIGN OUT DOES NOT WORK

            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.exit_to_app)),
          ],
          bottom: TabBar(tabs: tabnames.map((title) => Text(title)).toList()),
        ),
        body: Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: TabBarView(
            children: <Widget>[
              ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(40.0)),
                      child: Container(
                        // margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                        color: Colors.lightBlueAccent,
                        width: width / 1.2,
                        height: height / 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const StudentViewPage()));
                                },
                                child: Text(
                                  students[index],
                                  style: TextStyle(
                                      fontSize: height / 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800),
                                )),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    )
                  ],
                ),
              ),
              ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(40.0)),
                      child: Container(
                        // margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                        color: Colors.lightBlueAccent,
                        width: width / 1.2,
                        height: height / 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  // GOES TO EVENT PAGE
                                },
                                child: Text(
                                  students[index],
                                  style: TextStyle(
                                      fontSize: height / 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800),
                                )),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
