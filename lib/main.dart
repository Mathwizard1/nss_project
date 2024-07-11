import 'package:flutter/material.dart';
import './login_page.dart';

void main()
{
  runApp(const MainApp());
}

class MainApp extends StatelessWidget
{

  const MainApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return const MaterialApp(
      title:"National Social Service",
      color:Colors.blue,
      home:EntryPage()
    );
  }
}