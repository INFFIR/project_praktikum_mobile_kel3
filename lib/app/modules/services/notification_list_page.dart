// lib/app/modules/notification_list_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationListPage extends StatelessWidget {
  const NotificationListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Notifikasi'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data;
          if (data == null || data.docs.isEmpty) {
            return const Center(child: Text('Tidak ada notifikasi'));
          }
          return ListView.builder(
            itemCount: data.docs.length,
            itemBuilder: (context, index) {
              final doc = data.docs[index];
              final title = doc['title'] ?? 'Tanpa Judul';
              final body = doc['body'] ?? '';
              final timestamp = doc['timestamp'] != null
                  ? (doc['timestamp'] as Timestamp).toDate()
                  : DateTime.now();
              return ListTile(
                title: Text(title),
                subtitle: Text(body),
                trailing: Text(
                  '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
