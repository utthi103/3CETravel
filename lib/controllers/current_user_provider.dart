import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class CurrentUserProvider with ChangeNotifier {
  User? _currentUser;
  Map<String, dynamic>? _userData;

  User? get currentUser => _currentUser;
  Map<String, dynamic>? get userData => _userData;

  Future<void> fetchUserData() async {
    try {
      _currentUser = FirebaseAuth.instance.currentUser;
      if (_currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('tb_user')
            .doc(_currentUser!.uid)
            .get();
        if (userDoc.exists) {
          _userData = userDoc.data();
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      // Consider showing an error message to the user
    }
  }

  Future<void> updateUserData(Map<String, dynamic> data) async {
    try {
      if (_currentUser != null) {
        await FirebaseFirestore.instance
            .collection('tb_user')
            .doc(_currentUser!.uid)
            .update(data);
        _userData = {...?_userData, ...data}; // Update local data
        notifyListeners();
      }
    } catch (e) {
      print('Error updating user data: $e');
      // Consider showing an error message to the user
    }
  }

  Future<void> updateUserImage(String imagePath) async {
    try {
      String base64String = await encodeImageToBase64(imagePath);
      await updateUserData({'imgUser': base64String});
    } catch (e) {
      print('Error updating user image: $e');
      // Consider showing an error message to the user
    }
  }

  Future<String> encodeImageToBase64(String filePath) async {
    final File imageFile = File(filePath); // Read from the file path
    final Uint8List bytes = await imageFile.readAsBytes();
    return 'data:image/png;base64,' + base64Encode(bytes);
  }
}
