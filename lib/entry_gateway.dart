import 'package:flutter/material.dart';
import 'package:nss_project/login_page.dart';
import './signup_page.dart';


// ignore: camel_case_types
class entry_Gateway extends StatefulWidget
{
  const entry_Gateway({super.key});
  
  @override
  State createState()
  {
    return entry_GatewayState();
  }
}


// ignore: camel_case_types
class entry_GatewayState extends State
{
  bool showloginpage=true;

  void togglescreens()
  {
    setState((){showloginpage=!showloginpage;});
  }

  @override 
  Widget build(BuildContext context)
  {
    if(showloginpage)
    {
      return LoginPage(showregisterpage: togglescreens);
    }
    else
    {
      return SignUpPage(showloginpage: togglescreens,);
    }
    
  }
}