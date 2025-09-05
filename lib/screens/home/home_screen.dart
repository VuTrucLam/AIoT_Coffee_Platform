import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            GreetingCard(),
            SizedBox(height: 16),
            SensorDataCard(),
            SizedBox(height: 16),
            WeatherCard(),
            SizedBox(height: 16),
            NotificationsCard(),
            SizedBox(height: 16),
            QuickActionsCard(),
          ],
        ),
      ),
    );
  }
}

//
// ====== WIDGET THẺ CHÀO BUỔI SÁNG ======
//
class GreetingCard extends StatelessWidget {
  const GreetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chào buổi sáng!",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Nguyễn Văn Nam",
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Text("Thứ Bảy, 30 tháng 8, 2025",
                    style: TextStyle(color: Colors.black54)),
                SizedBox(width: 12),
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text("Trang trại A1", style: TextStyle(color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//
// ====== WIDGET DỮ LIỆU CẢM BIẾN ======
//
class SensorDataCard extends StatelessWidget {
  const SensorDataCard({super.key});

  Widget buildSensorItem(
      IconData icon, String value, String label, String status, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 6),
              Text(
                value,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              Text(
                status,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dữ liệu cảm biến",
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            buildSensorItem(Icons.thermostat, "28°C", "Nhiệt độ", "+2°C từ hôm qua", Colors.orange),
            buildSensorItem(Icons.water_drop, "65%", "Độ ẩm đất", "-5% từ hôm qua", Colors.blue),
          ],
        ),
        Row(
          children: [
            buildSensorItem(Icons.wb_sunny, "850 lux", "Ánh sáng", "+150 lux", Colors.amber),
            buildSensorItem(Icons.air, "72%", "Độ ẩm không khí", "Ổn định", Colors.green),
          ],
        ),
      ],
    );
  }
}

//
// ====== WIDGET THỜI TIẾT ======
//
class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Thời tiết hôm nay",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Icon(Icons.wb_sunny, color: Colors.orange),
              ],
            ),
            const SizedBox(height: 8),
            Text("32°C",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const SizedBox(height: 4),
            const Text("Nắng ít mây",
                style: TextStyle(color: Colors.black54, fontSize: 14)),
            const SizedBox(height: 8),
            const Text("Độ ẩm: 68%  |  Gió: 12 km/h",
                style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                WeatherForecast(icon: Icons.sunny, label: "Chiều", temp: "28°C"),
                WeatherForecast(icon: Icons.cloud, label: "Tối", temp: "25°C"),
                WeatherForecast(icon: Icons.sunny_snowing, label: "Mai", temp: "30°C"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherForecast extends StatelessWidget {
  final IconData icon;
  final String label;
  final String temp;

  const WeatherForecast({
    super.key,
    required this.icon,
    required this.label,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange, size: 28),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13)),
        Text(temp,
            style: const TextStyle(
                color: Colors.black87, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

//
// ====== WIDGET THÔNG BÁO ======
//
class NotificationsCard extends StatelessWidget {
  const NotificationsCard({super.key});

  Widget buildNotification(String title, String subtitle, Color color) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(Icons.circle, color: color, size: 14),
      title: Text(title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.black54)),
      trailing: const Text("5 phút trước",
          style: TextStyle(fontSize: 11, color: Colors.grey)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            buildNotification("Độ ẩm đất thấp", "Khu vực A2 cần tưới nước", Colors.red),
            buildNotification("Tưới nước hoàn thành", "Khu vực B1 đã được tưới", Colors.green),
            buildNotification("Dự báo mưa", "Có mưa vào chiều nay", Colors.blue),
          ],
        ),
      ),
    );
  }
}

//
// ====== WIDGET THAO TÁC NHANH ======
//
class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  Widget buildAction(IconData icon, String label, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 6),
              Text(label,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildAction(Icons.water_drop, "Tưới nước", Colors.blue),
        buildAction(Icons.bolt, "Điều khiển", Colors.orange),
        buildAction(Icons.camera_alt, "Chụp ảnh", Colors.green),
        buildAction(Icons.settings, "Cài đặt", Colors.grey),
      ],
    );
  }
}
