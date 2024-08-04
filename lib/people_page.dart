import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nss_project/sprofile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nss_project/newpic_homepage.dart';
import 'student_view_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PeoplePage extends StatefulWidget {
  final String userRole;
  const PeoplePage({super.key,required this.userRole});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {

  var tempvolunteerstream=FirebaseFirestore.instance.collection("users").where('role',isEqualTo: 'volunteer');
  var volunteerstream=FirebaseFirestore.instance.collection("users").where('role',isEqualTo: 'volunteer');

  Future openDialog()
  {
    TextEditingController searchcontroller=TextEditingController();
    return showDialog(context: context, builder: (context){return AlertDialog(
      title: const Text("Enter Roll Number"),
      content: SearchBar(controller: searchcontroller,),
      actions: [
        FloatingActionButton(child:const Text("Submit"),
        onPressed: (){setState(() {
          volunteerstream=volunteerstream.where('roll-number',isEqualTo: searchcontroller.text.trim().toUpperCase());
          Navigator.pop(context);
        });}
        )
      ],
    );});
  }

  @override
  Widget build(BuildContext context) {
    String mentorname = "Pranjal";
    //double width = MediaQuery.sizeOf(context).width;
    //double height = MediaQuery.sizeOf(context).height;
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.search),
          onPressed:(){
          openDialog();
        },),
        appBar: AppBar(
          title: Text('Hey $mentorname'),
          actions: <Widget>[
            
            IconButton(onPressed:(){setState(() {
              volunteerstream=tempvolunteerstream;
            });}, 
            icon: const Icon(Icons.refresh)
            ),

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
          bottom: const TabBar(tabs: [Tab(text: 'Students'),Tab(text: 'Mentors'),Tab(text: 'Secretary',)],labelStyle: TextStyle(fontSize: 22
          ,height: 1.8),),
        ),
        body: Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: TabBarView(
            children: <Widget>[
              StreamBuilder(stream: volunteerstream.snapshots(), 
              builder: (context,snapshot){
                if(!snapshot.hasData){
                  return const Center(child: Text("Loading"));
                }
                
                List<QueryDocumentSnapshot<Map<String, dynamic>>> stdlist = 
                [for (var i in snapshot.data!.docs) i];
                return ListView.builder(itemCount: stdlist.length,
                itemBuilder: (context,index){
                  return _buildPerson(stdlist[index],widget.userRole,context);
                }
                );
              }),

              StreamBuilder(stream: FirebaseFirestore.instance.collection("users").where('role',isEqualTo: 'mentor').snapshots(), 
              builder: (context,snapshot){
                if(!snapshot.hasData){
                  return const Text('Hello Darkness my ..');
                }

                List<QueryDocumentSnapshot<Map<String, dynamic>>> stdlist = 
                [for (var i in snapshot.data!.docs) i];
                return ListView.builder(itemCount: stdlist.length,
                itemBuilder: (context,index){
                  return _buildPerson(stdlist[index],widget.userRole,context);
                }
          );}),


              StreamBuilder(stream: FirebaseFirestore.instance.collection("users").where('role',isEqualTo: 'secretary').snapshots(), 
              builder: (context,snapshot){
                if(snapshot.hasData){
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> stdlist = 
                  [for (var i in snapshot.data!.docs) i]; // FIX CAUSE DEV IS A ASSHOLE  if(i['first name'] != 'dev') if(i['role'] == 'mentor')
                  //print(stdlist.length);
                  return ListView.builder(itemCount: stdlist.length,
                  itemBuilder: (context,index){
                    return _buildPerson(stdlist[index],widget.userRole,context);
                  }
                  );
                }
                return const Text('Hello Darkness my ..');

              }),
            ],
          ),
        ),
      ),
    );
  }

}

Widget _buildPerson(QueryDocumentSnapshot<Map<String, dynamic>> person, String userRole ,BuildContext context){

  final screenwidth=MediaQuery.sizeOf(context).width;

  return Padding(
    padding: const EdgeInsets.fromLTRB(0,5,0,5),
    child: SizedBox(
      height:300,
      child: InkWell(
        onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => StudentViewPage(person: person)));
            },
        child: Card(
          elevation: 0.5,
          color: Colors.white70,
          child: 
          Column(children: 
          [
            Container(
            width: screenwidth,
            height: 200,
            color: (person['role']=='volunteer')?Colors.blue:((person['role']=='mentor'))?Colors.red:Color.fromARGB(255, 255, 204, 1),
            child:Icon(Icons.account_circle,size: 50,color: Colors.white,) ,
            ),
        
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(getCapitalizedName(person['full-name']),style:const TextStyle(fontWeight: FontWeight.w600,fontSize: 22),),
            ),
        
             Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text('${person['roll-number']}',style:const TextStyle(fontSize: 18,color: Color.fromARGB(201, 119, 109, 109)),),
            )
          ],)
        ),
      ),
    ),
  );
}

String getCapitalizedName(String name){
  String ret = '';
  bool doCap = true;
    for(int i = 0;i<name.length;i++){
      if(doCap){
        ret = ret + name[i].toUpperCase();
        doCap = false;
      }
      else{
        ret = ret + name[i];
        if(name[i] == ' '){
        doCap = true;
        }
      }
    }
  return ret;
}
