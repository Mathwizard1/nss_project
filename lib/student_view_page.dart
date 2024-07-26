import 'package:flutter/material.dart';
import 'package:nss_project/sprofile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:io';

class StudentViewPage extends StatefulWidget {
  const StudentViewPage({super.key,required this.userRole ,required this.person});
  final QueryDocumentSnapshot<Map<String, dynamic>> person;
  final String userRole;
  @override
  State<StudentViewPage> createState() => _StudentViewPageState();
}

class _StudentViewPageState extends State<StudentViewPage> {
  String rolechange = 'volunteer';
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Student View'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
          ),

          // SIGN OUT DOES NOT WORK

          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.exit_to_app)),
        ],
      ),
      body: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                const SizedBox(
                  width: 8,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RichText(
                      text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            height: 1.3,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: getCapitalizedName(widget.person['full-name'] + '\n'),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 26)),
                            TextSpan(
                              text: '${widget.person['roll-number']}\n',
                            ),
                            TextSpan(text: '${widget.person['email']}'),
                          ]),
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      'assets/images/defaultprofilepic.jpg',
                      width: width / 3.3,
                      height: width / 3.3,
                    )),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
            SizedBox(
              height: height / 8,
            ),
            RichText(
                text: TextSpan(
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        height: 0.7,
                        fontStyle: FontStyle.italic),
                    children: [
                  const TextSpan(
                    text: 'sem1:\n',
                  ),
                  TextSpan(
                    text: '  ${widget.person['sem-1-hours']}',
                    style: const TextStyle(
                        fontSize: 120.0,
                        color: Color.fromRGBO(200, 150, 82, 1)),
                  ),
                  const TextSpan(text: '/', style: TextStyle(fontSize: 33.0)),
                  const TextSpan(
                      text: '40',
                      style: TextStyle(
                          fontSize: 33.0, color: Colors.lightBlueAccent)),
                ])),
            SizedBox(
              height: height / 8,
            ),
            RichText(
                text: TextSpan(
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        height: 0.7,
                        fontStyle: FontStyle.italic),
                    children: [
                  const TextSpan(
                    text: 'sem2:\n',
                  ),
                  TextSpan(
                    text: '  ${widget.person['sem-2-hours']}',
                    style: TextStyle(
                        fontSize: 120.0, color: Colors.deepPurple[300]),
                  ),
                  const TextSpan(text: '/', style: TextStyle(fontSize: 33.0)),
                  const TextSpan(
                      text: '40',
                      style: TextStyle(
                          fontSize: 33.0, color: Colors.lightBlueAccent)),
                ])),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('roles').snapshots(),
                  builder:(context,snaphot){
                    List<String> roles = ['pic','mentor'];
                    int i = roles.indexOf(widget.userRole);
              
                    for(int j = i;j>=0;j--){
                      roles.removeAt(j);
                    }
                    roles.add('volunteer');
                  
                    // ignore: non_constant_identifier_names
                    List<DropdownMenuEntry<String>> RoleEntries =
                      roles.map((option) => DropdownMenuEntry<String>(
                          value: option, label: option)).toList();
                    return DropdownMenu<String>(
                      initialSelection: 'volunteer',
                      requestFocusOnTap: false,
                      expandedInsets: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      textStyle: const TextStyle(color: Colors.white),
                      inputDecorationTheme: const InputDecorationTheme(
                      fillColor: Color.fromARGB(255, 128, 112, 185),
                      filled: true,
                      ),
                      label: const Text('role',style: TextStyle(color: Colors.white),),
                      onSelected: (String? role){setState(() {
                        if(role != null){
                          rolechange = role;
                        }
                      });},
                      dropdownMenuEntries: RoleEntries,
                    );
                  }),
                  ListTile(
                    tileColor: Colors.green,
                    onTap: () {
                      setState(() {
                        FirebaseFirestore.instance.collection('users').doc(widget.person.id).update({"role": rolechange}).then(
    (value) => print("DocumentSnapshot successfully updated!"),
    onError: (e) => print("Error updating document $e"));;
                      });
                    },
                  )
          ],
        ),
      ),
    );
  }
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