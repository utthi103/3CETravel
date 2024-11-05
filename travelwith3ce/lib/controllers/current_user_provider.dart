import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    }
  }

  Future<void> updateUserData(Map<String, dynamic> data) async {
    try {
      if (_currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .update(data);
        _userData = {...?_userData, ...data}; // Update local data
        notifyListeners();
      }
    } catch (e) {
      print('Error updating user data: $e');
    }
  }
}
