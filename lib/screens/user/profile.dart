// lib/profile_dialog.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart'; // dùng để điều hướng về màn hình Login khi logout

void showProfileDialog(
  BuildContext context, {
  required String name,
  required String email,
  required String farmName,
  required String accountType,
  VoidCallback? onLogout, // optional: callback khi logout
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar
              const CircleAvatar(
                radius: 35,
                backgroundColor: Color(0xFF3D5AFE),
                child: Icon(Icons.person, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 16),

              // Tên và email
              Text(
                name,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 4),
              Text(email, style: GoogleFonts.roboto(color: Colors.grey[600])),

              const SizedBox(height: 12),
              Divider(color: Colors.grey[300]),

              const SizedBox(height: 8),

              // Thông tin
              _infoRow("Tên trang trại", farmName),
              const SizedBox(height: 8),
              _infoRow("Loại tài khoản", accountType),

              const SizedBox(height: 20),

              // Nút đăng xuất
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // đóng dialog trước
                    if (onLogout != null) {
                      onLogout();
                    } else {
                      // Mặc định: điều hướng về LoginScreen và remove tất cả route
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3D5AFE), Color(0xFFFF6F00)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Đăng xuất",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _infoRow(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: GoogleFonts.roboto(color: Colors.grey[700])),
      Flexible(
        child: Text(
          value,
          textAlign: TextAlign.right,
          style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
        ),
      ),
    ],
  );
}
