// lib/widgets/notification_bell.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:iot_thi/screens/user/notifications_screen.dart';
import 'package:iot_thi/services/auth_service.dart';

class NotificationBell extends StatefulWidget {
  final String token;
  const NotificationBell({super.key, required this.token});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  int unreadCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUnreadCount();
    // Cập nhật mỗi 10s
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 10));
      if (mounted) fetchUnreadCount();
      return mounted;
    });
  }

  Future<void> fetchUnreadCount() async {
    try {
      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/api/notifications?per_page=1'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final int total = (data['total'] as num?)?.toInt() ?? 0;
        final List<dynamic> notifs = data['notifications'] ?? [];

        final int readCount = notifs.where((n) => n['is_read'] == true).length;
        final int unread = total - readCount;

        setState(() {
          unreadCount = unread;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NotificationsScreen(token: widget.token),
              ),
            );
          },
          icon: const Icon(Icons.notifications_none),
          color: Colors.black87,
        ),
        if (unreadCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                unreadCount > 99 ? "99+" : "$unreadCount",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
