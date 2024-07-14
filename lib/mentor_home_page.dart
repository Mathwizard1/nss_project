
import 'package:flutter/material.dart';
import 'package:nss_project/sprofile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(const MaterialApp(
    home: MentorHomePage(),
  ));
}

class MentorHomePage extends StatefulWidget {
  const MentorHomePage({super.key});

  @override
  State<MentorHomePage> createState() => _MentorHomePageState();
}

class _MentorHomePageState extends State<MentorHomePage> {
  @override
  Widget build(BuildContext context) {
    int numberoftabs = 2;
    List<String> tabnames = ['Mark Attendance','Upload Event Photo'];
    List<String> students = [
      'event1',
      'event2',
      'event3',
      'event4',
      'event2',
      'event3',
      'event4'
    ];
    List<String> events = [
      'event1',
      'event2',
      'event3',
      'event4',
      'event2',
      'event3',
      'event4'
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
          bottom: TabBar(tabs: tabnames.map((title) => Text(title)).toList() ),
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                        color: const Color.fromARGB(255, 167, 47, 247),
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
                        color: const Color.fromARGB(255, 167, 47, 247),
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
