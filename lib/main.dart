import 'package:flutter/material.dart';
import 'package:iot_thi/screens/log/log_screen.dart';
import 'package:iot_thi/screens/user/login.dart';
import 'package:iot_thi/screens/user/register.dart';
import 'core/app_theme.dart';
import 'screens/main_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // THÊM DÒNG NÀY
  );
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
