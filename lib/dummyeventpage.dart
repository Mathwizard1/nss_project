import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nss_project/qr_page.dart';

class DummyEventPage extends StatefulWidget
{
  final QueryDocumentSnapshot document;
  final AsyncSnapshot userSnapshot;
  const DummyEventPage({super.key,required this.document,required this.userSnapshot});
  @override
  State createState()
  {
    return DummyEventPageState();
  }
}

class DummyEventPageState extends State<DummyEventPage>
{

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
                        ),Text(widget.document['subtitle'], style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 18))
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
                child: FloatingActionButton.extended(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context){return qr_code(eventdocument:widget.document,userSnapshot:widget.userSnapshot);}));}, label:const Text("Register For Event"),backgroundColor:const Color.fromARGB(255, 247, 253, 245),elevation: 0,),
              )
              ),
          ),
        ],
        ) 
        )
  );
}

}