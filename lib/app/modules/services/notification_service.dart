// lib/app/services/notification_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> init() async {
    // Meminta izin (khusus iOS)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Inisialisasi notifikasi lokal
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onSelectNotification);

    // Menangani pesan foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Menerima pesan di foreground: ${message.messageId}');
      if (message.notification != null) {
        showNotification(
          message.notification!.title ?? '',
          message.notification!.body ?? '',
        );
      }
    });

    // Menangani saat aplikasi dibuka dari terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('Aplikasi dibuka dari terminated state via notifikasi: ${message.messageId}');
        // Tangani pesan di sini jika diperlukan
      }
    });

    // Menangani saat aplikasi di background dan dibuka melalui notifikasi
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Aplikasi dibuka dari background via notifikasi: ${message.messageId}');
      // Tangani pesan di sini jika diperlukan
    });
  }

  Future<void> showNotification(String title, String body) async {
    // Simpan notifikasi ke Firestore
    await saveNotificationToFirestore(title, body);

    // Mengonfigurasi detail notifikasi Android
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // Ganti dengan channel ID yang sesuai
      'your_channel_name', // Ganti dengan channel name yang sesuai
      channelDescription: 'your_channel_description', // Ganti dengan deskripsi yang sesuai
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Menampilkan notifikasi lokal
    await _flutterLocalNotificationsPlugin.show(
      0, // ID Notifikasi
      title,
      body,
      platformChannelSpecifics,
      payload: 'default_payload',
    );
  }

  Future<void> saveNotificationToFirestore(String title, String body) async {
    await _firestore.collection('notifications').add({
      'title': title,
      'body': body,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void onSelectNotification(NotificationResponse response) {
    // Logika saat notifikasi diklik
    String? payload = response.payload;
    if (payload != null && payload.isNotEmpty) {
      print('Payload notifikasi: $payload');
      // Navigasi ke halaman tertentu jika diperlukan
    }
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    // Untuk iOS versi lama
    print('Menerima notifikasi lokal: $id');
  }

  // Tambahkan metode untuk memicu notifikasi lokal secara manual
  Future<void> triggerForegroundNotification() async {
    showNotification('Notifikasi Foreground', 'Ini adalah notifikasi foreground');
  }

  Future<void> triggerBackgroundNotification() async {
    await Future.delayed(const Duration(seconds: 5));
    showNotification('Notifikasi Background', 'Ini adalah notifikasi background');
  }

  Future<void> triggerTerminatedNotification() async {
    await Future.delayed(const Duration(seconds: 10));
    showNotification('Notifikasi Terminated', 'Ini adalah notifikasi terminated');
  }
}
