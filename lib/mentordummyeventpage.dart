import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:nss_project/qr_page.dart';

class MentorDummyEventPage extends StatefulWidget
{
  final QueryDocumentSnapshot document;
  const MentorDummyEventPage({super.key,required this.document});
  @override
  State createState()
  {
    return DummyEventPageState();
  }
}

class DummyEventPageState extends State<MentorDummyEventPage>
{

  void updateHours(String ?userID,QueryDocumentSnapshot eventdocument) async
  {
     List registeredevents=await FirebaseFirestore.instance.collection('users').doc(userID).get().then((snapshot){return snapshot.get('attended-events');});
     if(!(registeredevents.contains(eventdocument.id)))
     {
     await FirebaseFirestore.instance.collection('events').doc(eventdocument.id).update({"registered-volunteers":FieldValue.arrayUnion([userID])});
     await FirebaseFirestore.instance.collection('users').doc(userID).update({"sem-1-hours":FieldValue.increment(await FirebaseFirestore.instance.collection('events').doc(eventdocument.id).get().then((snapshot){return snapshot['hours'];}))});
     await FirebaseFirestore.instance.collection('users').doc(userID).update({"attended-events":FieldValue.arrayUnion([eventdocument.id])});
     }
  }

  // ignore: non_constant_identifier_names
  Future ScanQr(QueryDocumentSnapshot eventdocument) async
  {
    // ignore: non_constant_identifier_names
    String QrResult;
    String ?userID;
    QrResult=await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
    await FirebaseFirestore.instance.collection('users').where('roll-number',isEqualTo:QrResult).get().then((snapshot){snapshot.docs.forEach((document){userID=document.id;});});
    updateHours(userID,eventdocument);
  }

@override 
Widget build(BuildContext context)
{
  final width=MediaQuery.sizeOf(context).width;
  final height=MediaQuery.sizeOf(context).height;

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} "
           "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  return Scaffold(
    appBar: AppBar(
      backgroundColor: const Color.fromARGB(255, 127, 112, 180),
      title:Text(widget.document['title'],style: const TextStyle(color: Colors.white),)
    ),
    body:Center(
      child:Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: SizedBox(
              width: width-50,
              height:height/3,
              child:Card(
                color:const Color.fromARGB(146, 70, 239, 78),
                child: Center(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(widget.document['description'],style:const TextStyle(color: Colors.white,fontSize: 20),),
                )),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(0, height/30, 0, 0),
            child: SizedBox(
              width: width-50,
              height:height/6,
              child:Card(
                color: Colors.lightBlue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text('Venue: ',style: TextStyle(fontWeight: FontWeight.bold,color: Color.fromARGB(255, 1, 88, 159),fontSize: 18),),
                        ),
                        
                        Text(widget.document['venue'],style:const TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 18))
                      ], 
                    ),

                    Row(
                      children: [
                        const Padding(
                          padding:  EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text('subtitle: ',style: TextStyle(fontWeight: FontWeight.bold,color: Color.fromARGB(255, 1, 88, 159),fontSize: 18)),
                        ),

                        Text(widget.document['subtitle'],style:const TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 18))
                      ],
                    ),

                    Row(
                      children: [
                        const Padding(
                          padding:  EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text('Time: ',style: TextStyle(fontWeight: FontWeight.bold,color: Color.fromARGB(255, 1, 88, 159),fontSize: 18)),
                        ),Text(_formatDateTime(widget.document['timestamp'].toDate()),style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 18))
                      ], 
                    ),

                  ],
                ),
              )
            ),
          ),


            Padding(
            padding: EdgeInsets.fromLTRB(width/2,height/30,0,0),
            child: Container(
              width: width/3,
              height: height/15,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(50),
                ),
              child: Center(child: Text('${widget.document['hours'].toString()} hours',style:const TextStyle(color: Color.fromARGB(255, 255, 237, 43),fontWeight: FontWeight.bold,fontSize: 15),)),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(0, height/15, 0, 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 130, 252, 134),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FloatingActionButton.extended(onPressed: (){ScanQr(widget.document);}, label:const Text("Scan QR for Attendance"),backgroundColor:const Color.fromARGB(255, 247, 253, 245),elevation: 0,),
              )
              ),
          ),
        ],
        ) 
        )
  );
}

}