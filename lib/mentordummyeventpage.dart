import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'date_time_formatter.dart';

class MentorDummyEventPage extends StatefulWidget {
  final QueryDocumentSnapshot document;
  const MentorDummyEventPage({super.key, required this.document});
  @override
  State createState() {
    return DummyEventPageState();
  }
}

int calculateDifferenceInMinutes(Timestamp firebaseTimestamp) {
  DateTime currentTime = DateTime.now();
  DateTime firebaseTime = firebaseTimestamp.toDate();

  // Calculate the difference in minutes
  int differenceInMinutes = currentTime.difference(firebaseTime).inMinutes;
  return differenceInMinutes;
}

class DummyEventPageState extends State<MentorDummyEventPage> {


  void updateHours(String? userId,String eventbuffer, QueryDocumentSnapshot eventdocument) async {
    List attendedevents = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((snapshot) {
      return snapshot.get('attended-events');
    });


    if (!(attendedevents.contains(eventdocument.id)&&eventbuffer==eventdocument.id)) {

      late final String semstatus;
      await FirebaseFirestore.instance.collection('configurables').doc('document').get().then((snapshot){if(snapshot['current-semester']==1){semstatus="sem-1-hours";}else{semstatus="sem-2-hours";} });
      
      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventdocument.id)
          .update({
        "attending-volunteers": FieldValue.arrayUnion([userId])
      });
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        "attended-events": FieldValue.arrayUnion([eventdocument.id]),
        semstatus: FieldValue.increment(eventdocument.get('hours')),
      });
    }
  }

  // ignore: non_constant_identifier_names
  Future ScanQr(QueryDocumentSnapshot eventdocument) async {
    // ignore: non_constant_identifier_names
    String QrResult;
    String? userId;
    QrResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.QR);

    late final int index;

    for(int x=0;x<QrResult.length;x++)
    {
      if(QrResult[x]=='~')
      {
        index=x;
      }
    }

    String rollbuffer=QrResult.substring(0,index);
    String eventbuffer=QrResult.substring(index+1);


    await FirebaseFirestore.instance
        .collection('users')
        .where('roll-number', isEqualTo: rollbuffer)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((document) {
        userId = document.id;
      });
    });

    debugPrint('${rollbuffer} $eventbuffer \n\n\n\n\n\n\n');
    updateHours(userId,eventbuffer, eventdocument);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 127, 112, 180),
            title: Text(
              widget.document['title'],
              style: const TextStyle(color: Colors.white),
            )),
        body: Center(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: SizedBox(
                width: width - 50,
                height: height / 3,
                child: Card(
                  color: const Color.fromARGB(146, 70, 239, 78),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.document['description'],
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, height / 30, 0, 0),
              child: SizedBox(
                  width: width - 50,
                  height: height / 6,
                  child: Card(
                    color: Colors.lightBlue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Text(
                                'Venue: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 1, 88, 159),
                                    fontSize: 18),
                              ),
                            ),
                            Text(widget.document['venue'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18))
                          ],
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Text('Time: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 1, 88, 159),
                                      fontSize: 18)),
                            ),
                            Text(
                                DateTimeFormatter.format(
                                    widget.document['timestamp'].toDate()),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18))
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(width / 2, height / 30, 0, 0),
              child: Container(
                width: width / 3,
                height: height / 15,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                    child: Text(
                  '${widget.document['hours'].toString()} hours',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 255, 237, 43),
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                )),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, height / 15, 0, 0),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 130, 252, 134),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        ScanQr(widget.document);
                      },
                      label: const Text("Scan QR for Attendance"),
                      backgroundColor: const Color.fromARGB(255, 247, 253, 245),
                      elevation: 0,
                    ),
                  )),
            ),
          ],
        )));
  }
}
