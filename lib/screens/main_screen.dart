import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home/home_screen.dart';
import 'log/log_screen.dart';
import 'production/production_screen.dart';
import 'analytics/analytics_screen.dart';
import 'control/control_screen.dart';
import 'package:iot_thi/screens/user/login.dart';
import 'package:iot_thi/services/auth_service.dart';
import '../widgets/notification_bell.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // KHÔNG dùng const ở đây để tránh lỗi state không cập nhật
  final List<Widget> _screens = [
    HomeScreen(),
    LogScreen(),
    ProductionScreen(),
    AnalyticsScreen(),
    ControlScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _redirectToLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
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
          FutureBuilder<String?>(
            future: AuthService.getToken(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              }

              if (snapshot.hasData && snapshot.data != null) {
                return NotificationBell(token: snapshot.data!);
              }

              return IconButton(
                onPressed: () => _redirectToLogin(context),
                icon: const Icon(Icons.notifications_none),
                color: Colors.black87,
              );
            },
          ),
          IconButton(
            onPressed: () {
              AuthService.showUserProfile(context);
            },
            icon: const Icon(Icons.account_circle_outlined),
            color: Colors.black87,
          ),
          const SizedBox(width: 10),
        ],
      ),

      // ⛔ FIX LỖI QUAN TRỌNG: KHÔNG RELOAD MÀN HÌNH KHI ĐỔI TAB
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

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
            icon: Icon(Icons.home_outlined),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: "Nhật ký",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.agriculture_outlined),
            label: "Sản xuất",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: "Phân tích",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_remote_outlined),
            label: "Điều khiển",
          ),
        ],
      ),
    );
  }
}
