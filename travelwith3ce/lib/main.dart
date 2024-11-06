import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travelwith3ce/constant.dart';
import 'package:travelwith3ce/views/account_screen.dart';
import 'package:travelwith3ce/views/edit_profile_screen.dart';
import 'package:travelwith3ce/views/my_booking_screen.dart';
import 'package:travelwith3ce/models/bottom_bar.dart';

void main() {
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3ce_hotel_booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NunitoSans',
        scaffoldBackgroundColor: kPrimaryColor,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const BottomBar(), // Bottom navigation
        '/account': (context) => const AccountScreen(),
        '/editProfile': (context) =>
            EditProfileScreen(), // Ensure this is defined
        '/myBooking': (context) =>
            BookingHistoryScreen(), // Ensure this is defined
      },
    );
  }
}
