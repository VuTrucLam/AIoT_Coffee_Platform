import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề
            Text(
              "Báo cáo & Phân tích",
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Phân tích dữ liệu sâu và dự báo xu hướng phát triển",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Bộ lọc + nút
            Row(
              children: [
                _filterButton("Tất cả trang trại"),
                const SizedBox(width: 10),
                _filterButton("Năm hiện tại"),
                const SizedBox(width: 10),
                _filterButton("1/1/2024 - 1/9/2025", icon: Icons.calendar_today),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.picture_as_pdf, size: 18),
                  label: const Text("Xuất báo cáo"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D5AFE),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text("Dự báo AI"),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Thẻ thống kê (4 khối đầu)
            _statCard(
              title: "Tổng doanh thu",
              value: "156.8M",
              unit: "VND",
              change: "+23.5%",
              subtitle: "so với năm trước",
              icon: Icons.savings_outlined,
            ),
            _statCard(
              title: "Năng suất trung bình",
              value: "32.4",
              unit: "tấn/ha",
              change: "+15.2%",
              subtitle: "cải thiện từ năm trước",
              icon: Icons.bar_chart,
            ),
            _statCard(
              title: "Hiệu quả chi phí",
              value: "68.5%",
              unit: "",
              change: "+8.7%",
              subtitle: "tối ưu hóa tài nguyên",
              icon: Icons.pie_chart,
            ),

            // Thêm 3 thẻ tiếp
            _statCard(
              title: "Chất lượng sản phẩm",
              value: "92.3%",
              unit: "",
              change: "+4.1%",
              subtitle: "đạt tiêu chuẩn A",
              icon: Icons.star,
            ),
            _statCard(
              title: "Tiết kiệm nước",
              value: "28.6%",
              unit: "",
              change: "+12.3%",
              subtitle: "nhờ IoT tự động",
              icon: Icons.water_drop_outlined,
            ),
            _statCard(
              title: "Giảm phân bón",
              value: "15.4%",
              unit: "",
              change: "+5.8%",
              subtitle: "sử dụng thông minh",
              icon: Icons.grass,
            ),
            const SizedBox(height: 20),

            // Biểu đồ: Xu hướng năng suất theo tháng
            _chartTitle("Xu hướng năng suất theo tháng (tấn/ha)"),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Text("T${v.toInt()}"),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    _lineData([2, 3, 4, 5, 4, 5.5, 6], Colors.red),
                    _lineData([1, 2, 3, 3.5, 3.8, 4.2, 5], Colors.green),
                    _lineData([0.8, 1.5, 2, 2.5, 3, 3.3, 4], Colors.blue),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Biểu đồ: Lợi nhuận theo tháng
            _chartTitle("Phân tích lợi nhuận theo tháng (triệu VND)"),
            SizedBox(
              height: 260,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Text("T${v.toInt()}"),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(12, (i) {
                    return BarChartGroupData(
                      x: i + 1,
                      barRods: [
                        BarChartRodData(toY: 15, color: Colors.green),
                        BarChartRodData(toY: 10, color: Colors.red),
                        BarChartRodData(toY: 5, color: Colors.blue),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Biểu đồ: So sánh năng suất theo mùa vụ
            _chartTitle("So sánh năng suất theo mùa vụ (tấn/ha)"),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          switch (v.toInt()) {
                            case 0:
                              return const Text("Cà chua");
                            case 1:
                              return const Text("Dưa chuột");
                            case 2:
                              return const Text("Ớt");
                            case 3:
                              return const Text("Rau xanh");
                          }
                          return const Text("");
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _barGroup(0, 28, 32, 35),
                    _barGroup(1, 22, 26, 28),
                    _barGroup(2, 18, 20, 22),
                    _barGroup(3, 20, 22, 25),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Biểu đồ: Dự báo AI
            _chartTitle("Dự báo AI & Phân tích xu hướng"),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    _lineData([30, 32, 34, 36, 38, 40], Colors.blue),
                    _lineData([32, 34, 36, 38, 40, 42], Colors.orange),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Thông tin AI
            _chartTitle("Thông tin chi tiết từ AI"),
            _aiInfoTile("Dự báo năng suất", "87% tin cậy",
                "Năng suất dự kiến tăng 15% trong 3 tháng tới nhờ điều kiện thời tiết thuận lợi"),
            _aiInfoTile("Cảnh báo chi phí", "73% tin cậy",
                "Chi phí phân bón có thể tăng 8% do giá nguyên liệu tăng"),
            _aiInfoTile("Cơ hội thị trường", "91% tin cậy",
                "Nhu cầu rau hữu cơ tăng 25%, nên chuyển đổi 30% diện tích"),
          ],
        ),
      ),
    );
  }

  // ====== Widgets phụ ======
  Widget _filterButton(String text, {IconData? icon}) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: icon != null ? Icon(icon, size: 16) : const SizedBox(),
      label: Text(text),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required String unit,
    required String change,
    required String subtitle,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0.5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "$value $unit",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(change,
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chartTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  LineChartBarData _lineData(List<double> values, Color color) {
    return LineChartBarData(
      spots: values
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value))
          .toList(),
      isCurved: true,
      color: color,
      barWidth: 3,
      belowBarData: BarAreaData(show: false),
    );
  }

  BarChartGroupData _barGroup(int x, double y1, double y2, double y3) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y1, color: Colors.grey, width: 10),
        BarChartRodData(toY: y2, color: Colors.blue, width: 10),
        BarChartRodData(toY: y3, color: Colors.orange, width: 10),
      ],
    );
  }

  Widget _aiInfoTile(String title, String trust, String desc) {
    return Card(
      margin: const EdgeInsets.only(top: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(desc),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(trust,
              style: const TextStyle(color: Colors.white, fontSize: 12)),
        ),
      ),
    );
  }
}
