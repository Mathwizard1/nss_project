import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'date_time_formatter.dart';

class NotificationModel {
  final String id;
  final String message;
  final DateTime timestamp;

  NotificationModel({required this.id, required this.message, required this.timestamp});

  factory NotificationModel.fromMap(Map<String, dynamic> data, String documentId) {
    return NotificationModel(
      id: documentId,
      message: data['message'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

class NotificationPage extends StatelessWidget {
  final CollectionReference notificationsRef = FirebaseFirestore.instance.collection('notifications');

  NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: StreamBuilder(
        stream: notificationsRef.orderBy('timestamp', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!.docs.map((doc) {
            return NotificationModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                title: Text(notification.message),
                subtitle: Text(DateTimeFormatter.format(notification.timestamp)),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> addNotification(String message) async {
    final timestamp = DateTime.now();
    final notification = NotificationModel(
      id: '',
      message: message,
      timestamp: timestamp,
    );
    await notificationsRef.add(notification.toMap());
  }
}

  // blow up all notificaitons
  Future<void> deleteAllNotifications() async {
  final CollectionReference notificationsRef = FirebaseFirestore.instance.collection('notifications');
  final QuerySnapshot snapshot = await notificationsRef.get();
  for (final QueryDocumentSnapshot doc in snapshot.docs) {
    await doc.reference.delete();
    }
  }

// Add this function whenever on pressed is called and it will add a notification
Future<void> addNotification(String message) async {
  final CollectionReference notificationsRef = FirebaseFirestore.instance.collection('notifications');
  final timestamp = DateTime.now();
  final notification = NotificationModel(
    id: '',
    message: message,
    timestamp: timestamp,
  );
  await notificationsRef.add(notification.toMap());
}
