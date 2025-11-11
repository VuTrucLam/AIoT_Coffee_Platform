// lib/screens/user/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:iot_thi/services/auth_service.dart';

class NotificationsScreen extends StatefulWidget {
  final String token;
  const NotificationsScreen({super.key, required this.token});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> notifications = [];
  bool isLoading = true;

  DateTime? _parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;

    try {
      // Trường hợp ISO 8601 (MongoDB hoặc backend khác)
      return DateTime.parse(dateString).toLocal();
    } catch (_) {
      try {
        // Trường hợp RFC 1123 như "Tue, 11 Nov 2025 07:37:08 GMT"
        final format = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en_US');
        return format.parse(dateString, true).toLocal();
      } catch (e) {
        debugPrint("⚠️ Lỗi parse ngày: $e | Chuỗi: $dateString");
        return null;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/api/notifications?per_page=50'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          notifications = data['notifications'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("Lỗi tải thông báo: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3D5AFE), Color(0xFFFF6F00)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          title: Text(
            "Thông báo",
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          ),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
          ? Center(
              child: Text(
                "Chưa có thông báo",
                style: GoogleFonts.montserrat(fontSize: 16),
              ),
            )
          : RefreshIndicator(
              onRefresh: fetchNotifications,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: notifications.length,
                itemBuilder: (context, i) {
                  final n = notifications[i];
                  final createdAt =
                      _parseDate(n['created_at']?.toString()) ??
                      _parseDate(n['timestamp']?.toString());
                  final isRead = n['is_read'] == true;

                  return Card(
                    elevation: 2,
                    color: n['level'] == 'danger' && !isRead
                        ? Colors.red.shade50
                        : Colors.grey.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isRead ? Colors.green : Colors.red,
                        child: Icon(
                          isRead ? Icons.check : Icons.warning,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        n['title'] ?? 'Không có tiêu đề',
                        style: GoogleFonts.montserrat(
                          fontWeight: isRead
                              ? FontWeight.w500
                              : FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        n['body'] ?? '',
                        style: const TextStyle(fontSize: 13),
                      ),
                      trailing: Text(
                        createdAt != null
                            ? DateFormat('dd/MM/yyyy HH:mm').format(createdAt)
                            : 'Không rõ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      onTap: () async {
                        try {
                          final url =
                              '${AuthService.baseUrl}/api/notifications/${n['_id']}';
                          await http.put(
                            Uri.parse(url),
                            headers: {
                              'Authorization': 'Bearer ${widget.token}',
                            },
                          );
                          fetchNotifications();
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
                        }
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
