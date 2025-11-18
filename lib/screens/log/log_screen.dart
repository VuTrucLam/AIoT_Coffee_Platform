import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iot_thi/services/log_service.dart';
import 'package:iot_thi/services/auth_service.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final List<Map<String, dynamic>> logs = [];

  String? selectedActivity;
  DateTime? selectedDate;
  String? _editingLogId;
  final costController = TextEditingController();
  final descriptionController = TextEditingController();
  late LogService logService;

  String formatCurrency(dynamic value) {
    try {
      final number = value is String ? double.parse(value) : value.toDouble();
      final formatter = NumberFormat('#,###', 'vi_VN');
      return formatter.format(number);
    } catch (e) {
      return value.toString();
    }
  }

  IconData getActivityIcon(String activity) {
    switch (activity) {
      case "Tưới nước":
        return Icons.water_drop;

      case "Bón phân":
        return Icons.eco;

      case "Phát cỏ":
        return Icons.grass;

      case "Phun Thuốc Trừ sâu":
        return Icons.bug_report;

      case "Cắt cành":
        return Icons.content_cut;

      case "Thu hoạch":
        return Icons.agriculture;

      default:
        return Icons.task_alt; // fallback
    }
  }

  Color _getIconBgColor(String activity) {
    switch (activity) {
      case "Tưới nước":
        return Colors.blue;
      case "Bón phân":
        return Colors.green;
      case "Phát cỏ":
        return Colors.orange;
      case "Phun Thuốc Trừ sâu":
        return Colors.red;
      case "Cắt cành":
        return Colors.purple;
      case "Thu hoạch":
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
    initLogService();
  }

  Future<void> initLogService() async {
    final token = await AuthService.getToken();
    if (token == null || token.isEmpty) {
      return;
    }

    logService = LogService(baseUrl: 'http://127.0.0.1:5000/api', token: token);

    await fetchLogsFromServer();
  }

  Future<void> fetchLogsFromServer() async {
    try {
      final serverLogs = await logService.getLogs();
      setState(() {
        logs.clear();

        logs.addAll(
          serverLogs.map((log) {
            String displayDate = log['date'];
            try {
              final d = DateTime.parse(log['date']).toLocal();
              displayDate = DateFormat('dd/MM/yyyy').format(d);
            } catch (_) {}

            return {
              "_id": log["_id"],
              "icon": getActivityIcon(
                log['activity'],
              ), // <-- icon theo loại hoạt động
              "title": log['activity'],
              "area": "Chưa có",
              "description": log['note'],
              "date": displayDate,
              "cost": log['cost'],
              "images": [],
            };
          }),
        );
      });
    } catch (e) {
      print("Lỗi tải log: $e");
    }
  }

  Future<void> pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('vi', 'VN'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF6F00),
              onPrimary: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.green),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
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

              GestureDetector(
                onTap: pickDate,
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Ngày thực hiện",
                      hintText: "Chọn ngày",
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: TextEditingController(
                      text: selectedDate != null
                          ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                          : "",
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Dropdown chọn loại hoạt động
              DropdownButtonFormField<String>(
                value: selectedActivity,
                hint: const Text("Chọn hoạt động"),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items:
                    [
                          "Tưới nước",
                          "Bón phân",
                          "Phát cỏ",
                          "Phun Thuốc Trừ sâu",
                          "Cắt cành",
                          "Thu hoạch",
                        ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (value) => setState(() => selectedActivity = value),
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

              ElevatedButton.icon(
                onPressed: () async {
                  if (selectedActivity == null || costController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Vui lòng nhập đầy đủ thông tin"),
                      ),
                    );
                    return;
                  }

                  try {
                    if (_editingLogId == null) {
                      // Thêm mới
                      await logService.createLog(
                        date:
                            selectedDate?.toIso8601String() ??
                            DateTime.now().toIso8601String(),
                        activity: selectedActivity!,
                        cost: costController.text,
                        note: descriptionController.text,
                      );
                    } else {
                      // Cập nhật log
                      await logService.updateLog(
                        logId: _editingLogId!,
                        date:
                            selectedDate?.toIso8601String() ??
                            DateTime.now().toIso8601String(),
                        activity: selectedActivity!,
                        cost: costController.text,
                        note: descriptionController.text,
                      );
                    }

                    await fetchLogsFromServer();

                    // Xóa form và reset trạng thái sửa
                    setState(() {
                      selectedActivity = null;
                      selectedDate = null;
                      costController.clear();
                      descriptionController.clear();
                      _editingLogId = null;
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
                  }
                },
                icon: const Icon(Icons.save),
                label: Text(
                  _editingLogId == null
                      ? "Lưu hoạt động"
                      : "Cập nhật hoạt động",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3D5AFE),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ICON Hoạt động
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getIconBgColor(log["title"]),
              shape: BoxShape.circle,
            ),
            child: Icon(
              getActivityIcon(log["title"]),
              color: Colors.white,
              size: 26,
            ),
          ),

          const SizedBox(width: 12),

          // Nội dung chính
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TIÊU ĐỀ + Chip hoạt động
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        log["title"],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Ghi chú
                if (log["description"] != null && log["description"] != "")
                  Text(
                    log["description"],
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),

                const SizedBox(height: 6),

                // Ngày + chi phí
                Text(
                  "📅 ${log["date"]}",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Text(
                  "💰 Chi phí: ${formatCurrency(log["cost"])} VNĐ",
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Nút sửa + xóa
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                iconSize: 22,
                onPressed: () {
                  setState(() {
                    // Điền dữ liệu log vào form
                    selectedActivity = log["title"];
                    selectedDate =
                        DateTime.tryParse(
                          log["date"].split('/').reversed.join('-'),
                        ) ??
                        DateTime.now();
                    costController.text = log["cost"].toString();
                    descriptionController.text = log["description"] ?? "";
                    _editingLogId = log["_id"]; // lưu id để biết đang chỉnh sửa
                  });

                  // Scroll lên form nếu cần
                  // Scrollable.ensureVisible(context); // bạn có thể dùng key để scroll
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Scrollable.ensureVisible(
                      context,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  });
                },
              ),

              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                iconSize: 22,
                onPressed: () async {
                  try {
                    await logService.deleteLog(log["_id"]);
                    await fetchLogsFromServer();
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReminder(
    IconData icon,
    Color color,
    String title,
    String subtitle,
  ) {
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
