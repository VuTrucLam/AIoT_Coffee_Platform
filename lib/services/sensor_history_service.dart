import 'package:firebase_database/firebase_database.dart';

class SensorHistoryService {
  static final DatabaseReference currentSensorRef =
      FirebaseDatabase.instance.ref("sensor");

  static final DatabaseReference historyRef =
      FirebaseDatabase.instance.ref("sensor_history");

  // Hàm bắt đầu lắng nghe dữ liệu cảm biến liên tục
  static void startListening() {
    currentSensorRef.onValue.listen((event) {
      final data = event.snapshot.value;

      // CHẶN LỖI NULL --- RẤT QUAN TRỌNG TRÊN FLUTTER WEB
      if (data == null) return;

      if (data is Map) {
        saveHistory(Map.from(data));
      }
    });
  }

  // Hàm lưu 1 bản ghi lịch sử
  static Future<void> saveHistory(Map data) async {
    final timestamp = DateTime.now().toIso8601String();

    await historyRef.child(timestamp).set({
      "humidity": data["humidity"],
      "lightPercent": data["lightPercent"],
      "lightRaw": data["lightRaw"],
      "phValue": data["phValue"],
      "pressure": data["pressure"],
      "soilMoisturePercent": data["soilMoisturePercent"],
      "soilRaw": data["soilRaw"],
      "temperature": data["temperature"],
      "manualPump": data["manualPump"],
      "moisture": data["moisture"],
      "pumpStatus": data["pumpStatus"],
      "rawValue": data["rawValue"],
      "npk": data["sensor"], // N-P-K nằm trong sensor
      "created_at": ServerValue.timestamp,
    });
  }
}
