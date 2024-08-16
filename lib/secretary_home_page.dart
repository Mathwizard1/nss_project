import 'package:flutter/material.dart';

import 'package:nss_project/sprofile_page.dart';

import 'sec_event_page.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SecretaryHomePage extends StatefulWidget {
  final String wing;
  const SecretaryHomePage({super.key, required this.wing});

  @override
  State<SecretaryHomePage> createState() => _SecretaryHomePageState();
}

class _SecretaryHomePageState extends State<SecretaryHomePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Secretary View'),
        ),
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Row(
              children: [
                SizedBox(
                  width: width / 2 - 15,
                  height: width / 2 - 15,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            Color.fromARGB(255, 227, 227, 227)),
                        shape: WidgetStateProperty.all(
                            const ContinuousRectangleBorder())),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SecEventPage(
                                  wing: widget.wing,
                                  recurring:
                                      "Non Recurring"))); // PAGE ADD HERE
                    },
                    child: Icon(
                      Icons.event,
                      size: width / 3,
                      color: const Color.fromARGB(255, 59, 62, 61),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: width / 2 - 15,
                  height: width / 2 - 15,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            const Color.fromARGB(255, 227, 227, 227)),
                        shape: WidgetStateProperty.all(
                            const ContinuousRectangleBorder())),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SecEventPage(
                                  wing: widget.wing,
                                  recurring: "Recurring"))); // PAGE ADD HEre
                    },
                    child: Icon(
                      Icons.event_repeat_outlined,
                      size: width / 3,
                      color: const Color.fromARGB(255, 59, 62, 61),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
