import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  // Fake data for devices
  final List<Map<String, dynamic>> devices = [
    {
      "name": "Bơm tưới khu A",
      "location": "Khu vực A",
      "icon": Icons.water_drop,
      "online": true,
      "auto": true,
      "value": 75,
    },
    {
      "name": "Quạt thông gió nhà kính 1",
      "location": "Nhà kính 1",
      "icon": Icons.wind_power,
      "online": true,
      "auto": false,
      "value": 50,
    },
    {
      "name": "Máy sưởi nhà kính 2",
      "location": "Nhà kính 2",
      "icon": Icons.device_thermostat,
      "online": true,
      "auto": true,
      "value": 40,
    },
    {
      "name": "Bơm tưới khu B",
      "location": "Khu vực B",
      "icon": Icons.water,
      "online": false,
      "auto": true,
      "value": 80,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildStatusOverview(),
              const SizedBox(height: 16),
              _buildDeviceControlSection(),
              const SizedBox(height: 20),
              _buildAutomationRulesSection(),
              const SizedBox(height: 20),
              _buildScheduleSection(),
              const SizedBox(height: 20),
              _buildDeviceStatusSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Điều khiển tự động",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              "Quản lý và điều khiển hệ thống IoT trang trại",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text("Thêm thiết bị"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildStatusOverview() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _StatusItem(color: Colors.green, label: "Tự động", count: 5),
          _StatusItem(color: Colors.orange, label: "Thủ công", count: 3),
          _StatusItem(color: Colors.red, label: "Offline", count: 2),
        ],
      ),
    );
  }

  Widget _buildDeviceControlSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Điều khiển thiết bị",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...devices.map((device) => _DeviceCard(device: device)).toList(),
      ],
    );
  }

  Widget _buildAutomationRulesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Quy tắc tự động hóa",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Icon(Icons.add_circle_outline, color: Colors.deepPurple),
          ],
        ),
        const SizedBox(height: 12),
        _AutomationCard(
          title: "Tưới tự động khu A",
          condition: "soil_moisture < 60",
          action: "Bật bơm tưới 30 phút",
        ),
        _AutomationCard(
          title: "Thông gió nhà kính",
          condition: "temperature > 30",
          action: "Bật quạt thông gió",
        ),
      ],
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Lịch tự động",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        _ScheduleCard(
          title: "Tưới sáng",
          time: "06:00",
          duration: "30 phút",
          repeat: "Hàng ngày",
        ),
        _ScheduleCard(
          title: "Tưới chiều",
          time: "18:00",
          duration: "25 phút",
          repeat: "Hàng ngày",
        ),
      ],
    );
  }

  Widget _buildDeviceStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Trạng thái thiết bị",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        _StatusCard(
          name: "Cảm biến độ ẩm A1",
          value: "65%",
          signal: "92%",
          battery: "85%",
        ),
        _StatusCard(
          name: "Bơm tưới A",
          value: "Đang hoạt động",
          signal: "88%",
          battery: "80%",
        ),
      ],
    );
  }
}

// ---------------- Widgets -----------------
class _StatusItem extends StatelessWidget {
  final Color color;
  final String label;
  final int count;

  const _StatusItem({
    required this.color,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(height: 4),
        Text(
          "$label",
          style: const TextStyle(fontSize: 14),
        ),
        Text(
          "$count thiết bị",
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}

class _DeviceCard extends StatelessWidget {
  final Map<String, dynamic> device;

  const _DeviceCard({required this.device});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(device['icon'], color: Colors.deepPurple, size: 30),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device['name'],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        device['location'],
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: device['online'] ? Colors.green[100] : Colors.red[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      device['online'] ? "Online" : "Offline",
                      style: TextStyle(
                        color: device['online'] ? Colors.green : Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: device['auto'] ? Colors.deepPurple[50] : Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      device['auto'] ? "Tự động" : "Thủ công",
                      style: TextStyle(
                        color: device['auto'] ? Colors.deepPurple : Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Trạng thái hoạt động"),
              CupertinoSwitch(
                value: device['online'],
                onChanged: (_) {},
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Chế độ tự động"),
              CupertinoSwitch(
                value: device['auto'],
                onChanged: (_) {},
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Slider(
                  value: device['value'].toDouble(),
                  max: 100,
                  divisions: 20,
                  label: "${device['value']}%",
                  onChanged: (_) {},
                ),
              ),
              Text("${device['value']}%"),
            ],
          )
        ],
      ),
    );
  }
}

class _AutomationCard extends StatelessWidget {
  final String title;
  final String condition;
  final String action;

  const _AutomationCard({required this.title, required this.condition, required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text("Điều kiện: $condition", style: const TextStyle(color: Colors.grey)),
          Text("Hành động: $action", style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final String title;
  final String time;
  final String duration;
  final String repeat;

  const _ScheduleCard({
    required this.title,
    required this.time,
    required this.duration,
    required this.repeat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text("Thời gian: $time", style: const TextStyle(color: Colors.grey)),
              Text("Lặp lại: $repeat", style: const TextStyle(color: Colors.grey)),
            ],
          ),
          Text(duration, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String name;
  final String value;
  final String signal;
  final String battery;

  const _StatusCard({
    required this.name,
    required this.value,
    required this.signal,
    required this.battery,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text("Giá trị: $value"),
          Text("Tín hiệu: $signal"),
          Text("Pin: $battery"),
        ],
      ),
    );
  }
}