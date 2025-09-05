import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home/home_screen.dart';
import 'log/log_screen.dart';
import 'production/production_screen.dart';
import 'analytics/analytics_screen.dart';
import 'control/control_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    LogScreen(),
    ProductionScreen(),
    AnalyticsScreen(),
    ControlScreen(),
  ];

  final List<String> _titles = const [
    "Trang chủ",
    "Nhật ký",
    "Sản xuất",
    "Phân tích",
    "Điều khiển",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 10),
            // Logo Gradient
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  colors: [Color(0xFF3D5AFE), Color(0xFFFF6F00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.menu_book, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            // Tên app FarmSmart
            Text(
              "FarmSmart",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        actions: [
          // Nút thông báo + badge đỏ
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none),
                color: Colors.black87,
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    "3",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Nút profile
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.account_circle_outlined),
            color: Colors.black87,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF3D5AFE),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Trang chủ"),
          BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined), label: "Nhật ký"),
          BottomNavigationBarItem(
              icon: Icon(Icons.agriculture_outlined), label: "Sản xuất"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined), label: "Phân tích"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_remote_outlined), label: "Điều khiển"),
        ],
      ),
    );
  }
}
