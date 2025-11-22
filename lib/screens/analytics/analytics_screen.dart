import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final DatabaseReference historyRef =
      FirebaseDatabase.instance.ref("sensor_history");

  List<Map> historyList = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  void loadHistory() {
    historyRef.onValue.listen((event) {
      final data = event.snapshot.value;

      if (data == null) {
        setState(() => historyList = []);
        return;
      }

      if (data is Map) {
        final List<Map> temp = [];

        data.forEach((key, value) {
          if (value is Map) {
            final item = Map.from(value);
            temp.add({
              "time": key,
              "temperature": item["temperature"],
              "humidity": item["humidity"],
              "soil": item["soilMoisturePercent"],
              "npk": item["npk"],
              "light": item["lightPercent"],
            });
          }
        });

        temp.sort((a, b) => b["time"].compareTo(a["time"]));

        setState(() {
          historyList = temp;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),

      // 🔥 AppBar GRADIENT GIỐNG FILE NOTIFICATION
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false, // ❌ không có nút back
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4169E1), // xanh dương
                  Color(0xFF7B61FF), // tím
                  Color(0xFFFF7B00), // cam
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          centerTitle: true,
          title: const Text(
            "Lịch sử cảm biến",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      ),

      body: historyList.isEmpty
          ? const Center(
              child: Text(
                "Chưa có dữ liệu lịch sử",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final item = historyList[index];

                return Card(
                  elevation: 4,
                  shadowColor: Colors.red.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.redAccent.withOpacity(0.4),
                        width: 1.2,
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        "🕒 Thời gian: ${item["time"]}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "🌡️ Nhiệt độ: ${item["temperature"]}°C\n"
                          "💧 Độ ẩm: ${item["humidity"]}%\n"
                          "🌱 Độ ẩm đất: ${item["soil"]}%\n"
                          "🔆 Ánh sáng: ${item["light"]}%\n"
                          "🧪 NPK: ${item["npk"]}",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
