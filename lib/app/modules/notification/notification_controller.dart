import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    _setupFCM();
  }

  Future<void> _setupFCM() async {
    // Dapatkan izin untuk menerima notifikasi di iOS
    await _messaging.requestPermission();

    // Handler untuk pesan masuk saat aplikasi dalam kondisi Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    // Handler untuk pesan yang diterima saat aplikasi di Background dan user mengetap notifikasi
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    // Handler untuk pesan saat aplikasi di Terminated dan user mengetap notifikasi
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  void _handleMessage(RemoteMessage message) {
    Get.snackbar(
      message.notification?.title ?? 'Notification',
      message.notification?.body ?? 'You have a new message.',
    );
    // Tambahkan logika untuk navigasi atau pengolahan data sesuai pesan notifikasi
  }
}
