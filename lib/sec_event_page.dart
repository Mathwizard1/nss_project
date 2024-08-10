import 'package:flutter/material.dart';

import 'package:nss_project/date_time_formatter.dart';

import 'package:nss_project/event_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SecEventPage extends StatefulWidget {
  final String wing;
  final String recurring;
  const SecEventPage({super.key, required this.wing, required this.recurring});

  @override
  SecEventPageState createState() => SecEventPageState();
}

class SecEventPageState extends State<SecEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recurring + " Events"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                      .collection("events")
                      .where('wing', isEqualTo: widget.wing).where('recurring', isEqualTo: widget.recurring)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Flexible(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return _buildEvent(snapshot.data!.docs[index],
                              context, widget.recurring);
                        }),
                  );
                }
                return const Text('Working');
              }),
        ],
      ),
    );
  }
}

Widget _buildEvent(QueryDocumentSnapshot<Map<String, dynamic>> event,
    BuildContext context, String recurr) {
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DisplayEventPage(
                              document: event,
                              selectedRole: (recurr == "Non Recurring")? "secretary" : "secretary_edit",
                            )));
            },
          ),
        );
      });
}
