import 'dart:convert';
import 'dart:typed_data';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelwith3ce/controllers/userController.dart';
import 'package:travelwith3ce/models/userModel.dart';

import '../../constant.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  User? _user;
  final UserController _userController = UserController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null && userId.isNotEmpty) {
      User? user = await _userController.getUserById(userId);
      setState(() {
        _user = user;
      });
    } else {
      print("User ID is not available");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 500),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 30,
              left: 24,
              right: 24,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset('assets/icons/menu.svg'),
                _user == null
                    ? const CircularProgressIndicator()
                    : CircleAvatar(
                        radius: 30, // Thay đổi kích thước ở đây
                        backgroundImage: _user!.imgUser.isNotEmpty
                            ? MemoryImage(_getImageFromBase64(_user!.imgUser))
                            : const AssetImage('assets/images/profile.png')
                                as ImageProvider,
                      ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 11),
        // Header text
        FadeInUp(
          duration: const Duration(milliseconds: 500),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find a perfect',
                  style: nunitoRegular17.copyWith(
                      color: Colors.black), // Change to black
                ),
                Text(
                  'Hotel for you',
                  style:
                      nunito26.copyWith(color: Colors.black), // Change to black
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/location.svg'),
                    const SizedBox(width: 5),
                    Text(
                      'Viet Nam',
                      style: nunito14.copyWith(
                          color: Colors.black,
                          fontFamily: 'Roboto'), // Change to black
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Uint8List _getImageFromBase64(String base64String) {
    if (base64String.contains(',')) {
      return base64Decode(base64String.split(',')[1]);
    } else {
      return base64Decode(base64String);
    }
  }
}
