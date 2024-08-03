import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class WingPiechart extends StatefulWidget {
  const WingPiechart({super.key});

  @override
  State<WingPiechart> createState() => _WingPiechartState();
}

class _WingPiechartState extends State<WingPiechart> {

  @override
  Widget build(BuildContext context) {
    Map<String, double> wingmap = {};
    return Scaffold(
      appBar: AppBar(title: Text('Wing Activity'),),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
    
          if (snapshot.connectionState == ConnectionState.active) {
     
            
            for (var event in snapshot.data!.docs){
              
              if (!wingmap.containsKey(event['wing'])){
                wingmap[event['wing']] = event['hours'].toDouble();
              } else {
                wingmap[event['wing']] =
                    wingmap[event['wing']]! + event['hours'].toDouble();
              }
            }
            
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: PieChart(
                dataMap: wingmap,
                legendOptions: LegendOptions(legendPosition: LegendPosition.bottom),
              ),
            );
          }
          return const Text('helo');
        },
      ),
    );
  }
}
