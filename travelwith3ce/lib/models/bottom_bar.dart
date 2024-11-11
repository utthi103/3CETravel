import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travelwith3ce/constant.dart';
import 'package:travelwith3ce/views/edit_profile_screen.dart';
import 'package:travelwith3ce/views/home_screen.dart';
import 'package:travelwith3ce/views/favourite_screen.dart';
import 'package:travelwith3ce/views/my_booking_screen.dart';
import 'package:travelwith3ce/views/notification_screen.dart';
import 'package:travelwith3ce/views/account_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  // Danh sách các trang tương ứng với các nút điều hướng dưới
  final List<Widget> _pages = [
    const HomeScreen(),
    FavouriteScreen(), // Sử dụng const nếu widget không thay đổi
    NotificationScreen(),
    const AccountScreen(),
  ];

  // Hàm điều hướng đến trang tương ứng
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật chỉ số trang đã chọn
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex], // Hiển thị trang đã chọn
          Positioned(
            bottom: 17,
            left: 41,
            right: 41,
            child: Container(
              height: 52,
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
                    onPressed: () =>
                        _onItemTapped(0), // Điều hướng đến HomeScreen
                    icon: SvgPicture.asset(
                      'assets/icons/home-active.svg',
                      color: _selectedIndex == 0
                          ? kPrimaryColor
                          : null, // Đổi màu icon nếu được chọn
                    ),
                  ),
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: kSecondaryColor,
                    onPressed: () =>
                        _onItemTapped(1), // Điều hướng đến FavouriteScreen
                    icon: SvgPicture.asset(
                      'assets/icons/heart-big.svg',
                      color: _selectedIndex == 1 ? kPrimaryColor : null,
                    ),
                  ),
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: kSecondaryColor,
                    onPressed: () =>
                        _onItemTapped(2), // Điều hướng đến NotificationScreen
                    icon: SvgPicture.asset(
                      'assets/icons/bell.svg',
                      color: _selectedIndex == 2 ? kPrimaryColor : null,
                    ),
                  ),
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: kSecondaryColor,
                    onPressed: () =>
                        _onItemTapped(3), // Điều hướng đến AccountScreen
                    icon: SvgPicture.asset(
                      'assets/icons/user.svg',
                      color: _selectedIndex == 3 ? kPrimaryColor : null,
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
