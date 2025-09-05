import 'package:flutter/material.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final List<Map<String, dynamic>> logs = [
    {
      "icon": Icons.water_drop,
      "title": "Tưới nước",
      "area": "Khu vực A",
      "description": "Tưới nước cho cây cà chua, thời gian 2 giờ",
      "date": "2024-01-15 06:00",
      "weather": "Nắng nhẹ",
      "quantity": "2 giờ",
      "cost": "50.000 VNĐ",
      "images": []
    },
    {
      "icon": Icons.eco,
      "title": "Bón phân",
      "area": "Khu vực B",
      "description": "Bón phân NPK cho cây rau xanh",
      "date": "2024-01-14 07:30",
      "weather": "Mây ít",
      "quantity": "20kg",
      "cost": "300.000 VNĐ",
      "images": []
    },
    {
      "icon": Icons.agriculture,
      "title": "Thu hoạch",
      "area": "Nhà kính 1",
      "description": "Thu hoạch dưa chuột, chất lượng tốt",
      "date": "2024-01-13 05:00",
      "weather": "Nắng đẹp",
      "quantity": "150kg",
      "cost": "0 VNĐ",
      "images": []
    },
  ];

  String? selectedActivity;
  String? selectedArea;
  final quantityController = TextEditingController();
  final costController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    quantityController.dispose();
    costController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text("Nhật ký canh tác"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                "Ghi nhật ký hoạt động mới",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Dropdown chọn loại hoạt động
              DropdownButtonFormField<String>(
                value: selectedActivity,
                hint: const Text("Chọn hoạt động"),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: ["Tưới nước", "Bón phân", "Thu hoạch", "Phun thuốc"]
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => selectedActivity = value),
              ),
              const SizedBox(height: 12),

              // Dropdown chọn khu vực
              DropdownButtonFormField<String>(
                value: selectedArea,
                hint: const Text("Chọn khu vực"),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: ["Khu vực A", "Khu vực B", "Nhà kính 1"]
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => selectedArea = value),
              ),
              const SizedBox(height: 12),

              // Nhập số lượng / khối lượng
              TextField(
                controller: quantityController,
                decoration: InputDecoration(
                  hintText: "VD: 50kg, 2 giờ, 100m²",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Nhập chi phí
              TextField(
                controller: costController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Chi phí (VNĐ)",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Nhập mô tả chi tiết
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Ghi chú thêm về hoạt động này...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Nút lưu hoạt động
              ElevatedButton.icon(
                onPressed: () {
                  if (selectedActivity == null ||
                      selectedArea == null ||
                      quantityController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Vui lòng nhập đầy đủ thông tin"),
                      ),
                    );
                    return;
                  }
                  setState(() {
                    logs.insert(0, {
                      "icon": Icons.task_alt,
                      "title": selectedActivity!,
                      "area": selectedArea!,
                      "description": descriptionController.text,
                      "date": DateTime.now().toString(),
                      "weather": "Chưa có",
                      "quantity": quantityController.text,
                      "cost": costController.text,
                      "images": []
                    });
                    selectedActivity = null;
                    selectedArea = null;
                    quantityController.clear();
                    costController.clear();
                    descriptionController.clear();
                  });
                },
                icon: const Icon(Icons.save),
                label: const Text("Lưu hoạt động"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 24),

              // Hoạt động gần đây
              const Text(
                "Hoạt động gần đây",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...logs.map((log) => _buildActivityCard(log)),

              const SizedBox(height: 24),

              // Thống kê nhanh
              const Text(
                "Thống kê nhanh",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildStatCard(Icons.task, "Hoạt động tuần này", "12", "+3"),
              _buildStatCard(Icons.monetization_on, "Chi phí tháng này", "2.5M",
                  "-200K", Colors.red),
              _buildStatCard(
                  Icons.grass, "Diện tích canh tác", "1.2ha", "", Colors.green),
              _buildStatCard(Icons.shopping_basket, "Sản lượng tuần", "450kg",
                  "+50kg", Colors.orange),
              const SizedBox(height: 24),

              // Gợi ý & nhắc nhở
              const Text(
                "Gợi ý & Nhắc nhở",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildReminder(Icons.lightbulb_outline, Colors.blue, "Gợi ý AI",
                  "Độ ẩm đất khu vực A đang thấp, nên tưới vào sáng sớm"),
              _buildReminder(Icons.calendar_today, Colors.orange, "Lịch canh tác",
                  "Đến thời gian bón phân cho cây cà chua (3 ngày nữa)"),
              _buildReminder(Icons.cloud, Colors.green, "Thời tiết",
                  "Dự báo mưa 2 ngày tới, hoãn việc phun thuốc"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> log) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(log["icon"], color: Colors.blueAccent),
        ),
        title: Text(log["title"]),
        subtitle: Text("${log["description"]}\nNgày: ${log["date"]}"),
        isThreeLine: true,
        trailing: Text(
          log["cost"],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      IconData icon, String title, String value, String change,
      [Color color = Colors.blue]) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(title),
        subtitle: Text(change.isNotEmpty ? "Thay đổi: $change" : ""),
        trailing: Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildReminder(
      IconData icon, Color color, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
