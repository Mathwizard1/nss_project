import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:nss_project/event_details_page.dart';
import 'package:nss_project/sprofile_page.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'date_time_formatter.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  StudentHomePageState createState() => StudentHomePageState();
}

int calculateDifferenceInMinutes(Timestamp firebaseTimestamp) {
  DateTime currentTime = DateTime.now();
  DateTime firebaseTime = firebaseTimestamp.toDate();

  // Calculate the difference in minutes
  int differenceInMinutes = currentTime.difference(firebaseTime).inMinutes;
  return differenceInMinutes;
}

class StudentHomePageState extends State<StudentHomePage>
    with SingleTickerProviderStateMixin {
  late final DocumentSnapshot userDocumentSnapshot;
  late final DocumentSnapshot configurablesSnapshot;
  late final Future eventStream;
  late final Future icondataStream;
  late TabController _tabController;

  bool initialized=false;


  void inititalize() async{
     userDocumentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    configurablesSnapshot=await FirebaseFirestore.instance.collection("configurables").doc('document').get();

    eventStream=FirebaseFirestore.instance.collection('events').orderBy('timestamp', descending: true).get();

    icondataStream=FirebaseFirestore.instance.collection('icondata').get();

    setState(() {initialized=true;});

  }

  @override
  void initState() {
    super.initState();
    inititalize();

    _tabController = TabController(length: 3, vsync: this);
  }




  /*@override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  */

  @override
  Widget build(BuildContext context) {
    
    if(initialized==false)
    {
      return Scaffold(body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                child: const CircularProgressIndicator()),
            ],
          ),
        ],
      ));
    }
    else {
      return Scaffold(
      appBar: AppBar(
        title: const Text('Student'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
          ),

          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon:
                  const Icon(Icons.exit_to_app)), // TODO confirmation dialogue
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Hours Completed'),
            Tab(text: 'Upcoming Events'),
            Tab(text: 'Attended Events'),
          ],
        ),
      ),
      body: TabBarView(
              controller: _tabController,
              children: [
                HoursCompletedTab(
                  userDocSnap: userDocumentSnapshot,
                ),
                UpcomingEventsTab(
                  userDocSnap: userDocumentSnapshot,configurablesSnapshot: configurablesSnapshot,eventStream:eventStream,icondataStream:icondataStream
                ),
                const AttendedEventsTab(),
              ],
            ),
    );
    }
  }
}

class HoursCompletedTab extends StatefulWidget {
  final DocumentSnapshot userDocSnap;
  const HoursCompletedTab({super.key, required this.userDocSnap});

  @override
  State createState() => HoursCompletedState();
}

class HoursCompletedState extends State<HoursCompletedTab> {
  double maxhours = 200;
  int maxhoursdisplay = 200;

  final userStreamController = StreamController();

  Future<void> setmaximumhours() async {
    int temp = await FirebaseFirestore.instance
        .collection('configurables')
        .doc('document')
        .get()
        .then((snapshot) {
      return snapshot.get('mandatory-hours');
    });
    setState(() {
      maxhours = temp.toDouble();
      maxhoursdisplay = temp;
    });
  }

  HoursCompletedState()
  {
    setmaximumhours();
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.sizeOf(context).width;
    final screenheight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 1),
              child: const Text(
                'Your Progress So Far',
                textScaler: TextScaler.linear(2),
              ),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: child,
                );
              },
            ),
            SizedBox(
                width: screenwidth - 50,
                height: screenheight / 2,
                child: SfRadialGauge(
                  enableLoadingAnimation: true,
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 0,
                      maximum: maxhours,
                      showLabels: false,
                      showTicks: false,
                      axisLineStyle: const AxisLineStyle(
                        thickness: 0.2,
                        cornerStyle: CornerStyle.bothCurve,
                        color: Color.fromARGB(30, 0, 169, 181),
                        thicknessUnit: GaugeSizeUnit.factor,
                      ),
                      pointers: <GaugePointer>[
                        RangePointer(
                          value: (widget.userDocSnap['sem-1-hours'] +
                                  widget.userDocSnap['sem-2-hours'])
                              .toDouble(),
                          cornerStyle: CornerStyle.bothCurve,
                          width: 0.2,
                          sizeUnit: GaugeSizeUnit.factor,
                        ),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          positionFactor: 0,
                          widget: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    (widget.userDocSnap['sem-1-hours'] +
                                            widget.userDocSnap['sem-2-hours'])
                                        .toStringAsFixed(0),
                                    style: TextStyle(
                                        fontSize: 40,
                                        color:
                                            (widget.userDocSnap['sem-1-hours'] +
                                                        widget.userDocSnap[
                                                            'sem-2-hours'] <
                                                    maxhours)
                                                ? Colors.red
                                                : Colors.green),
                                  ),
                                  Text(
                                    "/$maxhoursdisplay",
                                    style: const TextStyle(
                                        fontSize: 40, color: Colors.green),
                                  )
                                ],
                              ),
                              const Text(
                                "Hours Completed",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.green),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            SizedBox(
              width: screenwidth / 2,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HourDetailPage(userDocSnap: widget.userDocSnap)));
                },
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        Color.fromARGB(255, 127, 112, 180))),
                child: const Text("Details",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HourDetailPage extends StatefulWidget {
  final DocumentSnapshot userDocSnap;
  const HourDetailPage({super.key, required this.userDocSnap});

  @override
  State createState() {
    return HourDetailState();
  }
}

class HourDetailState extends State<HourDetailPage>
    with SingleTickerProviderStateMixin {

      HourDetailState()
      {
        fetchsemhours();
      }

  Future<void> fetchsemhours() async {
    await FirebaseFirestore.instance
        .collection('configurables')
        .doc('document')
        .get()
        .then((snapshot) {
      sem1hours=snapshot['sem1hours'];
      sem2hours=snapshot['sem2hours'];
    });

    setState(() {
    });
  }

  double sem1hours = 60;
  double sem2hours = 60;

  @override
  Widget build(BuildContext context) {

    final screenwidth = MediaQuery.sizeOf(context).width;
    final screenheight = MediaQuery.sizeOf(context).height;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Semester Details",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 127, 112, 180),
          foregroundColor: Colors.white,
        ),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, screenheight / 10),
            child: Stack(children: [
              Center(
                child: SizedBox(
                  width: screenwidth / 2,
                  height: screenwidth / 2,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(
                        begin: 0,
                        end: widget.userDocSnap['sem-1-hours'] / sem1hours),
                    duration: const Duration(seconds: 2),
                    builder: (context, value, _) => CircularProgressIndicator(
                        strokeCap: StrokeCap.round,
                        strokeWidth: 10,
                        backgroundColor:
                            (widget.userDocSnap['sem-1-hours'] < sem1hours)
                                ? Colors.red
                                : Colors.white,
                        color: (widget.userDocSnap['sem-1-hours'] < sem1hours)
                            ? Colors.green
                            : Colors.blue,
                        value: value),
                  ),
                ),
              ),
              Center(
                  child: Padding(
                padding: EdgeInsets.fromLTRB(0, screenwidth / 5, 0, 0),
                child: Text(
                  'Semester 1:\n     ' +
                      widget.userDocSnap['sem-1-hours'].toString()+
                      '/${sem1hours.toInt()}',
                  style: const TextStyle(fontSize: 20),
                ),
              ))
            ]),
          ),
          const Divider(
            color: Color.fromARGB(255, 127, 112, 180),
            thickness: 4,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, screenheight / 10, 0, 0),
            child: Stack(children: [
              Center(
                child: SizedBox(
                  width: screenwidth / 2,
                  height: screenwidth / 2,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(
                        begin: 0,
                        end: widget.userDocSnap['sem-2-hours'] / sem2hours),
                    duration: const Duration(seconds: 2),
                    builder: (context, value, _) => CircularProgressIndicator(
                      strokeCap: StrokeCap.round,
                      strokeWidth: 10,
                      backgroundColor:
                          (widget.userDocSnap['sem-2-hours'] < sem2hours)
                              ? Colors.red
                              : Colors.white,
                      color: (widget.userDocSnap['sem-2-hours'] < sem2hours)
                          ? Colors.green
                          : Colors.blue,
                      value: value,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, screenwidth / 5, 0, 0),
                child: Center(
                    child: Text(
                        'Semester 2:\n     ' +
                            widget.userDocSnap['sem-2-hours'].toString() +
                            '/${sem2hours.toInt()}',
                        style: const TextStyle(fontSize: 20))),
              )
            ]),
          )
        ])));
  }
}

class UpcomingEventsTab extends StatefulWidget {
  final DocumentSnapshot userDocSnap;
  final  DocumentSnapshot configurablesSnapshot;
  final Future eventStream;
  final Future icondataStream;
  const UpcomingEventsTab({required this.userDocSnap,required this.configurablesSnapshot,required this.eventStream,required this.icondataStream, super.key});

  @override
  State<UpcomingEventsTab> createState() => _UpcomingEventsTabState();
}

class _UpcomingEventsTabState extends State<UpcomingEventsTab> {

  late final double screenheight;

  ExpansionTileController tilecontroller = ExpansionTileController();

  int calculateDifferenceInMinutes(Timestamp firebaseTimestamp) {
    DateTime currentTime = DateTime.now();
    DateTime firebaseTime = firebaseTimestamp.toDate();

    // Calculate the difference in minutes
    int differenceInMinutes = currentTime.difference(firebaseTime).inMinutes;
    return differenceInMinutes;
  }

  Widget _buildUpcomingEvent(BuildContext context,
      {required DocumentSnapshot eventDocSnap,
      required DocumentSnapshot userDocSnap,
      required QueryDocumentSnapshot icondataDocSnap}) {
    String state;

    int minutes = calculateDifferenceInMinutes(eventDocSnap.get('timestamp'));
    if (minutes < 0) {
      state = "Upcoming";
    } else if (minutes > 300) {
      state = "Finished";
    } else {
      state = "Active";
    }
      return Card(
      child: InkWell(
        onTap: () {
          if(state!="Finished")
          {
            Navigator.push(context,MaterialPageRoute(builder: (context) => EventDetailsPage(eventSnapshot: eventDocSnap,userSnapshot: userDocSnap,),),);
          }
        },
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [
                (state == "Active")
                    ? const Color.fromARGB(255, 151, 236, 154)
                    : ((state == "Finished")
                        ? const Color.fromARGB(255, 254, 202, 198)
                        : const Color.fromARGB(255, 109, 189, 255)),
                Colors.white,
                Colors.white
              ])),
          child: ListTile(
            tileColor: const Color.fromARGB(255, 251, 250, 250),
            title: Text(eventDocSnap['title']),
            subtitle: Text(
                DateTimeFormatter.format(eventDocSnap['timestamp'].toDate())),
            leading: Icon(
                IconData(icondataDocSnap['codepoint'],
                    fontFamily: 'MaterialIcons'),
                color: Color(icondataDocSnap['color'])),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${eventDocSnap['hours']} Hrs'),
                Text(state,
                    style: TextStyle(
                        color: (state == "Active")
                            ? const Color.fromARGB(255, 151, 236, 154)
                            : ((state == "Finished")
                                ? const Color.fromARGB(255, 246, 109, 100)
                                : const Color.fromARGB(255, 109, 189, 255))))
              ],
            ),
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    screenheight=MediaQuery.sizeOf(context).height;

      return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(widget.userDocSnap.id).snapshots(),
        builder: (context, userStreamSnap) {
          
          return Column(
          children: <Widget>[
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('configurables')
                  .doc("document")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
          
                return Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Column(children: <Widget>[
                      FutureBuilder(
                        future:widget.icondataStream, // Incredibly retarded to not unify icon codepoints and colors with their wings
                        builder: (context, icondataAsyncSnap) {
                          if (icondataAsyncSnap.data == null) {
                            return const Center(child: CircularProgressIndicator());
                          }
          
                          final QuerySnapshot icondataSnap =
                              icondataAsyncSnap.data!;
          
                          return FutureBuilder(
                            future: widget.eventStream,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                    child: CircularProgressIndicator());
                              }
          
                              if (snapshot.data!.docs.isEmpty) {
                                return const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                    child: Text('Nothing to see here ._.'));
                              }
                              DocumentSnapshot<Object?> temp = userStreamSnap.data!;
                              return SizedBox(
                                height: screenheight - 207,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      return TweenAnimationBuilder(
                                        tween: Tween<double>(begin: 0, end: 1),
                                        duration: const Duration(seconds: 1),
                                        child: _buildUpcomingEvent(
                                          context,
                                          eventDocSnap: snapshot.data!.docs[index],
                                          userDocSnap: temp,
                                          icondataDocSnap: icondataSnap.docs
                                              .singleWhere((docSnap) =>
                                                  docSnap['wing'] ==
                                                  snapshot.data!.docs[index]
                                                      ['wing']),
                                        ),
                                        builder: (BuildContext context,
                                            double value, Widget? child) {
                                          return Opacity(
                                            opacity: value,
                                            child: child,
                                          );
                                        },
                                      );
                                    }),
                              );
                            },
                          );
                        },
                      ),
                    ]));
              },
            ),
          ],
              );
        }
      );
  }
}

class AttendedEventsTab extends StatefulWidget {
  const AttendedEventsTab({super.key});
  
  @override
  State<AttendedEventsTab> createState() => _AttendedEventsTabState();
}

class _AttendedEventsTabState extends State<AttendedEventsTab> {
  

  late Future<dynamic> fut;
  void getInfo(){
    var user = FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
    var events = FirebaseFirestore.instance.collection('events').get();
    fut = Future.wait([user,events]);
  }
  
  @override
  void initState(){
    super.initState();
    getInfo();

  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: fut,builder: (context,snapshot){
      if (!(snapshot.connectionState == ConnectionState.done && snapshot.hasData)){
              return Center(child: CircularProgressIndicator());
      }
      List<dynamic> eventL = [for(var x in snapshot.data![1]!.docs) if(snapshot.data![0].data()['attended-events'].contains(x.id)) x]; 

      return ListView.builder(itemCount: eventL.length,itemBuilder: (context,index){return _buildEvent(eventL[index], context);});



    },);
  }
}

Widget _buildEvent(
    QueryDocumentSnapshot event, BuildContext context) {

       String state;

    int minutes=calculateDifferenceInMinutes(event.get('timestamp'));
    if(minutes<0)
    {state="Upcoming";}
    else if(minutes>300)
    {state="Finished";}
    else
    {
      state="Active";
    }

  return StreamBuilder(
    stream: FirebaseFirestore.instance.collection('icondata').where('wing',isEqualTo: event['wing']).snapshots(),
    builder: (context, snapshot) {
      if(!snapshot.hasData)
      {return const Center(child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text("loading"),
      ));}

      return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0,end: 1),
        duration:const Duration(seconds: 1),
        builder: (context, value, child) {
          return Opacity(opacity: value,child:Card.outlined(
          elevation: 0.5,
          margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
          color: Colors.white70,
          child: ListTile(
            tileColor: const Color.fromARGB(255, 251, 250, 250),
            title: Text(event['title']),
            subtitle: Text(DateTimeFormatter.format(event['timestamp'].toDate())),
            leading: Icon(
                IconData(snapshot.data!.docs[0]['codepoint'], fontFamily: 'MaterialIcons'),
                color: Color(snapshot.data!.docs[0]['color'])),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${event['hours']} Hrs'),
                Text(state, style: TextStyle(color:(state=="Active")?const Color.fromARGB(255, 151, 236, 154):((state=="Finished")?const Color.fromARGB(255, 224, 57, 45):const Color.fromARGB(255, 109, 189, 255))))
              ],
            ),
            onTap: () {
            },
          ),
        ) ,
        );
        },
      );
    }
  );
}
