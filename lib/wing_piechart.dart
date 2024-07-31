import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pie_chart/pie_chart.dart';

class WingPiechart extends StatefulWidget {
  const WingPiechart({super.key});

  @override
  State<WingPiechart> createState() => _WingPiechartState();
}

class _WingPiechartState extends State<WingPiechart> {
  Map<String, double> wingmap = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
          if (snapshot.connectionState == ConnectionState.active) {
            print(snapshot.data!.docs.length);
            debugPrint("AAAAAAAAAAAAAAAAAAAA");
            for (var event in snapshot.data!.docs){
              print('CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC');
              if (!wingmap.containsKey(event['wing'])){
                wingmap[event['wing']] = event['hours'].toDouble();
              } else {
                wingmap[event['wing']] =
                    wingmap[event['wing']]! + event['hours'].toDouble();
              }
            }
            
            return PieChart(
              dataMap: wingmap,
            );
          }
          return const Text('helo');
        },
      ),
    );
  }
}
