import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'welcome_page.dart';
import 'student_home_page.dart';
import 'mentor_home_page.dart';
import 'newpic_homepage.dart';
import 'secretary_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Stream<DocumentSnapshot> userDocumentSnapshotOnRoleChange(
      Stream<DocumentSnapshot> userDocumentStream) async* {
    String currentUserRole = '';
    await for (final document in userDocumentStream) {
      if (document['role'] != currentUserRole) {
        currentUserRole = document['role'];
        yield document;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "National Social Service",
      color: Colors.blue,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            case ConnectionState.active:
              if (snapshot.data == null) {
                return const WelcomePage();
              }

              return StreamBuilder(
                stream: userDocumentSnapshotOnRoleChange(FirebaseFirestore
                    .instance
                    .collection('users')
                    .doc(snapshot.data!.uid)
                    .snapshots()),
                builder: (context, snapshot) {
                  // Don't need to switch here as there isn't any ambiguity as to where the null arises from
                  if (!snapshot.hasData) {
                    return const Scaffold(
                        body: Center(child: CircularProgressIndicator()));
                  }

                  switch (snapshot.data!['role']) {
                    case 'volunteer':
                      return const StudentHomePage(); // TODO rename to VolunteerHomePage
                    case 'mentor':
                      return MentorHomePage(role: snapshot.data!['role']);
                    case 'secretary':
                      return SecretaryHomePage(wing: snapshot.data!['wing']);
                    case 'pic':
                      return const NewpicHomepage();
                    default:
                      return const Center(
                          child: Text(
                              'Error: Unknown user role')); // TODO error page
                  }
                },
              );

            case ConnectionState.done:
              return const Center(
                  child: Text(
                      'Error: FirebaseAuth unexpectedly closed connection')); // TODO error page
          }
        },
      ),
    );
  }
}
