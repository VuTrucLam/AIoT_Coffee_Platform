// lib/services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_audio/just_audio.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final _audioPlayer = AudioPlayer();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _notifications.initialize(settings);
  }

  static Future<void> _playAlertSound() async {
    try {
      await _audioPlayer.setAsset('assets/sounds/alert.mp3');
      await _audioPlayer.play();
    } catch (e) {
      print("Lỗi phát âm thanh: $e");
    }
  }

  static Future<void> showDangerAlert(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'danger_channel',
      'Cảnh báo nguy hiểm',
      channelDescription: 'Thông báo khi cảm biến vượt ngưỡng đỏ',
      importance: Importance.max,
      priority: Priority.high,
      playSound: false,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );

    await _playAlertSound();
  }
}
