import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nss_project/student_home_page.dart';
import 'onboarding_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget
{

  const MainApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title:"National Social Service",
      color:Colors.blue,
      home:StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), 
      builder: (context,snapshot)
      {
        if(!snapshot.hasData)
        {return const EntryPage();}
        else
        {return const StudentHomePage();}
      }
      )
    );
  }
}