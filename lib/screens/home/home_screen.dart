import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iot_thi/services/weather_service.dart';
import 'package:iot_thi/services/sensor_service.dart';
import 'package:iot_thi/services/notification_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:iot_thi/services/auth_service.dart';

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

// === CẢNH BÁO 3 MỨC ĐỘ ===
enum AlertLevel { safe, warning, danger }

AlertLevel getAlertLevel(String sensor, double value) {
  switch (sensor) {
    case 'temperature':
      if (value >= 18 && value <= 28) return AlertLevel.safe;
      if ((value > 28 && value <= 32) || (value >= 15 && value < 18))
        return AlertLevel.warning;
      return AlertLevel.danger;

    case 'soilMoisture':
      if (value >= 50 && value <= 80) return AlertLevel.safe;
      if ((value >= 40 && value < 50) || (value > 80 && value <= 90))
        return AlertLevel.warning;
      return AlertLevel.danger;

    case 'light':
      if (value >= 100 && value <= 1000) return AlertLevel.safe;
      if ((value >= 50 && value < 100) || (value > 1000 && value <= 1500))
        return AlertLevel.warning;
      return AlertLevel.danger;

    case 'ph':
      if (value >= 6.0 && value <= 7.5) return AlertLevel.safe;
      if ((value >= 5.5 && value < 6.0) || (value > 7.5 && value <= 8.0))
        return AlertLevel.warning;
      return AlertLevel.danger;

    case 'pressure':
      if (value >= 950 && value <= 1050) return AlertLevel.safe;
      if ((value >= 900 && value < 950) || (value > 1050 && value <= 1100))
        return AlertLevel.warning;
      return AlertLevel.danger;

    case 'N':
    case 'P':
    case 'K':
      if (value >= 10 && value <= 50) return AlertLevel.safe;
      if ((value >= 5 && value < 10) || (value > 50 && value <= 100))
        return AlertLevel.warning;
      return AlertLevel.danger;

    default:
      return AlertLevel.safe;
  }
}

Color getAlertColor(AlertLevel level) {
  switch (level) {
    case AlertLevel.safe:
      return const Color.fromRGBO(91, 233, 96, 1).withOpacity(0.4);
    case AlertLevel.warning:
      return Colors.orange.withOpacity(0.2);
    case AlertLevel.danger:
      return Colors.red.withOpacity(0.3);
    default:
      return Colors.white.withOpacity(0.1);
  }
}

//
// ====== WIDGET SENSOR ======
//

class SensorDataCard extends StatefulWidget {
  const SensorDataCard({super.key});

  @override
  State<SensorDataCard> createState() => _SensorDataCardState();
}

class _SensorDataCardState extends State<SensorDataCard> {
  final Map<String, double> _previousValues = {};
  final Set<String> _alertedKeys = {};

  Future<void> _checkAndAlert(
    String sensor,
    double value,
    AlertLevel level,
    String label,
    String unit,
  ) async {
    final key = '$sensor:$level'; // Key = sensor + mức cảnh báo
    final prevValue = _previousValues[sensor] ?? value;

    if (level == AlertLevel.danger && !_alertedKeys.contains(key)) {
      _alertedKeys.add(key);

      NotificationService.showDangerAlert(
        "CẢNH BÁO: $label",
        "$label: ${value.toStringAsFixed(1)}$unit – Vượt ngưỡng nguy hiểm!",
      );

      final token = await AuthService.getToken();
      if (token != null && token.isNotEmpty) {
        try {
          await http.post(
            Uri.parse('${AuthService.baseUrl}/api/notifications'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({
              'title': 'CẢNH BÁO: $label',
              'body': '$label: ${value.toStringAsFixed(1)}$unit – Nguy hiểm!',
              'sensor': sensor,
              'level': 'danger',
            }),
          );
        } catch (e) {
          debugPrint("Lỗi gửi cảnh báo: $e");
        }
      }
    }

    // Cập nhật giá trị cũ
    _previousValues[sensor] = value;

    // Reset nếu trở về safe
    if (level == AlertLevel.safe) {
      _alertedKeys.removeWhere((k) => k.startsWith('$sensor:'));
    }
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

            // === TÍNH MỨC CẢNH BÁO ===
            final AlertLevel tempLevel = getAlertLevel('temperature', temp);
            final AlertLevel moistureLevel = getAlertLevel(
              'soilMoisture',
              moistureValue,
            );
            final AlertLevel lightLevel = getAlertLevel(
              'light',
              light.toDouble(),
            );
            final AlertLevel phLevel = getAlertLevel('ph', ph);
            final AlertLevel pressureLevel = getAlertLevel(
              'pressure',
              pressure,
            );

            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (mounted) {
                await _checkAndAlert(
                  'temperature',
                  temp,
                  tempLevel,
                  "Nhiệt độ",
                  "°C",
                );
                await _checkAndAlert(
                  'soilMoisture',
                  moistureValue,
                  moistureLevel,
                  "Độ ẩm đất",
                  "%",
                );
                await _checkAndAlert(
                  'light',
                  light.toDouble(),
                  lightLevel,
                  "Ánh sáng",
                  " lux",
                );
                await _checkAndAlert('ph', ph, phLevel, "pH đất", "");
                await _checkAndAlert(
                  'pressure',
                  pressure,
                  pressureLevel,
                  "Áp suất",
                  " hPa",
                );
              }
            });
            return Column(
              children: [
                Row(
                  children: [
                    _buildSensorItem(
                      icon: Icons.thermostat,
                      value: "${temp.toStringAsFixed(1)}°C",
                      label: "Nhiệt độ",
                      status: _getChange(temp, 28.0),
                      iconColor: Colors.red,
                      alertLevel: tempLevel,
                    ),
                    _buildSensorItem(
                      icon: Icons.water_drop,
                      value: moistureDisplay,
                      label: "Độ ẩm đất",
                      status: _getChange(moistureValue, 65),
                      iconColor: const Color.fromARGB(176, 33, 149, 243),
                      alertLevel: moistureLevel,
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildSensorItem(
                      icon: Icons.wb_sunny,
                      value: "$light lux",
                      label: "Ánh sáng",
                      status: "+150 lux",
                      iconColor: Colors.amber,
                      alertLevel: lightLevel,
                    ),
                    _buildSensorItem(
                      icon: Icons.science,
                      value: ph.toStringAsFixed(1),
                      label: "pH đất",
                      status: _getPhStatus(ph),
                      iconColor: Colors.purple,
                      alertLevel: phLevel,
                    ),
                    _buildSensorItem(
                      icon: Icons.compress,
                      value: "${pressure.toStringAsFixed(0)} hPa",
                      label: "Áp suất",
                      status: "Ổn định",
                      iconColor: const Color.fromARGB(255, 87, 112, 255),
                      alertLevel: pressureLevel,
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

  Widget _buildSensorItem({
    required IconData icon,
    required String value,
    required String label,
    required String status,
    required Color iconColor,
    required AlertLevel alertLevel,
  }) {
    return Expanded(
      child: Card(
        color: getAlertColor(alertLevel), // ĐỔI MÀU NỀN
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: alertLevel == AlertLevel.danger ? 6 : 1, // ĐỎ nổi hơn
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Icon(
                icon,
                color: alertLevel == AlertLevel.danger
                    ? Colors.red
                    : alertLevel == AlertLevel.warning
                    ? Colors.orange
                    : iconColor,
                size: 28,
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: alertLevel == AlertLevel.danger
                      ? Colors.red.shade700
                      : Colors.black87,
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
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: alertLevel == AlertLevel.danger
                      ? Colors.red
                      : alertLevel == AlertLevel.warning
                      ? Colors.orange
                      : Colors.grey,
                  fontWeight: alertLevel == AlertLevel.danger
                      ? FontWeight.bold
                      : null,
                ),
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

        final nLevel = getAlertLevel('N', n);
        final pLevel = getAlertLevel('P', p);
        final kLevel = getAlertLevel('K', k);

        if (snapshot.hasData && snapshot.data != null) {
          _checkAndAlert('N', n, nLevel, "Nitơ (N)", " mg/kg");
          _checkAndAlert('P', p, pLevel, "Photpho (P)", " mg/kg");
          _checkAndAlert('K', k, kLevel, "Kali (K)", " mg/kg");
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
                                  alertLevel: nLevel,
                                ),
                                _NutrientItem(
                                  label: "P",
                                  value: p.toStringAsFixed(1),
                                  alertLevel: pLevel,
                                ),
                                _NutrientItem(
                                  label: "K",
                                  value: k.toStringAsFixed(1),
                                  alertLevel: kLevel,
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
  final AlertLevel alertLevel;

  const _NutrientItem({
    required this.label,
    required this.value,
    required this.alertLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: getAlertColor(alertLevel),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: alertLevel == AlertLevel.danger
                  ? Colors.red.shade700
                  : Colors.black87,
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
      ),
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
