import 'package:flutter/material.dart';

class NewEvent extends StatefulWidget
{
  NewEvent({super.key});

  @override 
  State createState()
  {
    return New_Event_State();
  }
}

class New_Event_State extends State<NewEvent>
{
  @override 
  Widget build(BuildContext context)
  {

    TextEditingController namecontroller=TextEditingController(text:"Title");

    final width=MediaQuery.sizeOf(context).width;
    final height=MediaQuery.sizeOf(context).height;

    return Scaffold(
    appBar: AppBar(
      backgroundColor: const Color.fromARGB(255, 127, 112, 180),
      title:TextField(controller:namecontroller,style: TextStyle(color: Colors.white),)
    ),
    body:const Center(
      child:Column(
        ) 
        )
  );
  }
}