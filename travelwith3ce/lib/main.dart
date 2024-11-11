import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:travelwith3ce/models/home/home_header.dart';
import 'package:travelwith3ce/views/home_screen.dart';
import 'package:travelwith3ce/views/login.dart';
import 'package:travelwith3ce/views/my_booking_screen.dart';
import 'firebase_options.dart';
import 'package:travelwith3ce/views/signup.dart';
import 'package:travelwith3ce/models/bottom_bar.dart';
import 'package:travelwith3ce/views/account_screen.dart';
import 'package:travelwith3ce/views/edit_profile_screen.dart';
import 'package:travelwith3ce/controllers/current_user_provider.dart';
import 'package:provider/provider.dart';

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
    var userId;
    return ChangeNotifierProvider(
      create: (context) => CurrentUserProvider(),
      child: MaterialApp(
        title: 'Travel with 3CE',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/login', // Đặt đường dẫn khởi đầu đến màn hình đăng nhập
        routes: {
          '/home': (context) =>
              const BottomBar(), // Màn hình chính với Bottom navigation
          '/account': (context) => const AccountScreen(),
          '/editProfile': (context) => EditProfileScreen(),
          '/myBooking': (context) => const BookingHistoryScreen(),
          '/register': (context) => RegisterScreen(), // Màn hình đăng ký
          '/login': (context) => const LoginScreen(),
        },
        // // Xử lý điều hướng đến EditProfileScreen với userId
        // onGenerateRoute: (RouteSettings settings) {
        //   if (settings.name == '/editProfile') {
        //     final String userId =
        //         settings.arguments as String; // Lấy userId từ arguments
        //     return MaterialPageRoute(
        //       builder: (context) => EditProfileScreen(userId: userId),
        //     );
        //   }
        //   return null; // Trả về null nếu không tìm thấy route
        // },
        // Xử lý lỗi điều hướng không xác định
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (context) => RegisterScreen());
        },
      ),
    );
  }
}
