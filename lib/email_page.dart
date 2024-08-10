import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'date_time_formatter.dart';

class EmailSender extends StatefulWidget {
  final QueryDocumentSnapshot document;

  const EmailSender({super.key, required this.document});

  @override
  EmailSenderState createState() => EmailSenderState();
}

class EmailSenderState extends State<EmailSender> {

  late TextEditingController _recipientController;
  late TextEditingController _subjectController;
  late TextEditingController _bodyController;

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: (_recipientController.text).split(','),
      isHTML: false,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  String getEmailid() {
    return 'anshurup.gupta@gmail.com,tejeshwarsingh1205@gmail.com';
    //return 'pic_nss@iitp.ac.in,nss_gen_sec@iitp.ac.in';
  }

  String generateHtmlEmailBody() {
    return '''
    respected sir/ma'am,
We have successfully completed the event ${widget.document['title']}.
This event was conducted by ${widget.document['wing']} wing. It was conducted on ${DateTimeFormatter.format(widget.document['timestamp'].toDate())} in ${widget.document['venue']}.

  students registered: ${widget.document['registered-volunteers'].length}
  students attended: ${widget.document['attending-volunteers'].length}
  hours given: ${widget.document['hours']}

The event objective was:
  ${widget.document['description']}

Please check the events photos.
  Thank you
  ''';
  }

  @override
  void initState() {
    super.initState();
    initEdit();
  }

  void initEdit() {
    _subjectController =
        TextEditingController(text: 'Report on ${widget.document['title']}');

    _bodyController = TextEditingController(text: generateHtmlEmailBody());
    _recipientController = TextEditingController(text: getEmailid());
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _recipientController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Page'),
        actions: <Widget>[
          IconButton(
            onPressed: send,
            icon: const Icon(Icons.send),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _recipientController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Recipient',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Subject',
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _bodyController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                      labelText: 'Body', border: OutlineInputBorder()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
