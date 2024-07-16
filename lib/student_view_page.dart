import 'package:flutter/material.dart';
import 'package:nss_project/sprofile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:io';

class StudentViewPage extends StatefulWidget {
  const StudentViewPage({super.key, required this.person});
  final QueryDocumentSnapshot<Map<String, dynamic>> person;
  @override
  State<StudentViewPage> createState() => _StudentViewPageState();
}

class _StudentViewPageState extends State<StudentViewPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Student View'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
          ),

          // SIGN OUT DOES NOT WORK

          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.exit_to_app)),
        ],
      ),
      body: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                const SizedBox(
                  width: 8,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RichText(
                      text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            height: 1.3,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    '${(widget.person['first name']).substring(0, 1).toUpperCase()}${widget.person['first name'].substring(
                                  1,
                                )} ${(widget.person['last name']).substring(0, 1).toUpperCase()}${widget.person['last name'].substring(
                                  1,
                                )}\n',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 26)),
                            TextSpan(
                              text: '${widget.person['roll number']}\n',
                            ),
                            TextSpan(text: '${widget.person['email']}'),
                          ]),
                    ),
                  ),
                ),
                Expanded(child: SizedBox()),
                ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      'assets/images/defaultprofilepic.jpg',
                      width: width / 3.3,
                      height: width / 3.3,
                    )),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
            SizedBox(
              height: height / 8,
            ),
            RichText(
                text: const TextSpan(
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        height: 0.7,
                        fontStyle: FontStyle.italic),
                    children: [
                  TextSpan(
                    text: 'sem1:\n',
                  ),
                  TextSpan(
                    text: '  16',
                    style: const TextStyle(
                        fontSize: 120.0,
                        color: const Color.fromRGBO(200, 150, 82, 1)),
                  ),
                  TextSpan(text: '/', style: TextStyle(fontSize: 33.0)),
                  TextSpan(
                      text: '40',
                      style: TextStyle(
                          fontSize: 33.0, color: Colors.lightBlueAccent)),
                ])),
            SizedBox(
              height: height / 8,
            ),
            RichText(
                text: TextSpan(
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        height: 0.7,
                        fontStyle: FontStyle.italic),
                    children: [
                  const TextSpan(
                    text: 'sem2:\n',
                  ),
                  TextSpan(
                    text: '  24',
                    style: TextStyle(
                        fontSize: 120.0, color: Colors.deepPurple[300]),
                  ),
                  const TextSpan(text: '/', style: TextStyle(fontSize: 33.0)),
                  const TextSpan(
                      text: '40',
                      style: TextStyle(
                          fontSize: 33.0, color: Colors.lightBlueAccent)),
                ])),
          ],
        ),
      ),
    );
  }
}
