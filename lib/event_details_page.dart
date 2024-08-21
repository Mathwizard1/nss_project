import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'date_time_formatter.dart';
import 'qr_page.dart';

class EventDetailsPage extends StatefulWidget {
  final DocumentSnapshot eventSnapshot;
  final DocumentSnapshot userSnapshot;
  const EventDetailsPage(
      {super.key, required this.eventSnapshot, required this.userSnapshot});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  bool _hasRegistered = false;
  bool _hasMarkedAttendance = false;

  // Whether photo was uploaded before this page was init'ed
  Future<bool> _hasAlreadyUploaded = Future<bool>.value(false);

  final ImagePicker _imagePicker = ImagePicker();
  Stream<TaskSnapshot>? _uploadTaskSnapStream;

  late final DocumentSnapshot userDocSnap;
  late final DocumentSnapshot eventDocSnap;

  @override
  void initState() {
    super.initState();
    userDocSnap = widget.userSnapshot;
    eventDocSnap = widget.eventSnapshot;

    _hasRegistered = _isInRegisteredEvents(
        eventDocSnap: eventDocSnap, userDocSnap: userDocSnap);

    if (!_hasRegistered) {
      return;
    }

    _hasMarkedAttendance = _isInAttendedEvents(
        eventDocSnap: eventDocSnap, userDocSnap: userDocSnap);

    if (!_hasMarkedAttendance) {
      return;
    }

    _hasAlreadyUploaded = FirebaseStorage.instance
        .ref()
        .child(widget.eventSnapshot.id)
        .listAll()
        .then((listRes) {
      return listRes.items
          .map<String>((ref) => ref.name)
          .contains(FirebaseAuth.instance.currentUser!.uid);
    });
  }

  bool _isInRegisteredEvents(
      {required DocumentSnapshot eventDocSnap,
      required DocumentSnapshot userDocSnap}) {
    return userDocSnap['registered-events']
        .map<String>((dyn) {
          String ret = dyn;
          return ret;
        })
        .toList()
        .contains(widget.eventSnapshot.id);
  }

  bool _isInAttendedEvents(
      {required DocumentSnapshot eventDocSnap,
      required DocumentSnapshot userDocSnap}) {
    return userDocSnap['attended-events']
        .map<String>((dyn) {
          String ret = dyn;
          return ret;
        })
        .toList()
        .contains(widget.eventSnapshot.id);
  }

  Widget getPhotoUploadedWidget() {
    return const Card(
      color: Colors.green,
      child: ListTile(
        enabled: false,
        title: Center(
          child: Text('Photo Uploaded', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double appBarHeight = 0.075 * screenHeight;
    final double bottomPadding = 0.05 * screenHeight;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: appBarHeight,
        backgroundColor: Colors.deepPurple[300],
        title: Text(
          eventDocSnap['title'],
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SizedBox(
        height: screenHeight - appBarHeight - bottomPadding,
        child: Center(
          child: Column(
            children: <Widget>[
              Card.outlined(
                child: ListTile(
                  leading: const Icon(Icons.category),
                  title: const Text('Wing'),
                  subtitle: Text(eventDocSnap['wing']),
                  //trailing: Icon(), // TODO fix after unifying icondata and wings
                ),
              ),
              Card.outlined(
                child: ListTile(
                  leading: const Icon(Icons.hourglass_bottom),
                  title: const Text('Hours'),
                  subtitle: Text('${eventDocSnap['hours']}'),
                ),
              ),
              Card.outlined(
                child: ListTile(
                  leading: const Icon(Icons.event),
                  title: const Text('Date & Time'),
                  subtitle: Text(DateTimeFormatter.format(
                      eventDocSnap['timestamp'].toDate())),
                ),
              ),
              Card.outlined(
                child: ListTile(
                  leading: const Icon(Icons.place),
                  title: const Text('Venue'),
                  subtitle: Text(eventDocSnap['venue']),
                ),
              ),
              Expanded(
                child: Card.outlined(
                  child: ListTile(
                    leading: const Icon(Icons.description),
                    title: const Text('Description'),
                    subtitle: Text(eventDocSnap['description']),
                  ),
                ),
              ),
              Card(
                color: _hasRegistered ? Colors.green : Colors.deepPurple[300],
                child: ListTile(
                  title: Center(
                    child: _hasRegistered
                        ? const Text('Registered for Event',
                            style: TextStyle(color: Colors.white))
                        : const Text('Register for Event',
                            style: TextStyle(color: Colors.white)),
                  ),
                  enabled: !_hasRegistered,
                  onTap: () {
                    userDocSnap.reference.update({
                      'registered-events':
                          FieldValue.arrayUnion([eventDocSnap.id]),
                    }).then((value) => setState(() => _hasRegistered = true));

                    eventDocSnap.reference.update({
                      'registered-volunteers':
                          FieldValue.arrayUnion([userDocSnap.id]),
                    });
                  },
                ),
              ),
              Card(
                color: !_hasRegistered
                    ? Colors.grey
                    : _hasMarkedAttendance
                        ? Colors.green
                        : Colors.deepPurple[300],
                child: ListTile(
                  title: Center(
                    child: _hasMarkedAttendance
                        ? const Text('Attendance Marked',
                            style: TextStyle(color: Colors.white))
                        : const Text('Show Attendance QR',
                            style: TextStyle(color: Colors.white)),
                  ),
                  enabled: _hasRegistered && !_hasMarkedAttendance,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return QrPage(
                            oldEventDocSnap: eventDocSnap,
                            attendanceMarkedCallback: () =>
                                setState(() => _hasMarkedAttendance = true),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              !_hasMarkedAttendance
                  ? const Card(
                      color: Colors.grey,
                      child: ListTile(
                        enabled: false,
                        title: Center(
                          child: Text('Upload Photo',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    )
                  : FutureBuilder(
                      future: _hasAlreadyUploaded,
                      builder: (context, hasAlreadyUploadedSnap) {
                        if (!hasAlreadyUploadedSnap.hasData) {
                          return Card(
                            color: Colors.deepPurple[300],
                            child: const ListTile(
                              enabled: false,
                              title: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              ),
                            ),
                          );
                        }

                        if (hasAlreadyUploadedSnap.data!) {
                          return getPhotoUploadedWidget();
                        }

                        if (_uploadTaskSnapStream == null) {
                          return Card(
                            color: Colors.deepPurple[300],
                            child: ListTile(
                              title: const Center(
                                child: Text('Upload Photo',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              onTap: () async {
                                final XFile? image = (await _imagePicker
                                    .pickImage(source: ImageSource.gallery));

                                if (image == null) {
                                  return;
                                }

                                setState(() => _uploadTaskSnapStream =
                                    FirebaseStorage.instance
                                        .ref()
                                        .child(eventDocSnap.id)
                                        .child(userDocSnap.id)
                                        .putFile(File(image.path))
                                        .asStream());
                              },
                            ),
                          );
                        }

                        return StreamBuilder(
                          stream: _uploadTaskSnapStream,
                          builder: (context, uploadTaskSnap) {
                            if (uploadTaskSnap.connectionState ==
                                ConnectionState.done) {
                              return getPhotoUploadedWidget();
                            }

                            return Card(
                              color: Colors.deepPurple[300],
                              child: ListTile(
                                title: Center(
                                  child: (uploadTaskSnap.data == null)
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : CircularProgressIndicator.adaptive(
                                          valueColor:
                                              const AlwaysStoppedAnimation(
                                                  Colors.white),
                                          value: uploadTaskSnap
                                                  .data!.bytesTransferred
                                                  .toDouble() /
                                              uploadTaskSnap.data!.totalBytes
                                                  .toDouble(),
                                        ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
