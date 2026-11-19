import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';

// Handler notifikasi saat aplikasi berada di background
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint('[BACKGROUND] Notification received');
  debugPrint('[BACKGROUND] title: ${message.notification?.title}');
  debugPrint('[BACKGROUND] body: ${message.notification?.body}');
  debugPrint('[BACKGROUND] data: ${message.data}');
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('Notification permission: ${settings.authorizationStatus.name}');

    return settings.authorizationStatus;
  }

  // Mengambil FCM Token
  Future<String?> getToken() async {
    // ignore: deprecated_member_use
    final token = await _messaging.getToken();

    if (token != null) {
      debugPrint('FCM Token: $token');
    } else {
      debugPrint('FCM Token belum tersedia');
    }

    return token;
  }

  // Memantau perubahan FCM Token
  void listenTokenRefresh(void Function(String token) onRefresh) {
    // ignore: deprecated_member_use
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token diperbarui');
      onRefresh(newToken);
    });
  }

  // Inisialisasi penerimaan notifikasi
  Future<void> init() async {
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('[FOREGROUND] Notification received');
      debugPrint('title: ${message.notification?.title}');
      debugPrint('body: ${message.notification?.body}');
      debugPrint('data: ${message.data}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('[OPENED FROM NOTIFICATION]');
      debugPrint('title: ${message.notification?.title}');
      debugPrint('body: ${message.notification?.body}');
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      debugPrint('[TERMINATED] App opened from notification');
      debugPrint('title: ${initialMessage.notification?.title}');
      debugPrint('body: ${initialMessage.notification?.body}');
    }
  }
}
