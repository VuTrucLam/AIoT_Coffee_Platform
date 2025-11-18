import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // BẮT BUỘC
import 'package:iot_thi/screens/user/register.dart';
import 'core/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:iot_thi/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.init();
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
      locale: const Locale('vi', 'VN'),
      supportedLocales: const [Locale('vi', 'VN'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const RegisterScreen(),
    );
  }
}
