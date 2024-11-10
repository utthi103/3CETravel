import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:travelwith3ce/views/admin/dashboard.dart';
import 'package:travelwith3ce/views/login.dart';
import 'package:travelwith3ce/views/signup.dart';
import 'firebase_options.dart'; // Đảm bảo import file firebase_options.dart

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Sử dụng cấu hình nền tảng cụ thể
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminDashboard(),
    );
  }
}
