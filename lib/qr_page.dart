import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class qr_code extends StatefulWidget
{
  final AsyncSnapshot userSnapshot;
  final QueryDocumentSnapshot eventdocument;
  const qr_code({super.key,required this.userSnapshot,required this.eventdocument});

  @override 
  State createState()
  {
    return qrcodeState();
  }
}

class qrcodeState extends State<qr_code>
{

  var backgroundcolor=const Color.fromARGB(255, 246, 65, 52);

  @override 
  Widget build(BuildContext context)
  {
    final screenwidth=MediaQuery.sizeOf(context).width;
    final screenheight=MediaQuery.sizeOf(context).height;

    return Scaffold(
      body:Center(child: Stack(
        children: [
          
          Center(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').where('attended-events',arrayContains:widget.eventdocument.id).snapshots(),
              builder: (context, snapshot) {
                for(var x in snapshot.data!.docs)
                {
                  if(x.get('roll-number')==widget.userSnapshot.data!['roll-number'])
                  {
                    setState(() {
                      backgroundcolor=const Color.fromARGB(255, 79, 236, 84);
                    });
                  }
                }

                return AnimatedContainer(
                  decoration: BoxDecoration(shape:BoxShape.rectangle,color: backgroundcolor),
                  width:screenwidth,
                  height:screenheight,
                duration:const Duration(seconds: 1),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
                    child: Opacity(opacity:1,child: IconButton(icon: const Icon(Icons.arrow_back),onPressed: (){Navigator.pop(context);},iconSize: 30,)),
                  )
                  ),
                );
              }
            ),
          ), 


          Center(
            child: Container(
            width:screenwidth/2,
            height:screenwidth/2,
            color: Colors.white,
            child: QrImageView(data: widget.userSnapshot.data!['roll-number'])
              ),
          )
          ],
      )
    )
    );
  }
}

