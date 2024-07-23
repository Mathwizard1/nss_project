import 'package:flutter/material.dart';
import 'package:nss_project/login_page.dart';
import 'package:nss_project/role_page.dart';
import 'package:nss_project/signup_page.dart';


class EntryPage extends StatefulWidget
{
  const EntryPage({super.key});

  @override

  State createState()
  {
    return WelcomePage();
  }
}


class WelcomePage extends State
{

  @override
  Widget build(BuildContext context)
  {
    double height=MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor:Colors.white,   
      body:Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            SizedBox
            (
              width:400,
              height:300,
              child:Image.asset('assets/images/nss_logo.png')
            ),


            const Text("National Social Service",style:TextStyle(fontSize: 30,color: Color.fromARGB(255, 243, 118, 41),fontWeight: FontWeight.bold)),
            const Text("IIT Patna",style:TextStyle(color: Colors.blue,fontSize: 30,fontWeight: FontWeight.bold)),

            Padding( 
            padding:EdgeInsets.fromLTRB(0, height/4, 0, 0),
            child:FractionallySizedBox(
              widthFactor: 0.89,
            child:TextButton(
              style:const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 54, 28, 129)),
                foregroundColor:WidgetStatePropertyAll(Colors.white),
              ),
              onPressed:()=>{Navigator.push(context,MaterialPageRoute(builder:(context) => const LoginPage())),Navigator.push(context,MaterialPageRoute(builder:(context) => const SignUpPage()))},
              child:const Text("Get Started"),
            )
            )
            ),
            ]
          )
      )
    );
  }
}


