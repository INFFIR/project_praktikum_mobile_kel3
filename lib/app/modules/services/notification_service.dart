// lib/app/services/notification_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _serverKey = 'YOUR_SERVER_KEY_HERE'; // Ganti dengan Server Key Firebase

  Future<void> init() async {
    // Meminta izin notifikasi
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Inisialisasi notifikasi lokal
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    // Berlangganan ke topik "all"
    await _messaging.subscribeToTopic('all');

    // Menangani pesan saat aplikasi di foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotification(
          message.notification!.title ?? 'No Title',
          message.notification!.body ?? 'No Body',
        );
      }
    });

    // Menangani pesan saat aplikasi di background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Pesan diterima di background: ${message.messageId}');
  }

  // Mengirim notifikasi ke topik
  Future<void> sendNotificationToTopic(String title, String body) async {
    const String topic = '/topics/all';
    await _sendFCMNotification(topic, title, body);
  }

  // Mengirim notifikasi menggunakan FCM API
  Future<void> _sendFCMNotification(String to, String title, String body) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$_serverKey',
        },
        body: jsonEncode({
          'to': to,
          'notification': {
            'title': title,
            'body': body,
          },
          'priority': 'high',
        }),
      );

      if (response.statusCode == 200) {
        print('Notifikasi berhasil dikirim');
      } else {
        print('Gagal mengirim notifikasi: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saat mengirim notifikasi: $e');
    }
  }

  // Menampilkan notifikasi lokal
  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformDetails,
    );
  }

  // Memicu notifikasi foreground
  Future<void> triggerForegroundNotification() async {
    showNotification('Notifikasi Foreground', 'Ini adalah notifikasi foreground');
  }

  // Memicu notifikasi background setelah delay
  Future<void> triggerBackgroundNotification() async {
    await Future.delayed(const Duration(seconds: 5));
    showNotification('Notifikasi Background', 'Ini adalah notifikasi background');
  }

  // Memicu notifikasi terminated setelah delay
  Future<void> triggerTerminatedNotification() async {
    await Future.delayed(const Duration(seconds: 10));
    showNotification('Notifikasi Terminated', 'Ini adalah notifikasi terminated');
  }
}
