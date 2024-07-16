import 'package:flutter/material.dart';
import 'package:nss_project/sprofile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'student_view_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MaterialApp(
    home: PeoplePage(),
  ));
}

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  @override
  Widget build(BuildContext context) {
    String mentorname = "Pranjal";
    //double width = MediaQuery.sizeOf(context).width;
    //double height = MediaQuery.sizeOf(context).height;
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hey $mentorname'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
              },
            ),

            // SIGN OUT DOES NOT WORK

            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.exit_to_app)),
          ],
          bottom: const TabBar(tabs: [Tab(text: 'students'),Tab(text: 'mentors')]),
        ),
        body: Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: TabBarView(
            children: <Widget>[
              StreamBuilder(stream: FirebaseFirestore.instance.collection("users").snapshots(), 
              builder: (context,snapshot){
                if(snapshot.hasData){
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> stdlist = 
                  [for (var i in snapshot.data!.docs) if(i['first name'] != 'dev') if(i['role'] == 'volunteer') i];   // FIX CAUSE DEV IS A ASSHOLE
                  //print(stdlist.length);
                  return ListView.builder(itemCount: stdlist.length,
                  itemBuilder: (context,index){
                    return _buildPerson(stdlist[index],context);
                  }
                  );
                }
                return const Text('Hello Darkness my ..');
              }),
              StreamBuilder(stream: FirebaseFirestore.instance.collection("users").snapshots(), 
              builder: (context,snapshot){
                if(snapshot.hasData){
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> stdlist = 
                  [for (var i in snapshot.data!.docs) if(i['first name'] != 'dev') if(i['role'] == 'mentor') i];   // FIX CAUSE DEV IS A ASSHOLE
                  //print(stdlist.length);
                  return ListView.builder(itemCount: stdlist.length,
                  itemBuilder: (context,index){
                    return _buildPerson(stdlist[index],context);
                  }
                  );
                }
                return const Text('Hello Darkness my ..');
              })

            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildPerson(QueryDocumentSnapshot<Map<String, dynamic>> person,BuildContext context){
  return Card(
    elevation: 0.5,
    color: Colors.white70,
    child: ListTile(
      horizontalTitleGap: 16,
      leading: Icon(Icons.account_circle,size: 50,),
      title: Text('${(person['first name']).substring(0,1).toUpperCase()}${person['first name'].substring(1,)} ${(person['last name']).substring(0,1).toUpperCase()}${person['last name'].substring(1,)}',style:const TextStyle(fontWeight: FontWeight.w600,fontSize: 22),),
      subtitle: Text('${person['roll number']}',style:const TextStyle(fontSize: 14),),
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context) => StudentViewPage(person: person)));
      },
    ),
  );
}
