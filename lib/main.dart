import 'package:flutter/material.dart';
import 'package:iot_thi/screens/log/log_screen.dart';
import 'package:iot_thi/screens/user/login.dart';
import 'package:iot_thi/screens/user/register.dart';
import 'core/app_theme.dart';
import 'screens/main_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo dữ liệu định dạng cho ngôn ngữ Việt Nam
  await initializeDateFormatting('vi_VN', null);

  runApp(const FarmSmartApp());
}

class FarmSmartApp extends StatelessWidget {
  const FarmSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmSmart',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const RegisterScreen(),
    );
  }
}
