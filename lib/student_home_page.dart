import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:nss_project/sprofile_page.dart';

void main() {
  runApp(const StudentHomePage());
}

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SHomePage(),
    );
  }
}

class SHomePage extends StatefulWidget {
  const SHomePage({super.key});

  @override
  SHomePageState createState() => SHomePageState();
}

class SHomePageState extends State<SHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _sem1Hours = 30;
  int _sem2Hours = 20;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void setSem1Hours(int hours) {
    setState(() {
      _sem1Hours = hours;
    });
  }

  int getSem1Hours() {
    return _sem1Hours;
  }

  void setSem2Hours(int hours) {
    setState(() {
      _sem2Hours = hours;
    });
  }

  int getSem2Hours() {
    return _sem2Hours;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>const ProfilePage()));
            },
          ),
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
            sem1Hours: _sem1Hours,
            sem2Hours: _sem2Hours,
            onIncrementSem1: () {
              setSem1Hours(_sem1Hours + 1);
            },
            onIncrementSem2: () {
              setSem2Hours(_sem2Hours + 1);
            },
          ),
          const UpcomingEventsTab(),
          const AttendedEventsTab(),
        ],
      ),
    );
  }
}

class HoursCompletedTab extends StatelessWidget {
  final int sem1Hours;
  final int sem2Hours;
  final VoidCallback onIncrementSem1;
  final VoidCallback onIncrementSem2;

  const HoursCompletedTab({super.key, 
    required this.sem1Hours,
    required this.sem2Hours,
    required this.onIncrementSem1,
    required this.onIncrementSem2,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Your Progress So Far',
              textScaler: TextScaler.linear(2),
            ),
            SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: 60,
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
                      value: (sem1Hours + sem2Hours).toDouble(),
                      cornerStyle: CornerStyle.bothCurve,
                      width: 0.2,
                      sizeUnit: GaugeSizeUnit.factor,
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      positionFactor: 0,
                      widget: Text(
                        '${(sem1Hours + sem2Hours).toStringAsFixed(0)} / 80 Hours',
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                  SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 0,
                        maximum: 30,
                        showLabels: false,
                        showTicks: false,
                        radiusFactor: 0.5,
                        axisLineStyle: const AxisLineStyle(
                          thickness: 0.2,
                          cornerStyle: CornerStyle.bothCurve,
                          color: Color.fromARGB(30, 0, 169, 181),
                          thicknessUnit: GaugeSizeUnit.factor,
                        ),
                        pointers: <GaugePointer>[
                          RangePointer(
                            value: sem1Hours.toDouble(),
                            cornerStyle: CornerStyle.bothCurve,
                            width: 0.2,
                            sizeUnit: GaugeSizeUnit.factor,
                          ),
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            positionFactor: 0,
                            widget: Text(
                              '${sem1Hours.toStringAsFixed(0)} Hours\n(Sem 1)',
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        ],
                      ),
                ]),
                  SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 0,
                        maximum: 30,
                        showLabels: false,
                        showTicks: false,
                        radiusFactor: 0.5,
                        axisLineStyle: const AxisLineStyle(
                          thickness: 0.2,
                          cornerStyle: CornerStyle.bothCurve,
                          color: Color.fromARGB(30, 0, 169, 181),
                          thicknessUnit: GaugeSizeUnit.factor,
                        ),
                        pointers: <GaugePointer>[
                          RangePointer(
                            value: sem2Hours.toDouble(),
                            cornerStyle: CornerStyle.bothCurve,
                            width: 0.2,
                            sizeUnit: GaugeSizeUnit.factor,
                          ),
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            positionFactor: 0,
                            widget: Text(
                              '${sem2Hours.toStringAsFixed(0)} Hours\n(Sem 2)',
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        ],
                      ),
                ]),
              ],
            ),
          ],
      ),
    );
  }
}

class UpcomingEventsTab extends StatelessWidget {
  const UpcomingEventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Upcoming Events Content'),
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
