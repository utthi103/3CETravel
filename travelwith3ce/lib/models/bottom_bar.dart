import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travelwith3ce/constant.dart';
import 'package:travelwith3ce/views/edit_profile_screen.dart';
import 'package:travelwith3ce/views/home_screen.dart';
import 'package:travelwith3ce/views/favourite_screen.dart'; // Import your FavouriteScreen
import 'package:travelwith3ce/views/my_booking_screen.dart';
import 'package:travelwith3ce/views/notification_screen.dart'; // Import your NotificationScreen
import 'package:travelwith3ce/views/account_screen.dart'; // Import your AccountScreen

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  // List of pages corresponding to the bottom navigation buttons
  final List<Widget> _pages = [
    const HomeScreen(),
    FavouriteScreen(), // Add your FavouriteScreen
    NotificationScreen(), // Add your NotificationScreen
    AccountScreen(), // Add your AccountScreen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex], // Display the selected page
          Positioned(
            bottom: 17,
            left: 41,
            right: 41,
            child: Container(
              height: 52,
              width: 291,
              decoration: BoxDecoration(
                color: kBottomBarColor,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: kSecondaryColor,
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0; // Navigate to HomeScreen
                      });
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/home-active.svg',
                    ),
                  ),
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: kSecondaryColor,
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1; // Navigate to FavouriteScreen
                      });
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/heart-big.svg',
                    ),
                  ),
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: kSecondaryColor,
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 2; // Navigate to NotificationScreen
                      });
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/bell.svg',
                    ),
                  ),
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: kSecondaryColor,
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 3; // Navigate to AccountScreen
                      });
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/user.svg',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
