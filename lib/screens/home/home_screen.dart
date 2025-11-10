import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iot_thi/services/weather_service.dart';
import 'package:iot_thi/services/sensor_service.dart';

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
class GreetingCard extends StatefulWidget {
  const GreetingCard({super.key});

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> {
  String location = "Đang lấy vị trí...";

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  /// 🕒 Trả về lời chào theo thời gian trong ngày
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Chào buổi sáng!';
    } else if (hour < 18) {
      return 'Chào buổi chiều!';
    } else {
      return 'Chào buổi tối!';
    }
  }

  String _getImageForTime() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'assets/images/sang.png';
    if (hour >= 12 && hour < 18) return 'assets/images/chieu.png';
    // if (hour >= 17 && hour < 22) return 'assets/images/toi.png';
    return 'assets/images/toi.png';
  }

  /// 📅 Trả về ngày hiện tại (định dạng tiếng Việt)
  String getCurrentDate() {
    return DateFormat('EEEE, d \'tháng\' M, y', 'vi_VN').format(DateTime.now());
  }

  /// 📍 Lấy vị trí hiện tại
  Future<void> _fetchLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => location = "Vui lòng bật GPS");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => location = "Không có quyền truy cập vị trí");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => location = "Quyền vị trí bị từ chối vĩnh viễn");
      return;
    }

    Position pos = await Geolocator.getCurrentPosition();
    setState(() {
      location =
          "(${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)})";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bên trái: phần text cũ giữ nguyên
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getGreeting(),
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  // const SizedBox(height: 4),
                  // Text(
                  //   widget.userName,
                  //   style: GoogleFonts.montserrat(
                  //     fontSize: 14,
                  //     color: Colors.black54,
                  //   ),
                  // ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        getCurrentDate(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          location,
                          style: const TextStyle(color: Colors.black54),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bên phải: ảnh minh họa theo thời gian
            const SizedBox(width: 12),
            Image.asset(
              _getImageForTime(),
              height: 80,
              width: 80,
              fit: BoxFit.contain,
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

// class SensorDataCard extends StatelessWidget {
//   const SensorDataCard({super.key});

//   Widget buildSensorItem(
//     IconData icon,
//     String value,
//     String label,
//     String status,
//     Color color,
//   ) {
//     return Expanded(
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         elevation: 1,
//         child: Padding(
//           padding: const EdgeInsets.all(14),
//           child: Column(
//             children: [
//               Icon(icon, color: color, size: 28),
//               const SizedBox(height: 6),
//               Text(
//                 value,
//                 style: GoogleFonts.montserrat(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               Text(
//                 label,
//                 style: GoogleFonts.montserrat(
//                   fontSize: 13,
//                   color: Colors.black54,
//                 ),
//               ),
//               Text(
//                 status,
//                 style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // 👉 Thẻ riêng cho NPK
//   Widget buildNPKCard({
//     required double n,
//     required double p,
//     required double k,
//   }) {
//     return Expanded(
//       child: Card(
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CircleAvatar(
//                 backgroundColor: Colors.green.withOpacity(0.15),
//                 child: const Icon(Icons.eco, color: Colors.green),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "NPK",
//                       style: GoogleFonts.montserrat(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         _NutrientItem(label: "N", value: n.toStringAsFixed(1)),
//                         _NutrientItem(label: "P", value: p.toStringAsFixed(1)),
//                         _NutrientItem(label: "K", value: k.toStringAsFixed(1)),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Dữ liệu cảm biến",
//           style: GoogleFonts.montserrat(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           children: [
//             buildSensorItem(
//               Icons.thermostat,
//               "28°C",
//               "Nhiệt độ",
//               "+2°C từ hôm qua",
//               Colors.orange,
//             ),
//             buildSensorItem(
//               Icons.water_drop,
//               "65%",
//               "Độ ẩm đất",
//               "-5% từ hôm qua",
//               Colors.blue,
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             buildSensorItem(
//               Icons.wb_sunny,
//               "850 lux",
//               "Ánh sáng",
//               "+150 lux",
//               Colors.amber,
//             ),
//             buildSensorItem(
//               Icons.science,
//               "5.5",
//               "pH đất",
//               "Trung tính",
//               Colors.purple,
//             ),
//             buildSensorItem(
//               Icons.compress, // Icon áp suất khí quyển
//               "1012 hPa",
//               "Áp suất không khí",
//               "Ổn định",
//               Colors.indigo,
//             ),
//           ],
//         ),
//         Row(children: [buildNPKCard(n: 45.0, p: 30.0, k: 25.0)]),
//       ],
//     );
//   }
// }

// // Widget nhỏ cho từng giá trị N, P, K
// class _NutrientItem extends StatelessWidget {
//   final String label;
//   final String value;

//   const _NutrientItem({required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: GoogleFonts.montserrat(
//             fontSize: 13,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: GoogleFonts.montserrat(fontSize: 13, color: Colors.black54),
//         ),
//       ],
//     );
//   }
// }

class SensorDataCard extends StatefulWidget {
  const SensorDataCard({super.key});

  @override
  State<SensorDataCard> createState() => _SensorDataCardState();
}

class _SensorDataCardState extends State<SensorDataCard> {
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

        // Dùng StreamBuilder để lắng nghe dữ liệu realtime
        StreamBuilder<Map<String, dynamic>?>(
          stream: SensorService.getSensorStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Text("Không có dữ liệu cảm biến");
            }

            final data = snapshot.data!;

            // Lấy giá trị, xử lý null
            final double temp =
                (data['temperature'] as num?)?.toDouble() ?? 0.0;
            final double humidity =
                (data['humidity'] as num?)?.toDouble() ?? 0.0;
            final int light = (data['lightRaw'] as num?)?.toInt() ?? 0;
            final double ph = (data['phValue'] as num?)?.toDouble() ?? 0.0;
            final double pressure =
                (data['pressure'] as num?)?.toDouble() ?? 0.0;
            final int soilMoisture = (data['soilRaw'] as num?)?.toInt() ?? 0;

            final double moistureValue = soilMoistureValue(
              soilMoisture,
            ); // Lấy giá trị double
            final String moistureDisplay = "$moistureValue%"; // Chuỗi hiển thị

            return Column(
              children: [
                Row(
                  children: [
                    _buildSensorItem(
                      Icons.thermostat,
                      "${temp.toStringAsFixed(1)}°C",
                      "Nhiệt độ",
                      _getChange(temp, 28.0),
                      Colors.red,
                    ),
                    _buildSensorItem(
                      Icons.water_drop,
                      moistureDisplay, // Hiển thị: "74.68%"
                      "Độ ẩm đất",
                      _getChange(moistureValue, 65), // Tính toán: dùng double
                      const Color.fromARGB(176, 33, 149, 243),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildSensorItem(
                      Icons.wb_sunny,
                      "$light lux",
                      "Ánh sáng",
                      "+150 lux",
                      Colors.amber,
                    ),
                    _buildSensorItem(
                      Icons.science,
                      ph.toStringAsFixed(1),
                      "pH đất",
                      _getPhStatus(ph),
                      Colors.purple,
                    ),
                    _buildSensorItem(
                      Icons.compress,
                      "${pressure.toStringAsFixed(0)} hPa",
                      "Áp suất",
                      "Ổn định",
                      const Color.fromARGB(255, 87, 112, 255),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildNPKRow(),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSensorItem(
    IconData icon,
    String value,
    String label,
    String status,
    Color color,
  ) {
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
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              Text(
                status,
                style: GoogleFonts.montserrat(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNPKRow() {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: SensorService.getNPKStream(),
      builder: (context, snapshot) {
        double n = 0, p = 0, k = 0;
        if (snapshot.hasData && snapshot.data != null) {
          n = (snapshot.data!['N'] as num?)?.toDouble() ?? 0;
          p = (snapshot.data!['P'] as num?)?.toDouble() ?? 0;
          k = (snapshot.data!['K'] as num?)?.toDouble() ?? 0;
        }

        return Row(
          children: [
            Expanded(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green.withOpacity(0.15),
                        child: const Icon(Icons.eco, color: Colors.green),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "NPK",
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _NutrientItem(
                                  label: "N",
                                  value: n.toStringAsFixed(1),
                                ),
                                _NutrientItem(
                                  label: "P",
                                  value: p.toStringAsFixed(1),
                                ),
                                _NutrientItem(
                                  label: "K",
                                  value: k.toStringAsFixed(1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getChange(double current, double previous) {
    final diff = current - previous;
    if (diff > 0) return "+${diff.toStringAsFixed(1)}";
    if (diff < 0) return "${diff.toStringAsFixed(1)}";
    return "Không đổi";
  }

  String _getPhStatus(double ph) {
    if (ph < 6.0) return "Axit";
    if (ph > 7.5) return "Kiềm";
    return "Trung tính";
  }

  double soilMoistureValue(int raw) {
    final percent = ((1023 - raw) / 1023 * 100).clamp(0.0, 100.0);
    return double.parse(
      percent.toStringAsFixed(2),
    ); // Trả về double đã làm tròn
  }

  String soilMoisturePercent(int raw) {
    return soilMoistureValue(raw).toStringAsFixed(2); // Chỉ để hiển thị
  }
}

class _NutrientItem extends StatelessWidget {
  final String label;
  final String value;
  const _NutrientItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

//
// ====== WIDGET THỜI TIẾT ======
//

class WeatherCard extends StatefulWidget {
  const WeatherCard({super.key});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  Map<String, dynamic>? weatherData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      // Lấy vị trí hiện tại
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Gọi WeatherService
      final data = await WeatherService.fetchWeather(
        pos.latitude,
        pos.longitude,
      );

      setState(() {
        weatherData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        weatherData = null;
      });
      print("Lỗi lấy dữ liệu thời tiết: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Card(
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (weatherData == null) {
      return const Card(
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: Text("Không thể lấy dữ liệu thời tiết")),
        ),
      );
    }

    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Bên trái
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Thời tiết hôm nay",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    weatherData!["location"] ?? "Không xác định",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    formattedTime,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.air, color: Colors.blueAccent, size: 22),
                      const SizedBox(width: 6),
                      Text(
                        "${weatherData!["windSpeed"]} km/h",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "(${weatherData!["windDirection"]})",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bên phải
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    weatherData!["icon"] ?? "🌍",
                    style: const TextStyle(fontSize: 36),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    weatherData!["description"] ?? "",
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${weatherData!["temperature"]}°C",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Độ ẩm: ${weatherData!["humidity"]}% | Áp suất: ${weatherData!["pressure"]} hPa",
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      ),
      trailing: const Text(
        "5 phút trước",
        style: TextStyle(fontSize: 11, color: Colors.grey),
      ),
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
            buildNotification(
              "Độ ẩm đất thấp",
              "Khu vực A2 cần tưới nước",
              Colors.red,
            ),
            buildNotification(
              "Tưới nước hoàn thành",
              "Khu vực B1 đã được tưới",
              Colors.green,
            ),
            buildNotification(
              "Dự báo mưa",
              "Có mưa vào chiều nay",
              Colors.blue,
            ),
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
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
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
