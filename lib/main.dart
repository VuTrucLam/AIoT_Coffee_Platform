import 'package:flutter/material.dart';
import 'package:iot_thi/screens/log/log_screen.dart';
import 'package:iot_thi/screens/user/login.dart';
import 'core/app_theme.dart';
import 'screens/main_screen.dart';

void main() {
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
      home: const MainScreen()
     
     

    );
  }
}
