import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nss_project/login_page.dart';
import 'package:nss_project/student_home_page.dart';

// ignore: camel_case_types
class signin_Gateway extends StatelessWidget
{
  const signin_Gateway({super.key});

   @override
    Widget build(BuildContext context)
    {
      return Scaffold(
        body:StreamBuilder<User?>(
          stream:FirebaseAuth.instance.authStateChanges(),
          builder:(context,snapshot)
          {
            if(snapshot.hasData)
            {return const StudentHomePage();}
            else
            {return const LoginPage();}
          }
          )
      );
    }

}