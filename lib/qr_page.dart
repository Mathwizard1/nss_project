import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrPage extends StatefulWidget {
  final String eventDocId;
  const QrPage({super.key, required this.eventDocId});

  @override
  State createState() {
    return QrPageState();
  }
}

class QrPageState extends State<QrPage> {
  late final Stream<DocumentSnapshot> eventDocSnapStream;
  late final Stream<DocumentSnapshot> userDocSnapStream;

  @override
  void initState() {
    super.initState();
    eventDocSnapStream = FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventDocId)
        .snapshots();
    userDocSnapStream = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  bool _hasMarkedAttendance(
      {required DocumentSnapshot eventDocSnap,
      required DocumentSnapshot userDocSnap}) {
    return userDocSnap['attended-events']
        .map<String>((dyn) {
          String ret = dyn;
          return ret;
        })
        .toList()
        .contains(widget.eventDocId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userDocSnapStream,
      builder: (context, userDocAsyncSnap) {
        if (!userDocAsyncSnap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final DocumentSnapshot userDocSnap = userDocAsyncSnap.data!;

        return StreamBuilder(
          stream: eventDocSnapStream,
          builder: (context, eventDocAsyncSnap) {
            if (!eventDocAsyncSnap.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final DocumentSnapshot eventDocSnap = eventDocAsyncSnap.data!;

            final double screenHeight = MediaQuery.sizeOf(context).height;
            final double screenWidth = MediaQuery.sizeOf(context).width;

            final double appBarHeight = 0.075 * screenHeight;

            return Scaffold(
              appBar: AppBar(
                toolbarHeight: appBarHeight,
                backgroundColor: Colors.deepPurple[400],
                title: Text(
                  eventDocSnap['title'],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              body: AnimatedContainer(
                duration: const Duration(seconds: 1),
                color: _hasMarkedAttendance(
                        eventDocSnap: eventDocSnap, userDocSnap: userDocSnap)
                    ? Colors.green
                    : Colors.white,
                child: Center(
                  child: SizedBox(
                    width:screenWidth/1.5,
                    height:screenWidth/1.5,
                    child: QrImageView(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.all(0.05 * screenWidth),
                      data: '${userDocSnap['roll-number']}~${eventDocSnap.id}',
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
