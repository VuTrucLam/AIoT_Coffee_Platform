import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:iot_thi/screens/user/login.dart';
import 'package:iot_thi/screens/user/profile.dart';

class AuthService {
  static const String baseUrl = "http://127.0.0.1:5000";

  static Future<void> showUserProfile(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");

    if (token == null) {
      _redirectToLogin(context);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/auth/me"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data["user"];

        showProfileDialog(
          context,
          name: user["name"] ?? "",
          email: user["email"] ?? "",
          farmName: user["farm_name"] ?? "",
          accountType: user["account_type"] ?? "",
          onLogout: () async {
            await prefs.remove("access_token");
            _redirectToLogin(context);
          },
        );
      } else {
        await prefs.remove("access_token");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Phiên đăng nhập hết hạn, vui lòng đăng nhập lại."),
          ),
        );
        _redirectToLogin(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi kết nối server: $e")));
    }
  }

  /// Hàm phụ: chuyển hướng về trang login
  static void _redirectToLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
}
