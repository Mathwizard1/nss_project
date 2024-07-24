import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class qr_code extends StatefulWidget
{
  final Stream userDocumentStream;
  const qr_code({super.key,required this.userDocumentStream});

  @override 
  State createState()
  {
    return qrcodeState();
  }
}

class qrcodeState extends State<qr_code>
{

  @override 
  Widget build(BuildContext context)
  {
    final width=MediaQuery.sizeOf(context).width;

    return Scaffold(
      body:StreamBuilder(
        stream: widget.userDocumentStream,
        builder:(context,snapshot)
        { 
          return Center(child: SizedBox(
            width:width/2,
            height:width/2,
            child: QrImageView(data: snapshot.data!['roll-number'])
            ));
        }
      )
    );
  }
}

