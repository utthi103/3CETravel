import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:travelwith3ce/controllers/current_user_provider.dart';
import 'package:travelwith3ce/models/bottom_bar.dart';
import 'package:travelwith3ce/views/login.dart';
import 'package:travelwith3ce/views/signup.dart';
import 'package:travelwith3ce/views/store/loginStore.dart';
import 'package:travelwith3ce/views/account_screen.dart';
import 'package:travelwith3ce/views/edit_profile_screen.dart';
import 'package:travelwith3ce/views/my_booking_screen.dart';
import 'package:travelwith3ce/views/favourite_screen.dart'; // Add your FavouriteScreen import
import 'package:travelwith3ce/views/notification_screen.dart'; // Add your NotificationScreen import
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurrentUserProvider(),
      child: MaterialApp(
        title: 'Travel with 3CE',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/', // Set the initial route
        routes: {
          '/': (context) => StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      // Fetch user data when authenticated
                      Provider.of<CurrentUserProvider>(context, listen: false)
                          .fetchUserData();
                      return const BottomBar();
                    } else {
                      return const LoginScreen();
                    }
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
          '/home': (context) => const BottomBar(),
          '/account': (context) => const AccountScreen(),
          '/editProfile': (context) => EditProfileScreen(), // New route added
          '/myBooking': (context) =>
              const BookingHistoryScreen(), // New route added
          '/register': (context) => RegisterScreen(), // New route added
          '/loginStore': (context) =>
              const LoginStoreScreen(), // New route added
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (context) => const LoginScreen());
        },
      ),
    );
  }
}
