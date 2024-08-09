import 'package:flutter/material.dart';
import 'package:nss_project/sprofile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:io';


class SecretaryWingChangepage extends StatefulWidget {
  const SecretaryWingChangepage({super.key,required this.id});
  final String id;

  @override
  State<SecretaryWingChangepage> createState() => _SecretaryWingChangepageState();
}

class _SecretaryWingChangepageState extends State<SecretaryWingChangepage> {

  late Future<dynamic> wings;
  late Future<dynamic> secs;
  late Future<dynamic> complete;
  
  String? _newsecwing;

  void getSnaps() async{
    wings = FirebaseFirestore.instance.collection('configurables').doc('document').get();
    secs = FirebaseFirestore.instance.collection('users').where('role',isEqualTo:'secretary').get();
  }
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    getSnaps();
    complete = Future.wait([wings,secs]);
    
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).width;
    List<String> w = [];
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Select Wing'),),),
      body: Column(
        children: [
          FutureBuilder(future: complete, builder:(context, snapshot){
            if (!(snapshot.connectionState == ConnectionState.done && snapshot.hasData)){
              return CircularProgressIndicator();
            }
            for(var x in snapshot.data![0]!.data()!['wings']){
            w.add(x);
            }
            for(var x in snapshot.data![1]!.docs){
            w.remove(x['wing']);
    }
            return Flexible(
              child: ListView.builder(
                itemCount: w.length,
                itemBuilder: (context, index) => RadioListTile(title: Text(w[index]),value: w[index], groupValue: _newsecwing, onChanged: (String? value) {
                  setState(() {
                    _newsecwing = value;
                  });
                }),
              ),
            );
          },),
          SizedBox(
            width: width-20,
            child: Card.outlined(
              clipBehavior: Clip.hardEdge,
              child: ListTile(
                tileColor:  const Color.fromARGB(255, 8, 21, 125),
                title: const Center(child: Text('Change Role',style: TextStyle(color: Colors.white))),
                onTap: () {
                  FirebaseFirestore.instance.collection('users').doc(widget.id).update({"role": 'secretary',"wing": _newsecwing}).then(
                                              (value) => print("DocumentSnapshot successfully updated!"),
                                              onError: (e) => print("Error updating document $e"));
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

