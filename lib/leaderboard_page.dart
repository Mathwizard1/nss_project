import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MaterialApp(
    home: LeaderboardPage(),
  ));
}

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  Future<List<Map<String, dynamic>>> fetchVolunteerData() async {
    List<Map<String, dynamic>> volunteers = [];

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'volunteer')
        .get();

    for (var doc in snapshot.docs) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        String name = data['full-name'] ?? 'Unknown';
        int sem1 = data['sem-1-hours'] != null ? data['sem-1-hours'] as int : 0;
        int sem2 = data['sem-2-hours'] != null ? data['sem-2-hours'] as int : 0;
        int totalHours = sem1 + sem2;

        volunteers.add({
          'name': name,
          'totalHours': totalHours,
        });
      }
    }

    volunteers.sort((a, b) => b['totalHours'].compareTo(a['totalHours']));
    return volunteers.take(100).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchVolunteerData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available.'));
          } else {
            List<Map<String, dynamic>> volunteers = snapshot.data!;
            return ListView.builder(
              itemCount: volunteers.length,
              itemBuilder: (context, index) {
                var volunteer = volunteers[index];
                String name = volunteer['name'] ?? 'Unknown';
                int totalHours = volunteer['totalHours'] ?? 0;

                TextStyle textStyle;

                if (index == 0) {
                  textStyle = const TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    fontSize: 21,
                    color: Colors.amber,
                  );
                } else if (index == 1) {
                  textStyle = const TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    fontSize: 18,
                    color: Colors.grey,
                  );
                } else if (index == 2) {
                  textStyle = const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    color: Colors.brown,
                  );
                } else if (index >= 3 && index < 10) {
                  textStyle = const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.indigo,
                  );
                } else if (index >= 10 && index < 25) {
                  textStyle = const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Colors.green,
                  );
                } else if (index >= 25 && index < 50) {
                  textStyle = const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    color: Colors.yellow,
                  );
                } else {
                  textStyle = const TextStyle(
                    fontSize: 13,
                    color: Colors.red,
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      name,
                      style: textStyle,
                    ),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                    tileColor: (index <= 3)? Colors.teal[200]: Colors.blueGrey[50],
                    trailing: Text(
                      '$totalHours hrs',
                      style: textStyle,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
