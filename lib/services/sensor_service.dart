import 'package:firebase_database/firebase_database.dart';

class SensorService {
  static final DatabaseReference _db = FirebaseDatabase.instance.ref();

  static Stream<Map<String, dynamic>?> getSensorStream() {
    return _db.child('device2/sensor').onValue.map((event) {
      final data = event.snapshot.value as Map<Object?, Object?>?;
      if (data == null) return null;

      return data.map((key, value) => MapEntry(key.toString(), value));
    });
  }

  static Stream<Map<String, dynamic>?> getNPKStream() {
    return _db.child('sensor/npk').onValue.map((event) {
      final data = event.snapshot.value as Map<Object?, Object?>?;
      if (data == null) return null;

      return data.map((key, value) => MapEntry(key.toString(), value));
    });
  }

  static Stream<Map<String, dynamic>?> getPumpStatusStream() {
    return _db.child('device2').onValue.map((event) {
      final data = event.snapshot.value as Map<Object?, Object?>?;
      if (data == null) return null;

      return {
        'pumpStatus': data['pumpStatus'],
        'manualPump': data['manualPump'],
        'autoMode': data['autoMode'],
      };
    });
  }
}
