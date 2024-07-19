import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leaderboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LeaderboardPage(),
    );
  }
}

class LeaderboardPage extends StatelessWidget {
  final List<String> volunteers = [
    'Alice', 'Bob', 'Charlie', 'David', 'Eve',
    'Frank', 'Grace', 'Hannah', 'Ivy', 'Jack',
    'Kate', 'Liam', 'Mia', 'Noah', 'Olivia',
    'Penelope', 'Quinn', 'Ryan', 'Sophia', 'Thomas',
    'Uma', 'Victor', 'Willow', 'Xavier', 'Yasmine',
  ];

  final List<double> hours = [
    30.5, 25.0, 23.5, 21.0, 19.5,
    18.0, 16.5, 15.0, 14.5, 12.0,
    11.5, 10.0, 9.5, 8.0, 7.5,
    6.0, 5.5, 4.0, 3.5, 2.0,
    1.5, 1.0, 0.5, 0.2, 0.1,
  ];

  LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text("Leaderboard"),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: volunteers.length,
        itemBuilder: (context, index) {
          String volunteer = volunteers[index];
          double hour = hours[index];

          // Determine styling based on index (top 3, 4-10, 11-20)
          TextStyle? textStyle;
          if (index < 3) {
            textStyle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.green, decoration: TextDecoration.underline);
          } else if (index < 10) {
            textStyle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue);
          } else if (index < 20) {
            textStyle = const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange);
          }

          return ListTile(
            title: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    volunteer,
                    style: textStyle,
                    ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    hour.toString(),
                    textAlign: TextAlign.right,
                    style: textStyle,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
