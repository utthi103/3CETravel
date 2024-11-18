import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:travelwith3ce/views/detail/image_container.dart';
import 'package:travelwith3ce/views/detail/detail_info.dart';
import 'package:travelwith3ce/views/detail/description.dart';
import 'package:travelwith3ce/views/detail/facilities.dart';
import 'package:travelwith3ce/views/detail/custom_button.dart';

class DetailScreen extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String rawRating;
  final String price;
  final List<String> amenities;
  final String description;  // Thêm description vào constructor

  const DetailScreen({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.rawRating,
    required this.price,
    required this.amenities,
    required this.description,  // Thêm description vào constructor
  }) : super(key: key);
  
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Image.memory(
              base64Decode(widget.imageUrl), // Giải mã base64 thành mảng byte
              scale: 4,
              fit: BoxFit.cover,
            ),
            DetailInfo(
              title: widget.title,
              rawRating: widget.rawRating,
              price: widget.price,
            ),
            Facilities(
              amenities: widget.amenities,
            ),
            Description(
            description: widget.description,
            ),
            const CustomButton(),
          ],
        ),
      ),
    );
  }
}
