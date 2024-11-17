import 'package:flutter/material.dart';

class Favourite {
  final String id; // roomId
  final String name; // roomName
  final double price; // roomPrice
  final String description; // roomDescription
  final String roomImages; // New property for room images

  Favourite({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.roomImages, // Add the new property
  });
}
