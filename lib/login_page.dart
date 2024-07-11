import 'package:flutter/material.dart';


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

              const Text("Not Me But You",
              style:TextStyle(
                color:Color.fromARGB(255, 238, 103, 13),
                fontWeight: FontWeight.w400,
                fontSize: 17,
              ),
              ) ,

            Padding( 
            padding:EdgeInsets.fromLTRB(0, height/4, 0, 0),
            child:FractionallySizedBox(
              widthFactor: 0.89,
            child:TextButton(
              style:const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 54, 28, 129)),
                foregroundColor:WidgetStatePropertyAll(Colors.white),
              ),
              onPressed:()=>{Navigator.push(context,MaterialPageRoute(builder:(context) => const LoginPage(),))},
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


class LoginPage extends StatefulWidget
{
  const LoginPage({super.key});

  @override
    State createState()
    {
      return LoginPageState();
    }
}

class LoginPageState extends State
{
  @override
  Widget build(BuildContext context)
  {
    return const Scaffold(
      backgroundColor: Colors.white,
      body:Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[]
        )
      ),
    );
  }

}