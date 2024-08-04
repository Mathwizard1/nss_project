import 'package:flutter/material.dart';
import 'package:nss_project/sprofile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:io';

class StudentViewPage extends StatefulWidget {
  const StudentViewPage({super.key,required this.person});
  final QueryDocumentSnapshot<Map<String, dynamic>> person;
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
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('configurables').doc('document').snapshots(),
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                ClipRRect(
                        borderRadius: BorderRadius.circular(width),
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(
                          'assets/images/defaultprofilepic.jpg',
                          width: width / 3.3,
                          height: width / 3.3,
                        )),
                Center(
                  child: SizedBox(
                    width: width/1.1,
                    child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: RichText(
                                textAlign: TextAlign.center,
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
                  ),
                ),
                    const SizedBox(
                      height: 30,
                    ),
                (widget.person['role'] == 'volunteer') ? RichText(
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
                            fontSize: 110.0,
                            color: Color.fromRGBO(200, 150, 82, 1)),
                      ),
                      const TextSpan(text: '/', style: TextStyle(fontSize: 33.0)),
                      TextSpan(
                          text: '${(snapshot.data!['mandatory-hours'])/2}',
                          style: const TextStyle(
                              fontSize: 33.0, color: Colors.lightBlueAccent)),
                    ])) : const SizedBox(height: 20,),
                SizedBox(
                  height: height / 8,
                ),
                (widget.person['role'] == 'volunteer') ? RichText(
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
                            fontSize: 110.0, color: Colors.deepPurple[300]),
                      ),
                      const TextSpan(text: '/', style: TextStyle(fontSize: 33.0)),
                      TextSpan(
                          text: '${(snapshot.data!['mandatory-hours'])/2}',
                          style: const TextStyle(
                              fontSize: 33.0, color: Colors.lightBlueAccent)),
                    ])) : const SizedBox(height: 20,),
                    SizedBox(height: 20,),
                    SizedBox(
                      width: width/1.3,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('roles').snapshots(),
                        builder:(context,snaphot){
                          List<String> roles = ['secretary','mentor','volunteer'];

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
                    ),
                      SizedBox(
                        width: width /1.3,
                        child: Card.outlined(
                          clipBehavior: Clip.hardEdge,
                          child: ListTile(
                            tileColor: Colors.green,
                            title: const Center (child: Text('Change Role')),
                            onTap: () {
                              setState(() async {
                                if(rolechange  == 'volunteer' || rolechange == 'mentor'){
                                  FirebaseFirestore.instance.collection('users').doc(widget.person.id).update({"role": rolechange}).then(
                                  (value) => print("DocumentSnapshot successfully updated!"),
                                  onError: (e) => print("Error updating document $e"));
                                }
                                if(rolechange == 'secretary'){
                                  DocumentSnapshot<Map<String, dynamic>> wings = await FirebaseFirestore.instance.collection('configurables').doc('document').get();
                                  QuerySnapshot<Map<String, dynamic>> secs = await FirebaseFirestore.instance.collection('users').where('role',isEqualTo:'secretary').get();
                                  List<String> w = [];
                                  for(var x in wings.data()!['wings']){
                                    w.add(x);
                                  }
                                  for(var x in secs.docs){
                                    w.remove(x['wing']);
                                  }
                                  String? _newsecwing;
                                  showDialog(context: context, builder:(BuildContext context){
                                    return AlertDialog(
                                      title: const Text('Choose Wing'),
                                      content: ListView.builder(
                                        itemCount: w.length,
                                        itemBuilder: (context, index) => RadioListTile(title: Text(w[index]),value: w[index], groupValue: _newsecwing, onChanged: (String? value) {
                                          setState(() {
                                            _newsecwing = value;
                                          });
                                        }),
                                      ),
                                      actions: [
                                        TextButton(onPressed: (){
                                          if(_newsecwing != null){
                                             FirebaseFirestore.instance.collection('users').doc(widget.person.id).update({"role": rolechange,"wing": _newsecwing}).then(
                                              (value) => print("DocumentSnapshot successfully updated!"),
                                              onError: (e) => print("Error updating document $e"));

                                          }
                                         Navigator.pop(context);
                                        }, child: const Text('confirm'))
                                      ],
                                    );
                                  });

                                }

                              });
                            },
                          ),
                        ),
                      )
              ],
            );
          }
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