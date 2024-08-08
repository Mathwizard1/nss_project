import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:nss_project/event_details_page.dart';
import 'package:nss_project/sprofile_page.dart';

import 'package:nss_project/notification_page.dart';

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
  late final Stream<DocumentSnapshot> userDocumentStream;
  late final Stream<QuerySnapshot> eventsDocumentStream;
  late final Stream<QuerySnapshot> configurablesDocumentStream;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    userDocumentStream = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    eventsDocumentStream =
        FirebaseFirestore.instance.collection('events').snapshots();
    configurablesDocumentStream =
        FirebaseFirestore.instance.collection('configurables').snapshots();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationPage()));
            },
          ),
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
      body: StreamBuilder(
          stream: userDocumentStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return TabBarView(
              controller: _tabController,
              children: [
                HoursCompletedTab(
                  userDocSnap: snapshot.data!,
                ),
                UpcomingEventsTab(
                  userDocSnap: snapshot.data!,
                ),
                const AttendedEventsTab(),
              ],
            );
          }),
    );
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

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.sizeOf(context).width;
    final screenheight = MediaQuery.sizeOf(context).height;

    setmaximumhours();

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
  Future<void> fetchsemhours() async {
    int tempsem1hours = await FirebaseFirestore.instance
        .collection('configurables')
        .doc('document')
        .get()
        .then((snapshot) {
      return snapshot.get('sem1hours');
    });
    int tempsem2hours = await FirebaseFirestore.instance
        .collection('configurables')
        .doc('document')
        .get()
        .then((snapshot) {
      return snapshot.get('sem2hours');
    });
    setState(() {
      sem1hours = tempsem1hours;
      sem2hours = tempsem2hours;
    });
  }

  int sem1hours = 60;
  int sem2hours = 60;

  @override
  Widget build(BuildContext context) {
    fetchsemhours();

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
                      widget.userDocSnap['sem-1-hours'].toString() +
                      '/$sem1hours',
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
                            '/$sem2hours',
                        style: const TextStyle(fontSize: 20))),
              )
            ]),
          )
        ])));
  }
}

class UpcomingEventsTab extends StatefulWidget {
  final DocumentSnapshot userDocSnap;
  const UpcomingEventsTab({required this.userDocSnap, super.key});

  @override
  State<UpcomingEventsTab> createState() => _UpcomingEventsTabState();
}

class _UpcomingEventsTabState extends State<UpcomingEventsTab> {
  String _selectedWing = 'All';

  ExpansionTileController tilecontroller = ExpansionTileController();

  Widget _buildUpcomingEvent(BuildContext context,
      {required QueryDocumentSnapshot eventDocSnap,
      required DocumentSnapshot userDocSnap,
      required QueryDocumentSnapshot icondataDocSnap}) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsPage(
                eventDocId: eventDocSnap.id,
              ),
            ),
          );
        },
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [
                Color.fromARGB(255, 151, 236, 154),
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
                const Text('Active', style: TextStyle(color: Colors.green))
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.sizeOf(context).height;

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

            final wingOptions = ['All'] +
                snapshot.data!['wings'].map<String>((dyn) {
                  String ret = dyn;
                  return ret;
                }).toList();
            final events = FirebaseFirestore.instance.collection('events');

            return Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(children: <Widget>[
                  Card(
                      borderOnForeground: false,
                      child: DropdownMenu<String>(
                          textStyle: const TextStyle(color: Colors.white),
                          label: const Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              'NSS Wing',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          leadingIcon:
                              const Icon(Icons.category, color: Colors.white),
                          expandedInsets:
                              const EdgeInsets.only(top: 64.0, bottom: 8.0),
                          inputDecorationTheme: const InputDecorationTheme(
                            fillColor: Color.fromARGB(255, 128, 112, 185),
                            filled: true,
                          ),
                          initialSelection: 'All',
                          onSelected: (selectedWing) {
                            setState(() {
                              if (selectedWing != null) {
                                _selectedWing = selectedWing;
                              }
                            });
                          },
                          dropdownMenuEntries: wingOptions
                              .map<DropdownMenuEntry<String>>((option) {
                            return DropdownMenuEntry<String>(
                              value: option,
                              label: option,
                            );
                          }).toList())),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('icondata')
                        .snapshots(), // Incredibly retarded to not unify icon codepoints and colors with their wings
                    builder: (context, icondataAsyncSnap) {
                      if (icondataAsyncSnap.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final QuerySnapshot icondataSnap =
                          icondataAsyncSnap.data!;

                      return StreamBuilder(
                        stream: _selectedWing == 'All'
                            ? events.snapshots()
                            : events
                                .where('wing', isEqualTo: _selectedWing)
                                .snapshots(),
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
                                      userDocSnap: widget.userDocSnap,
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
}

class AttendedEventsTab extends StatelessWidget {
  const AttendedEventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Attended Events Content'),
    );
  }
}
