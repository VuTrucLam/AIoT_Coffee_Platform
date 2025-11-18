import 'dart:convert';
import 'package:http/http.dart' as http;

class LogService {
  final String baseUrl;
  final String token;

  LogService({required this.baseUrl, required this.token});

  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  Future<List<Map<String, dynamic>>> getLogs() async {
    final response = await http.get(
      Uri.parse('$baseUrl/logs'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['logs'] as List;
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to fetch logs');
    }
  }

  Future<void> createLog({
    required String date,
    required String activity,
    required String cost,
    String? note,
  }) async {
    final body = json.encode({
      'date': date,
      'activity': activity,
      'cost': cost,
      'note': note,
    });
    final response = await http.post(
      Uri.parse('$baseUrl/logs'),
      headers: headers,
      body: body,
    );
    if (response.statusCode != 201) throw Exception('Failed to create log');
  }

  Future<void> updateLog({
    required String logId,
    required String date,
    required String activity,
    required String cost,
    String? note,
  }) async {
    final body = json.encode({
      'date': date,
      'activity': activity,
      'cost': cost,
      'note': note,
    });
    final response = await http.put(
      Uri.parse('$baseUrl/logs/$logId'),
      headers: headers,
      body: body,
    );
    if (response.statusCode != 200) throw Exception('Failed to update log');
  }

  Future<void> deleteLog(String logId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/logs/$logId'),
      headers: headers,
    );
    if (response.statusCode != 200) throw Exception('Failed to delete log');
  }
}
