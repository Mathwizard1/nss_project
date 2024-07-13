import 'package:flutter/material.dart';
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
    return const MaterialApp(
      debugShowCheckedModeBanner:false,
      title:"National Social Service",
      color:Colors.blue,
      home:EntryPage()
    );
  }
}