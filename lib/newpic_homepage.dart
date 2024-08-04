import 'package:flutter/material.dart';
import 'package:nss_project/event_add_page.dart';

import 'package:nss_project/people_page.dart';
import 'package:nss_project/picprofile_page.dart';
import 'package:nss_project/wing_piechart.dart';
import 'package:nss_project/pic_event_list.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewpicHomepage extends StatefulWidget {
  const NewpicHomepage({super.key});

  @override
  State<NewpicHomepage> createState() => _NewpicHomepageState();
}

class _NewpicHomepageState extends State<NewpicHomepage> {
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    //double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pic Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => const PicProfilePage()));
            },
          ),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.exit_to_app)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Row(
              children: [
                SizedBox(
                width: width/2 - 15,
                height: width/2 -15,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 191, 193, 189)), shape: WidgetStateProperty.all(const ContinuousRectangleBorder())),
                  onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => const PicEventList()));
                  },
                  child: Icon(Icons.list_alt,size: width/3,color: const Color.fromARGB(255, 59, 62, 61),),
                ),
              ),
                const SizedBox(width: 10,),
                SizedBox(
                width: width/2 - 15,
                height: width/2 -15,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 191, 193, 189)), shape: WidgetStateProperty.all(const ContinuousRectangleBorder())),
                  onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => const EventPage()));
                  },
                  child: Icon(Icons.format_list_bulleted_add,size: width/3,color: const Color.fromARGB(255, 59, 62, 61),),
                ),
              )
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                SizedBox(
                width: width/2 - 15,
                height: width/2 -15,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 155, 169, 215)), shape: WidgetStateProperty.all(const ContinuousRectangleBorder())),
                  onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => const PeoplePage(userRole: "pic",)));
                  },
                  child: Icon(Icons.person,size: width/3,color: const Color.fromARGB(255, 80, 80, 200),),
                ),
              ),
                const SizedBox (width: 10,),
                SizedBox(
                width: width/2 - 15,
                height: width/2 -15,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 19, 119, 45)), shape: WidgetStateProperty.all(const ContinuousRectangleBorder())),
                  onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => const WingPiechart()));
                  },
                  child: Icon(Icons.pie_chart,size: width/3,color: const Color.fromARGB(255, 100, 255, 165),),
                ),
              )
              ],
            ),
            const SizedBox(height: 10,),
            
            
          ],),
      )
    );
  }
}