import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProductionScreen extends StatelessWidget {
  ProductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text(
          //   "Quản lý sản xuất & Tài chính",
          //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 4),
          // const Text(
          //   "Theo dõi chi phí, sản lượng và lợi nhuận từng mùa vụ",
          //   style: TextStyle(color: Colors.grey),
          // ),
          // const SizedBox(height: 16),

          // Bộ lọc
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                DropdownButton<String>(
                  value: "Mùa vụ hiện tại",
                  items: const [
                    DropdownMenuItem(
                      value: "Mùa vụ hiện tại",
                      child: Text("Mùa vụ hiện tại"),
                    ),
                    DropdownMenuItem(
                      value: "Mùa vụ trước",
                      child: Text("Mùa vụ trước"),
                    ),
                  ],
                  onChanged: (_) {},
                ),
                // const SizedBox(width: 10),
                // OutlinedButton.icon(
                //   onPressed: () {},
                //   icon: const Icon(Icons.calendar_today, size: 18),
                //   label: const Text("Chọn thời gian"),
                // ),
                // const SizedBox(width: 10),
                // OutlinedButton.icon(
                //   onPressed: () {},
                //   icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                //   label: const Text("Xuất báo cáo"),
                // ),
                // const SizedBox(width: 10),
                // IntrinsicWidth(
                //   // ← THÊM DÒNG NÀY
                //   child: ElevatedButton(
                //     onPressed: () {},
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.blue,
                //     ),
                //     child: const Text("Phân tích AI"),
                // ),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Thẻ thống kê
          _buildStatCard(
            "Tổng doanh thu",
            "45.2M VND",
            "+12.5%",
            Icons.savings_outlined,
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            "Tổng chi phí",
            "28.8M VND",
            "+8.2%",
            Icons.money_off,
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            "Lợi nhuận",
            "16.4M VND",
            "+4.2%",
            Icons.trending_up,
            Colors.blue,
          ),
          const SizedBox(height: 24),

          // Biểu đồ phân tích chi phí
          const Text(
            "Phân tích chi phí",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 40,
                sectionsSpace: 2,
                sections: [
                  _pieSection(29.5, Colors.blue, "Giống"),
                  _pieSection(41.7, Colors.orange, "Phân bón"),
                  _pieSection(14.6, Colors.green, "Thuốc BVTV"),
                  _pieSection(10.8, Colors.purple, "Nhân công"),
                  _pieSection(3.4, Colors.grey, "Khác"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Biểu đồ sản lượng
          // const Text(
          //   "Phân tích sản lượng",
          //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 16),
          // SizedBox(
          //   height: 280,
          //   child: BarChart(
          //     BarChartData(
          //       maxY: 3500,
          //       minY: 0,
          //       gridData: FlGridData(show: true),
          //       titlesData: FlTitlesData(
          //         bottomTitles: AxisTitles(
          //           sideTitles: SideTitles(
          //             showTitles: true,
          //             getTitlesWidget: (value, meta) {
          //               switch (value.toInt()) {
          //                 case 0:
          //                   return Text("Cà chua"); // Không const
          //                 case 1:
          //                   return Text("Rau xanh");
          //                 case 2:
          //                   return Text("Dưa chuột");
          //                 case 3:
          //                   return Text("Ớt");
          //               }
          //               return const Text("");
          //             },
          //           ),
          //         ),
          //         leftTitles: AxisTitles(
          //           sideTitles: SideTitles(showTitles: true, reservedSize: 35),
          //         ),
          //       ),
          //       borderData: FlBorderData(show: false),
          //       barGroups: [
          //         _barGroup(0, 2300, 2800, 3000),
          //         _barGroup(1, 1000, 1200, 1400),
          //         _barGroup(2, 1600, 1800, 2000),
          //         _barGroup(3, 700, 800, 900),
          //       ],
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 24),

          // // Biểu đồ tài chính theo tháng
          // const Text(
          //   "Tổng quan tài chính theo tháng",
          //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 16),
          // SizedBox(
          //   height: 260,
          //   child: LineChart(
          //     LineChartData(
          //       gridData: FlGridData(show: true),
          //       titlesData: FlTitlesData(show: true),
          //       borderData: FlBorderData(show: false),
          //       lineBarsData: [
          //         _lineChart([2, 3, 4, 4.5, 5, 6, 7, 8], Colors.green),
          //         _lineChart([1.5, 2, 2.5, 3, 3.5, 3.8, 4, 4.5], Colors.red),
          //         _lineChart([1, 1.5, 2, 2.2, 2.8, 3.2, 3.5, 4], Colors.blue),
          //       ],
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 40),
        ],
      ),
    );
  }

  // Widget card thống kê
  Widget _buildStatCard(
    String title,
    String value,
    String change,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text("So với mùa vụ trước"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              change,
              style: TextStyle(
                color: change.contains("-") ? Colors.red : Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Biểu đồ tròn
  PieChartSectionData _pieSection(double value, Color color, String label) {
    return PieChartSectionData(
      color: color,
      value: value,
      title: "${value.toStringAsFixed(1)}%",
      radius: 45,
      titleStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // // Biểu đồ cột
  // BarChartGroupData _barGroup(int x, double y1, double y2, double y3) {
  //   return BarChartGroupData(
  //     x: x,
  //     barRods: [
  //       BarChartRodData(toY: y1, color: Colors.grey, width: 10),
  //       BarChartRodData(toY: y2, color: Colors.blue, width: 10),
  //       BarChartRodData(toY: y3, color: Colors.orange, width: 10),
  //     ],
  //   );
  // }

  // // Biểu đồ đường
  // LineChartBarData _lineChart(List<double> values, Color color) {
  //   return LineChartBarData(
  //     spots: values
  //         .asMap()
  //         .entries
  //         .map((e) => FlSpot(e.key.toDouble(), e.value))
  //         .toList(),
  //     isCurved: true,
  //     color: color,
  //     barWidth: 3,
  //     belowBarData: BarAreaData(show: false),
  //   );
  // }
}
