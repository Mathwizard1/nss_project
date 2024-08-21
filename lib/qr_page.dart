import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrPage extends StatefulWidget {
  final DocumentSnapshot oldEventDocSnap;
  final VoidCallback attendanceMarkedCallback;
  const QrPage(
      {super.key,
      required this.oldEventDocSnap,
      required this.attendanceMarkedCallback});

  @override
  State createState() {
    return QrPageState();
  }
}

class QrPageState extends State<QrPage> {
  late final Stream<DocumentSnapshot> userDocSnapStream;

  @override
  void initState() {
    super.initState();
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
        .contains(widget.oldEventDocSnap.id);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;

    final double appBarHeight = 0.075 * screenHeight;

    return PopScope(
      onPopInvoked: (bool didPop) {
        if (didPop) {
          widget.attendanceMarkedCallback();
        }
      },
      child: StreamBuilder(
        stream: userDocSnapStream,
        builder: (context, userDocAsyncSnap) {
          if (!userDocAsyncSnap.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final DocumentSnapshot userDocSnap = userDocAsyncSnap.data!;

          late final Color bgColor;
          if (_hasMarkedAttendance(
              eventDocSnap: widget.oldEventDocSnap, userDocSnap: userDocSnap)) {
            bgColor = Colors.green;
          } else {
            bgColor = Colors.white;
          }

          return Scaffold(
            appBar: AppBar(
              toolbarHeight: appBarHeight,
              backgroundColor: Colors.deepPurple[400],
              title: Text(
                widget.oldEventDocSnap['title'],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            body: AnimatedContainer(
              duration: const Duration(seconds: 1),
              color: bgColor,
              child: Center(
                child: SizedBox(
                  width: screenWidth / 1.5,
                  height: screenWidth / 1.5,
                  child: QrImageView(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(0.05 * screenWidth),
                    data:
                        '${userDocSnap['roll-number']}~${widget.oldEventDocSnap.id}',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
