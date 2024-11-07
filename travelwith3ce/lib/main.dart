// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:travelwith3ce/views/signup.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Khởi tạo Firebase với các tùy chọn
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: RegisterScreen(), // Đảm bảo RegisterScreen đã được định nghĩa
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:travelwith3ce/models/bottom_bar.dart';
import 'package:travelwith3ce/views/login.dart';
import 'package:travelwith3ce/views/my_booking_screen.dart';
import 'package:travelwith3ce/views/signup.dart';
import 'firebase_options.dart';
import 'package:travelwith3ce/views/signup.dart'; // Đảm bảo đường dẫn đúng
import 'package:travelwith3ce/models/bottom_bar.dart'; // Đảm bảo đường dẫn đúng
import 'package:travelwith3ce/views/account_screen.dart'; // Đảm bảo đường dẫn đúng
import 'package:travelwith3ce/views/edit_profile_screen.dart'; // Đảm bảo đường dẫn đúng

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase với các tùy chọn
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
      title: 'Travel with 3CE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login', // Đặt đường dẫn khởi đầu đến màn hình đăng ký
      routes: {
        '/home': (context) =>
            BottomBar(), // Màn hình chính với Bottom navigation
        '/account': (context) => AccountScreen(),
        '/editProfile': (context) => EditProfileScreen(),
        '/myBooking': (context) => BookingHistoryScreen(),
        '/register': (context) => RegisterScreen(), // Màn hình đăng ký
        '/login': (context) => LoginScreen(),
      },
      // Xử lý lỗi điều hướng không xác định
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => RegisterScreen());
      },
    );
  }
}
