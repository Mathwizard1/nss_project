import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nss_project/entry_gateway.dart';
import 'package:nss_project/student_home_page.dart';

// ignore: camel_case_types
class main_Gateway extends StatelessWidget
{
  const main_Gateway({super.key});

   @override
    Widget build(BuildContext context)
    {
      return StreamBuilder<User?>(
          stream:FirebaseAuth.instance.authStateChanges(),
          builder:(context,snapshot)
          {
            if(snapshot.hasData)
            {return const StudentHomePage();}
            else
            {return const entry_Gateway();}
          }
          );
    }

}